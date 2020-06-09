/*
import 'package:client/screens/order_detail.dart';
import 'package:client/utils/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_form.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';

void main() => runApp(MySample());

class MySample extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MySampleState();
  }
}

class MySampleState extends State<MySample> {


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Credit Card View Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.close, color: darkText,),
              onPressed: (){Navigator.pop(context);},
            )
          ],
          backgroundColor: white,
          iconTheme: IconThemeData(color: darkText),
          title: Text('Enter Card Details', style: TextStyle(
            color: darkText
          )),
        ),
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: Column(
            children: <Widget>[
              CreditCardWidget(
                cardNumber: cardNumber,
                expiryDate: expiryDate,
                cardHolderName: cardHolderName,
                cvvCode: cvvCode,
                showBackView: isCvvFocused,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: CreditCardForm(
                    onCreditCardModelChange: onCreditCardModelChange,
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: Container(
                  height: 50,
                  margin: EdgeInsets.only(right: 40, left: 40),
                  child: FlatButton(
                    color: primaryColor,
                    child: Text('Submit',
                    style: TextStyle(
                      color: white
                    ),),
                    onPressed: (){
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
              SizedBox(height: 50,)
            ],
          ),
        ),
      ),
    );
  }

  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    setState(() {
      cardNumber = creditCardModel.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }
}*/
