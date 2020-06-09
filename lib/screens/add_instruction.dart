import 'dart:convert';
import 'dart:io';

import 'package:client/utils/common.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AddInstruction extends StatefulWidget {

  dynamic productData;
  AddInstruction(this.productData);

  @override
  _AddInstructionState createState() => _AddInstructionState();
}

class _AddInstructionState extends State<AddInstruction> {

  TextEditingController instructionController = new TextEditingController();
 


     String sku = "";
     String instruction = "";
 


  getInstruction()
  {
    for (int i = 0; i < instructionList.length; i ++){
    // print(cartItemsList[i]);
    
      if(instructionList[i]['item_id'].toString() == widget.productData["item_id"].toString())
      {
       // cartItemsList[i]['instructions'] = instructionController.text.toString(); 
       setState(() {
         instructionController.text = instructionList[i]['instructions'];
       });
         print(instructionList[i]);
      }
   }
  // Navigator.pop(context);
  }


  @override
  Widget build(BuildContext context) {

    getInstruction();
    

    print(widget.productData);
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          FlatButton(
            onPressed: (){
             
             addInstructionToServer();
            },
            child:isLoading ? CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color> (primaryColor)) : Text("DONE",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: primaryColor
            ),),
          )
        ],
        elevation: 1,
        centerTitle: true,
        backgroundColor: white,
        iconTheme: IconThemeData(color: darkText),
        title: Text("Add Instructions",
        style: TextStyle(
          color: darkText,
          fontWeight: FontWeight.bold,
        ),),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10),
            color: white,
            child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
            //itemToDelete == widget.productData['item_id'] ? Container(padding: EdgeInsets.all(12.0), height: 43, width: 43,child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(primaryColor))):
            /*IconButton(
              onPressed: widget.delItem,
              iconSize: 19,
              icon: Icon(Icons.delete, color: transparentREd, ),
            ),*/
            /* GestureDetector(
              onTap: (){},
              child: Container(
                color: lightGrey,
                padding: EdgeInsets.all(1),
                child: FadeInImage.assetNetwork(
                    height: 70,
                    width: 70,
                    placeholder: 'assets/images/loading.gif',
                    image: ""//imageList[skuList.indexOf(widget.productData['item_id'])]
                ),
              ),
            ),*/
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.only(left: 15, top: 5, right: 15),
                      child: Text(
                        widget.productData['name'],
                        style: TextStyle(
                            color: darkText,
                            fontWeight: FontWeight.normal,
                            fontSize: 15
                        ),
                      )
                  ),
                  Row(
                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                          margin: EdgeInsets.only(left: 15, top: 5),
                          child: Text(
                            '\$' + widget.productData['price'].toStringAsFixed(2),
                            style: TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 20
                            ),
                          ),
                      ),
                      SizedBox(width: 30,),
                      Text('x',
                          style: TextStyle(
                              color: darkText,
                              fontSize: 18,
                              fontWeight: FontWeight.normal
                          )),
                      cartOnHold && updatingItemId ==  widget.productData['item_id']? Container(height: 15, width: 15, child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(primaryColor)),) :
                      Text(widget.productData['qty'].toString(),
                          style: TextStyle(
                              color: darkText,
                              fontSize: 18,
                              fontWeight: FontWeight.bold
                          )),


                    ],
                  ),
                  
                ] ,
              ),
              
            )
        ],
      ),
          ),
          Divider(height: 1,),
          Container(
            padding: EdgeInsets.all(25),
            child: Text("Special Instruction for your shopper",
            textAlign: TextAlign.left,
            style: TextStyle(
              color: lightestText,
              fontSize: 13
            ),),
          ),
          Divider(height: 1,),
          Container(
            color: white,
            padding: EdgeInsets.only(left: 25, right: 25,top: 25, bottom:25),
            child: Container(
                    //margin: EdgeInsets.only(left: 20, right: 20),
                    child: TextField(
                      
                      controller: instructionController,
                      textCapitalization: TextCapitalization.sentences,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      onChanged: (text)
                      {
                        //postalCode = text;
                      },
                      decoration : InputDecoration(
                        border: InputBorder.none,
                        hintText: 'I\'d like my shopper to...',
                      ),
                      style: TextStyle(fontSize: 16),
                    
                    ),
                  ),
          ),
        Divider(height: 1,),
        ],
      ),
    );
  }





  Future<void> addInstructionToServer() async
  {
   
   if(instructionController.text == "")
   {
     showToast("Please fill instructions");
     return;
   }
      setState(() {
          isLoading = true;
        });

    var preferences = await SharedPreferences.getInstance();
    //print(preferences.getString(user_token ?? ''));
    try
    {
      print('update');
      Map itemInfo = {"item_id":widget.productData["item_id"],"instructions": instructionController.text};

     // Map abc = { "cartItem" : {'sku': itemId, "qty" : quantity, "quoteId" : int.parse(preferences.getInt(cart_id ?? '0').toString()) }};

      print(domainURL+"index.php/rest/V1/Iorderaddons/customOption/");
      print(itemInfo);
      final response = await http.post(
          domainURL+"index.php/rest/V1/Iorderaddons/customOption/",
          headers: {HttpHeaders.authorizationHeader: 'Bearer '+ preferences.getString(user_token ?? ''),
            HttpHeaders.contentTypeHeader: contentType},
          body: json.encode(itemInfo)
      );

      if(response.statusCode == 200)
      {
        final responseJson = json.decode(response.body);
        ///prodList[index] = responseJson;
        //saveInstruction();
       instructionList.add(itemInfo);
       Navigator.pop(context);
        print(responseJson);
      }
      else
      {
        final responseJson = json.decode(response.body);
        print(responseJson);
        //showToast(response.statusCode.toString());
        setState(() {
          isLoading = false;
        });
        showToast(responseJson['message']);
      }
      
    }
    catch(e){
      print(e);
      setState(() {
        isLoading = false;
      });}

  }




  



bool isLoading = false;
 









}