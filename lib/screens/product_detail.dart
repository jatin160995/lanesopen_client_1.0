import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:client/screens/user/signin.dart';
import 'package:flutter/material.dart';
import 'package:client/utils/common.dart';
import 'package:client/widget/horizontal_product_list.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/html_parser.dart';
import 'package:flutter_html/style.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class ProductDetail extends StatefulWidget {


  dynamic productData;

  ProductDetail({Key key, @required this.productData}) : super(key: key);

  @override
  _ProductDetailState createState() => _ProductDetailState();
}


class _ProductDetailState extends State<ProductDetail> {



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
    super.initState();
    startTimer();
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
      backgroundColor: white,
      body: ListView(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Align(
                    child: 
                    SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.width,
                              child: Center(child: CachedNetworkImage(
                                fadeInDuration : const Duration(milliseconds: 400),
                                placeholder: (context, url) =>
                                         Image.asset("assets/images/loading.jpg"),
                                imageUrl: getImage(),
                              )),)
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      margin: EdgeInsets.only(top: 40, left: 15),
                      decoration: new BoxDecoration(
                          color: lightGrey,
                          borderRadius: new BorderRadius.only(
                            topLeft: const Radius.circular(40.0),
                            topRight: const Radius.circular(40.0),
                            bottomRight: const Radius.circular(40.0),
                            bottomLeft: const Radius.circular(40.0),
                          )
                      ),
                      child: IconButton(
                        icon: Icon(Icons.close),
                        onPressed: (){
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  )
                ],
              ),
              Container(
                margin: EdgeInsets.all(15.0),
                child: Text(
                  widget.productData['name'],
                  style: TextStyle(
                      color: darkText,
                      fontWeight: FontWeight.bold,
                      fontSize: 20
                  ),
                ),
              ),
              Row(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 15.0),
                    child: Text(
                      '\$'+ double.parse(widget.productData['final_price'].toString()).toStringAsFixed(2),
                      style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 24
                      ),
                    ),
                  ),
                  widget.productData['base_price'] == widget.productData['final_price'] ? Container() :Container(
                    margin: EdgeInsets.only(left: 15.0),
                    child: Text(
                      '\$'+ double.parse(widget.productData['base_price'].toString()).toStringAsFixed(2),
                      style: TextStyle(
                          color: lightestText,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          decoration: TextDecoration.lineThrough
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 10,),
              Container(
                margin: EdgeInsets.only(left: 15.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      'Availability: ',
                      style: TextStyle(
                          color: lightText,
                            fontWeight: FontWeight.bold,
                            fontSize: 12
                      ),
                    ),
                    Text(
                      widget.productData['status'] == 1 ? 'In Stock' : 'Out Of Stock',
                      style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.normal,
                          fontSize: 14
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 5,),
              Container(
                margin: EdgeInsets.only(left: 15.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      'SKU: ',
                      style: TextStyle(
                          color: lightText,
                            fontWeight: FontWeight.bold,
                            fontSize: 12
                      ),
                    ),
                    Text(
                      widget.productData['sku'],
                      style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.normal,
                          fontSize: 14
                      ),
                    ),
                  ],
                ),
              ),
              widget.productData['description'].toString() != "null" ?  SizedBox(height: 5,) : Container(), 
              Container(
                margin: EdgeInsets.only(left: 15, right: 15),
                child: Text(
                        widget.productData['description'].toString() != "null" ?'Description: ' : "",
                        style: TextStyle(
                            color: lightText,
                            fontWeight: FontWeight.bold,
                            fontSize: 12
                        ),
                      ),
              ),
              Container(
                margin: EdgeInsets.only(left: 10, right: 15),
                //data:widget.productData['description'].toString() != "null" ? widget.productData['description'].toString(): "",
                child: Html(
          data: widget.productData['description'].toString() != "null" ?widget.productData['description'].toString() : "",
          //Optional parameters:
          style: {
            "html": Style(
              backgroundColor: white,
//              color: Colors.white,
            ),
//            "h1": Style(
//              textAlign: TextAlign.center,
//            ),
            "table": Style(
              backgroundColor: Color.fromARGB(0x50, 0xee, 0xee, 0xee),
            ),
            "tr": Style(
              border: Border(bottom: BorderSide(color: Colors.grey)),
            ),
            "th": Style(
              padding: EdgeInsets.all(5),
              backgroundColor: Colors.grey,
            ),
            "td": Style(
              padding: EdgeInsets.all(5),
            ),
           // "var": Style(fontFamily: 'serif'),
           
          },
         
          onLinkTap: (url) {
            print("Opening $url...");
          },
          onImageTap: (src) {
            print(src);
          },
          onImageError: (exception, stackTrace) {
            print(exception);
          },
        )
              ),
              widget.productData['description'].toString() != "null" ? SizedBox(height: 20,) : Container(), 
              Container(
                margin: EdgeInsets.only(left: 15.0),
                child: Row(
                  children: <Widget>[
                    Container(
                      color: primaryColor,
                      width: 150,
                      child: FlatButton(
                        onPressed: ()
                        {
                          //widget.productData['quantity'] = '1';
                          //cartList.add(widget.productData);
                          /*cartId == '' ?
                          getCartId() : addItemToCart();*/
                          isLoggedIn();

                          setState(() {
                           /// cartCount++;
                          });
                          /*setState(() {
                            bool isFound = false;
                            for(var item in cartList ){
                              if(widget.productData["sku"] == item['sku'])
                              {
                                print(item['name']);
                                item['quantity'] = item['quantity'] + 1;
                                isFound = true;
                                //break;
                              }
                            }
                            if(!isFound)
                            {
                              widget.productData['quantity'] = 1;
                              cartList.add(widget.productData);
                            }
                            cartCount ++;
                          });*/

                        },
                        child: isLoading ? CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(white),): Text('Add To Cart',
                          style: TextStyle(
                              color: white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 10,),
              HorizontalProductList(1, getCategoryId(), 'Related Products')
            ],
          ),
        ],
      )
    );
  }


String getCategoryId()
{
  String catID = "";
  try{
    catID = widget.productData['category_id'];
   // print(widget.productData['category_id']);
   }
  catch(e)
  {
    catID = widget.productData['extension_attributes']['category_links'][0]['category_id'];
    //print(widget.productData['extension_attributes']);
  }


  return catID;
}

String getImageToSave()
  {
    String image = '';
    try
    {
      image = widget.productData['image_url'];
    }
    catch(e)
    {
      try
    {
      image =  widget.productData['custom_attributes'][0]['value'];
    }
    catch(e)
    {
      print(e);
      image = "";
    }
    }
    print(image);
    return image;
  }

  String getImage()
  {
   String image = '';
    try
    {
      image = domainURL+"pub/media/catalog/product/" + widget.productData['image'];
    }
    catch(e)
    {
      try
    {
      image = domainURL+"pub/media/catalog/product/" + widget.productData['media_gallery_entries'][0]['file'];
    }
    catch(e)
    {
      print(e);
      image = "";
    }
    }

    return image;
  }

  void isLoggedIn() async
  {
    var preferences = await SharedPreferences.getInstance();
    //preferences.getBool(is_logged_in ?? false);
    try
    {
      if(!preferences.getBool(is_logged_in ?? false))
      {
        Navigator.push(
            context,
            MaterialPageRoute(
              fullscreenDialog: true,
              builder: (context) => SignIn( 'finish'),
            ));
      }
      else
      {
        ///Navigator.pushReplacementNamed(context, '/home');
        addItemToCart();
      }
    }
    catch(e){
      Navigator.push(
          context,
          MaterialPageRoute(
            fullscreenDialog: true,
            builder: (context) => SignIn( 'finish'),
          ));
      print("exception");}

    //return preferences.getBool(is_logged_in ?? false);
  }

  bool isLoading = false;
  Future<void> getCartId() async {
    print('getCartID');
    setState(() {
      isLoading = true;
    });
    final response = await http.post(
      createCartId,
      headers: {HttpHeaders.authorizationHeader: auth,
        HttpHeaders.contentTypeHeader: contentType},
    );
    setState(() {
      isLoading = false;
    });
    if(response.statusCode == 200)
    {
      final responseJson = json.decode(response.body);
      cartId = responseJson;

      addItemToCart();
      print(responseJson);
    }
    else
    {
      showToast('Something went wrong');
    }
  }



  Future<void> addItemToCart() async {


    var preferences = await SharedPreferences.getInstance();
    try{
      print('itemTocart');
      Map itemInfo = { "cartItem" : { "sku" : widget.productData['sku'], "qty" : 1, "quoteId" : preferences.getInt(cart_id ?? 0) } };
      setState(() {
        isLoading = true;
      });
      final response = await http.post(
          itemToCartURL(cartId),
          headers: {HttpHeaders.authorizationHeader: auth,
            HttpHeaders.contentTypeHeader: contentType},
          body: json.encode(itemInfo)
      );
      //response.add(utf8.encode(json.encode(itemInfo)));

      setState(() {
        isLoading = false;
      });
      if(response.statusCode == 200)
      {
        final responseJson = json.decode(response.body);
        //cartId = responseJson;
        //widget.productData['quantity'] = '1';
        cartCount++;
        cartProdTitle.add(widget.productData['name']);
        cartProdImages.add(getImage());
        updateCart();

        print(responseJson);
      }
      else
      {
        showToast('Something went wrong');
      }
    }
    catch(e)
    {
      setState(() {
        isLoading = false;
      });
      print(e);
    }
  }

  void updateCart() async
  {
    try{
      var preferences = await SharedPreferences.getInstance();
      //print(preferences.getString(user_token ?? ''));
      int updatedCount = preferences.getInt(cart_count ?? 0) +1;
      setState(() {
        preferences.setInt(cart_count, updatedCount);
      });
    }
    catch(e)
    {
      showToast('Something went wrong');
    }
  }



}
