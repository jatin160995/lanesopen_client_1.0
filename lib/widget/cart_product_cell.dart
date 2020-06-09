import 'package:cached_network_image/cached_network_image.dart';
import 'package:client/utils/common.dart';
import 'package:flutter/material.dart';

class CartProductCell extends StatefulWidget {


  dynamic productData;
  final Function addQuant;
  final Function delQuant;
  final Function delItem;

  CartProductCell({this.productData, this.addQuant,this.delQuant,this.delItem});

  @override
  _CartProductCellState createState() => _CartProductCellState();
}

class _CartProductCellState extends State<CartProductCell> {

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

    //print(widget.productData);
    //dropdownValue = widget.productData['quantity'];
    cartCount = cartCount+ widget.productData['qty'];
    return Container(
      margin: EdgeInsets.only(top: 15, bottom: 15, right: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          itemToDelete == widget.productData['item_id'] ? Container(padding: EdgeInsets.all(12.0), height: 43, width: 43,child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(primaryColor))):
          IconButton(
            onPressed: widget.delItem,
            iconSize: 18,
            icon: Icon(Icons.delete, color: iconColor, ),
          ),
          GestureDetector(
            onTap: (){},
            child: Container(
              height: 70,
              width: 70,
              color: lightGrey,
              padding: EdgeInsets.all(0),
              child: CachedNetworkImage(
                                placeholder: (context, url) =>
                                         Image.asset("assets/images/loading.jpg"),
                                imageUrl: getImage(),
                              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
             children: <Widget>[
               Container(
                   margin: EdgeInsets.only(left: 10, top: 5),
                   child: Text(
                     widget.productData['name'],
                     style: TextStyle(
                         color: darkText,
                         fontWeight: FontWeight.normal,
                         fontSize: 14
                     ),
                   )
               ),
               Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: <Widget>[
                   Container(
                       margin: EdgeInsets.only(left: 10, top: 5),
                       child: Text(
                         '\$' + widget.productData['price'].toStringAsFixed(2),
                         style: TextStyle(
                             color: primaryColor,
                             fontWeight: FontWeight.bold,
                             fontSize: 19
                         ),
                       )
                   ),
                   Row(
                     children: <Widget>[
                       IconButton(
                         onPressed: cartOnHold ? null : widget.delQuant,
                         iconSize: 18,
                         icon: Icon(Icons.remove),
                       ),

                       cartOnHold && updatingItemId ==  widget.productData['item_id']? Container(height: 15, width: 15, child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(primaryColor)),) :
                       Text(widget.productData['qty'].toString(),
                       style: TextStyle(
                         color: darkText,
                         fontSize: 16
                       )),
                       IconButton(
                         onPressed: cartOnHold ? null : widget.addQuant,
                         color: primaryColor,
                         iconSize: 18,
                         icon: Icon(Icons.add),

                       ),

                     ],
                   )
                 ],
               )
             ] ,
            ),
          )
        ],
      ),
    );
  }

getImage()
{
  String image = "";

    try{
      image = cartProdImages[cartProdTitle.indexOf(widget.productData['name'])];
    }
    catch(e)
    {
      
    }

  return image; 
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