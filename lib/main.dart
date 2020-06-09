import 'package:client/screens/store_detail.dart';
import 'package:client/screens/thankyou_screen.dart';
import 'package:client/screens/user/address_book.dart';
import 'package:client/screens/user/my_orders.dart';
import 'package:flutter/material.dart';
import 'package:client/screens/home.dart';
import 'package:client/screens/splash_screen.dart';
import 'package:client/screens/enter_postal_code.dart';
import 'package:client/screens/categories.dart';
import 'package:client/screens/product_detail.dart';
import 'package:client/screens/cart.dart';
import 'package:client/screens/order_detail.dart';
import 'package:client/screens/user/profile.dart';
import 'package:client/screens/user/signin.dart';
import 'package:client/chat/chat.dart';
import 'package:flutter/services.dart';
import 'package:client/utils/common.dart';

void main(){ 
  
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: statusBarColor,
    statusBarIconBrightness: Brightness.light
  ));
  
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
  routes: {
    '/': (context) => SplashScreen(),
    '/home': (context) => Home(null),
    '/postal': (context) => EnterPostalCode(false),
    '/storeDetail': (context) => StoreDetail(storeData: null,),
    '/categories': (context) => Categories(categoryList: null,),
    '/prodDetail': (context) => ProductDetail( productData: null,),
    '/chat': (context) => Chat(null),
    '/cart': (context) => Cart(),
    '/profile': (context) => Profile(),
    '/orderDetail': (context) => OrderDetail(),
    '/thankyou': (context) => ThankyouScreen(),
    '/signin': (context) => SignIn('home'),
    '/myOrders': (context) => MyOrders(),
    '/address': (context) => AddressBook("Address Book"),
  },
  theme: ThemeData(fontFamily: 'proxima'),
));
}