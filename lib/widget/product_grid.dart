import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:client/utils/common.dart';
import 'package:client/widget/product.dart';

class ProductGrid extends StatefulWidget {
  dynamic catInfo;


  ProductGrid(this.catInfo);

  @override
  _ProductGridState createState() => _ProductGridState();
}

class _ProductGridState extends State<ProductGrid> with AutomaticKeepAliveClientMixin<ProductGrid> {

  bool isError = false;
  dynamic productFromServer = new List();

  ScrollController controller;
  int currentPage = 1;

  void _scrollListener() {
    if (controller.position.pixels == controller.position.maxScrollExtent) {
      
      setState(() {
       // currentPage ++;
        //getProducts();
      });

      print('hello');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = new ScrollController()..addListener(_scrollListener);
    getProducts();
  }

  @override
  Widget build(BuildContext context) {
    return new GridView.count(
      primary: false,
      padding: const EdgeInsets.all(15),
      childAspectRatio: (160 / 220),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      crossAxisCount: 2,
      controller: controller,
      children: createProduct(),
    );
  }


  List<Widget> createProduct()
  {
    List<Widget> productList = new List();

    if(productFromServer.length > 0){
      for(int i =0; i < productFromServer.length; i++)
      {
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
    }
    /* try {


    } on Exception catch (_) {

      print('never reached');
    }
*/
    return productList;
  }

  bool isLoading = false;
  Future<void> getProducts() async {


    isLoading = true;
    try
    {
      print(categoriesURLPre+widget.catInfo['id'].toString()+categoriesURLPostProd+'30'+'&searchCriteria[currentPage]='+currentPage.toString());
      final response = await http.get(
        //categoriesURLPre+widget.catInfo['id'].toString()+categoriesURLPostProd+'30'+'&searchCriteria[currentPage]='+currentPage.toString(),
        domainURL+"index.php/rest/V1/yello/featuredproducts/"+widget.catInfo['id'].toString(),
        headers: {HttpHeaders.authorizationHeader: auth,
          HttpHeaders.contentTypeHeader: 'application/json'},
      );
      print(json.decode(response.body));
      if(response.statusCode == 200)
      {
        final responseJson = json.decode(response.body);
        print(responseJson);
        productFromServer.addAll(responseJson[0]['items'] as List); //;

        setState(() {
          isError = false;
          isLoading = false;
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
     // showToast('Something went wrong');
    }


  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
