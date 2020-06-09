import 'dart:convert';
import 'dart:io';

import 'package:client/screens/order_detail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:client/utils/common.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'cart.dart';
//import 'package:stripe_payment/stripe_payment.dart';


class ShippingAddress extends StatefulWidget {
  @override
  _ShippingAddressState createState() => _ShippingAddressState();
}

class _ShippingAddressState extends State<ShippingAddress> {


  String fName = '';
  String lName = '';
  String zip = '';
  String streetAddress = '';
  String company = '';
  String email = '';
  String city = '';
  String state = '';
  String country = 'Canada';
  String phoneNumber = '';
  String comment = '';
  String dateString = '';


  bool isLoading = false;

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  String _error;
  //Token _paymentToken;
  //PaymentMethod _paymentMethod;
  final String _currentSecret = null; //set this yourself, e.g using curl
  //PaymentIntentResult _paymentIntent;
  //Source _source;

  ScrollController _controller = ScrollController();

  void setError(dynamic error) {
    //_scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(error.toString())));
    setState(() {
      _error = error.toString();
      print(_error);
    });
  }
  

  String dropdownValue = '';

  TextEditingController countryController = new TextEditingController();
  final format = DateFormat("dd-MM-yyyy HH:mm:aa");

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    zip = savedPostalCode;
    state = "Ontario";
    countryController.text = 'Canada';
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: white,
        elevation: 0,
        centerTitle: true,
        title: Text('Address',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: darkText
          ),),
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            Container(
              margin: EdgeInsets.fromLTRB(15, 30, 15, 0),
              child: Column
                (
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: Text('Add your shipping address!',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: darkText,
                        fontSize: 18,

                      ),
                    ),
                  ),

                  SizedBox(height: 15,),
                  Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Container(
                          child: TextFormField(
                            onChanged: (text){
                              //password = text;
                              fName = text;
                            },
                            cursorColor: primaryColor,
                            decoration: new InputDecoration(
                              focusedBorder:OutlineInputBorder
                                (
                                borderSide: const BorderSide(color:  Colors.grey, width: 1.0),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              labelText: "First name",
                              labelStyle: TextStyle
                                (
                                  color: Colors.grey
                              ),
                              fillColor: Colors.white,
                              border: new OutlineInputBorder
                                (
                                borderRadius: new BorderRadius.circular(8.0),
                                borderSide: new BorderSide(
                                ),
                              ),
                            ),
                            validator: (val) {
                              if(val.length==0) {
                                return "First name can not be empty";
                              }else{
                                return null;
                              }
                            },
                            keyboardType: TextInputType.emailAddress,
                            style: new TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10,),
                      Expanded(
                        flex: 1,
                        child: Container(
                          child: TextFormField(
                            onChanged: (text){
                              //password = text;
                              lName = text;
                            },
                            cursorColor: primaryColor,
                            decoration: new InputDecoration(
                              focusedBorder:OutlineInputBorder
                                (
                                borderSide: const BorderSide(color:  Colors.grey, width: 1.0),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              labelText: "Last name",
                              labelStyle: TextStyle
                                (
                                  color: Colors.grey
                              ),
                              fillColor: Colors.white,
                              border: new OutlineInputBorder
                                (
                                borderRadius: new BorderRadius.circular(8.0),
                                borderSide: new BorderSide(
                                ),
                              ),
                            ),
                            validator: (val) {
                              if(val.length==0) {
                                return "Last name cannot be empty";
                              }else{
                                return null;
                              }
                            },
                            keyboardType: TextInputType.emailAddress,
                            style: new TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),

                    ],
                  ),
                  /*SizedBox(height: 10),
                  Container(
                    child: TextFormField(
                      onChanged: (text){
                        //password = text;
                        email = text;
                      },
                      cursorColor: primaryColor,
                      decoration: new InputDecoration(
                        focusedBorder:OutlineInputBorder
                          (
                          borderSide: const BorderSide(color:  Colors.grey, width: 1.0),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        labelText: "Email",
                        labelStyle: TextStyle
                          (
                            color: Colors.grey
                        ),
                        fillColor: Colors.white,
                        border: new OutlineInputBorder
                          (
                          borderRadius: new BorderRadius.circular(8.0),
                          borderSide: new BorderSide(
                          ),
                        ),
                      ),
                      validator: (val) {
                        if(val.length==0) {
                          return "Email cannot be empty";
                        }else{
                          return null;
                        }
                      },
                      keyboardType: TextInputType.emailAddress,
                      style: new TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),*/

                  /*SizedBox(height: 10),
                  Container(
                    child: TextFormField(
                      onChanged: (text){
                        //password = text;
                        company = text;
                      },
                      cursorColor: primaryColor,
                      decoration: new InputDecoration(
                        focusedBorder:OutlineInputBorder
                          (
                          borderSide: const BorderSide(color:  Colors.grey, width: 1.0),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        labelText: "Company",
                        labelStyle: TextStyle
                          (
                            color: Colors.grey
                        ),
                        fillColor: Colors.white,
                        border: new OutlineInputBorder
                          (
                          borderRadius: new BorderRadius.circular(8.0),
                          borderSide: new BorderSide(
                          ),
                        ),
                      ),
                      validator: (val) {
                        if(val.length==0) {
                          return "Company cannot be empty";
                        }else{
                          return null;
                        }
                      },
                      keyboardType: TextInputType.emailAddress,
                      style: new TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),*/
                  SizedBox(height: 10),
                  Container(
                    child: TextFormField(
                      onChanged: (text){
                        //password = text;
                        streetAddress = text;
                      },
                      cursorColor: primaryColor,
                      decoration: new InputDecoration(
                        focusedBorder:OutlineInputBorder
                          (
                          borderSide: const BorderSide(color:  Colors.grey, width: 1.0),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        labelText: "Street Address",
                        labelStyle: TextStyle
                          (
                            color: Colors.grey
                        ),
                        fillColor: Colors.white,
                        border: new OutlineInputBorder
                          (
                          borderRadius: new BorderRadius.circular(8.0),
                          borderSide: new BorderSide(
                          ),
                        ),
                      ),
                      validator: (val) {
                        if(val.length==0) {
                          return "Street Address cannot be empty";
                        }else{
                          return null;
                        }
                      },
                      keyboardType: TextInputType.emailAddress,
                      style: new TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),

                  SizedBox(height: 10),
                  Container(
                    child: TextFormField(
                      onChanged: (text){
                        //password = text;
                        city = text;
                      },
                      cursorColor: primaryColor,
                      decoration: new InputDecoration(
                        focusedBorder:OutlineInputBorder
                          (
                          borderSide: const BorderSide(color:  Colors.grey, width: 1.0),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        labelText: "City",
                        labelStyle: TextStyle
                          (
                            color: Colors.grey
                        ),
                        fillColor: Colors.white,
                        border: new OutlineInputBorder
                          (
                          borderRadius: new BorderRadius.circular(8.0),
                          borderSide: new BorderSide(
                          ),
                        ),
                      ),
                      validator: (val) {
                        if(val.length==0) {
                          return "City cannot be empty";
                        }else{
                          return null;
                        }
                      },
                      keyboardType: TextInputType.emailAddress,
                      style: new TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
                  SizedBox(height: 14),
                  Text('State/Province',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 11,
                  )),
                  SizedBox(
                    width: double.infinity,
                    child: Container(
                      child:
                      DropdownButton<String>(
                        value: 'Ontario',
                        icon: Icon(Icons.arrow_drop_down),
                        iconSize: 24,
                        elevation: 8,
                        style: TextStyle(color: darkText),
                        underline: Container(
                          height: 2,
                          color: transparent,
                        ),
                        onChanged: (String newValue) {
                          setState(() {
                            state = newValue;
                            //driverTip = calculateDriverTip(double.parse(newValue));
                            //print(newValue);
                          });
                        },
                        items: ['Ontario']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value ),
                          );
                        }).toList(),
                      ),

                      /*TextFormField(
                        onChanged: (text){
                          //password = text;
                          state = text;
                        },
                        cursorColor: primaryColor,
                        decoration: new InputDecoration(
                          focusedBorder:OutlineInputBorder
                            (
                            borderSide: const BorderSide(color:  Colors.grey, width: 1.0),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          labelText: "State/Povince",
                          labelStyle: TextStyle
                            (
                              color: Colors.grey
                          ),
                          fillColor: Colors.white,
                          border: new OutlineInputBorder
                            (
                            borderRadius: new BorderRadius.circular(8.0),
                            borderSide: new BorderSide(
                            ),
                          ),
                        ),
                        validator: (val) {
                          if(val.length==0) {
                            return "Street Address cannot be empty";
                          }else{
                            return null;
                          }
                        },
                        keyboardType: TextInputType.emailAddress,
                        style: new TextStyle(
                          fontSize: 14,
                        ),
                      ),*/
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    child: TextFormField(
                      initialValue: savedPostalCode,
                      onChanged: (text){
                        //password = text;
                        zip = text;
                      },
                      cursorColor: primaryColor,
                      decoration: new InputDecoration(
                        focusedBorder:OutlineInputBorder
                          (
                          borderSide: const BorderSide(color:  Colors.grey, width: 1.0),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        labelText: "Zip / Postal Code",
                        labelStyle: TextStyle
                          (
                            color: Colors.grey
                        ),
                        fillColor: Colors.white,
                        border: new OutlineInputBorder
                          (
                          borderRadius: new BorderRadius.circular(8.0),
                          borderSide: new BorderSide(
                          ),
                        ),
                      ),
                      validator: (val) {
                        if(val.length==0) {
                          return "Zip/Postal Code cannot be empty";
                        }else{
                          return null;
                        }
                      },
                      keyboardType: TextInputType.emailAddress,
                      style: new TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),

                  SizedBox(height: 10),
                  Container(
                    child: TextFormField(
                      //controller: countryController,
                      onChanged: (text){
                        //password = text;
                        country = text;
                      },
                      enabled: false,
                      initialValue: 'Canada',
                      cursorColor: primaryColor,
                      decoration: new InputDecoration(
                        focusedBorder:OutlineInputBorder
                          (
                          borderSide: const BorderSide(color:  Colors.grey, width: 1.0),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        labelText: "Country",
                        labelStyle: TextStyle
                          (
                            color: Colors.grey
                        ),
                        fillColor: Colors.white,
                        border: new OutlineInputBorder
                          (
                          borderRadius: new BorderRadius.circular(8.0),
                          borderSide: new BorderSide(
                          ),
                        ),
                      ),
                      validator: (val) {
                        if(val.length==0) {
                          return "Country cannot be empty";
                        }else{
                          return null;
                        }
                      },
                      keyboardType: TextInputType.emailAddress,
                      style: new TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),

                  SizedBox(height: 10),
                  Container(
                    child: TextFormField(
                      //controller: countryController,
                      keyboardType: TextInputType.number,
                      onChanged: (text){
                        //password = text;
                        phoneNumber = text;
                      },
                      cursorColor: primaryColor,
                      decoration: new InputDecoration(
                        focusedBorder:OutlineInputBorder
                          (
                          borderSide: const BorderSide(color:  Colors.grey, width: 1.0),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        labelText: "Phone number",
                        labelStyle: TextStyle
                          (
                            color: Colors.grey
                        ),
                        fillColor: Colors.white,
                        border: new OutlineInputBorder
                          (
                          borderRadius: new BorderRadius.circular(8.0),
                          borderSide: new BorderSide(
                          ),
                        ),
                      ),
                      validator: (val) {
                        if(val.length==0) {
                          return "Phone number cannot be empty";
                        }else{
                          return null;
                        }
                      },
                      style: new TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),

                  /*SizedBox(height: 10),
                  Container(
                    child: TextFormField(
                      //controller: countryController,
                      keyboardType: TextInputType.text,
                      onChanged: (text){
                        //password = text;
                        comment = text;
                      },
                      cursorColor: primaryColor,
                      decoration: new InputDecoration(
                        focusedBorder:OutlineInputBorder
                          (
                          borderSide: const BorderSide(color:  Colors.grey, width: 1.0),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        labelText: "Comment",
                        labelStyle: TextStyle
                          (
                            color: Colors.grey
                        ),
                        fillColor: Colors.white,
                        border: new OutlineInputBorder
                          (
                          borderRadius: new BorderRadius.circular(8.0),
                          borderSide: new BorderSide(
                          ),
                        ),
                      ),
                      validator: (val) {
                        if(val.length==0) {
                          return "Comment cannot be empty";
                        }else{
                          return null;
                        }
                      },
                      style: new TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),*/





                  SizedBox(height: 20,),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: FlatButton(
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(8)
                      ),
                      color: primaryColor,
                      onPressed: ()
                      {

                        /*StripePayment.paymentRequestWithCardForm(CardFormPaymentRequest()).then((paymentMethod) {
                          //_scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('Received ${paymentMethod.id}')));
                          setState(() {
                            _paymentMethod = paymentMethod;
                            sendDataToServer();

                          });
                        }).catchError(setError);*/
                        //sendDataToServer();
                        getToken();
                      },
                      textColor: white,
                      child: isLoading ? CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(white),): Text("CONTINUE"),
                    ),
                  ),
                  SizedBox(height: 50,),


                ],
              ),
            )
          ],
        ),
      ),
    );


  }


  void saveData(dynamic data) async
  {
    var preferences = await SharedPreferences.getInstance();
    preferences.setString(user_token, data);
    getToken();
    //print(preferences.getString(user_token));
    // var savedValue = preferences.getString('value_key');
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
        saveData(responseJson);
        print(responseJson.toString());

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

  void getToken() async
  {
    try{
      var preferences = await SharedPreferences.getInstance();
      print(preferences.getString(user_token ?? ''));
      sendDataToServer(preferences.getString(user_token ?? ''));
    }
    catch(e)
    {
      showToast('Something went wrong');
    }
  }



  Future<void> sendDataToServer(String token) async {

    if (_formKey.currentState.validate()) {

      Map addressInfo = { "addressInformation": { "shippingAddress": { "country_id": "CA", "street": [ streetAddress ], "company": company, "telephone": phoneNumber, "postcode": zip, "city": city, "region": state, "region_id": '74',  "firstname": fName, "lastname": lName, "email": email, "sameAsBilling": 1 },
        "billingAddress": { "country_id": "CA", "street": [ streetAddress ], "company":company, "telephone": phoneNumber, "postcode": zip , "city": city,"region": state,"region_id": '74', "firstname": fName, "lastname": lName, "email": email }, "shipping_method_code": "flatrate", "shipping_carrier_code": "flatrate" } };


      addressToOrderDetail = { "country_id": "CA", "street": [ streetAddress ], "telephone": phoneNumber, "postcode": zip, "city": city, "region": state,  "firstname": fName, "lastname": lName, "email": email };
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
          loginInfoFromLocal();
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
    else{
      print('errors');
    }

  }

  /*Future<void> getCartId(String token) async {
    print('getCartID');
    setState(() {
      isLoading = true;
      //gettingCartId = true;
    });
    print(createCartId);
    final response = await http.get(
      createCartId,
      headers: {HttpHeaders.authorizationHeader: "Bearer "+token,
        HttpHeaders.contentTypeHeader: contentType},
    );
    setState(() {
      isLoading = false;
      //gettingCartId = false;
    });

    if(response.statusCode == 200)
    {
      final responseJson = json.decode(response.body);
      //cartId = responseJson.to;

      //assignCartToUser(token);
      //addItemToCart();


      addItemToCart(responseJson['id'].toString(), token );
      print(responseJson);
    }
    else
    {
      setState(() {
        isLoading = false;
        //gettingCartId = false;
      });
      final responseJson = json.decode(response.body);
      showToast(responseJson['message']);
    }
  }


  int itemReqCounter = 0;

  Future<void> addItemToCart( String cartId, String token) async {
    try{
      print(cartId);

      //dynamic itemArray = new Map();

      Map abc = { "cartItem" : {'sku': cartList[itemReqCounter]['sku'], "qty" : cartList[itemReqCounter]['quantity'], "quoteId" : cartId }};
      setState(() {
        isLoading = true;
      });

      print(itemToCartURL(cartId));
      print(json.encode(abc));
      final response = await http.post(
          itemToCartURL(cartId),
          headers: {HttpHeaders.authorizationHeader: 'Bearer '+token,
            HttpHeaders.contentTypeHeader: contentType},
          body: json.encode(abc)
      );

      setState(() {
        isLoading = false;
      });
      if(response.statusCode == 200)
      {
        final responseJson = json.decode(response.body);
        print(responseJson);
        itemReqCounter++;
        if(itemReqCounter == cartList.length)
        {
          Navigator.pushReplacementNamed(context, '/orderDetail');
        }
        else{

          addItemToCart(cartId, token);
        }


      }
      else
      {
        print(response.statusCode);
        final responseJson = json.decode(response.body);
        print(responseJson);
        showToast(responseJson['message']);
      }
    }
    catch(e)
    {
      setState(() {
        isLoading = false;
      });
      print(e);
    }
  }
*/
/*
  Future<void> assignCartToUser(String Token) async {
    if (_formKey.currentState.validate()) {
      try
      {print('payment method');
        //print(addressInfo);
        setState(() {
          isLoading = true;
        });
        Map cartInfo = {
          "customerId": userInfoObject['id'],
          "storeId": userInfoObject['store_id']
        };

        final response = await http.put(
            paymentMethod+cartId,
            headers: {HttpHeaders.authorizationHeader: 'Bearer '+ Token,
              HttpHeaders.contentTypeHeader: contentType},
            body: json.encode(cartInfo)
        );
        //response.add(utf8.encode(json.encode(itemInfo)));

        if(response.statusCode == 200)
        {
          final responseJson = json.decode(response.body);
          print(responseJson);
          if(responseJson == true)
          {
            isLoading = false;
            addressAdded = true;
            Navigator.pushReplacementNamed(context, '/orderDetail');
          }
          //createOrder(responseJson);

        }
        else
        {
          final responseJson = json.decode(response.body);
          showToast(responseJson['message']);
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
    else{
      print('errors');
    }

  }*/

  /*Future<void> createOrder(dynamic paymentMethodMap) async {
    if (_formKey.currentState.validate()) {
      try
      {
        print('createOrder');
      //print(addressInfo);
      setState(() {
        isLoading = true;
      });

      Map orderInfo = {
        "paymentMethod": {
          "method": "stripe_payments",
          "additional_data": {
            "token": (_paymentMethod?.toJson() ?? {})['id']
          }
        }
      };
      print(paymentMethod+cartId+'/order');
      //return;
      final response = await http.put(
        paymentMethod+cartId+'/order',
        headers: {HttpHeaders.authorizationHeader: auth,
          HttpHeaders.contentTypeHeader: contentType},
        body: json.encode(orderInfo)
      );
      //response.add(utf8.encode(json.encode(itemInfo)));

      if(response.statusCode == 200)
      {
        final responseJson = json.decode(response.body);
        print(responseJson);
      }
      else
      {
        showToast('Something went wrong');
        final responseJson = json.decode(response.body);
        showToast(responseJson['message']);
        print(responseJson);
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
    else{
      print('errors');
    }

  }
*/


}
