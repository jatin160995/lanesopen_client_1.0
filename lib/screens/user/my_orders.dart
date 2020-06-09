import 'dart:convert';
import 'dart:io';

import 'package:client/utils/common.dart';
import 'package:client/widget/user_order_cell.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MyOrders extends StatefulWidget {
  @override
  _MyOrdersState createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserID();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: darkText),
        backgroundColor: white,
        centerTitle: true,
        title: Text(
          'My Orders',
          style: TextStyle(
            color: darkText,
            fontWeight: FontWeight.bold
          ),
        ),
      ),
      body: isLoading? new Container(
        height: MediaQuery.of(context).size.width,
        width: MediaQuery.of(context).size.width,
        child: Image.asset('assets/images/loading.gif'),
      ):
      ListView(
        children: <Widget>[
          getDD(items)
        ],
      ),
    );
  }

  bool isLoading = false;
  dynamic items = new List();


  void getUserID() async
  {
    setState(() {
      isLoading = true;
    });

    var preferences = await SharedPreferences.getInstance();
    getUserOrders(preferences.getInt(id ?? ''));
  }


  void getUserOrders(int id) async
  {
    try
    {
      setState(() {
        isLoading = true;
      });
      print(orders+id.toString());
      final response = await http.get(
        orders+id.toString(),
        headers: {HttpHeaders.authorizationHeader: auth,
          HttpHeaders.contentTypeHeader: contentType},
        // body: json.encode(addressInfo)
      );
      //response.add(utf8.encode(json.encode(itemInfo)));

      if(response.statusCode == 200)
      {
        final responseJson = json.decode(response.body);
        //saveData(responseJson);
       // items =  responseJson[0]['items'] as List;
        items =  responseJson as List;
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
      isLoading = false;
      showToast('Something went wrong');
      Navigator.pop(context);

    }

  }


  Widget getDD(dynamic variable)
  {
    if(variable.length == 0)
    {
      //return  Container(height: MediaQuery.of(context).size.width,child: Center(child: CircularProgressIndicator()));
    }
    List<Widget> list = new List<Widget>();
    for(int i =variable.length -1; i >= 0; i--){
     // if(variable[i]['status'] != "processing" && variable[i]['status'] != "pending")
      //{
        list.add(new UserOrderCell(variable[i]));
      //}

    }
    if(list.length == 0)
    {
      return new Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.width,
        child: Column(
          children: <Widget>[
            SizedBox(height: 50),
            Text('No Orders!',
              style:  TextStyle(
                  color: lightestText,
                  fontWeight: FontWeight.normal,
                  fontSize: 22
              ),),
            SizedBox(height: 20),

          ],
        ),
      );
    }
    else
    {
      return new Column(crossAxisAlignment: CrossAxisAlignment.stretch,children: list);
    }

  }





}
