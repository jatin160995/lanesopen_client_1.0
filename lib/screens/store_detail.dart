import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:client/payment/search.dart';
import 'package:client/screens/user/signin.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:client/utils/common.dart';
import 'package:client/widget/horizontal_product_list.dart';
import 'package:badges/badges.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http ;

class StoreDetail extends StatefulWidget {
  @override
  _StoreDetailState createState() => _StoreDetailState();


  dynamic storeData;
  StoreDetail({Key key, @required this.storeData}) : super(key: key);
}

class _StoreDetailState extends State<StoreDetail> {

  List<Widget> catWidgetList = new List();
  String name = '';

  @override
  void initState() {

    super.initState();

      instructionList = new List();
    startTimer();
    isLoggedInForCartClear();
    cartId = '';
    cartCount = 0;
    addressAdded = false;
    gettingCartId = false;
    cartList = new List();

    print(widget.storeData);
    setCartCount();
    getCategories();

  }

  @override
  void didUpdateWidget(StoreDetail oldWidget) {

    print('didUpdateWidget');
    super.didUpdateWidget(oldWidget);

  }


  void getCategories()
  {
    List categories = widget.storeData['children_data'];
    for(int i = 0; i < categories.length; i++)
    {
      try
      {
        catWidgetList.add(HorizontalProductList(categories[i], categories[i]['id'], categories[i]['name']));
      }
      catch(e)
      {
        catWidgetList.add(HorizontalProductList(1, categories[i]['id'], categories[i]['name']));
      }

    }
    setState(() {});
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();

    print('onDispose');
  }


  void setCartCount() async
  {
    try{
      var preferences = await SharedPreferences.getInstance();
      // print(preferences.getInt(cart_count ?? 0));
        preferences.setInt(cart_count, countFromLocal);
    }
    catch(e)
    {
      showToast('Error while setting cart count');
    }
  }
  int countFromLocal = 0;
  void getCartCount() async
  {
    try{
      var preferences = await SharedPreferences.getInstance();
     // print(preferences.getInt(cart_count ?? 0));
      countFromLocal =  preferences.getInt(cart_count);
    }
    catch(e)
    {
      showToast('Error while getting cart count');
      countFromLocal = 0;
    }
  }

Timer timer ;
int justaNumber= 0;
  void startTimer()
  {
    timer = new Timer.periodic(Duration(seconds: 1), (timer) {  setState(() {
      justaNumber = 11;
     // print('valueSett');
    });});
  }

  @override
  Widget build(BuildContext context) {
    createName();
    getCartCount();
    return WillPopScope(
        onWillPop: () async {
      final value = await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text('Clear cart and exit?'),
              actions: <Widget>[
                FlatButton(
                  child: Text('No'),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
                FlatButton(
                  child: Text('Yes, exit'),
                  onPressed: () {
                   // clearCartFromServer();
                    cartId = '';
                    Navigator.of(context).pop(true);
                  },
                ),
              ],
            );
          }
      );

      return value == true;
    },
    child: Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: ()
        {
          Navigator.pushNamed(context, '/cart');
        },
        backgroundColor: primaryColor,
        child: Badge(
          badgeContent: Text(
            countFromLocal.toString(),
          style: TextStyle(
              color: white
          ),),
          child: Icon(Icons.shopping_cart, size: 25),
        ),
      ),
      body: SizedBox(
        width: double.infinity,
        child: ListView(
          children: <Widget>[
            Container
              (
              height: 160,
              decoration: new BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/store_background.jpg',),
                    fit: BoxFit.cover,
                  )
              ),
              child: Container(
                color: transparentBlack,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[

                    SafeArea(
                      child: Stack(
                        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Align(
                            alignment: Alignment.topLeft,
                            child: IconButton(
                              icon: Icon(
                                Icons.arrow_back,
                                color: white,
                              ),
                              onPressed: (){
                                //Navigator.pop(context);
                                exitDialog();

                              },
                            ),
                          ),
                          Align(
                            alignment: Alignment.topCenter,
                            child: Container(
                              margin: EdgeInsets.only(top: 5),
                              child: Column(
                                children: <Widget>[
                                  Text(widget.storeData['name'],
                                      style: TextStyle
                                        (
                                          color: white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18
                                      )
                                  ),
                                  Text('Shopping in '+savedPostalCode,
                                      style: TextStyle
                                        (
                                          color: lightGrey,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 11
                                      )
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: GestureDetector(
                              onTap: (){ isLoggedIn();},
                              child: Container(
                                padding: EdgeInsets.only(top: name == '' ? 0: 15),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    name == ''?
                                    Container(
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.account_circle,
                                          color: white,
                                        ),
                                        onPressed: (){
                                          isLoggedIn();

                                        },
                                      ),
                                    ) :
                                    Text('Hi '+ name +" >",
                                        style: TextStyle(
                                            color: white,
                                            fontSize: 14
                                        )), SizedBox(width: 15,)
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 30),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                         /* Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            elevation: 2,
                            child: new Container(
                              width: 100.0,
                              height: 100.0,
                              padding: EdgeInsets.all(5),
                              child: FadeInImage.assetNetwork(
                                placeholder: 'assets/images/loading.gif',
                                image: getImage(),
                              ),
                            ),
                          ),*/
                          GestureDetector(
                            onTap: ()
                            {
                              print('tapped');
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FindItem( widget.storeData['id'].toString())//Search( widget.storeData['id'].toString()),
                                  ));

                            },
                            child: Card(
                              color: white,
                              margin: EdgeInsets.only(top: 30, left: 40, right: 40),
                              child: Row(
                                // crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[

                                  Expanded(
                                    flex: 10,
                                    child: Container(
                                      margin: EdgeInsets.only(left: 20, right: 20),
                                      child:Text('Search '+widget.storeData['name']+'...',
                                          maxLines: 1,
                                          style: TextStyle(
                                              color: lightestText,
                                              fontSize: 16
                                          )),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,

                                    child: Container(
                                        height: 50,
                                        decoration: new BoxDecoration(
                                          color: primaryColor,
                                          borderRadius: new BorderRadius.only(
                                            bottomRight: const Radius.circular(4.0),
                                            topRight: const Radius.circular(4.0),
                                          ),
                                        ),
                                        child: Center(
                                            child: Icon(
                                              Icons.search,
                                              color: white,
                                            )
                                        )),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  ],
                ),
              ),
            ),

            Column(
              children: catWidgetList
            ),

          ],
        ),
      ),
    ));
  }

  String getImage()
  {
    //print(widget.storeData['custom_attributes'][0]['value'].toString());

    /* try {

    } on Exception catch (_) {
      print('never reached');
    }*/
    if(widget.storeData['image'].toString() != "null")
    {
      return urlPrefix + widget.storeData['image'];
    }
    else
    {
      return 'https://lanesopen.com/pub/media/logo/stores/1/logo2.png';
    }
  }


  void isLoggedIn() async
  {
    var preferences = await SharedPreferences.getInstance();
    //preferences.getBool(is_logged_in ?? false);
    try
    {
      if(!preferences.getBool(is_logged_in ?? false))
      {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SignIn('profile'),
            ));
      }
      else
      {
        Navigator.pushNamed(context, '/profile');

      }
    }
    catch(e){
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SignIn( 'profile'),
          ));
      print("exception");}

    //return preferences.getBool(is_logged_in ?? false);
  }



  void exitDialog() async
  {
    final value = await showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text('Clear cart and exit?'),
            actions: <Widget>[
              FlatButton(
                child: Text('No'),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              FlatButton(
                child: Text('Yes, exit'),
                onPressed: () {
                 // clearCartFromServer();
                  cartId = '';
                  Navigator.of(context).pop(true);
                  Navigator.pop(context);
                  print('exit');

                },
              ),
            ],
          );
        }
    );

  }



  void isLoggedInForCartClear() async
  {
    var preferences = await SharedPreferences.getInstance();
    try
    {
     String qouteID =  preferences.getInt(cart_id ?? 0).toString();
     clearCartFromServer(qouteID);
    }
    catch(e)
    {
      clearCartFromServer("0");
    }


  }

  bool isLoading = false;
  void  clearCartFromServer(String qouteID) async
  {

    var preferences = await SharedPreferences.getInstance();
    print(clearCart);
    try
    {
      setState(() {
        isLoading = true;
      });

      final response = await http.post(
          clearCart,
        headers: {HttpHeaders.authorizationHeader: auth,
          HttpHeaders.contentTypeHeader: contentType},
         body: json.encode({'quote_id': qouteID})
      );
      //response.add(utf8.encode(json.encode(itemInfo)));
      print({'quote_id': qouteID});

      if(response.statusCode == 200)
      {
        final responseJson = json.decode(response.body);
        print("clearCart" + responseJson.toString() + "clearCart");
        preferences.setString(min_cart_value, responseJson[0].toString());
        preferences.setString(today_timing, responseJson[1][0]['limits_serialized'].toString());
        //print();
      }
      else
      {
        final responseJson = json.decode(response.body);
        showToast(responseJson['message']+ "clearCart");
        print(responseJson);
       // Navigator.pop(context);
      }
      setState(() {
        isLoading = false;
      });
    }
    catch(e){
      print(e);
      isLoading = false;
      showToast('Something went wrong');
      //Navigator.pop(context);

    }

  }










 bool isNameUpdated = false;
  void createName() async
  {
    var preferences = await SharedPreferences.getInstance();

    Widget nameWidget = new Container();
    try
    {

       // setState(() {
          if(preferences.getBool(is_logged_in ?? false))
          {
            name = preferences.getString(firstname ?? '');
          }
          else
          {
            name = '';
          }
          //isNameUpdated = true;

        //});


    }
    catch(e)
    {
      print('error');
    }

    //return nameWidget;
  }

  void saveNameData(dynamic data) async
  {
    var preferences = await SharedPreferences.getInstance();

    preferences.setInt(store_id, data['store_id']);
    preferences.setInt(id, data['id']);
    preferences.setString(firstname, data['firstname']);
    preferences.setString(lastname, data['lastname']);
    preferences.setString(savedEmail, data['email']);

  }

}
