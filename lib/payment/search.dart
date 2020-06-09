import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:badges/badges.dart';
import 'package:client/screens/add_special_request.dart';
import 'package:client/screens/categories.dart';
import 'package:client/utils/common.dart';
import 'package:client/widget/product.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class FindItem extends StatefulWidget {

  String storeId;

  FindItem(this.storeId);

  @override
  _FindItemState createState() => _FindItemState();
}

class _FindItemState extends State<FindItem> {


  int currentPage = 1;

  bool ischanged = false;
  TextEditingController textEditingController = new TextEditingController();

  String query = '';



  @override
  void initState() {
    startTimer();
    super.initState();

  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

Timer timer ;
int justaNumber= 0;
  void startTimer()
  {
    timer = new Timer.periodic(Duration(seconds: 1), (timer) {  setState(() {
      justaNumber = 11;
     // print('valueSett');
    });});
  }

int countFromLocal = 0;
  void getCartCount() async
  {
    try{
      var preferences = await SharedPreferences.getInstance();
     // print(preferences.getInt(cart_count ?? 0));
      countFromLocal =  preferences.getInt(cart_count);
    }
    catch(e)
    {
      showToast('Error while getting cart count');
      countFromLocal = 0;
    }
  }

  @override
  Widget build(BuildContext context) {

    getCartCount();
    return Scaffold(
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
        centerTitle: true,
        backgroundColor: white,
        iconTheme: IconThemeData(color: darkText),
        title: Text('Search',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: darkText
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            color: lightGrey,
            padding: EdgeInsets.all(8),
            child: Card(
              child: Container(
                margin: EdgeInsets.only(left: 10,),
                  color: white,
                  child: Row(
                    // crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[

                      Expanded(
                        flex: 10,
                        child: Container(
                          margin: EdgeInsets.only(left: 20, right: 20),
                          child:TextField(
                            controller: textEditingController,
                            enabled:  true,
                            //textCapitalization: TextCapitalization.characters,
                            onChanged: (text)
                            {

                              query = text;
                              // print(query);
                              ischanged = true;
                            },
                            decoration : InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Search...',
                            ),
                            textInputAction: TextInputAction.search,
                            onSubmitted: (val)
                            {
                              if(textEditingController.text == ""){
                                      return;
                                    }
                              productFromServer = new List();
                                    currentPage = 1;
                                    getProducts(widget.storeId.toString());
                                    FocusScope.of(context).requestFocus(FocusNode());
                            },
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,

                        child: Container(
                            height: 50,
                            decoration: new BoxDecoration(
                              color: primaryColor,
                              borderRadius: new BorderRadius.only(
                                bottomRight: const Radius.circular(4.0),
                                topRight: const Radius.circular(4.0),
                              ),
                            ),
                            child: Center(
                                child: IconButton(
                                  onPressed: (){
                                    print(textEditingController.text);
                                    if(textEditingController.text == ""){
                                      return;
                                    }
                                    productFromServer = new List();
                                    currentPage = 1;
                                    getProducts(widget.storeId.toString());
                                    FocusScope.of(context).requestFocus(FocusNode());},
                                  icon: Icon(Icons.search),
                                  color: white,
                                )
                            )),
                      ),
                    ],
                  )
              ),
            ),
          ),

          !isLoading && productFromServer.length ==0 ? SizedBox(
            width: double.infinity,
              child: Container(
                margin: EdgeInsets.all(30),
                color: white,
              child: Column(
                children: <Widget>[
                  Container(
                    height: 150,
                    child: Image.asset("assets/images/search.png"),
                  ),
                  new FlatButton(
                  onPressed: ()
                  {
                    Navigator.of(context).push(
                      CupertinoPageRoute(
                        fullscreenDialog: true,
                        builder: (context) => AddSpecialRequest(),
                      )
                    );
                  },
                  color: white,
                  child: (Text("Add a Special Request",
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 15,
                    fontWeight: FontWeight.bold
                  ),
                  )),
        ),
                ],
              ),
            ),
          )  : Expanded(
            child:  Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
               isLoading ? Container() :  Container(
                 color: white,
                 
                 child: Column(
                      
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: createCategory()
                    ),
               ),
                Expanded(
                  child:
                  GridView.count(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    primary: false,
                    padding: const EdgeInsets.all(15),
                    childAspectRatio: (160 / 220),
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    crossAxisCount: 2,
                    //controller: controller,
                    children: isLoading && currentPage ==1 ? [Center(child: Container(
                        margin:EdgeInsets.only(top: 80),height: 40, width: 40, child: CircularProgressIndicator()))] :getChildren(),
                  )

                  /*ListView(

                      children: isLoading && currentPage ==1 ? [Center(child: Container(
                          margin:EdgeInsets.only(top: 80),height: 40, width: 40, child: CircularProgressIndicator()))] :getChildren()
                  ),*/
                ),
              ],
            ),
          )
        ],
      ),
    );
  }


  dynamic categoryFromServer = new List();
  List<Widget> createCategory()
  {
    List<Widget> categoryList = new List();
    if(categoryFromServer.length > 0)
    {
categoryList.add(SizedBox(
      width: double.infinity,
          child: new Container(
        padding: EdgeInsets.only(left: 15, right: 15, bottom: 3, top: 3),
        color: background,
        child: Text
        (
          "Products in Category",
          style: TextStyle
          (
            color: lightestText,
            fontSize: 16,
            fontWeight: FontWeight.bold
          )
        )
      ),
    ));
    }
    
    for (dynamic category in categoryFromServer)
    {
      String catName  = category['name'];
      String innerCatName = '';
       String entity_id = '';
      dynamic  catChild = category['child'] as List;
    
      category["children_data"] = catChild;
      category["children_data"][0]['id'] = category["children_data"][0]['entity_id'];
      print(category);
      for(var catInner in catChild)
      {
        innerCatName = catInner['name'];
        entity_id = catInner['entity_id'];
      }
        categoryList.add( GestureDetector(
            onTap: ()
              {
                Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Categories(categoryList: category,),
        ));
                
              },
            child: Container(
            margin: EdgeInsets.only(top: 8),
            padding: EdgeInsets.only(left:15, right: 15),
            child: Row(
                children: <Widget>[
                  Text(catName+ " > ",
                  style: TextStyle(
                    fontSize: 15,
                    color: darkText
                  ),),
                  Expanded(
                    child: Text(innerCatName,
                    style: TextStyle(
                      fontSize: 15,
                      color: primaryColor,
                      fontWeight: FontWeight.bold
                    ),),
                  ),
                ],
              ),
          ),
        ) );
    }
    categoryList.add(SizedBox(
      width: double.infinity,
          child: new Container(
            margin: EdgeInsets.only(top: 8),
        padding: EdgeInsets.only(left: 15, right: 15, bottom: 3, top: 3),
        color: background,
        child: Text
        (
          "Products ("+ productFromServer.length.toString()+")",
          style: TextStyle
          (
            color: lightestText,
            fontSize: 16,
            fontWeight: FontWeight.bold
          )
        )
      ),
    ));
    return categoryList;
  }




  bool isDialogLoading = false;
  List<Widget> getChildren()
  {
    List<Widget> productList = new List();
    for(int i = 0; i < productFromServer.length; i ++)
    {
      productList.add(new Product(productFromServer[i], 0));
    }
   /* if(productList.length > 0)
    {
      productList.add(new FlatButton(
          onPressed: isLoading? (){} : (){
            currentPage ++;
            productList.remove(productList.length-1);
            productList.add(CircularProgressIndicator());
            setState(() {

            });
            getProducts(widget.storeId.toString());

          },
          child: isLoading ? Container( height: 40, width: 40, child: CircularProgressIndicator()): Text('Load More')
      )
      );
    }*/
    

    return productList;
  }

  

  dynamic productFromServer = new List();
  bool isLoading = false;
  Future<void> getProducts(String categoyId) async {

    setState(() {
      isLoading = true;
    });

    print(textEditingController.text);
    categoryFromServer= new List();
    try
    {
       print("https://demo2.lanesopen.com/index.php/rest/V1/yello/searchProducts/");
     Map searchData = {"keyword":textEditingController.text,"page":1,"category_id":categoyId};
     print(searchData);
      final response = await http.post(
       domainURL+"index.php/rest/V1/yello/searchProducts/",
      headers: {HttpHeaders.authorizationHeader: auth,
        HttpHeaders.contentTypeHeader: 'application/json'},
        body: json.encode(searchData)
    );
    //print(json.decode(response.body));
    if(response.statusCode == 200)
    {
      final responseJson = json.decode(response.body);
      // print(responseJson);
      if(currentPage > 1)
      {
       // productFromServer.removeAt(productFromServer.length -1);
      }
      print(responseJson[0]['products']);
      productFromServer.addAll(responseJson[0]['products'] as List); //;
      categoryFromServer.addAll(responseJson[0]['category'] as List);
      // productFromServer.add({'isLast':'1'});
      setState(() {
        isLoading = false;
        //createProduct();
        print('setstate');
      });

    }
    else
    {
      setState(() {
        isLoading = false;
      });
    }
    }
    catch(e)
    {
      print(e);
      setState(() {
        isLoading = false;
      });
      showToast('Something went wrong');
    }
  }

}



class SearchedItem extends StatefulWidget {

  dynamic productData;
  Function openDialog;
  SearchedItem(this.productData, this.openDialog);
  @override
  _SearchedItemState createState() => _SearchedItemState();
}

class _SearchedItemState extends State<SearchedItem> {
  @override
  Widget build(BuildContext context) {

    print(widget.productData['custom_attributes'][0]['value']);
    return GestureDetector(
      onTap: widget.openDialog,
      child: Card(
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(

            children: <Widget>[
              FadeInImage.assetNetwork(
                height: 70,
                width: 70,
                placeholder: 'assets/images/loading.gif',
                image: widget.productData['custom_attributes'][0]['value'],
              ),
              SizedBox(width: 10,),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(widget.productData['name'],
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                          color: lightestText,
                          fontSize: 15,
                        )
                    ),
                    SizedBox(height: 5,),
                    Text('\$' + widget.productData['price'].toStringAsFixed(2),

                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,

                        )
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

