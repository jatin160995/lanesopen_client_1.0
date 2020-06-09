import 'dart:convert';
import 'dart:io';

import 'package:client/utils/common.dart';
import 'package:flutter/material.dart';
import 'package:client/widget/product.dart';
import 'package:http/http.dart' as http;
import 'package:client/screens/categories.dart';
import 'package:client/screens/store_detail.dart';

typedef StateCallback = void Function();
class HorizontalProductList extends StatefulWidget {

  dynamic categoryData;
  dynamic categoryId;
  dynamic categoryName;


  HorizontalProductList(this.categoryData, this.categoryId, this.categoryName);


  @override
  _HorizontalProductListState createState() => _HorizontalProductListState();
}

class _HorizontalProductListState extends State<HorizontalProductList> {

  bool isError = false;
  dynamic productFromServer = new List();




  void _sendDataToCategoryScreen(BuildContext context) {
    dynamic textToSend = widget.categoryData;
    print(textToSend);
    if(textToSend["children_data"].length == 0 )
    {
      textToSend["children_data"] = [widget.categoryData];
    }
    
    
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Categories(categoryList: textToSend,),
        ));
  }

  refresh()
  {
    /*this.setState(() {
      print('horizontal');

      //products[i]['quantity'] = '1';
      //cartList.add(products[i]);
    });*/

  }

  List<Widget> createProduct(List products)
  {
    List<Widget> productList = new List();

    if(products.length > 0){
      int totalProducts = 10;
      if(products.length < 10)
      {
        totalProducts = products.length;
      }
      for(int i =0; i < totalProducts; i++)
      {
        productList.add(Product(products[i],widget.categoryData));
      }
    }
    else {
        if(!isError)
          productList.add(Container(width: MediaQuery.of(context).size.width,child: Center(child: Image.asset('assets/images/loading.gif'))));
        else
          productList.add(Container(
              margin: EdgeInsets.only(left: 15, top: 50),
              child: Text('No Product Avaiable')
          ));
      }

   /* try {


    } on Exception catch (_) {

      print('never reached');
    }
*/
    return productList;
  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProducts();

    print(widget.categoryName);
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(widget.categoryName,
              style: TextStyle(
                color: darkText,
                fontWeight: FontWeight.bold,
                fontSize: 16
              )),
              GestureDetector(
                onTap: ()
                {
                  widget.categoryData == 1 ? null : _sendDataToCategoryScreen(context);
                },
                child: Text(
                    widget.categoryData == 1 ? '' : 'View more >',
                    style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.normal,
                        fontSize: 14
                    )),
              )
            ],
          ),
        ),
        Container(
          height: 250,
          child: ListView(

            scrollDirection: Axis.horizontal,
            children: createProduct(productFromServer)
          ),
        )
      ],
    );
  }


  Future<void> getProducts() async {


  print(domainURL+"index.php/rest/V1/yello/featuredproducts/"+widget.categoryId.toString());
    String url = "";
    if(widget.categoryData ==1 )
    {
      //url = categoriesURLPre+widget.categoryId.toString()+categoriesURLPost;
      url = domainURL+"index.php/rest/V1/yello/featuredproducts/"+widget.categoryId.toString();
    }
    else
    {
      url = domainURL+"index.php/rest/V1/yello/featuredproducts/"+widget.categoryId.toString();
    }
    print(url);
    final response = await http.get(
      url,
      headers: {HttpHeaders.authorizationHeader: "Bearer 64tdnqc6cuwr56a3yk2qlazwt1n8bmgf",
        HttpHeaders.contentTypeHeader: 'application/json'},
    );
    
    if(response.statusCode == 200)
    {
      final responseJson = json.decode(response.body);
      print(responseJson[0]);

      productFromServer = widget.categoryData != 1 ? responseJson[0]['items'] as List : responseJson[0]['items'] as List;

      if (!mounted) return;
      setState(() {
        if(productFromServer.length == 0)
        {
          isError = true;
        }
        else
        isError = false;

        print('setstate');
      });
    }
    else
    {
      if (!mounted) return;
      setState(() {
        isError = true;
      });
    }

   

  }


}


/*()
{
widget.productData['quantity'] = '1';
cartList.add(widget.productData);
}*/
