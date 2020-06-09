import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:client/utils/common.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}


class _ChangePasswordState extends State<ChangePassword> {

  final signInKey = GlobalKey<FormState>();
  String oldPassword = '';
  String newPassword = '';
  String confirmPassword = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              margin: EdgeInsets.only(left: 15, top: 30),
              child: IconButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                icon: Icon(Icons.close, color: darkText,),

              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              margin: EdgeInsets.only(top: 50),
              child: Text("Change Password",
                style: TextStyle(
                    color: darkText,
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
          ),

          Align(
            alignment: Alignment.topCenter,
            child: Container(
              margin: EdgeInsets.only(top: 150, left: 10, right: 10),
              child: Form(
                key: signInKey,
                child: Column(
                  children: <Widget>[

                    Container(
                      child: TextFormField(
                        obscureText: true,
                        onChanged: (text){
                          oldPassword = text;
                        },
                        cursorColor: primaryColor,
                        decoration: new InputDecoration(
                          focusedBorder:OutlineInputBorder
                            (
                            borderSide: const BorderSide(color:  Colors.grey, width: 1.0),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          labelText: "Old Password",
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
                        obscureText: true,
                        onChanged: (text){
                          newPassword = text;
                        },
                        cursorColor: primaryColor,
                        decoration: new InputDecoration(
                          focusedBorder:OutlineInputBorder
                            (
                            borderSide: const BorderSide(color:  Colors.grey, width: 1.0),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          labelText: "New Password",
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
                    SizedBox(height: 10),
                    Container(
                      child: TextFormField(
                        obscureText: true,
                        onChanged: (text){
                          confirmPassword = text;
                        },
                        cursorColor: primaryColor,
                        decoration: new InputDecoration(
                          focusedBorder:OutlineInputBorder
                            (
                            borderSide: const BorderSide(color:  Colors.grey, width: 1.0),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          labelText: "Confirm Password",
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
                          if(oldPassword == "" || newPassword == "" || confirmPassword == "")
                          {
                            showToast("Please fill all fields");
                          }
                          else
                          {
                            if(newPassword != confirmPassword)
                            {
                              showToast("Password doesn't matched");
                              return;
                            }
                            else
                            {
                              FocusScope.of(context).requestFocus(FocusNode());
                              loginInfoFromLocal();
                            }
                          }
                          
                          
                        },
                        textColor: white,
                        child: isLoading ? CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(white),) : Text("UPDATE"),
                      ),
                    ),
                    SizedBox(height: 40,),




                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }


  void savePassword() async
  {
    var preferences = await SharedPreferences.getInstance();

    preferences.setString(password, newPassword);
    preferences.setBool(is_logged_in, true);
    Navigator.pop(context);
    //print(preferences.getString(user_token));
    // var savedValue = preferences.getString('value_key');
  }

  bool isLoading = false;

  Future<void> changePassword(String token) async {


    
    if (signInKey.currentState.validate()) {

      Map addressInfo =  {
        "currentPassword": oldPassword,
        "newPassword": newPassword
      } ;

      try
      {
        print(forgotPassword);
        print(addressInfo);

        setState(() {
          isLoading = true;
        });

        final response = await http.put(
            changePasswordURL,
            headers: {HttpHeaders.authorizationHeader: "Bearer "+token,
              HttpHeaders.contentTypeHeader: contentType},
            body: json.encode(addressInfo)
        );
        //response.add(utf8.encode(json.encode(itemInfo)));

        if(response.statusCode == 200)
        {
          final responseJson = json.decode(response.body);

          savePassword();
          //exitDialog();
          showToast("Password changed successfully");

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
      changePassword(preferences.getString(user_token ?? ''));
    }
    catch(e)
    {
      showToast('Something went wrong');
    }
  }


  void saveData(dynamic data) async
  {
    var preferences = await SharedPreferences.getInstance();
    preferences.setString(user_token, data);
    getToken();
    //print(preferences.getString(user_token));
    // var savedValue = preferences.getString('value_key');
  }










}



