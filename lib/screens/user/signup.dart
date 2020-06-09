import 'dart:convert';
import 'dart:io';

import 'package:client/utils/common.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:client/screens/webview_screen.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {


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
  String passwordString = '';


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: white,
        elevation: 0,
        centerTitle: true,
        title: Text('Signup',
        style: TextStyle(
            fontWeight: FontWeight.bold,
            color: darkText
        ),),
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(15, 60, 15, 0),
            child: Form(
              key: signUpKey,
              child: Column
                (
                children: <Widget>[
                  Center(
                    child: Text('Join LanesOpen today!',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: darkText,
                        fontSize: 18,

                      ),
                    ),
                  ),
                  SizedBox(height: 5,),
                  Center(
                    child: Text('Create an account to start shopping',
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: lightestText,
                        fontSize: 14,

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
                              lName  = text;
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
                  SizedBox(height: 10),
                  Container(
                    child: TextFormField(
                      onChanged: (text){
                        //password = text;
                        email  = text;
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
                      //initialValue: savedPostalCode,
                      onChanged: (text){
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
                  ),*/
                  SizedBox(height: 10),
                  Container(
                    child: TextFormField(
                      obscureText: true,
                      onChanged: (text){
                        passwordString = text;
                      },
                      cursorColor: primaryColor,
                      decoration: new InputDecoration(
                        focusedBorder:OutlineInputBorder
                          (
                          borderSide: const BorderSide(color:  Colors.grey, width: 1.0),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        labelText: "Password",
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
                          return "Password cannot be empty";
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
                  GestureDetector(
                    onTap: (){
                     Navigator.of(context).push(
                      CupertinoPageRoute(
                          fullscreenDialog: true,
                          builder: (context) => WebviewScreen("https://lanesopen.com/terms-and-conditions", "Terms & conditions")
                      )
                  );
                    },
                        child: Container(
                      padding: EdgeInsets.only(top: 20, bottom: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("By clicking on submit you agree ",
                          style: TextStyle(
                            color: lightestText,
                            fontSize: 12
                          )),
                          Text("Terms & conditions",
                          style: TextStyle(
                            color: primaryColor,
                            fontSize: 12
                          )),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      Navigator.of(context).push(
                      CupertinoPageRoute(
                          fullscreenDialog: true,
                          builder: (context) => WebviewScreen("https://lanesopen.com/privacy-policy", "Privacy Policy")
                      )
                  );
                    },
                                      child: Text("Privacy Policy",
                            style: TextStyle(
                              color: primaryColor,
                              fontSize: 12
                            )),
                  ),
                  SizedBox(height: 10,),
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
                        FocusScope.of(context).requestFocus(FocusNode());
                        signUp();
                      },
                      textColor: white,
                      child: isLoading? CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color> (white),) : Text("SIGNUP"),
                    ),
                  ),

                  /*Container(
                margin: EdgeInsets.all(40),
                child: SizedBox(
                  width: double.infinity,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 5,
                        child: Divider(
                          thickness: 1,

                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Center(
                          child: Text('OR',
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: lightestText,
                              fontSize: 14,

                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: Divider(
                          thickness: 1,

                        ),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: ()
                {
                  Navigator.of(context).pushReplacement(
                      CupertinoPageRoute(
                          fullscreenDialog: true,
                          builder: (context) => SignIn('finish')
                      )
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Already have an account?',
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: lightestText,
                        fontSize: 14,

                      ),
                    ),
                Text(' SignIn',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                    fontSize: 14,


                  ),)
                  ],
                ),
              )*/
                ],
              ),
            ),
          ),
          SizedBox(height: 50,)
        ],
      ),
    );
  }

  final signUpKey = GlobalKey<FormState>();
  bool isLoading = false;

  Future<void> signUp() async {

    if (signUpKey.currentState.validate()) {

      Map addressInfo = {
        "customer": {
          "email": email,
          "firstname": fName,
          "lastname": lName,
          "addresses": [
            /*{
              "defaultShipping": true,
              "defaultBilling": true,
              "firstname": fName,
              "lastname": lName,
              "region": {
                "regionCode": null,
                "region": null,
                "regionId": null
              },
              "postcode": "LL",
              "street": [
                "ss"
              ],
              "city": "Purchase",
              "telephone": phoneNumber,
              "countryId": "CA"
            }*/
          ],
          "custom_attributes": [
            {
              "attribute_code": "telephone",
              "value": phoneNumber
            },
            {
              "attribute_code": "b2b_activasion_status",
              "value": "2"
            }
          ]
        },
        "password": passwordString
      };

      try
      {
        print(loginUrl);
        print(addressInfo);

        setState(() {
          isLoading = true;
        });

        final response = await http.post(
            signUpUrl,
            headers: {//HttpHeaders.authorizationHeader: auth,
              HttpHeaders.contentTypeHeader: contentType},
            body: json.encode(addressInfo)
        );
        //response.add(utf8.encode(json.encode(itemInfo)));

        if(response.statusCode == 200)
        {
          final responseJson = json.decode(response.body);
          //getUserInfoFromServer(responseJson);
          saveData(responseJson);
          /*setState(() {
            isLoading = false;
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
    else{
      print('errors');
    }

  }




  Future<void> getNewCartId(String token) async {
    print('getCartID');
    setState(() {
      isLoading = true;
      gettingCartId = true;
    });
    final response = await http.post(
      createCartId,
      headers: {HttpHeaders.authorizationHeader: 'Bearer '+token,
        HttpHeaders.contentTypeHeader: contentType},
    );
    setState(() {
      isLoading = false;
      gettingCartId = false;
    });
    if(response.statusCode == 200)
    {
      final responseJson = json.decode(response.body);
      // cartId = responseJson;
      print(responseJson);
      cartValues(responseJson, 0);
      //addItemToCart();

    }
    else
    {
      setState(() {
        isLoading = false;
        gettingCartId = false;
      });
      final responseJson = json.decode(response.body);
      print(responseJson);
      showToast(responseJson['message']);
    }
  }


  void cartValues(dynamic data, int quantity) async
  {
    var preferences = await SharedPreferences.getInstance();

    ;
    if(quantity == 0)
    {
      preferences.setInt(cart_id, data);
      preferences.setInt(cart_count, 0);
    }
    else{
      preferences.setInt(cart_id, data["id"]);
      preferences.setInt(cart_count, data["items_count"]);
    }
    //Navigator.pushReplacementNamed(context, '/home');
    Navigator.pop(context);
    Navigator.pop(context);
    //print(preferences.getString(user_token));
    // var savedValue = preferences.getString('value_key');
  }








  Future<void> loginRequest() async {



      Map addressInfo = { 'username' : email, 'password' : passwordString};

      try
      {
        print(loginUrl);
        print(addressInfo);

        setState(() {
          isLoading = true;
        });

        final response = await http.post(
            loginUrl,
            headers: {//HttpHeaders.authorizationHeader: auth,
              HttpHeaders.contentTypeHeader: contentType},
            body: json.encode(addressInfo)
        );
        //response.add(utf8.encode(json.encode(itemInfo)));

        if(response.statusCode == 200)
        {
          final responseJson = json.decode(response.body);

          saveToken(responseJson);
          getNewCartId(responseJson);
          /*setState(() {
            isLoading = false;
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












  void saveToken(dynamic data) async
  {
    var preferences = await SharedPreferences.getInstance();
    preferences.setString(user_token, data);


  }

  void saveData(dynamic data) async
  {
    var preferences = await SharedPreferences.getInstance();

    preferences.setString(user_token, "0");
    preferences.setString(username, email);
    preferences.setString(password, passwordString);
    preferences.setBool(is_logged_in, true);

    preferences.setInt(store_id, data['store_id']);
    preferences.setInt(id, data['id']);
    preferences.setString(firstname, data['firstname']);
    preferences.setString(lastname, data['lastname']);
    preferences.setString(savedEmail, data['email']);
     String phoneNumber = '';
    try
    {phoneNumber = data['custom_attributes'][0]['value'];}
    catch(e){ try{phoneNumber = data['addresses'][0]['telephone'];}
    catch(e){phoneNumber = '';}}
    preferences.setString(savedtelephone, phoneNumber);
    print(phoneNumber);

    loginRequest();

    //print(preferences.getString(user_token));
    // var savedValue = preferences.getString('value_key');
  }


}
