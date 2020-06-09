import 'dart:io';

import 'package:client/screens/user/signin.dart';
import 'package:flutter/material.dart';
import 'package:client/utils/common.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {


  @override
  _SplashScreenState createState() => _SplashScreenState();

}

class _SplashScreenState extends State<SplashScreen> {




  void splashTimer() async
  {
    print('start');
    Future.delayed(Duration(seconds: 2) ,() {
      Navigator.pushReplacementNamed(context, '/postal');
      //isLoggedIn();
      //SystemNavigator.pop();
      print('end');
    });
  }



  clearPReference() async
  {
     var preferences = await SharedPreferences.getInstance();
     preferences.clear();
  }
  @override
  void initState() {
    super.initState();
    //clearPReference();

    splashTimer();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(90.0),
          child: Image(
            image: AssetImage('assets/images/logo_white.png'),
          ),
        ),
      ),
    );
  }




  void isLoggedIn() async
  {
    var preferences = await SharedPreferences.getInstance();
    //preferences.getBool(is_logged_in ?? false);
    try
    {
      if(!preferences.getBool(is_logged_in ?? false))
      {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => SignIn( 'postal'),
            ));
      }
      else
      {
        Navigator.pushReplacementNamed(context, '/postal');
      }
    }
    catch(e){
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SignIn( 'postal'),
          ));
      print("exception");}

    //return preferences.getBool(is_logged_in ?? false);
  }
}
