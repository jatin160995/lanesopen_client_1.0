import 'package:client/screens/user/user_order_detail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:client/utils/common.dart';

class UserOrderCell extends StatefulWidget {

  dynamic orderData1;


  UserOrderCell(this.orderData1);

  @override
  _UserOrderCellState createState() => _UserOrderCellState();
}

class _UserOrderCellState extends State<UserOrderCell> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()
      {
        print('Pressed');
        Navigator.of(context).push(
            CupertinoPageRoute(
                fullscreenDialog: true,
                builder: (context) => UserOrderDetail(widget.orderData1['entity_id'].toString(), widget.orderData1['increment_id'].toString())
            )
        );
      },
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[

                    Row(
                      children: <Widget>[
                        Text
                          (
                            "Order Id:",
                            style: TextStyle(
                                fontSize: 14,
                                color: darkText
                            )
                        ),
                        SizedBox(width: 5,),
                        Text
                          (
                            '#' + widget.orderData1['increment_id'].toString(),
                            style: TextStyle(
                                fontSize: 14,
                                color: accent,
                                fontWeight: FontWeight.bold
                            )
                        ),

                        /*SizedBox(width: 20,),
                        Text
                          (
                            '('+widget.orderData1['state'].toString() + ')',
                            style: TextStyle(
                                fontSize: 12,
                                color: darkText,
                                fontWeight: FontWeight.normal
                            )
                        ),*/
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        /*Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40.0),
                          ),
                          elevation: 2,
                          child: new Container(
                            width: 38.0,
                            height: 38.0,
                            padding: EdgeInsets.all(2),
                            child: FadeInImage.assetNetwork(
                              placeholder: 'assets/images/loading.gif',
                              image: 'https://images.squarespace-cdn.com/content/v1/59bbdf8e7131a59f2cc29b51/1557428713117-B8S5FCNSYVQQ642JG068/ke17ZwdGBToddI8pDm48kCjnDAuDqCfbBd8eSxgXLL8UqsxRUqqbr1mOJYKfIPR7LoDQ9mXPOjoJoqy81S2I8N_N4V1vUb5AoIIIbLZhVYxCRW4BPu10St3TBAUQYVKc6qo2finnqc85j2f5Ujm2QqQWeUolcsLwahrgb4OaR47OjFnm4pt8t5qAG9PA6VXN/Partner+Logos+-+Sized+New-09.png',
                            ),
                          ),
                        ),*/

                       /* Text
                          (
                            //widget.orderData1['customer_firstname'] + " " + widget.orderData1['customer_lastname'],
                          'Fortinos',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: lightestText
                            )
                        ),*/
                      ],
                    ),
                    /*SizedBox(height: 5,),
                      Text
                        (
                          widget.orderData1['billing_address']['street'][0] + ', ' + widget.orderData1['billing_address']['city']+ ', ' +
                          widget.orderData1['billing_address']['region'] + ', '+ widget.orderData1['billing_address']['postcode'],
                          style: TextStyle(
                              fontSize: 12,
                              color: lightText
                          )
                      ),*/
                    SizedBox(height: 5,),
                    Text
                      (

                        widget.orderData1['state'].toString().toUpperCase(),
                        style: TextStyle(
                            fontSize: 16,
                            color: blue
                        )
                    ),
                  ],    
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text
                      (
                        widget.orderData1['updated_at'].toString().split(' ')[0],
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13
                        )
                    ),
                    SizedBox(height: 5,),
                    Text
                      (
                        "\$" + double.parse(widget.orderData1['base_grand_total']).toStringAsFixed(2) ,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: accent
                        )
                    ),
                    SizedBox(height: 5,),
                    Text
                      (
                        "Total Items: "+ widget.orderData1['total_item_count'].toString(),
                        style: TextStyle(
                            fontSize: 12,
                            color: lightText
                        )
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
