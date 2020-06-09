import 'package:cached_network_image/cached_network_image.dart';
import 'package:client/screens/store_detail.dart';
import 'package:client/screens/user/signin.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:client/utils/common.dart';
import 'package:client/screens/user/signup.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StoreListCell extends StatefulWidget {

  dynamic storeData;

  StoreListCell(this.storeData);

  @override
  _StoreListCellState createState() => _StoreListCellState();
}

class _StoreListCellState extends State<StoreListCell> {




  void _sendDataToStoreScreen(BuildContext context) {
    dynamic textToSend = widget.storeData;
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => StoreDetail(storeData: textToSend,),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()
      {
        /*Navigator.of(context).push(
            CupertinoPageRoute(
                fullscreenDialog: true,
                builder: (context) => Signup()
            )
        );*/
        _sendDataToStoreScreen(context);
        //isLoggedIn();
        //Navigator.pushNamed(context, '/storeDetail');
      },
      child: Container(
        color: white,
        margin: EdgeInsets.only(top: 2),
        child: Card(
          margin: EdgeInsets.all(10),
          elevation: 0,
          child: Row(
            children: <Widget>[
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(35.0),
                ),
                elevation: 2,
                child: new Container(
                    width: 70.0,
                    height: 70.0,
                    padding: EdgeInsets.all(5),
                    child: SizedBox(
                              width: 70.0,
                              height: 70.0,
                              child: Center(child: CachedNetworkImage(
                                placeholder: (context, url) =>
                                         Image.asset("assets/images/loading.jpg"),
                                imageUrl: getImage(),
                              )),
                            )
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(

                    margin: EdgeInsets.only(left: 15, right: 15),
                    child: Text(widget.storeData['name'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: lightText,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  /*Container(
                    margin: EdgeInsets.only(left: 15, right: 15),
                    child: Text('',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: lightestText,
                        fontSize: 12,
                      ),
                    ),
                  ),*/
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String getImage()
  {
    //print(widget.storeData['custom_attributes'][0]['value'].toString());

   /* try {

    } on Exception catch (_) {
      print('never reached');
    }*/
    if(widget.storeData['image'].toString() != "null")
    {
      return urlPrefix + widget.storeData['image'];
    }
    else
      {
        return 'https://lanesopen.com/pub/media/logo/stores/1/logo2.png';
      }
  }
}
