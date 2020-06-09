import 'dart:convert';
import 'dart:io';

import 'package:client/payment/card_form.dart';
import 'package:client/payment/paymetn.dart';
import 'package:client/screens/user/address_book.dart';
import 'package:client/widget/card_form/input_formatters.dart';
import 'package:client/widget/card_form/payment_card.dart';
import 'package:client/widget/order_detail_cell.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:client/widget/product.dart';
import 'package:client/utils/common.dart';
import 'package:client/widget/cart_product_cell.dart';
import 'package:client/screens/shipping_address.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stripe_payment/stripe_payment.dart';
//import 'package:stripe_payment/stripe_payment.dart';


String cardNumber = '';
String expiryDate = '';
String cardHolderName = '';
String cvvCode = '';
bool isCvvFocused = false;

class OrderDetail extends StatefulWidget {

  //dynamic addressObject;

  //OrderDetail(this.addressObject);


  @override
  _OrderDetailState createState() => _OrderDetailState();
}

class _OrderDetailState extends State<OrderDetail> {

  bool isLoading = false;
  bool isLoaded = false;

  String dropdownValue = '5';

  double subTotal = 0;
  double grandTotal = 0;
  double driverTip = 0;
  double shipping = 7.99;
  double serviceFeePercent = 10;
  double serviceFee = 0;
  double taxPercent = 6;
  double tax = 0;




  ExpandableController expandableController =  new ExpandableController();
  ExpandableController dateTimeController =  new ExpandableController();
  ExpandableController commentController =  new ExpandableController();
  ExpandableController addressController =  new ExpandableController();

  Token _paymentToken;
  PaymentMethod _paymentMethod;
  String _error;
  final String _currentSecret = null; //set this yourself, e.g using curl
  PaymentIntentResult _paymentIntent;
  Source _source;
  ScrollController _controller = ScrollController();
  void setError(dynamic error) {
    //_scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(error.toString())));
    setState(() {
      isLoading = false;
      print(error.toString());
      try
      {
        String errorString = "";
        for(int i= 1; i <  error.toString().split(",").length-1; i++)
        {
            errorString = errorString + error.toString().split(",")[i];
        }
        showToast(errorString.trim());
      }
      catch(e)
      {
        showToast("Your card was declined");
      }
      
      _error = error.toString();
      
    });
  }


  List<String> getDropdownValues()
  {
    List<String> drodownValues = new List();
    drodownValues.add('5');
    drodownValues.add('10');
    drodownValues.add('15');
    drodownValues.add('20');
    drodownValues.add('0');
    return drodownValues;
  }

  double calculateDriverTip (double percentagle)
  {
    double driverTip1 = 0;
    driverTip1 = double.parse(subTotal.toStringAsFixed(2))*(percentagle/100);
    driverTip = driverTip1;
    grandTotal = baseGrandTotal + driverTip1;
    return driverTip1;

  }



/*

  double calculateTax(double taxPer, double amount)
  {
    double calTax = 0;
    calTax = double.parse(amount.toStringAsFixed(2))*(taxPer/100);

    return calTax;
  }
*/

  final format = DateFormat("yyyy-MM-dd");
  final format2 = DateFormat("HH:mm:aa");
  String dateOfDelivery = '';
  String timeFrom = '';
  String timeTo = '';
  String comment = '';
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  var _formKey = new GlobalKey<FormState>();
  var numberController = new TextEditingController();
  var _paymentCard = PaymentCard();
  var _autoValidate = false;

  var _card = new PaymentCard();

  dynamic timeObject = '';

  int selectedTimeSlot = 0;
  getAdminTimeSlots() async
  {
    var preferences = await SharedPreferences.getInstance();
    timeObject = preferences.getString(today_timing ?? "");
  }

  List<Widget> createDateTimeLayout()
  {
    List<Widget> widgetList = new List();
    widgetList.add(Container(
      height: 90,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: createNextDaysDate(),
      ),
    ),);
    widgetList.add(SizedBox(height: 20,),);





    dynamic timeLimit= getTimingObject();
    for(int i = 0 ; i < timeLimit.length; i ++)
    {
      //print();
      dynamic singleTime = timeLimit[i];
      widgetList.add(GestureDetector(
        onTap: ()
        {
          setState(() {
            selectedTimeSlot = i;
          });
        },
        child: Container(
          padding: EdgeInsets.only(top: 10, bottom: 10),
          child: Row(
            children: <Widget>[
              SizedBox(width: 5,),
              Icon(  selectedTimeSlot == i ? Icons.radio_button_checked :Icons.radio_button_unchecked ,color: primaryColor,),
              SizedBox(width: 15,),

              Text(singleTime['from']+ " - "+ singleTime['to'],
                  style : TextStyle(
                      color: lightestText,
                      fontWeight: FontWeight.bold,
                      fontSize: 16
                  )
              )
            ],
          ),
        ),
      ),);
      //widgetList.add(SizedBox(height: 20,),);
    }
    //print(todayTimings);


    return widgetList;
  }

  TextEditingController cvvController = new TextEditingController();


  dynamic getTimingObject()
  {
    dynamic decodeData = json.decode(timeObject);
    Map todayTimings  ;
    try{
      todayTimings = decodeData[DateFormat('EEEE').format(getSelectedDate()).toLowerCase()];
    }
    catch(e)
    {
      todayTimings = decodeData['default'];
    }
    dynamic timeLimit= todayTimings['time_limits'];

    return timeLimit;
  }

  List<Widget> createProduct(List products)
  {
   // subTotal = 0;


    List<Widget> productList = new List();

    if(products.length > 0){
      for(int i =0; i < products.length; i++)
      {
        productList.add(OrderDetailCell(
          productData :products[i],
          addQuant: (){
            //setState(() {cartList[i]['quantity'] = (int.parse(cartList[i]['quantity']) + 1).toString();});
            print('add quant');
          },
          delQuant: ()
          {
            setState(() {
              /*if(cartList[i]['quantity'] == '1')
                {
                  return;
                }
                cartList[i]['quantity'] = (int.parse(cartList[i]['quantity']) - 1).toString();*/
              print('minus');
            });
          },
          delItem: ()
          {
            setState(() {
              //cartList.remove(cartList[i]);
              print('minus');
            });
          },
        )
        );
      //  ,// ,subTotal = subTotal + (double.parse(products[i]['price'].toString()) * double.parse(products[i]['qty'].toString()));
      }
      


      productList.add(Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
         // SizedBox(height: 15),
          /*Container(
            margin: EdgeInsets.only(right: 15, left: 15),
              child:Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                Text('Date',
                style: TextStyle(
                  color: iconColor
                )),
                DateTimeField(
                  onChanged: (text)
                  {
                    dateOfDelivery = text.toString();
                  },
                  format: format,
                  onShowPicker: (context, currentValue) {
                    return showDatePicker(
                        context: context,
                        firstDate: DateTime.now(),
                        initialDate: currentValue ?? DateTime.now(),
                        lastDate: DateTime(2100));
                  },
                ),
              ])
          ),*/
          //SizedBox(height: 15),
          /*Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(
                    margin: EdgeInsets.only(right: 15, left: 15),
                    child:Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Time from',
                              style: TextStyle(
                                  color: iconColor
                              )),
                          DateTimeField(
                            onChanged: (text)
                            {
                              timeFrom = text.toString();
                            },
                            format: format2,
                            onShowPicker: (context, currentValue) async {
                              final time = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                              );
                              return DateTimeField.convert(time);
                            },
                          ),
                        ])
                ),
              ),
              SizedBox(width: 15),
              Expanded(
                  flex: 1,
                child: Container(
                    margin: EdgeInsets.only(right: 15, left: 15),
                    child:Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Time to',
                              style: TextStyle(
                                  color: iconColor
                              )),
                          DateTimeField(
                            onChanged: (text)
                            {
                              timeTo = text.toString();
                              print(timeTo);
                            },
                            format: format2,
                            onShowPicker: (context, currentValue) async {
                              final time = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                              );
                              return DateTimeField.convert(time);
                            },
                          ),
                        ])
                ),
              ),

            ],
          ),*/
          SizedBox(height: 15),

        Container(
          color: background,
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.all(15),
          child: ExpandablePanel(
            controller: expandableController,
            header: Container(
              margin: EdgeInsets.only(top: 12),
              child: Text("Payment Information",
              style: TextStyle(
                  fontSize: 16,
                color: darkText,
                fontWeight: FontWeight.bold
              ),),
            ),
            collapsed: Text(numberController.text != "" ? numberController.text : "Please select a payment method", softWrap: true, maxLines: 2, overflow: TextOverflow.ellipsis,),
            expanded: Wrap(
              children: <Widget>[
                Form(
                  key: _formKey,
                  autovalidate: _autoValidate,
                  child: Card(
                      child: Container
                        (
                          padding: EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new TextFormField(
                                enabled: !isCardValid,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  WhitelistingTextInputFormatter.digitsOnly,
                                  new LengthLimitingTextInputFormatter(19),
                                  new CardNumberInputFormatter()
                                ],
                                controller: numberController,
                                decoration: new InputDecoration(
                                  fillColor: white,
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                  //border: const UnderlineInputBorder(),
                                  filled: true,
                                  icon: CardUtils.getCardIcon(_paymentCard.type),
                                  hintText: 'Card Number',
                                  labelText: 'Card Number',
                                ),
                                onSaved: (String value) {
                                  print('onSaved = $value');
                                  print('Num controller has = ${numberController.text}');
                                  _paymentCard.number = CardUtils.getCleanedNumber(value);
                                },
                                validator: CardUtils.validateCardNum,
                              ),
                              
                              SizedBox(height: 5),
                              Container(
                                color: white,
                                width: 150,
                                child: new TextFormField(
                                  controller: cvvController,
                                  enabled: !isCardValid,
                                  inputFormatters: [
                                    WhitelistingTextInputFormatter.digitsOnly,
                                    new LengthLimitingTextInputFormatter(4),
                                  ],
                                  decoration: new InputDecoration(
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                    fillColor: white,
                                    //border: const UnderlineInputBorder(),
                                    filled: true,
                                    icon: new Image.asset(
                                      'assets/images/card_cvv.png',
                                      width: 30.0,
                                      //color: Colors.grey[600],
                                    ),
                                    hintText: 'CVV',
                                    labelText: 'CVV',
                                    
                                  ),
                                  validator: CardUtils.validateCVV,
                                  keyboardType: TextInputType.number,
                                  //initialValue: _paymentCard.cvv.toString() == "null" ? "" : _paymentCard.cvv.toString(),
                                  onSaved: (value) {
                                    _paymentCard.cvv = int.parse(value);
                                  },
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(
                                    width: 150,
                                    child: new TextFormField(
                                      enabled: !isCardValid,
                                      inputFormatters: [
                                        WhitelistingTextInputFormatter.digitsOnly,
                                        new LengthLimitingTextInputFormatter(4),
                                        new CardMonthInputFormatter()
                                      ],
                                      decoration: new InputDecoration(
                                        //border: const UnderlineInputBorder(),
                                        border: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        errorBorder: InputBorder.none,
                                        disabledBorder: InputBorder.none,
                                        fillColor: white,
                                        filled: true,
                                        icon: new Image.asset(
                                          'assets/images/calender.png',
                                          width: 25.0,
                                          color: Colors.grey[600],
                                        ),
                                        hintText: 'MM/YY',
                                        labelText: 'Expiry Date',
                                      ),
                                      validator: CardUtils.validateDate,
                                      keyboardType: TextInputType.number,
                                      initialValue:  _paymentCard.month.toString() == "null" ? "" : _paymentCard.month.toString()+"/"+ _paymentCard.year.toString(),
                                      onSaved: (value) {
                                        List<int> expiryDate = CardUtils.getExpiryDate(value);
                                        _paymentCard.month = expiryDate[0];
                                        _paymentCard.year = expiryDate[1];
                                      },
                                    ),
                                  ),
                                  FlatButton(
                                    onPressed: !isCardValid ? (){expandableController.toggle();} : _validateInputs,
                                    child: Text(isCardValid ? "Change" :"Next",
                                        style: TextStyle(
                                            color: white
                                        )
                                    ),
                                    color: primaryColor,
                                  )
                                ],
                              )
                            ],
                          )
                      )

                  ),
                )
              ],
            ),
            tapHeaderToExpand: true,
            hasIcon: true,
          ),
        ),
          Container(
            color: background,
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.only(left:15, right: 15),
            child: ExpandablePanel(
              controller: dateTimeController,
              header: Container(
                margin: EdgeInsets.only(top: 12),
                child: Text("Choose Delivery Date and Time",
                  style: TextStyle(
                    fontSize: 16,
                      color: darkText,
                      fontWeight: FontWeight.bold
                  ),),
              ),
              collapsed: Text(DateFormat('EEE').format(getSelectedDate()).toUpperCase() + " (" +
                  DateFormat('MMM').format(getSelectedDate()) + " " + DateFormat('dd').format(getSelectedDate())+")"
                , softWrap: true, maxLines: 2, overflow: TextOverflow.ellipsis,),
              expanded: Container(
               // height: 180,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: createDateTimeLayout(),
                )
              ),
              tapHeaderToExpand: true,
              hasIcon: true,
            ),
          ),
          Container(
            color: background,
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.only(left:15, right: 15, top: 15),
            child: ExpandablePanel(
              controller: commentController,
              header: Container(
                margin: EdgeInsets.only(top: 12),
                child: Text("Delivery Instructions",
                  style: TextStyle(
                      fontSize: 16,
                      color: darkText,
                      fontWeight: FontWeight.bold
                  ),),
              ),
              expanded: Container(
                color: white,
                margin: EdgeInsets.only(left: 0, right: 0, top: 5),
                child: TextFormField(
                  //controller: countryController,
                  keyboardType: TextInputType.text,
                  onChanged: (text){
                    //password = text;
                    comment = text;
                  },
                  cursorColor: primaryColor,
                  decoration: new InputDecoration(
                    focusedBorder:OutlineInputBorder
                      (
                      borderSide: const BorderSide(color:  Colors.grey, width: 1.0),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    labelText: "Delivery Instruction (Optional)",
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
                      return "Comment cannot be empty";
                    }else{
                      return null;
                    }
                  },
                  style: new TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
              tapHeaderToExpand: true,
              hasIcon: true,
            ),
          ),
          Container(
            color: background,
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.only(left:15, right: 15, top: 15),
            child: ExpandablePanel(
              controller: addressController,
              header: Container(
                margin: EdgeInsets.only(top: 12),
                child: Text("Address",
                  style: TextStyle(
                      fontSize: 16,
                      color: darkText,
                      fontWeight: FontWeight.bold
                  ),),
              ),
              collapsed: Text(addressToOrderDetail["street"][0], softWrap: true, maxLines: 2, overflow: TextOverflow.ellipsis,),
              expanded: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: Text(addressToOrderDetail["firstname"] + " "+addressToOrderDetail["lastname"]+", \n"+addressToOrderDetail["street"][0]+
                        ", "+ addressToOrderDetail["city"]+", "+addressToOrderDetail["postcode"])
                  ),
                  IconButton(
                    onPressed: (){
                      Navigator.of(context).pushReplacement(
                          CupertinoPageRoute(
                              fullscreenDialog: true,
                              builder: (context) => AddressBook("Select Address")
                          )
                      );
                    },
                    color: iconColor,
                    icon: Icon(Icons.edit)
                  )
                ],
              ),

              tapHeaderToExpand: true,
              hasIcon: true,
            ),
          )
        ],
      ));

      var couponDesign = new Card(
        margin: EdgeInsets.only(left: 15, right: 15),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 10,
              child: Container(
                margin: EdgeInsets.only(left: 20, right: 20),
                child: TextField(
                  //textCapitalization: TextCapitalization.characters,
                  onChanged: (text)
                  {
                    //postalCode = text;
                  },
                  decoration : InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter Discount Code',
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
                      child: Text('Apply',
                        style: TextStyle(
                          color: white,
                          fontSize: 14,

                        ),),
                    )),
              ),
            )
          ],
        ),
      );
      //productList.add(couponDesign);
      var pricesDesign = new Container(
        margin: EdgeInsets.all(15),
        color: background,
        padding: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('SubTotal:'),
                Text('\$'+ subTotal.toStringAsFixed(2)),
              ],
            ),
            SizedBox(height: 8,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Shipping:'),
                Text('\$'+ shipping.toStringAsFixed(2)),
              ],
            ),
            SizedBox(height: 8,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Service Fee:'),
                Text('\$'+ serviceFee.toStringAsFixed(2)),
              ],
            ),
            SizedBox(height: 8,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Tax:'),
                Text('\$'+ tax.toStringAsFixed(2)),
              ],
            ),
            SizedBox(height: 0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Driver\'s tip:'),
                DropdownButton<String>(
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
                      driverTip = calculateDriverTip(double.parse(newValue));
                      //print(newValue);
                    });
                  },
                  items: getDropdownValues()
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value+ '%' ),
                    );
                  }).toList(),
                ),
                Text('\$' + calculateDriverTip(double.parse(dropdownValue)).toStringAsFixed(2))
              ],
            ),
            SizedBox(height: 15,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Total:',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                  ),),
                Text('\$' + grandTotal.toStringAsFixed(2),
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                  ),),
              ],
            )
          ],
        ),
      );

      productList.add(pricesDesign);
     // setState(() {

      //});
      //subTotal = subTotal + driverTip;
      print(driverTip);

      var submitButton = Container(
        height: 45,
        margin: EdgeInsets.only(left: 15, right: 15, bottom: 50),
        child: FlatButton(
          onPressed:isLoading ? (){}:(){




            Map orderToSend ;






            /*StripePayment.authenticatePaymentIntent(clientSecret: "sk_test_iNSXH4n77MAaadJ2LYVTzylA009UCJjBrL").then((paymentIntent) {


              print('Received ${paymentIntent.paymentIntentId}');
              setState(() {
                _paymentIntent = paymentIntent;
              });
            }).catchError(setError);*/
            _validateInputs1();

            if(isCardValid)
            {
              //_validateInputs();
              if(_formKey.currentState.validate())
              {

               /* isLoading = true;
                StripePayment.createTokenWithCard(
                  CreditCard(
                    number: _paymentCard.number,
                    expMonth: _paymentCard.month,
                    expYear: _paymentCard.year,
                     // cvc: _paymentCard.cvv.toString(),
                  ),
                ).then((token) {
                  //_scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('Received ${token.tokenId}')));
                  setState(() {
                    _paymentToken = token;
                    print(token.tokenId);
                   // createOrder(token.tokenId);

                    send();
                  });
                }).catchError(setError);*/
                

                setState(() {
                  isLoading = true;
                });
                print(cvvController.text);
                print(cvvController.text);
                print(cvvController.text);
                print(cvvController.text);
                StripePayment.createPaymentMethod(
                  PaymentMethodRequest(
                    card: CreditCard(
                      number: _paymentCard.number,
                      expMonth: _paymentCard.month,
                      expYear: _paymentCard.year,
                      addressCity: addressToOrderDetail['city'],
                      country: addressToOrderDetail['country_id'],
                      addressLine1: addressToOrderDetail['street'][0],
                      cvc: cvvController.text,
                      name: addressToOrderDetail['firstname'] + " "+ addressToOrderDetail['lastname'],
                    ),
                  ),
                ).then((paymentMethod) {
                  //_scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('Received ${paymentMethod.id}')));
                  setState(() {

                   
                    _paymentMethod = paymentMethod;
                    print(_paymentMethod.card.toJson());
                    send();
                    // print(addressToOrderDetail['city']);
                    // print(_paymentMethod.toString());
                  });
                }).catchError(setError);

                print('validate');
              }
              else{
                expandableController.expanded = true;
                showToast("Please enter a valid Card");
                print('Not validate');
              }
            }
            else{

              print('Validate your card');
              expandableController.expanded = true;
              showToast("Please enter a valid Card");
              
            }

           /* if(cardNumber == '' || expiryDate == '' || cvvCode == '' || cardHolderName == '')
            {
              Navigator.of(context).push(
                  CupertinoPageRoute(
                      fullscreenDialog: true,
                      builder: (context) => MySample()
                  )
              );
            }
            else
              {
                if(dateOfDelivery == "" || timeFrom == "" || timeTo == "")
                {
                  showToast("Please select date and time");
                }
                else
                  {
                    isLoading = true;
                    StripePayment.createTokenWithCard(
                      CreditCard(
                        number: cardNumber,
                        expMonth: int.parse(expiryDate.split("/")[0]),
                        expYear: int.parse(expiryDate.split("/")[1]),
                      ),
                    ).then((token) {
                      //_scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('Received ${token.tokenId}')));
                      setState(() {
                        _paymentToken = token;
                        print(token.tokenId);
                        createOrder(token.tokenId);

                        send();
                      });
                    }).catchError(setError);
                  }

              }
*/


          },
          color: primaryColor,
          child: isLoading ?  CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(white)) : Text('Create Order',
            style: TextStyle(
                color: white,
                fontSize: 16
            ),),
        ),
      );
      productList.add(submitButton);

    }
    else{
      if(isLoaded)
      {
        productList.add(new Container(
            height: MediaQuery.of(context).size.width,
            child: Container(
              margin: EdgeInsets.only(top: 100),
              child: Column(
                children: <Widget>[
                  Text('Cart is empty!',
                    style:  TextStyle(
                        color: iconColor,
                        fontWeight: FontWeight.normal,
                        fontSize: 22
                    ),),
                  Container(
                    height: 48,
                    width: 48,
                    child: Image.asset("assets/images/empty_cart.png"),
                  )
                ],
              ),
            )
        ));
      }
      else
      {
        productList.add(new Container(
          height: MediaQuery.of(context).size.width,
          width: MediaQuery.of(context).size.width,
          child: Image.asset('assets/images/loading.gif'),
        ));
      }

    }
    return productList;
  }



  DateTime getSelectedDate()
  {
    var today = new DateTime.now();
    var nextDate = today.add(new Duration(days: currentSelectedDate));
    return nextDate;
  }

  int currentSelectedDate = 0;
  List<Widget> createNextDaysDate()
  {
    List<Widget> dateCellList = new List();
    var today = new DateTime.now();

    for(int i = 0; i < 7; i ++)
    {
      var nextDate = today.add(new Duration(days: i));
      dateCellList.add(GestureDetector(
        onTap: (){
          setState(() {
            currentSelectedDate = i ;
            selectedTimeSlot = 0;
          });
          },
        child: new Container(
          height: 80,
          width: 110,
          color: currentSelectedDate == i ? primaryColor : white,
          margin: EdgeInsets.only(top: 10, left: 10, right: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(DateFormat('EEE').format(nextDate).toUpperCase(),
              style: TextStyle(
                color: currentSelectedDate == i ? white : primaryColor,
                fontSize: 18,
                fontWeight: FontWeight.bold
              ),),
              Text(DateFormat('MMM').format(nextDate) + " "+ DateFormat('dd').format(nextDate),
                style: TextStyle(
                    color:  currentSelectedDate == i ? white : primaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold
                ),)
            ],
          ),
        ),
      ));
    }
    return dateCellList;
  }




  Future<void> send() async {

    var preferences = await SharedPreferences.getInstance();

      //Map addressInfo = { 'username' : usernameString, 'password' : passwordString};

      try
      {
        print(sendDateTime);
        setState(() {
          isLoading = true;
        });


        String optionID = '';
        if(dropdownValue == '5'){optionID = '2';}
        else if(dropdownValue == '10'){optionID = '3';}
        else if(dropdownValue == '15'){optionID = '4';}
        else if(dropdownValue == '20'){optionID = '5';}
        else if(dropdownValue == '0'){optionID = '7';}

        Map jsonToSend =  {'quote_id': addressToOrderDetail['id'],
          'option_id': optionID,
          'fee_amount': driverTip.toString(),
          'base_fee_amount': driverTip.toString(),
          'label': dropdownValue+"%",
          'delivery_day': getSelectedDate().toString(),
          'delivery_hours_from': getTimingObject()[selectedTimeSlot]['from'].split(':')[0],
          'delivery_hours_to': getTimingObject()[selectedTimeSlot]['to'].split(':')[0],
          'delivery_minutes_from': getTimingObject()[selectedTimeSlot]['from'].split(':')[1],
          'delivery_minutes_to': getTimingObject()[selectedTimeSlot]['to'].split(':')[1],
          'delivery_comment': comment,
        };

        print(jsonToSend);
        //return;
        print(cardNumber +
            expiryDate +
            cvvCode+
            cardHolderName );
        final response = await http.post(
          sendDateTime, //body: jsonToSend
            headers: {HttpHeaders.authorizationHeader: auth,
              HttpHeaders.contentTypeHeader: contentType},
            body: json.encode(jsonToSend)
        );
        //response.add(utf8.encode(json.encode(itemInfo)));

        if(response.statusCode == 200)
        {
          final responseJson = json.decode(response.body);
          if(responseJson)
          {
            //createOrder(_paymentToken.tokenId);
            print('added values');
            createOrder(_paymentMethod.id);


          }
          else
            {
              //final responseJson = json.decode(response.body);
              showToast("Error while adding dates");
              setState(() {
                isLoading = false;
              });
            }

          /*setState(() {
            isLoading = false;
          });*/
          print(responseJson);
        }
        else
        {
          final responseJson = json.decode(response.body);
          showToast(responseJson['message']);
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
        });}


  }




  void saveData(dynamic data) async
  {
    var preferences = await SharedPreferences.getInstance();
    preferences.setString(user_token, data);
    getToken();
    //print(preferences.getString(user_token));
    // var savedValue = preferences.getString('value_key');
  }


  void loginInfoFromLocal() async
  {
    setState(() {
      isLoading = true;
    });
    try
    {
      var preferences = await SharedPreferences.getInstance();
      getUserToken(preferences.getString(username ?? ''), preferences.getString(password ?? ''));
    }
    catch(e){
      //showToast("Something went wrong");
    }
  }

  Future<void> getUserToken(String username, String password) async {

    Map addressInfo = { 'username' : "$username", 'password' : "$password"};

    try
    {
      print(loginUrl);
      print(addressInfo);

      setState(() {
        isLoading = true;
      });

      final response = await http.post(
          loginUrl,
          headers: {HttpHeaders.authorizationHeader: auth,
            HttpHeaders.contentTypeHeader: contentType},
          body: json.encode(addressInfo)
      );
      //response.add(utf8.encode(json.encode(itemInfo)));

      if(response.statusCode == 200)
      {
        final responseJson = json.decode(response.body);
        saveData(responseJson);
        print(responseJson.toString());

      }
      else
      {
        final responseJson = json.decode(response.body);
        showToast(responseJson['message']);
        Navigator.pop(context);
        print(response.statusCode);
      }
      setState(() {
        //isLoading = false;
      });
    }
    catch(e){
      print(e);
      setState(() {
        Navigator.pop(context);
        //showToast("Something went wrong");
      });}
  }






  void getToken() async
  {
    try{
      var preferences = await SharedPreferences.getInstance();
      //preferences.getString(user_token ?? '');
      print(preferences.getString(user_token ?? ''));
      if(isCreatingOrder)
      {
        createOrder(_paymentMethod.id);
      }
      else
        {
          getCartValues(preferences.getString(user_token ?? ''));
        }

    }
    catch(e)
    {
     // showToast('Something went wrong');
    }

  }








  @override
  void initState() {
    getToken();
    cardNumber == '' ;
    expiryDate == '' ;
    cvvCode == '' ;
    cardHolderName == '';

    expandableController.expanded = true;
    commentController.expanded = true;
    dateTimeController.expanded = true;
    addressController.expanded = true;

    isCvvFocused = false;

    getAdminTimeSlots();


    _paymentCard.type = CardType.Others;
    numberController.addListener(_getCardTypeFrmNumber);
    super.initState();
    StripePayment.setOptions(
        StripeOptions(publishableKey: "pk_live_UAuTKr5skTQf5Mvk2l99fNrj00pApXd56E", merchantId: "info@lanesopen.com", androidPayMode: 'production'));
       //StripeOptions(publishableKey: "pk_test_KwrXXsuQmvLz6Qy5ISuCRFVn003YYcIKZ2", merchantId: "info@lanesopen.com", androidPayMode: 'test'));
       //StripeOptions(publishableKey: "pk_test_zJqlVKni4musZSKmfjQMtDIs", merchantId: "info@lanesopen.com", androidPayMode: 'test'));
  }

  void _getCardTypeFrmNumber() {
    String input = CardUtils.getCleanedNumber(numberController.text);
    CardType cardType = CardUtils.getCardTypeFrmNumber(input);
    setState(() {
      this._paymentCard.type = cardType;
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is removed from the Widget tree
    numberController.removeListener(_getCardTypeFrmNumber);
    numberController.dispose();
    super.dispose();
  }

  bool isCardValid = false;
  void _validateInputs() {

    if(numberController.text.length < 20 )
    {
      print(_paymentCard.number.toString());
      showToast("Enter Valid Card");
      return;
    }
    //print(numberController.text.length.toString());
    //return;
    if(isCardValid)
    {
      setState(() {
        isCardValid =false;
        numberController.text = "";

        return;
      });
    }
    final FormState form = _formKey.currentState;
    if (!form.validate()) {
      setState(() {
        _autoValidate = true;
        isCardValid = false;// Start validating on every change.
      });
      showToast('Please fix the errors in red before submitting.');
    } else {
      form.save();
      // Encrypt and send send payment details to payment gateway
      setState(() {
        isCardValid = true;
      });

      expandableController.toggle();
      if(!dateTimeController.expanded)
      {
        dateTimeController.toggle();
      }
      //showToast('Payment card is valid');
    }
  }

  void _validateInputs1() {

    if(numberController.text.length < 20 )
    {
      print(_paymentCard.number.toString());
      showToast("Enter Valid Card");
      return;
    }
    //print(numberController.text.length.toString());
    //return;
   
    final FormState form = _formKey.currentState;
    if (!form.validate()) {
      setState(() {
        _autoValidate = true;
        isCardValid = false;// Start validating on every change.
      });
      showToast('Please fix the errors in red before submitting.');
    } else {
      form.save();
      // Encrypt and send send payment details to payment gateway
      setState(() {
        isCardValid = true;
      });

      expandableController.toggle();
      if(!dateTimeController.expanded)
      {
        dateTimeController.toggle();
      }
      //showToast('Payment card is valid');
    }
  }

  @override
  Widget build(BuildContext context) {

    

    print(addressToOrderDetail);
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        actions: <Widget>[
          FlatButton(
            onPressed: (){
              Navigator.pop(context);

            },
            child: Text('Edit Order',
            style: TextStyle(
              color: darkText
            ),),
          )
        ],
        elevation: 1,
        iconTheme: IconThemeData(
            color: darkText
        ),
        centerTitle: true,
        backgroundColor: white,
        title: Text('Order Detail',
          style: TextStyle(
              color: darkText,
              fontWeight: FontWeight.bold
          ),),
      ),
      body: ListView(
        children:
        createProduct(prodList),

      ),
    );
  }


  Future<void> getCartValues(String token) async {
    try
    {
      setState(() {
        isLoading = true;
      });
      print(cartTotals);
      final response = await http.get(
        cartTotals,
        headers: {HttpHeaders.authorizationHeader: 'Bearer '+token,
          HttpHeaders.contentTypeHeader: contentType},
      );
      isLoaded = true;
      if(response.statusCode == 200)
      {
        final responseJson = json.decode(response.body);
        print(responseJson);
        setState(() {
          prodList = responseJson['items'] as List;
          dynamic pricesArray = responseJson['total_segments'] as List;
          for(int i =0; i < pricesArray.length; i++)
          {
            String code = pricesArray[i]['code'];
            dynamic value = pricesArray[i]['value'];
            if(code == 'subtotal'){subTotal = double.parse(value.toString());}
            else if(code == 'shipping'){shipping = double.parse(value.toString());}
            else if(code == 'tax'){tax = double.parse(value.toString());}
            else if(code == 'fee'){serviceFee = double.parse(value.toString());}
            else if(code == 'grand_total'){grandTotal= subTotal + shipping +tax +serviceFee;baseGrandTotal=  subTotal + shipping +tax +serviceFee; }
          }
        });
        setState(() {
          isLoading = false;
        });
        //showToast('success');
      }
      else
      {
        final responseJson = json.decode(response.body);
        showToast(responseJson['message']);
        setState(() {
          isLoading = false;
        });
        loginInfoFromLocal();
        //showToast('Something went wrong');
      }
    }
    catch(e){
      setState(() {
        isLoading = false;
      });
    }
  }

  List prodList = new List();

  double baseGrandTotal = 0;





  /*Future<void> getPaymentMEthod() async {

      try
      {print('payment method');
      //print(addressInfo);
      setState(() {
        isLoading = true;
      });
      final response = await http.get(
        paymentMethod+cartId+'/payment-information',
        headers: {HttpHeaders.authorizationHeader: auth,
          HttpHeaders.contentTypeHeader: contentType},
        //body: json.encode(addressInfo)
      );
      //response.add(utf8.encode(json.encode(itemInfo)));

      if(response.statusCode == 200)
      {
        final responseJson = json.decode(response.body);
        print(responseJson);
        createOrder(responseJson);
        //isLoading = false;
        //addressAdded = true;
       // Navigator.pushReplacementNamed(context, '/orderDetail');
      }
      else
      {
        final responseJson = json.decode(response.body);
        showToast(responseJson['message']);
        setState(() {
          isLoading = false;
        });
      }

      }
      catch(e){
        print(e);
        setState(() {
          isLoading = false;
        });}

  }*/

  bool isCreatingOrder = false;
  Future<void> createOrder(String paymentId) async {

    isCreatingOrder = true;
      try
      {
        print("Create order");
        var preferences = await SharedPreferences.getInstance();
        //preferences.getString(user_token ?? '');
        print(paymentId);
        //print(addressInfo);
        setState(() {
          isLoading = true;
        });

        //Map orderInfo = {"paymentMethod": {"method": "stripe_payments"}};
       /* Map orderInfo = {
          "paymentMethod": {
            "method": "stripe_rest",
            //"method": "stripe_payments",
            "additional_data": {
              "token": paymentId
            }
          }
        };//right one*/

        /*Map orderInfo ={"paymentMethod": {
          "method": "stripe_payments",
          "additional_data" : {
          {
            "id": _paymentMethod.id,
            "object": "payment_method",
            "billing_details": {
              "address": {
                "city": null,
                "country": null,
                "line1": null,
                "line2": null,
                "postal_code": null,
                "state": null
              },
              "email": null,
              "name": null,
              "phone": null
            },
            "card": {
              "brand": 'visa',
              "checks": {
                "address_line1_check": null,
                "address_postal_code_check": null,
                "cvc_check": null
              },
              "country": "US",
              "exp_month": 12,
              "exp_year": 2021,
              "funding": "credit",
              "generated_from": null,
              "last4": "4242",
              "three_d_secure_usage": {
                "supported": true
              },
              "wallet": null
            },
            "created": _paymentMethod.created,
            "customer": null,
            "livemode": false,
            "metadata": {
            },
            "type": "card"
          }
            }}
        };*/

        print(_paymentMethod.card.brand);
        //return;
        Map orderInfo = {"paymentMethod": {
          "method": "stripe_payments",
          "additional_data": {
            "cc_stripejs_token": paymentId+":${_paymentMethod.card.brand}:${_paymentMethod.card.last4}",
            "cc_save" : "false"

          }
        }
        };

        print(createOrderURl);
        print(orderInfo);
        //return;
        final response = await http.put(
            createOrderURl,
            headers: {HttpHeaders.authorizationHeader: "Bearer "+preferences.getString(user_token ?? ""),
              HttpHeaders.contentTypeHeader: contentType},
            body: json.encode(orderInfo)
        );
        //response.add(utf8.encode(json.encode(itemInfo)));

        if(response.statusCode == 200)
        {
          final responseJson = json.decode(response.body);
          print(responseJson);
          ///showToast("Order Created");
          cartId = '';
          cartCount = 0;
          skuList.clear();
          imageList.clear();


          getNewCartId();
          //Navigator.pop(context);

        }
        else
        {
          //showToast('Something went wrong');
          final responseJson = json.decode(response.body);
          showToast(responseJson['message']);
          if(responseJson["message"].contains("Minimum order amount is")){
            Navigator.pop(context);
          }
          if(responseJson['message'].contains('The consumer isn\'t authorized to access %resources'))
          {
            loginInfoFromLocal();
          }

          print(responseJson);
        }
        setState(() {
          isLoading = false;
        });
      }
      catch(e){
        print(e);
        loginInfoFromLocal();
        setState(() {
          isLoading = false;
        });}
  }


  Future<void> getNewCartId() async {
    print('getCartID');

    try
    {
      var preferences = await SharedPreferences.getInstance();
      setState(() {
        isLoading = true;
        gettingCartId = true;
      });
      final response = await http.post(
        createCartId,
        headers: {HttpHeaders.authorizationHeader: 'Bearer '+preferences.getString(user_token?? ''),
          HttpHeaders.contentTypeHeader: contentType},
      );
      setState(() {
        isLoading = false;
        gettingCartId = false;
      });
      if(response.statusCode == 200)
      {

        final responseJson = json.decode(response.body);
        cartValues(responseJson, 0);
        // cartId = responseJson;
        print(responseJson);

        //addItemToCart();

      }
      else
      {
        setState(() {
          isLoading = false;
          gettingCartId = false;
        });
        final responseJson = json.decode(response.body);
        print(responseJson);
        showToast(responseJson['message']);
        showToast("Your order has been placed! Please try logging in again.");
      }
    }
    catch(e){
      showToast("Your order has been placed! Please try logging in again.");
      getNewCartId();
    }

  }



  void cartValues(dynamic data, int quantity) async
  {
    var preferences = await SharedPreferences.getInstance();
    int zeroValue = 0;
    preferences.setInt(cart_count, zeroValue);
    preferences.setInt(cart_id, data);
    print(preferences.getInt(cart_count ));

    Navigator.pushReplacementNamed(context, '/thankyou');


  }


  /*void showCheckoutMethodDialog()
  {

    final act =CupertinoActionSheet(
        title: Text('Select'),
        //message: Text('Which option?'),
        actions: <Widget>[
          CupertinoActionSheetAction(
            child: Text('Pay online'),
            onPressed: () {
              Navigator.pop(context);

            *//*  StripePayment.paymentRequestWithCardForm(CardFormPaymentRequest()).then((paymentMethod) {
                //_scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('Received ${paymentMethod.id}')));
                setState(() {

                  _paymentMethod = paymentMethod;
                  //sendDataToServer();

                });
              }).catchError(setError);*//*

            },
          ),
          CupertinoActionSheetAction(
            child: Text('Cash On Delivery'),
            onPressed: () {
              Navigator.pop(context);

              getPaymentMEthod();

            },
          ),

        ],
        cancelButton: CupertinoActionSheetAction(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.pop(context);
          },
        ));
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) => act);


  }*/



}
