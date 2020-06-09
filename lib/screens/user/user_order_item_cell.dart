import 'dart:convert';

import 'package:client/utils/common.dart';
import 'package:flutter/material.dart';

class UserOrderDetailCell extends StatefulWidget {


  dynamic productData;
  final Function addQuant;
  final Function delQuant;
  final Function delItem;

  UserOrderDetailCell({this.productData, this.addQuant,this.delQuant,this.delItem});

  @override
  _UserOrderDetailCellState createState() => _UserOrderDetailCellState();
}

class _UserOrderDetailCellState extends State<UserOrderDetailCell> {

  String dropdownValue = '1';

  List<String> getDropdownValues()
  {
    List<String> drodownValues = new List();
    for(int i =1; i < 100; i++ )
    {
      drodownValues.add(i.toString());
    }
    return drodownValues;
  }


  @override
  void dispose() {

    itemToDelete= 0;
    super.dispose();
  }

  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

   
   String instructionString = '';
        dynamic decodeInstruct = json.decode(widget.productData['product_options'].toString());
        try
        {
          instructionString = decodeInstruct['info_buyRequest']['options']['instruction'];
          //print();
        }
        catch(e){}

    return Container(
      margin: EdgeInsets.only(top: 15, bottom: 15, right: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          itemToDelete == widget.productData['item_id'] ? Container(padding: EdgeInsets.all(12.0), height: 43, width: 43,child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(primaryColor))):
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
                          fontSize: 16
                      ),
                    )
                ),
                Row(
                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 15, top: 5),
                      child: Text(
                        '\$' + double.parse(widget.productData['price']).toStringAsFixed(2),
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
                    Text(widget.productData['qty_ordered'].split(".")[0].toString(),
                        style: TextStyle(
                            color: darkText,
                            fontSize: 18,
                            fontWeight: FontWeight.bold
                        )),
                        


                  ],
                ),
                Container(
                  margin: EdgeInsets.only(left: 15, right: 15, top: 3),
                  child:instructionString != "" ? Text("Notes: "+instructionString,
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                  ): Container())
              ] ,
            ),
          )
        ],
      ),
    );
  }
}

/*
* DropdownButton<String>(
                     value: dropdownValue,
                     icon: Icon(Icons.arrow_drop_down),
                     iconSize: 24,
                     elevation: 8,
                     style: TextStyle(color: darkText),
                     underline: Container(
                       height: 2,
                       color: transparent,
                     ),
                     onChanged: (String newValue) {
                       setState(() {
                         dropdownValue = newValue;
                         print('in the cell');
                         //getTap();
                       });
                     },
                     items: getDropdownValues()
                         .map<DropdownMenuItem<String>>((String value) {
                       return DropdownMenuItem<String>(
                         value: value,
                         child: Text(value),
                       );
                     }).toList(),
                   )
* */