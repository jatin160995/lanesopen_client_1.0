import 'dart:convert';
import 'dart:io';

import 'package:badges/badges.dart';
import 'package:client/utils/common.dart';
import 'package:client/widget/product.dart';
import 'package:client/widget/search_grid.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Search extends StatefulWidget {

  String storeId;

  Search(this.storeId);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {



  ScrollController controller;
  int currentPage = 1;

  bool ischanged = false;
  TextEditingController textEditingController = new TextEditingController();

  String query = '';
  void _scrollListener() {

    if (controller.position.pixels == controller.position.maxScrollExtent) {
      //startLoader();
      setState(() {
        currentPage ++;
        print('hello');
        //getProducts();
      });

    }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = new ScrollController()..addListener(_scrollListener);
  }







  int countFromLocal = 0;
  bool isCartIUpdated = false;
  void getCartCount() async
  {
    try{
      var preferences = await SharedPreferences.getInstance();
      //print(preferences.getString(user_token ?? ''));
      countFromLocal =  preferences.getInt(cart_count ?? 0);
      if(!isCartIUpdated)
      {
        setState(() {
          // isCartIUpdated = true;
        });
      }

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
                //padding: EdgeInsets.only(left: 10, right: 10),
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
                                onPressed: (){ print(textEditingController.text); productFromServer.clear(); createProduct(); FocusScope.of(context).requestFocus(FocusNode());},
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

          Expanded(
            key: Key('keyValue'),
            child:GridView.count(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              primary: false,
              padding: const EdgeInsets.all(15),
              childAspectRatio: (160 / 220),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              crossAxisCount: 2,
              controller: controller,
              children: query != '' ? createProduct() : [],
            )
          )
        ],
      ),
    );
  }


  dynamic productFromServer = new List();
  List<Widget> createProduct()
  {

    getProducts();
    List<Widget> productList = new List();
    //productFromServer.clear();
    if(productFromServer.length > 0){
      for(int i =0; i < productFromServer.length; i++)
      {
        print(productFromServer[i]);
        //String isLast = productFromServer[i]['isLast'];
        if(productFromServer[i]['isLast'] == '1')
        {
          productList.add(new FlatButton(onPressed: (){ currentPage ++;
          getProducts();}, child: Text("Load more")));
          continue;
        }
        productList.add(Product(productFromServer[i], 0));

      }
    }
    else {
      if(!isError)
        productList.add(Container(width: MediaQuery.of(context).size.width,child: Center(child: Image.asset('assets/images/loading.gif'))));
      else
        productList.add(Center(child: Text('No Store Avaiable')));
    }
    if(isLoading && currentPage>1)
    {
      productList.add(Container(width: MediaQuery.of(context).size.width,child: Center(child: Image.asset('assets/images/loading.gif'))));
      setState(() {
       // getProducts();
      });
    }
    /* try {


    } on Exception catch (_) {

      print('never reached');
    }
*/
    return productList;
  }

  bool isLoading = false;
  bool isError = false;


  Future<void> getProducts() async {
    if(currentPage > 1)
    {
      productFromServer.removeAt(productFromServer.length -1);
    }
    setState(() {
      isLoading = true;
    });

    print(textEditingController.text);
    try
    {
     print("https://demo2.lanesopen.com/index.php/rest/V1/yello/searchProducts/");
     Map searchData = {"keyword":textEditingController.text,"page":1,"category_id":widget.storeId.toString()};
      final response = await http.post(
       domainURL+"index.php/rest/V1/yello/searchProducts/",
        headers: {HttpHeaders.authorizationHeader: auth,
          HttpHeaders.contentTypeHeader: 'application/json'},
          body: json.encode(searchData)
      );
      print(json.decode(response.body));
      if(response.statusCode == 200)
      {
        final responseJson = json.decode(response.body);
        print(responseJson);

        productFromServer.addAll(responseJson['items'] as List); //;

       // productFromServer.add({'isLast':'1'});
        setState(() {
          isError = false;
          isLoading = false;
          //createProduct();
          print('setstate');
        });

      }
      else
      {
        setState(() {
          isError = true;
          isLoading = false;
        });
      }
    }
    catch(e)
    {
      print(e);
      //showToast('Something went wrong');
    }


  }

  void getSearchResult()
  {
    setState(() {

    });
  }

/*  Widget getViews()
  {
    var results = new SearchProductGrid(
        widget.storeId, query, currentPage.toString(), ischanged);
    print(currentPage.toString());
    return results;
  }*/


}

