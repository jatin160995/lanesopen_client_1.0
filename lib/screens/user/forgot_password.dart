import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:client/utils/common.dart';
import 'package:http/http.dart' as http;

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {

  bool isLoading = false;
  final signInKey = GlobalKey<FormState>();
  String usernameString = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: white,
        elevation: 0,
        centerTitle: true,
        title: Text('Forgot Password',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: darkText
          ),),
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body: Container(
        margin: EdgeInsets.fromLTRB(15, 60, 15, 0),
        child: Column
          (
          children: <Widget>[
            Center(
              child: Text('Enter your email',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: darkText,
                  fontSize: 18,

                ),
              ),
            ),
            SizedBox(height: 5,),
            Center(
              child: Text('',
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
                  //loginRequest();
                  FocusScope.of(context).requestFocus(FocusNode());
                  sendEmail();
                },
                textColor: white,
                child: isLoading ? CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(white),): Text("SUBMIT"),
              ),
            ),
          ],
        ),
      ),
    );
  }





  Future<void> sendEmail() async {

    if (signInKey.currentState.validate()) {


      Map addressInfo =  {
        "email": usernameString,
        "template": "email_reset",
        "websiteId": 1
      };

      try
      {
        print(forgotPassword);
        print(addressInfo);

        setState(() {
          isLoading = true;
        });

        final response = await http.put(
            forgotPassword,
            headers: {HttpHeaders.authorizationHeader: auth,
              HttpHeaders.contentTypeHeader: contentType},
            body: json.encode(addressInfo)
        );
        //response.add(utf8.encode(json.encode(itemInfo)));

        if(response.statusCode == 200)
        {
          final responseJson = json.decode(response.body);

          exitDialog();
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


  void exitDialog() async
  {
    final value = await showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text('Email has been sent. Please follow the instructions.'),
            actions: <Widget>[
              /*FlatButton(
                child: Text('No'),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),*/
              FlatButton(
                child: Text('Okay'),
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



}
