import 'dart:async';

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:client/utils/common.dart';
import 'package:client/widget/product_grid.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Categories extends StatefulWidget {

  dynamic categoryList;
  Categories({Key key, @required this.categoryList}) : super(key: key);

  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {

  dynamic categoryList ;
  List<Widget> getHeading()
  {
    List<Widget> headingList = new List();
    dynamic categoryList = widget.categoryList['children_data'];
    for(int i = 0; i < categoryList.length; i ++)
    {
      headingList.add(Padding(
        padding: EdgeInsets.all(10),
        child: new Text(
            categoryList[i]['name'],
            style: TextStyle(
              color: darkText,
              fontWeight: FontWeight.bold
            ),
        ),
      ));
    }

   // print(categoryList.length);
    return headingList;
    //dynamic categoryList = widget.categoryList['children_data'];

  }

  Timer timer ;
int justaNumber= 0;
  void startTimer()
  {
    timer = new Timer.periodic(Duration(seconds: 1), (timer) {  setState(() {
      justaNumber = 11;
     // print('valueSett');
     getCartCount();
    });});
  }


@override
  void dispose() {
    timer.cancel();
    super.dispose();

    print('onDispose');
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTimer();
    categoryList = widget.categoryList['children_data'] as List;
    getHeading();
  }

   



  int countFromLocal = 0;
  bool isCartIUpdated = false;
  void getCartCount() async
  {
    try{
      var preferences = await SharedPreferences.getInstance();
      //print(preferences.getString(user_token ?? ''));
      countFromLocal =  preferences.getInt(cart_count ?? 0);
      
        

    }
    catch(e)
    {
      showToast('Error while getting cart count');
      countFromLocal = 0;
    }
  }


  @override
  Widget build(BuildContext context) {
    //getCartCount();
    return DefaultTabController(
      length: categoryList.length,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: ()
          {
            Navigator.pushNamed(context, '/cart');
          },
          backgroundColor: primaryColor,
          child: Badge(
            badgeContent: Text(
              countFromLocal.toString(),
              style: TextStyle(
                  color: white
              ),),
            child: Icon(Icons.shopping_cart, size: 25),
          ),
        ),
        appBar: AppBar(
          bottom: TabBar(
            tabs: getHeading(),
            isScrollable: true,
            indicatorColor: primaryColor,

          ),


          iconTheme: IconThemeData(
            color: Colors.black
          ),
          title: Text(widget.categoryList['name'],
          style: TextStyle(
            color: darkText,
            fontWeight: FontWeight.bold
          ),),
          backgroundColor: white,
          centerTitle: true,
        ),
        body: TabBarView(
          children: createTabBarView(),

        ),
      ),
    );
  }


  List<Widget> createTabBarView()
  {

      List<Widget> viewList = new List();
      dynamic categoryList = widget.categoryList['children_data'];
      for(int i = 0; i < categoryList.length; i ++)
      {
        viewList.add(ProductGrid(categoryList[i]));
      }

     // print(categoryList.length);
      return viewList;
      //dynamic categoryList = widget.categoryList['children_data'];


  }


}
