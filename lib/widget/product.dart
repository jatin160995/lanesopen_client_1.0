import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:client/screens/user/signin.dart';
import 'package:client/utils/common.dart';
import 'package:flutter/material.dart';
import 'package:client/screens/product_detail.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class Product extends StatefulWidget {


  dynamic productData;
  dynamic isReplacement;

  Product(this.productData, this.isReplacement);

  @override
  _ProductState createState() => _ProductState();
}

class _ProductState extends State<Product> {


  bool isLoading = false;


  void _sendDataToProductDetailScreen(BuildContext context) {
    dynamic textToSend = widget.productData;
    if(widget.isReplacement == 1)
    {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetail(productData: textToSend,),
          ));
    }
    else
      {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductDetail(productData: textToSend,),
            ));
      }

  }

  @override
  Widget build(BuildContext context) {

    //print(widget.productData);
    return Stack(
      children: <Widget>[
        GestureDetector(
          onTap: ()
          {
            _sendDataToProductDetailScreen(context);
          },
          child: Container(
            color: white,
            width: 160,
            child: Column(
              children: <Widget>[
                Container(
                  color: white,
                  width: 160,
                  margin: EdgeInsets.only(left: 10, right: 5),
                  child: Stack(
                    children: <Widget>[
                      isLoading? Align
                        (
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FadeInImage.assetNetwork(
                            height: 161,
                            width: 160,
                            placeholder: 'assets/images/loading.gif',
                            image: ""//widget.productData['custom_attributes'][0]['value'],
                          ),
                        ),
                      ): Container(),
                      Align
                        (
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                              width: 160.0,
                              height: 160.0,
                              child: Center(child: CachedNetworkImage(
                                fadeInDuration : const Duration(milliseconds: 400),
                                placeholder: (context, url) =>
                                         Image.asset("assets/images/loading.jpg"),
                                imageUrl: getImage(),
                              )),)
                            
                            /*FadeInImage.assetNetwork(
                            height: 160,
                            width: 160,
                            placeholder: 'assets/images/loading.jpg',
                            image: getImage()//widget.productData['custom_attributes'][0]['value'],
                          )*/
                        ),
                      ),
                      Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            onPressed:()
                            {
                              //getToken();
                              isLoggedIn();
                              cartProdTitle.add(widget.productData['name']);
                              cartProdImages.add(getImage());
                              /*if(!gettingCartId){
                                cartId == '' ?
                                getCartId() : addItemToCart();
                              }*/
                              /*bool isFound = false;
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
                              }*/
                              cartCount ++;
                            },
                            icon: Icon(Icons.add_shopping_cart,
                              color: primaryColor
                            ),
                          )
                      ),

                    ],
                  ),

                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5.0, right: 5),
                  child: Text(widget.productData['name'],
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      style: TextStyle
                        (
                          color: lightestText,
                          fontSize: 13
                      )),
                ),
                SizedBox(height: 5,),
                Padding(
                    padding: const EdgeInsets.only(left: 5.0, right: 5),
                    child: Text('\$' + double.parse(widget.productData['final_price'].toString()).toStringAsFixed(2),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        style: TextStyle
                          (
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                            fontSize: 19
                        ))
                ),

              ],
            ),
          ),
        ),
        isLoading?
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            color: transparentBackground,
            child: Image(
              height: 160,
              width: 160,
              image: AssetImage('assets/images/loading.gif'),
            ),
          ),
        ) : Container()
      ],
    );
  }


  String getImage()
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
        getToken();
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


  void saveData(dynamic data) async
  {
    var preferences = await SharedPreferences.getInstance();
    preferences.setString(user_token, data);
    getToken();
    //print(preferences.getString(user_token));
    // var savedValue = preferences.getString('value_key');
  }

  void getToken() async
  {
    try{
      var preferences = await SharedPreferences.getInstance();
      print(preferences.getString(user_token ?? ''));
      addItemToCart(preferences.getInt(cart_id ?? 0));

    }
    catch(e)
    {
      //showToast('Something went wrong');
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
      //showToast("Something went wrong");
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
        //Navigator.pop(context);
        //showToast("Something went wrong");
      });}


  }

  /*Future<void> getCartId(String token) async {
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
      cartId = responseJson;

      addItemToCart();
      print(responseJson);
    }
    else
    {
      setState(() {
        isLoading = false;
        gettingCartId = false;
      });
      final responseJson = json.decode(response.body);
      showToast(responseJson['message']);
    }
  }
*/


  Future<void> addItemToCart(int cart_id) async {
    try{
      print('itemTocart');
      Map itemInfo = { "cartItem" : { "sku" : widget.productData['sku'], "qty" : 1, "quoteId" : cart_id } };
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
        //cartCount++;
        //cartId = responseJson;
        //widget.productData['quantity'] = '1';
        updateCart();
        skuList.add(widget.productData['sku']);
        imageList.add( widget.productData['custom_attributes'][0]['value']);
        
        print(responseJson);
      }
      else
      {
        final responseJson = json.decode(response.body);
        print(responseJson);
        loginInfoFromLocal();
        showToast(responseJson['message']);
      }
    }
    catch(e)
    {
      setState(() {
        isLoading = false;
      });
      //showToast('Something went wrong');
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
      //showToast('Something went wrong');
    }
  }
}
