import 'package:client/utils/common.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThankyouScreen extends StatefulWidget {
  @override
  _ThankyouScreenState createState() => _ThankyouScreenState();
}

class _ThankyouScreenState extends State<ThankyouScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    updateCart();
  }
  @override
  Widget build(BuildContext context) {

    updateCart();
    return Scaffold(

      body: Stack(
        children: <Widget>[
          Container(
              padding: EdgeInsets.all(50),
              margin: EdgeInsets.only(top: 170),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text('Thanks for your order!',
                        style: TextStyle(
                            color: darkText,
                            fontSize: 22,
                          fontWeight: FontWeight.bold
                        )),
                    Text('Order has been placed',
                        style: TextStyle(
                            color: iconColor,
                            fontSize: 14,
                            fontWeight: FontWeight.bold
                        )),
                    Container(
                      margin: EdgeInsets.only(top: 30),
                      child: FlatButton(
                        onPressed: (){
                          Navigator.of(context).popUntil((route) => route.isFirst);
                        },
                        color: primaryColor,
                        child: Text('Continue Shopping',
                            style: TextStyle(
                                color: white
                            )),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      child: FlatButton(
                        onPressed: (){
                         Navigator.of(context).popUntil((route) => route.isFirst);
                          Navigator.pushNamed(context, "/myOrders");
                        },
                        color: transparent,
                        child: Text('My Orders >',
                            style: TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.bold
                            )),
                      ),
                    )
                  ],
                ),
              )
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: 120,
              margin: EdgeInsets.only(bottom: 30,),
                child: Image.asset('assets/images/logo.png')),
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
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
              ),
            ),
          )
        ],
      )
    );
  }

   updateCart() async
  {
    int zeroValue = 0;
    var preferences = await SharedPreferences.getInstance();
    //await preferences.remove(cart_count);
    setState(() {
      preferences.setInt(cart_count, zeroValue);
    });

    //print(preferences.getInt(cart_count));
    //print(preferences.getInt(cart_id));
  }

}
