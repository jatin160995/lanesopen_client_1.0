import 'dart:convert';
import 'dart:io';

import 'package:client/screens/home.dart';
import 'package:client/utils/common.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EnterPostalCode extends StatefulWidget {

  bool isModal;

  EnterPostalCode(this.isModal);

  @override
  _EnterPostalCodeState createState() => _EnterPostalCodeState();
}

class _EnterPostalCodeState extends State<EnterPostalCode> {

  var postalCode = '';
  var postal = new RegExp('/^\s*[a-ceghj-npr-tvxy]\d[a-ceghj-npr-tv-z](\s)?\d[a-ceghj-npr-tv-z]\d\s*\$/i');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[

          Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.topCenter,
                child: SizedBox(
                  width: double.infinity,
                  child: Container(
                    height: 200,
                    child: Image(
                      height: 100,
                      fit: BoxFit.cover,
                      image:  AssetImage('assets/images/postal_back.jpg', ),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                    constraints: BoxConstraints.expand(height: 200.0),
                    color: transparentBlack,
                    child: Container(
                      margin: EdgeInsets.only(bottom: 10, top: 120, left: 90, right: 90),
                      child: Image(
                        width: 100,
                        height: 100,
                        fit:BoxFit.fitWidth,
                        image: AssetImage('assets/images/logo_white.png'),
                      ),
                    ),
              )
              ),
              widget.isModal?
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  margin: EdgeInsets.only(top: 30),
                  child: IconButton(
                    onPressed: ()
                    {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.close, color: white,),
                  ),
                ),
              ): Container()
            ],
          ),


          Card(
            color: white,
            margin: EdgeInsets.only(top: 100, left: 40, right: 40),
            child: Row(
             // crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: CircleAvatar(
                    backgroundImage: AssetImage('assets/images/flag.png'),
                    backgroundColor: transparent,
                  ),
                ),
                Expanded(
                  flex: 10,
                  child: Container(
                    margin: EdgeInsets.only(left: 20, right: 20),
                    child: TextField(
                      enabled: isLoading ? false : true,
                      textCapitalization: TextCapitalization.characters,
                      onChanged: (text)
                      {
                        postalCode = text;
                      },
                      decoration : InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter Postal Code',
                      ),
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,

                  child: GestureDetector(
                    onTap: ()
                    {
                      //print('hello');
                      if(postalCode == '')
                      {
                       showToast('Please enter postal code');
                      }
                      else
                        {
                          /*if (postal.hasMatch(postalCode))
                          {
                            print('right');
                            print(postalCode);
                          }
                          else
                            {
                              print('wrong');
                              print(postalCode);
                            }
                          Navigator.pushReplacementNamed(context, '/home');*/
                          FocusScope.of(context).requestFocus(FocusNode());
                          verifyPostalCode();
                          //Navigator.pushReplacementNamed(context, '/chat');
                        }
                    },
                    child: Container(
                      height: 50,
                      decoration: new BoxDecoration(
                          color: primaryColor,
                          borderRadius: new BorderRadius.only(
                            bottomRight: const Radius.circular(4.0),
                            topRight: const Radius.circular(4.0),
                          ),
                      ),
                        child: Center(
                          child: isLoading ? CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(white),) : Text('Enter',
                          style: TextStyle(
                            color: white,
                            fontSize: 16,
                          ),),
                        )),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 20),
            child: Text('Delivery in as little as 1 hour',
            style: TextStyle(
              color: lightestText,
              fontWeight: FontWeight.bold,
              fontSize: 16,

            )),
          ),


          /*SizedBox(height: 70,),
          FlatButton(
            child: Text('Chat',
            style: TextStyle(
              color: white
            )),
            color: primaryColor,
            onPressed: ()
            {
              Navigator.pushNamed(context, '/chat');
            },
          )*/
        ],
      ),
    );
  }



  bool isLoading = false;

  Future<void> verifyPostalCode() async {
    try{
      print('Verify Code'); setState(() {
        isLoading = true;
      });
      print(domainURL+'zipcodevalidator/zipcode/result?zip='+postalCode+'&productId=0');
      final response = await http.get(
          domainURL+'zipcodevalidator/zipcode/result?zip='+postalCode+'&productId=0',
          headers: {HttpHeaders.authorizationHeader: auth,
            HttpHeaders.contentTypeHeader: contentType},
      );
      setState(() {
        isLoading = false;
      });
      if(response.statusCode == 200)
      {
        final responseJson = json.decode(response.body);
        //cartId = responseJson;
        //widget.productData['quantity'] = '1';
        print(responseJson);
        if(responseJson['result'] == 1)
        {
          savedPostalCode = postalCode;
          if(widget.isModal){
            Navigator.pop(context);
            dynamic catIds = responseJson["category_ids"];
            Navigator.of(context).pushReplacement(
              CupertinoPageRoute(builder: (context) => Home(catIds))
            );
          }
          else{
            dynamic catIds = responseJson["category_ids"];
            Navigator.of(context).pushReplacement(
              CupertinoPageRoute(builder: (context) => Home(catIds))
            );
            /*isLoggedIn();*/}

        }
        else
          {
            showToast("Enter a valid postal code.");
          }
        print(responseJson);
      }
      else
      {
        final responseJson = json.decode(response.body);
        showToast(responseJson['message']);
      }
    }
    catch(e)
    {
      setState(() {
        isLoading = false;
      });
      print(e);
    }
  }



}
