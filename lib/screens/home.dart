import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:client/screens/enter_postal_code.dart';
import 'package:client/screens/user/signin.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:client/utils/common.dart' ;
import 'package:client/widget/store_list_cell.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  dynamic storeIds;
  Home(this.storeIds);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List stores= new List();
  bool isError = false;
  String name = '';

  void createName() async
  {
    var preferences = await SharedPreferences.getInstance();
    try
    {

          if(preferences.getBool(is_logged_in ?? false))
          {
            name = preferences.getString(firstname ?? '');
          }
          else
          {
            name = '';
          }
    }
    catch(e)
    {
      print('error');
    }

    //return nameWidget;
  }


  Future<void> getStores() async {
    print('fetchdata');
    try{

      final response = await http.get(
        storeUrl,
        headers: {HttpHeaders.authorizationHeader: auth,
          HttpHeaders.contentTypeHeader: 'application/json'},
      );
      print(json.decode(response.body));
      if(response.statusCode == 200)
      {
        final responseJson = json.decode(response.body);
        stores = responseJson["children_data"] as List;

        setState(() {
          isError = false;
          print('setstate');
        });
      }
      else
      {
        setState(() {
          isError = true;
        });
      }

    }
    catch(e){
      setState(() {

      });
    }
  }


  void isLoggedIn() async
  {
    var preferences = await SharedPreferences.getInstance();
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
  }

  @override
  void initState() {
    super.initState();
    startTimer();
    getStores();
  }
  @override
  void dispose()
  {
    timer.cancel();
    super.dispose();
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
    //print(widget.storeIds);
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        actions: <Widget>[
          GestureDetector(
            onTap: (){ isLoggedIn();},
            child: Container(
              padding: EdgeInsets.only(top: name == '' ? 0: 5 ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  name == ''?
                  Container(
                    child: IconButton(
                      icon: Icon(
                        Icons.account_circle,
                        color: darkText,
                      ),
                      onPressed: (){
                        isLoggedIn();

                      },
                    ),
                  ) :
                  Text('Hi '+ name +" >",
                      style: TextStyle(
                          color: darkText,
                          fontSize: 14
                      )), SizedBox(width: 15,)
                ],
              ),
            ),
          ),
        ],
        backgroundColor: white,
        centerTitle: true,
        elevation: 0,
        title: Text('Choose Store',
          style: TextStyle(
              fontWeight: FontWeight.bold,
            color: darkText
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 20),
              child: Center(
                child: Text('Where do you want to shop today?',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: lightText,
                    fontSize: 17,

                  ),
                ),
              ),
            ),
            Card(
              color: white,
              margin: EdgeInsets.only(top: 15, left: 40, right: 40, bottom: 20),
              child: Row(
                // crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: CircleAvatar(
                      backgroundImage: AssetImage('assets/images/map.png'),
                      backgroundColor: transparent,
                    ),
                  ),
                  Expanded(
                    flex: 10,
                    child: Container(
                      margin: EdgeInsets.only(left: 20, right: 20),
                      child: Text(savedPostalCode,
                          style: TextStyle(
                            color: lightestText,
                            fontWeight: FontWeight.normal,
                            fontSize: 18,

                          )),
                    ),
                  ),
                  Expanded(
                    flex: 3,

                    child: GestureDetector(
                      onTap: ()
                      {
                        Navigator.of(context).push(
                            CupertinoPageRoute(
                                fullscreenDialog: true,
                                builder: (context) => EnterPostalCode(true)
                            )
                        );

                      },
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
                            child: Text('Change',
                              style: TextStyle(
                                color: white,
                                fontSize: 14,

                              ),),
                          )),
                    ),
                  ),
                ],
              ),
            ),

            createStores(stores)


          ],
        )
      ),
    );
  }


  Widget createStores (List stores)
  {

    List<Widget> storeWidgetList = new List();
    List storeIdsList = widget.storeIds as List;
    for (int storeIndex = 0; storeIndex< stores.length; storeIndex++)
    {
      if(stores[storeIndex]['is_active'])
      {
        if(storeIdsList.contains(stores[storeIndex]['id'].toString()))
        {
          storeWidgetList.add(new StoreListCell(stores[storeIndex]));
        }
        
      }

    }

    if(stores.length == 0)
    {
      if(!isError)
      return  Container(height: MediaQuery.of(context).size.width,child: Center(child: CircularProgressIndicator()));
      else
        return Center(child: Text('No Store Avaiable'));
    }
    else
      {
        return new Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: storeWidgetList);
      }

  }
}
