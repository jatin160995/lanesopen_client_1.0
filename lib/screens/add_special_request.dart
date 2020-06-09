import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:client/screens/cart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:client/utils/common.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
class AddSpecialRequest extends StatefulWidget {
  @override
  _AddSpecialRequestState createState() => _AddSpecialRequestState();
}

class _AddSpecialRequestState extends State<AddSpecialRequest> {

  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  TextEditingController titleController = new TextEditingController();
  TextEditingController quantityController = new TextEditingController();
  TextEditingController instructionController = new TextEditingController();


  File imageFile = null;
  void onPickImageSelected() async {

    try {
      final file =
      await ImagePicker.pickImage(source: ImageSource.camera, maxWidth: 640, maxHeight: 480);
      setState(() {
        imageFile = file;
      });
      if (file == null) {
        throw Exception('File is not available');
      }
    } catch(e) {
     // scaffold.showSnackBar(SnackBar(content: Text(e.toString()),));
      showToast(e.toString());
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: white,
        elevation: 0,
        centerTitle: true,
        title: Text('Special Request',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: darkText
          ),),
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body: Container(
        margin: EdgeInsets.fromLTRB(15, 30, 15, 0),
        child: Column
          (
          children: <Widget>[
            
            SizedBox(height: 5,),
            Center(
              child: Text('Add as much detail as you can to help your shopper find the right item.',
                //textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  color: lightestText,
                  fontSize: 14,

                ),
              ),
            ),
            SizedBox(height: 15,),

            Form(
              key: formKey,
              child: Column(
                children: <Widget>[
                  Container(
                    child: TextFormField(
                      enabled: isLoading ? false: true,
                      onChanged: (text){
                        //usernameString = text;
                      },
                      cursorColor: primaryColor,
                      controller: titleController,
                      decoration: new InputDecoration(
                        focusedBorder:OutlineInputBorder
                          (
                          borderSide: const BorderSide(color:  Colors.grey, width: 1.0),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        labelText: "What are you looking for?",
                        labelStyle: TextStyle
                          (
                            color: Colors.grey
                        ),
                        fillColor: Colors.white,
                        border: new OutlineInputBorder
                          (
                          borderRadius: new BorderRadius.circular(8.0),
                          borderSide: new BorderSide(
                          ),
                        ),
                      ),
                      validator: (val) {
                        if(val.length==0) {
                          return "Title cannot be empty";
                        }else{
                          return null;
                        }
                      },
                      keyboardType: TextInputType.text,
                      style: new TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    child: TextFormField(
                    controller: quantityController,
                      enabled: isLoading ? false: true,
                      onChanged: (text){
                        //usernameString = text;
                      },
                      cursorColor: primaryColor,
                      decoration: new InputDecoration(
                        focusedBorder:OutlineInputBorder
                          (
                          borderSide: const BorderSide(color:  Colors.grey, width: 1.0),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        labelText: "Quantity",
                        labelStyle: TextStyle
                          (
                            color: Colors.grey
                        ),
                        fillColor: Colors.white,
                        border: new OutlineInputBorder
                          (
                          borderRadius: new BorderRadius.circular(8.0),
                          borderSide: new BorderSide(
                          ),
                        ),
                      ),
                      validator: (val) {
                        if(val.length==0) {
                          return "Quantity cannot be empty";
                        }else{
                          return null;
                        }
                      },
                      keyboardType: TextInputType.number,
                      style: new TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  GestureDetector(
                  onTap: (){
                      onPickImageSelected();
                    },
                    child: imageFile == null ? Card(
                      child: Container(
                        padding: EdgeInsets.only(left: 15, right: 15),
                        height: 100,
                        child: Row(
                        children: <Widget>[
                          Icon(Icons.image ,color: primaryColor,),
                          SizedBox(width: 10),
                          Text("Add Image",
                          style: TextStyle(
                            color: primaryColor,
                            fontSize: 18,
                          ))
                        ],
                        )
                      ),
                    ) : Container(
                      height: 100,
                      width: 100,
                      child: Stack(children: <Widget>
                      [
                        Image.file(imageFile),
                        Align(
                          alignment: Alignment.topRight,
                          child: Icon(Icons.delete, color: Colors.red[200],),
                        )
                      ],)
                      )
                )
                ],
              ),
            ),
            SizedBox(height: 10,),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: FlatButton(
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(8)
                ),
                color: primaryColor,
                onPressed: ()
                {
                  //loginRequest();
                  FocusScope.of(context).requestFocus(FocusNode());
                  addProduct();
                },
                textColor: white,
                child: isLoading ? CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(white),): Text("Add special request to cart",
                style: TextStyle(
                  fontSize: 16
                ),),
              ),
            ),
       /* SizedBox(height: 10,),
        FlatButton(
          onPressed:()
          {
            Navigator.of(context).push(
                CupertinoPageRoute(
                    fullscreenDialog: true,
                    builder: (context) => ForgotPassword()
                )
            );
          },
          child: Text("Forgot Password"),
        ),*/
          ],
        ),
      ),
    );
  }




Future<void> addProduct() async {


      final Random _random = Random.secure();
      if(titleController.text.trim() == "" || quantityController.text.trim() == "")
      {
        showToast("Please fill values");
        return;
      }
    
     String image64 = "";
      if(imageFile != null)
      {
        final imageBytes = imageFile.readAsBytesSync();
        image64 =  base64Encode(imageBytes);
        //print(image64);
        //return;
      }
      
      Map productInfo = {
                    "product": {
                      "sku": "XM-"+base64Encode(List<int>.generate(32, (index) => _random.nextInt(256))).substring(0,8),
                      "name": titleController.text.trim(),
                      "price": 0.0,
                      "status": 1,
                      "type_id": "simple",
                      "visibility": 1,
                      "attribute_set_id":4,
                      "weight": 1, 
                      "extension_attributes": {
                        "stock_item": {
                                "qty": "10",
                                "is_in_stock": true
                            }
                      },"custom_attributes": [
                            {
                                "attribute_code": "product_brand",
                                "value": "custom"
                            }
                            ],
                            "media_gallery_entries": [
									  {
									    "position": 2,
									    "media_type": "image",
									    "label": "test",
									    "disabled": false,
									    "types": [
								            "image",
								            "small_image",
								            "thumbnail"
								        ],
									    "content": {
									      "base64_encoded_data": image64,
                        "type": "image/jpeg",
                            "name": "XM-"+base64Encode(List<int>.generate(32, (index) => _random.nextInt(256))).substring(0,8).replaceAll("/","")+".jpeg"
                          
									    }
									  }
									]
									
                      }
                    };


      try
      {
        print(addProductURL);
        print(productInfo);

        setState(() {
          isLoading = true;
        });

        final response = await http.post(
            addProductURL,
            headers: {HttpHeaders.authorizationHeader: auth,
              HttpHeaders.contentTypeHeader: contentType},
            body: json.encode(productInfo)
        );
        //response.add(utf8.encode(json.encode(itemInfo)));

        if(response.statusCode == 200)
        {
          final responseJson = json.decode(response.body);
          print(responseJson);
          //String productId = responseJson['id'];
          String sku = responseJson['sku'];
          getToken(sku, responseJson);

          //saveData(responseJson);
          
         
        }
        else
        {
          showToast('Something went wrong');
          setState(() {
            isLoading = false;
          });
          print(response.statusCode);
        }

      }
      catch(e){
        print(e);
        setState(() {
          isLoading = false;
        });}
    }
   

  









void getToken(String sku, dynamic response) async
  {
    try{
      var preferences = await SharedPreferences.getInstance();
      getCartItems(sku , preferences.getInt(cart_id ?? 0), response);

    }
    catch(e)
    {
      //showToast('Something went wrong');
    }
  }


Future<void> getCartItems(String sku, int cartID, dynamic productData) async {
                print('cartItems');
                Map itemInfo = { "cartItem" : { "sku" : sku, "qty" : double.parse(quantityController.text), "quoteId" : cartID } };
                setState(() {
                  isLoading = true;
                });
                try
                {
                  print(itemInfo);
                  print(itemToCartURL(cartID.toString()));
                  final response = await http.post(
                      itemToCartURL(cartID.toString()),
                      headers: {HttpHeaders.authorizationHeader: auth,
                        HttpHeaders.contentTypeHeader: contentType},
                      body: json.encode(itemInfo)
                  );
                  // response.add(utf8.encode(json.encode(itemInfo)));

                  if(response.statusCode == 200)
                  {
                    final responseJson = json.decode(response.body);
                    print(responseJson);
                    //productData[]
                    
                    //orderProductList[widget.index][0]['items'][widget.itemIndex]=(productData);
                    //print(orderProductList[widget.index][0]['items'][widget.itemIndex]);
                    /*orderProductList[widget.index][0]['items'][widget.itemIndex][isTodo] = 0;
                    orderProductList[widget.index][0]['items'][widget.itemIndex][isPending] = 1;
                    orderProductList[widget.index][0]['items'][widget.itemIndex][isDone] = 0;
                    orderProductList[widget.index][0]['items'][widget.itemIndex][doneQuantity] =(0).toString();
                    orderProductList[widget.index][0]['items'][widget.itemIndex][pendingQuantity] ="0";*///double.parse(orderProductList[widget.index]['qty_ordered']).toStringAsFixed(0);
                    cartProdTitle.add(productData['name']);
                    cartProdImages.add(domainURL+"pub/media/catalog/product/"+productData['media_gallery_entries'][0]['file']);
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.of(context).push(
                      CupertinoPageRoute(
                        builder: (context) => Cart(),
                      )
                    );

                    //cartId = responseJson;
                    setState(() {
                      isLoading = false;
                      //isSuccess = true;
                    });
                  }
                  else
                  {
                    final responseJson = json.decode(response.body);
                    print(responseJson);
                    setState(() {
                      isLoading = false;
                    });
                  }
                }
                catch(e){
                  print(e);
                  setState(() {
                    isLoading = false;
                  });
                }
              }




  //bool isLoading = false;







Future<void> addProductImage(String sku) async {


      final Random _random = Random.secure();
      

      String image64 = "";
      if(imageFile != null)
      {
        final imageBytes = imageFile.readAsBytesSync();
        image64 =  base64Encode(imageBytes);
        //print(image64);
        //return;
      }
    
      Map productInfo = {
    "entry": {
        "media_type": "image",
        "label": "Image",
        "position": 1,
        "disabled": false,
        "types": [
            "image",
            "small_image",
            "thumbnail"
        ],
        "content": {
            "base64EncodedData": image64,
            "type": "image/jpeg",
            "name": "XM-"+base64Encode(List<int>.generate(32, (index) => _random.nextInt(256))).substring(0,8)+".jpeg"
        }
    }
};
                                      
      try
      {
        print(addProductURL);
        print(productInfo);

        setState(() {
          isLoading = true;
        });

        final response = await http.post(
            domainURL+"index.php/rest/V1/products/"+sku+"/media",
            headers: {HttpHeaders.authorizationHeader: auth,
              HttpHeaders.contentTypeHeader: contentType},
            body: json.encode(productInfo)
        );
        //response.add(utf8.encode(json.encode(itemInfo)));

        if(response.statusCode == 200)
        {
          final responseJson = json.decode(response.body);
          print(responseJson);
          //String productId = responseJson['id'];
         // String sku = responseJson['sku'];
          //addedProduct = responseJson;
          getToken( sku, responseJson);

          //saveData(responseJson);
          
         
        }
        else
        {
          final responseJson = json.decode(response.body);
          showToast('Something went wrong');
          setState(() {
            isLoading = false;
          });
          print(responseJson);
        }

      }
      catch(e){
        print(e);
        setState(() {
          isLoading = false;
        });}
    }









}