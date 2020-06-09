import 'dart:convert';
import 'dart:io';

import 'package:client/screens/cart.dart';
import 'package:client/screens/order_detail.dart';
import 'package:client/screens/shipping_address.dart';
import 'package:client/screens/user/add_address.dart';
import 'package:client/utils/common.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


dynamic addressList;
dynamic addressListToSend;

class AddressBook extends StatefulWidget {

  String title;

  AddressBook(this.title);

  @override
  _AddressBookState createState() => _AddressBookState();
}

class _AddressBookState extends State<AddressBook> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loginInfoFromLocal();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
         IconButton(
           icon: Icon(Icons.playlist_add, color: primaryColor,),
            onPressed: ()
            {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddAddress(addressListToSend, widget.title),
                  ));
            },
         )

        ],
        iconTheme: IconThemeData(color: darkText),
        backgroundColor: white,
        centerTitle: true,
        title: Text(widget.title,
        style: TextStyle(
          color: darkText,
          fontWeight: FontWeight.bold
        ),
        )
      ),
      body: ListView(
        children: isLoading ? loadingWidget() : getAddressCells()
      ),
    );
  }

  List<Widget> loadingWidget()
  {
    List<Widget> loadingWidgetList = new List();
    loadingWidgetList.add( new Container(
      height: MediaQuery.of(context).size.width,
      width: MediaQuery.of(context).size.width,
      child: Image.asset('assets/images/loading.gif'),
    ) );
    return loadingWidgetList;
  }

  List<Widget> getAddressCells()
  {
    List<Widget> addressWidgetList = new List();
    for(int i= 0 ;i < addressList.length; i++)
    {
      addressWidgetList.add(AddressCell(addressList[i], widget.title , (){
        setState(() {
          deleteAddressRequest(addressList[i]['id'], i);
        },);},
              (){
                setState(() {
                  getUserTokenToAddAddress(addressList[i]);
                });
              }));
    }
    if(addressList.length == 0)
    {
      addressWidgetList.add(new Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.width,
        child: Column(
          children: <Widget>[
            SizedBox(height: 50),
            Text('Address Book is empty!',
              style:  TextStyle(
                  color: iconColor,
                  fontWeight: FontWeight.normal,
                  fontSize: 22
              ),),
            SizedBox(height: 20),
            GestureDetector(
              onTap: (){
                Navigator.of(context).push(
                    CupertinoPageRoute(
                        fullscreenDialog: true,
                        builder: (context) => AddAddress(addressListToSend, widget.title)
                    )
                );
              },
              child: Container(
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.playlist_add, color: primaryColor,),
                    Text('Add new Address',
                      style:  TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.normal,
                          fontSize: 14
                      ),),

                  ],
                ),
              ),
            )
          ],
        ),
      ));
    }


    return addressWidgetList;
  }

  void loginInfoFromLocal() async
  {
    setState(() {
      isLoading = true;
    });
    try
    {
      var preferences = await SharedPreferences.getInstance();
      getUserToken(preferences.getString(username ?? ''), preferences.getString(password ?? ''));
    }
    catch(e){
      showToast("Something went wrong");
    }
  }




  Future<void> getUserToken(String username, String password) async {

    Map addressInfo = { 'username' : "$username", 'password' : "$password"};

    try
    {
      print(loginUrl);
      print(addressInfo);

      setState(() {
        isLoading = true;
      });

      final response = await http.post(
          loginUrl,
          headers: {HttpHeaders.authorizationHeader: auth,
            HttpHeaders.contentTypeHeader: contentType},
          body: json.encode(addressInfo)
      );
      //response.add(utf8.encode(json.encode(itemInfo)));

      if(response.statusCode == 200)
      {
        final responseJson = json.decode(response.body);
        //saveData(responseJson);
        print(responseJson.toString());
        saveData(responseJson);
        getUserInfoFromServer(responseJson);

      }
      else
      {
        final responseJson = json.decode(response.body);
        showToast(responseJson['message']);
        Navigator.pop(context);
        print(response.statusCode);
      }
      setState(() {
        //isLoading = false;
      });
    }
    catch(e){
      print(e);
      setState(() {
        Navigator.pop(context);
        showToast("Something went wrong");
      });}
  }

  void saveData(dynamic data) async
  {
    var preferences = await SharedPreferences.getInstance();
    preferences.setString(user_token, data);

  }





  bool isLoading = false;

  void getUserInfoFromServer(String token) async
  {
    try
    {
      setState(() {
        isLoading = true;
      });

      final response = await http.get(
        userInfo,
        headers: {HttpHeaders.authorizationHeader: 'Bearer '+ token,
          HttpHeaders.contentTypeHeader: contentType},
      );
      if(response.statusCode == 200)
      {
        final responseJson = json.decode(response.body);
        userInfoObject = responseJson;
        addressList = responseJson['addresses'] as List;
        addressListToSend = responseJson['addresses'] ;
        getAddressCells();
        print(responseJson);
      }
      else
      {
        final responseJson = json.decode(response.body);
        showToast(responseJson['message']);
        print(response.statusCode);
        Navigator.pop(context);
      }
      setState(() {
        isLoading = false;
      });
    }
    catch(e){
      print(e);
      setState(() {
        isLoading = false;
      });}

  }



  Future<void> deleteAddressRequest(int addressId, int index) async {


    ///Map addressInfo = { 'username' : usernameString, 'password' : passwordString};

    try
    {
      Navigator.pop(context);
      print(deleteAddress+addressId.toString());
      ///print(addressInfo);

      setState(() {
        isLoading = true;
      });

      final response = await http.delete(
          deleteAddress+addressId.toString(),
          headers: {HttpHeaders.authorizationHeader: auth,
            HttpHeaders.contentTypeHeader: contentType},
      );
      //response.add(utf8.encode(json.encode(itemInfo)));

      if(response.statusCode == 200)
      {
        final responseJson = json.decode(response.body);
        setState(() {
          addressList.removeAt(index);
          addressListToSend.removeAt(index);
          isLoading = false;

        });
        //getUserInfoFromServer(responseJson);
        //saveData(responseJson);
        /*setState(() {

          });*/
        print(responseJson);
      }
      else
      {
        final responseJson = json.decode(response.body);
        showToast(responseJson['message']);
        print(responseJson);
        setState(() {
          isLoading = false;
        });
      }

    }
    catch(e){
      print(e);
      setState(() {
        isLoading = false;
      });}


  }







  Future<void> getUserTokenToAddAddress(dynamic address) async {

    var preferences = await SharedPreferences.getInstance();

    Map addressInfo = { 'username' : preferences.getString(username ?? ''), 'password' : preferences.getString(password ?? '')};

    try
    {
      print(loginUrl);
      print(addressInfo);

      setState(() {
        isLoading = true;
      });

      final response = await http.post(
          loginUrl,
          headers: {HttpHeaders.authorizationHeader: auth,
            HttpHeaders.contentTypeHeader: contentType},
          body: json.encode(addressInfo)
      );
      //response.add(utf8.encode(json.encode(itemInfo)));

      if(response.statusCode == 200)
      {
        final responseJson = json.decode(response.body);
        //saveData(responseJson);
        print(responseJson.toString());
        saveData(responseJson);
        sendDataToServer(responseJson, address);

      }
      else
      {
        final responseJson = json.decode(response.body);
        showToast(responseJson['message']);
        Navigator.pop(context);
        print(response.statusCode);
      }
      setState(() {
        //isLoading = false;
      });
    }
    catch(e){
      print(e);
      setState(() {
        Navigator.pop(context);
        showToast("Something went wrong");
      });}
  }


  Future<void> sendDataToServer(String token, dynamic addressObject) async {



    Map addressInfo = { "addressInformation": { "shippingAddress": { "country_id": "CA", "street": [ addressObject['street'][0] ], "company": "", "telephone": addressObject['telephone'], "postcode": addressObject['postcode'], "city": addressObject['city'], "region": addressObject['region']['region'], "region_id": addressObject['region']['region_id'],  "firstname": addressObject['firstname'], "lastname": addressObject['lastname'], "email": "", "sameAsBilling": 1 },
      "billingAddress": { "country_id": "CA", "street": [ addressObject['street'][0] ], "company":"", "telephone": addressObject['telephone'], "postcode": addressObject['postcode'] , "city": addressObject['city'],"region": addressObject['region']['region'],"region_id": '74', "firstname": addressObject['firstname'], "lastname":  addressObject['lastname'], "email": "" }, "shipping_method_code": "flatrate", "shipping_carrier_code": "flatrate" } };

    addressToOrderDetail = { "country_id": "CA", "street": [ addressObject['street'][0] ], "telephone": addressObject['telephone'], "postcode": addressObject['postcode'], "city": addressObject['city'], "region": addressObject['region']['region'],  "firstname": addressObject['firstname'],"lastname": addressObject['lastname'], "email": "" };
    try
    {
      print(saveAddress);
      print(json.encode(addressInfo));

      setState(() {
        isLoading = true;
      });
      final response = await http.post(
          saveAddress,
          headers: {HttpHeaders.authorizationHeader: "Bearer "+ token,
            HttpHeaders.contentTypeHeader: contentType},
          body: json.encode(addressInfo)
      );
      //response.add(utf8.encode(json.encode(itemInfo)));

      if(response.statusCode == 200)
      {
        final responseJson = json.decode(response.body);
        print(responseJson);
        //getCartId(token);
        isAddressAdded = true;


        Navigator.of(context).pushReplacement(
            CupertinoPageRoute(
              //fullscreenDialog: true,
                builder: (context) => OrderDetail()
            )
        );
        //Navigator.pushReplacementNamed(context, '/orderDetail');
      }
      else
      {
        //showToast('Something went wrong');
        print(response.statusCode);
        final responseJson = json.decode(response.body);
        print(responseJson);
        showToast(responseJson['message']);
        getUserTokenToAddAddress(addressObject);
        setState(() {
          isLoading = false;
        });
      }

    }
    catch(e){
      print(e);
      setState(() {
        isLoading = false;
      });}


  }







}







class AddressCell extends StatelessWidget {

  dynamic address;
  Function deleteRequest;
  Function addAddress;
  String title;


  AddressCell(this.address, this.title, this.deleteRequest, this.addAddress);

  @override
  Widget build(BuildContext context) {




    void deleteDialog() async
    {
      final value = await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text('Delete this address?',
                style: TextStyle(
                    color: darkText,
                  fontWeight: FontWeight.bold
                ),),
              actions: <Widget>[
                FlatButton(
                  child: Text('Yes',
                  style: TextStyle(
                    color: darkText
                  ),),
                  onPressed: this.deleteRequest,
                ),
                FlatButton(
                  child: Text('No',
                    style: TextStyle(
                        color: primaryColor
                    ),),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),

              ],
            );
          }
      );

    }


    return GestureDetector(
      onTap: title == "Select Address" ? addAddress : null,
      child: Container(
        margin: EdgeInsets.all(10),
        child: Card(
          child: Container(
            padding: EdgeInsets.all(10),
            child: Stack(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Icon(Icons.location_on, color: primaryColor, size: 15,),
                        SizedBox(width: 10),
                        Text(address['postcode'],
                            style: TextStyle(
                              color: primaryColor,
                            )
                        ),
                      ],
                    ),

                    SizedBox(height: 6),
                    Text(address['firstname'] + ' ' + address['lastname'],
                        style: TextStyle(
                            color: darkText,
                            fontWeight: FontWeight.bold,
                            fontSize: 16
                        )
                    ),

                    SizedBox(height: 3),
                    Text("Address: "+address['street'][0],
                        style: TextStyle(
                            color: lightestText,
                            fontWeight: FontWeight.normal,
                            fontSize: 14
                        )
                    ),

                    SizedBox(height: 3),
                    Text('Phone: '+address['telephone'],
                        style: TextStyle(
                            color: lightestText,
                            fontWeight: FontWeight.normal,
                            fontSize: 14
                        )
                    ),

                  ],
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    height: 30,
                    width: 30,
                    child: IconButton(
                      onPressed: (){
                        deleteDialog();
                      },
                      icon:  Icon( Icons.delete, size: 20,),
                      color: lightGrey,
                    ),
                  )
                )
              ],
            )
          ),
        )
      ),
    );



  }




}

