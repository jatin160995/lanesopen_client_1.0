import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:client/utils/common.dart';
import 'package:client/widget/product.dart';

class SearchProductGrid extends StatefulWidget {
  dynamic catId;
  dynamic query;
  dynamic pageIndex;
  bool ischanged;


  SearchProductGrid(this.catId, this.query, this.pageIndex, this.ischanged);


  @override
  _SearchProductGridState createState() => _SearchProductGridState();
}

class _SearchProductGridState extends State<SearchProductGrid> with AutomaticKeepAliveClientMixin<SearchProductGrid> {

  bool isError = false;
  dynamic productFromServer = new List();

  ScrollController controller;
  int currentPage = 1;



  void _scrollListener() {
    print(widget.query);
    if (controller.position.pixels == controller.position.maxScrollExtent) {
      //startLoader();
      setState(() {
        currentPage ++;
        getProducts();
      });


    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.ischanged);

    controller = new ScrollController()..addListener(_scrollListener);
    getProducts();
  }

  @override
  Widget build(BuildContext context) {

    //print(widget.query);
    return new GridView.count(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
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
        print(productFromServer[i]);
        String isLast = productFromServer[i]['isLast'];
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


    if(currentPage > 1)
    {
      productFromServer.removeAt(productFromServer.length -1);
    }
    setState(() {
      isLoading = true;
    });

    try
    {
      print(categoriesURLPre+'index.php/rest/V1/products?searchCriteria[filter_groups][0][filters][0][field]=category_id&searchCriteria[filter_groups][0][filters][0][value]='+widget.catId.toString()+
          '&searchCriteria[filter_groups][0][filters][0][conditionType]=eq&searchCriteria[filter_groups][0][filters][1][field]=name&searchCriteria[filter_groups][0][filters][1][value]=%25'
          +widget.query+'%25&searchCriteria[filter_groups][0][filters][1][conditionType]=like&searchCriteria[pageSize]=10&searchCriteria[currentPage]='+widget.pageIndex);
      final response = await http.get(
        categoriesURLPre+'index.php/rest/V1/products?searchCriteria[filter_groups][0][filters][0][field]=category_id&searchCriteria[filter_groups][0][filters][0][value]='+widget.catId.toString()+
            '&searchCriteria[filter_groups][0][filters][0][conditionType]=eq&searchCriteria[filter_groups][0][filters][1][field]=name&searchCriteria[filter_groups][0][filters][1][value]=%25'
            +widget.query+'%25&searchCriteria[filter_groups][0][filters][1][conditionType]=like&searchCriteria[pageSize]=30&searchCriteria[currentPage]='+widget.pageIndex,
        headers: {HttpHeaders.authorizationHeader: auth,
          HttpHeaders.contentTypeHeader: 'application/json'},
      );
      print(json.decode(response.body));
      if(response.statusCode == 200)
      {
        final responseJson = json.decode(response.body);
        print(responseJson);

        productFromServer.addAll(responseJson['items'] as List); //;

        productFromServer.add({'isLast':'1'});
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
      print(e);
      showToast('Something went wrong');
    }


  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
