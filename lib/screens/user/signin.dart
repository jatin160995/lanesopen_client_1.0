import 'dart:convert';
import 'dart:io';

import 'package:client/screens/user/forgot_password.dart';
import 'package:client/screens/user/signup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:client/utils/common.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SignIn extends StatefulWidget {

  String identifier ;

  SignIn(this.identifier);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  String usernameString = '';
  String passwordString = '';



  final signInKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: white,
        elevation: 0,
        centerTitle: true,
        title: Text('Signin',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: darkText
          ),),
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body: Container(
        margin: EdgeInsets.fromLTRB(15, 50, 15, 0),
        child: Column
          (
          children: <Widget>[
            Center(
              child: Text('Signin to Lanesopen!',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: darkText,
                  fontSize: 18,

                ),
              ),
            ),
            SizedBox(height: 5,),
            Center(
              child: Text('Signin to start shopping',
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  color: lightestText,
                  fontSize: 14,

                ),
              ),
            ),
            SizedBox(height: 15,),

            Form(
              key: signInKey,
              child: Column(
                children: <Widget>[
                  Container(
                    child: TextFormField(
                      enabled: isLoading ? false: true,
                      onChanged: (text){
                        usernameString = text;
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
                      enabled: isLoading ? false: true,
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
                ],
              ),
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
                  loginRequest();
                },
                textColor: white,
                child: isLoading ? CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(white),): Text("SIGNIN"),
              ),
            ),
       /* SizedBox(height: 10,),
        FlatButton(
          onPressed:()
          {
            Navigator.of(context).push(
                CupertinoPageRoute(
                    fullscreenDialog: true,
                    builder: (context) => ForgotPassword()
                )
            );
          },
          child: Text("Forgot Password"),
        ),*/

      Container(
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
          Navigator.of(context).push(
              CupertinoPageRoute(
                  fullscreenDialog: true,
                  builder: (context) => Signup()
              )
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Don\'t have account? ',
              style: TextStyle(
                fontWeight: FontWeight.normal,
                color: lightestText,
                fontSize: 14,

              ),
            ),
            Text(' SignUp',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: primaryColor,
                fontSize: 14,


              ),)
          ],
        ),)

          ],
        ),
      ),
    );
  }


  bool isLoading = false;

  Future<void> loginRequest() async {

    if (signInKey.currentState.validate()) {

      Map addressInfo = { 'username' : usernameString, 'password' : passwordString};

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
          getUserInfoFromServer(responseJson);
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
        // body: json.encode(addressInfo)
      );
      //response.add(utf8.encode(json.encode(itemInfo)));

      if(response.statusCode == 200)
      {
        final responseJson = json.decode(response.body);
        //saveData(responseJson);
        getCartId(token);
        userInfoObject = responseJson;
        saveNameData(responseJson);
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
        //isLoading = false;
      });
    }
    catch(e){
      print(e);
      showToast('Something went wrong');
      Navigator.pop(context);

    }

  }


  Future<void> getCartId(String token) async {
    print('getCartID');
    setState(() {
      isLoading = true;
      gettingCartId = true;
    });
    final response = await http.get(
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
      cartValues(responseJson, 1);
      //addItemToCart();

    }
    else
    {
      setState(() {
        isLoading = false;
        gettingCartId = false;
        getNewCartId(token);
      });
      final responseJson = json.decode(response.body);
      print(responseJson);
      //showToast(responseJson['message']);
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



  void  clearCartFromServer() async
  {

    print(clearCart);
    var preferences = await SharedPreferences.getInstance();
    try
    {
      setState(() {
        isLoading = true;
      });

      final response = await http.post(
          clearCart,
          headers: {HttpHeaders.authorizationHeader: auth,
            HttpHeaders.contentTypeHeader: contentType},
          body: json.encode({'quote_id': preferences.getInt(cart_id ?? 0).toString()})
      );
      //response.add(utf8.encode(json.encode(itemInfo)));
      print({'quote_id': preferences.getInt(cart_id ?? 0).toString()});

      if(response.statusCode == 200)
      {
        final responseJson = json.decode(response.body);
        preferences.setString(min_cart_value, responseJson[0].toString());
        preferences.setString(today_timing, responseJson[1][0]['limits_serialized'].toString());
        if(widget.identifier == 'finish')
        {
          Navigator.pop(context);
        }
        else if(widget.identifier == 'profile')
        {
          Navigator.pop(context);
          Navigator.pushNamed(context, '/profile');
        }
        else if(widget.identifier == 'postal')
        {
          //Navigator.pop(context);
          Navigator.pushReplacementNamed(context, '/postal');
        }
        else if(widget.identifier == 'home')
        {
          Navigator.pushReplacementNamed(context, '/home');
        }

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
        //Navigator.pop(context);
      }
      setState(() {
        isLoading = false;
      });
    }
    catch(e){
      print(e);
      isLoading = false;
      showToast('Something went wrong');
      Navigator.pop(context);

    }

  }



  void saveData(dynamic data) async
  {
    var preferences = await SharedPreferences.getInstance();

    preferences.setString(user_token, data);
    preferences.setString(username, usernameString);
    preferences.setString(password, passwordString);
    preferences.setBool(is_logged_in, true);

    //print(preferences.getString(user_token));
    // var savedValue = preferences.getString('value_key');
  }

  void cartValues(dynamic data, int quantity) async
  {
    var preferences = await SharedPreferences.getInstance();


    if(quantity == 0)
    {
      preferences.setInt(cart_id, data);
      preferences.setInt(cart_count, 0);
    }
    else{
      preferences.setInt(cart_id, data["id"]);
      preferences.setInt(cart_count, 0);
    }



    clearCartFromServer();



    //print(preferences.getString(user_token));
    // var savedValue = preferences.getString('value_key');
  }


  void saveNameData(dynamic data) async
  {
    var preferences = await SharedPreferences.getInstance();

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
    //print(preferences.getString(user_token));
    // var savedValue = preferences.getString('value_key');
  }
}
