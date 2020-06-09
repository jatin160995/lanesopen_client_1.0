import 'dart:convert';
import 'dart:io';

import 'package:client/screens/add_special_request.dart';
import 'package:client/screens/order_detail.dart';
import 'package:client/screens/user/address_book.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:client/utils/common.dart';
import 'package:client/widget/cart_product_cell.dart';
import 'package:client/screens/shipping_address.dart';
import 'package:http/http.dart' as http;
import 'package:client/screens/user/signin.dart';
import 'package:shared_preferences/shared_preferences.dart';

//import 'package:stripe_payment/stripe_payment.dart';


bool isAddressAdded = false;
class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {

  bool isLoading = false;
  bool isLoaded = false;
  bool onHold = false;

  String dropdownValue = '5';

  double subTotal = 0;
  double grandTotal = 0;
  double driverTip = 0;
  double shipping = 7.99;
  double serviceFeePercent = 10;
  double serviceFee = 0;
  double taxPercent = 6;
  double tax = 0;


  List prodList = new List();

  bool gettingSavedValues =false;




  List<String> getDropdownValues()
  {
    List<String> drodownValues = new List();
    drodownValues.add('5');
    drodownValues.add('10');
    drodownValues.add('15');
    drodownValues.add('20');
    return drodownValues;
  }

  double calculateDriverTip (double percentagle)
  {
    double driverTip1 = 0;
    driverTip1 = double.parse(subTotal.toStringAsFixed(2))*(percentagle/100);
    return driverTip1;
  }

  double calculateTax(double taxPer, double amount)
  {
    double calTax = 0;
    calTax = double.parse(amount.toStringAsFixed(2))*(taxPer/100);

    return calTax;
  }


  void updateCart(int cartCount) async
  {
    try{
      var preferences = await SharedPreferences.getInstance();
      //print(cartCount);
      //setState(() {
        preferences.setInt(cart_count, cartCount);
      //});
    }
    catch(e)
    {
      //showToast('Something went wrong');
    }
  }


  int curentCartCount = 0;
  List<Widget> createProduct(List products)
  {
    curentCartCount = 0;
    subTotal = 0;
    updateCart(curentCartCount);
    List<Widget> productList = new List();

    if(products.length > 0){
      for(int i =0; i < products.length; i++)
      {
       

        productList.add(CartProductCell(
            productData :products[i],
            addQuant: (){
              //setState(() {cartList[i]['quantity'] = (int.parse(cartList[i]['quantity']) + 1).toString();});
              setState(() {
               // products[i]['quantity'] = products[i]['quantity'] + 1;
                updateItemToCart(products[i]['item_id'], products[i]['qty'] + 1, i);
              });
              print('add quant');
            },
            delQuant: ()
            {
              setState(() {
                if( products[i]['quantity'] == 1)
                {
                  return;
                }
                //products[i]['quantity'] =  products[i]['quantity'] - 1;
                updateItemToCart( products[i]['item_id'], products[i]['qty'] -1 , i);

                print('minus');
              });
            },
          delItem: ()
          {
            setState(() {
                //cartList.remove(cartList[i]);
              deleteItemFromCart(products[i]['item_id'].toString(), i);
              print('minus');
            });
          },
        )
        );
        curentCartCount = curentCartCount + products[i]['qty'];
        subTotal = subTotal + (double.parse(products[i]['price'].toString()) * double.parse(products[i]['qty'].toString()));
      }

      productList.add(Padding(
        padding: const EdgeInsets.only(left:20.0, right: 20),
        child: new FlatButton(
          onPressed: ()
          {
            Navigator.of(context).push(
              CupertinoPageRoute(
                fullscreenDialog: true,
                builder: (context) => AddSpecialRequest(),
              )
            );
          },
          color: white,
          child: (Text("Add a Special Request",
          style: TextStyle(
            color: primaryColor,
            fontSize: 15,
            fontWeight: FontWeight.bold
          ),
          )),
        ),
      ));
      updateCart(curentCartCount);
      grandTotal = subTotal;
      serviceFee = calculateDriverTip(serviceFeePercent);
      tax = calculateTax(taxPercent, subTotal + shipping + serviceFee);

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
     // productList.add(couponDesign);
      var pricesDesign = new Container(
        margin: EdgeInsets.all(15),
        color: lightGrey,
        padding: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
           /* Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('SubTotal:'),
                Text('\$'+ subTotal.toStringAsFixed(2)),
              ],
            ),// sub total
            SizedBox(height: 8,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Shipping:'),
                Text('\$'+ shipping.toStringAsFixed(2)),
              ],
            ),// shipping
            SizedBox(height: 8,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Service Fee:'),
                Text('\$'+ serviceFee.toStringAsFixed(2)),
              ],
            ),// service fee
            SizedBox(height: 8,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Tax:'),
                Text('\$'+ tax.toStringAsFixed(2)),
              ],
            ),// tax
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
            ),// drivers tip
            SizedBox(height: 15,),*/
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('SubTotal:',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                ),),
                cartOnHold ? Container(height: 15, width: 15, child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(primaryColor)),) :
                Text('\$' + (subTotal /*+ calculateDriverTip(double.parse(dropdownValue)) + shipping + calculateDriverTip(serviceFeePercent)*/).toStringAsFixed(2),
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
      
      //subTotal = subTotal + driverTip;
      //print(driverTip);
      var minCartText = new Center(
        child: Text("Minimum order amount is CA\$"+ minCartValue.toString(),
          style: TextStyle(
              color: transparentREd
          ),),
      );

      if(subTotal < minCartValue)
      {
        productList.add(minCartText);
        productList.add(SizedBox(height: 15));
      }
      var submitButton = Container(
        height: 45,
        margin: EdgeInsets.only(left: 15, right: 15, bottom: 50),
        child: FlatButton(

          onPressed: subTotal < minCartValue ? null : (){
            //isLoggedIn() != null ? showToast('logged in') : showCheckoutMethodDialog();
            /*if(addressAdded)
            {
              Navigator.pushReplacementNamed(context, '/orderDetail');
            }
            else{

              Navigator.of(context).push(
                CupertinoPageRoute(
                    fullscreenDialog: true,
                    builder: (context) => ShippingAddress()
                )
            );}*/

            //isLoggedIn();
            if(isAddressAdded)
            {
              Navigator.of(context).push(
                  CupertinoPageRoute(
                    //fullscreenDialog: true,
                      builder: (context) => OrderDetail()
                  )
              );
             // Navigator.pushNamed(context, '/orderDetail');
            }
            else{
              Navigator.of(context).push(
                  CupertinoPageRoute(
                      fullscreenDialog: true,
                      builder: (context) => AddressBook("Select Address")
                  )
              );
            }
          },
          disabledColor: iconColor,
          color: primaryColor,
          child: isLoading || cartOnHold  ? CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color> (white),) :Text('Continue',
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
   // setState(() {

      //});
    return productList;
  }


  int minCartValue = 0;
  getMinCartValue() async
  {
    var preferences = await SharedPreferences.getInstance();
    setState(() {
      minCartValue = int.parse(preferences.getString(min_cart_value ?? "0"));
    });

  }


  @override
  void initState() {
    getToken();
    cartOnHold = false;
    isAddressAdded = false;
    
    getMinCartValue();
   // StripePayment.setOptions(
      //  StripeOptions(publishableKey: "pk_test_aSaULNS8cJU6Tvo20VAXy6rp", merchantId: "Test", androidPayMode: 'test'));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    //print('cart');
    print("here");
    cartCount = 0;
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        elevation: 1,
        iconTheme: IconThemeData(
          color: darkText
        ),
        centerTitle: true,
        backgroundColor: white,
        title: Text('Cart',
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


  void getUserInfoFromServer(String token) async
  {
    try
    {
      setState(() {
        isLoading = true;
      });

      final response = await http.get(
        userInfo,
        headers: {HttpHeaders.authorizationHeader: 'Bearer '+ token,
          HttpHeaders.contentTypeHeader: contentType},
      );
      if(response.statusCode == 200)
      {
        final responseJson = json.decode(response.body);
        userInfoObject = responseJson;
        //getAddressCells();

        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ShippingAddress(),
            ));

        print(responseJson);
      }
      else
      {
        final responseJson = json.decode(response.body);
        showToast(responseJson['message']);
        print(response.statusCode);
        Navigator.pop(context);
      }
      setState(() {
        isLoading = false;
      });
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
    //var savedValue = preferences.getString('value_key');
  }

  void getToken() async
  {
    try{
      var preferences = await SharedPreferences.getInstance();
      print(preferences.getString(user_token ?? ''));
      getCartItems(preferences.getString(user_token ?? ''));
    }
    catch(e)
    {
      //showToast('Something went wrong');
    }
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
      });
    }


  }














 






  Future<void> getCartItems(String token) async {
    print('cartItems');
    //Map itemInfo = { "cartItem" : { "sku" : widget.productData['sku'], "qty" : 1, "quoteId" : cartId } };
    setState(() {
      isLoading = true;
    });
    try
    {
      final response = await http.get(
        createCartId,
        headers: {HttpHeaders.authorizationHeader: 'Bearer '+token,
          HttpHeaders.contentTypeHeader: contentType},
      );
      //response.add(utf8.encode(json.encode(itemInfo)));



      if(response.statusCode == 200)
      {
        final responseJson = json.decode(response.body);
        //cartId = responseJson;

 

        setState(() {
          print(responseJson);
          prodList = responseJson['items'] as List;


         
          isLoading = false;
       
        isLoaded = true;


        String method = responseJson['extension_attributes']['shipping_assignments'][0]['shipping']['method'].toString();
        String regionId = responseJson['extension_attributes']['shipping_assignments'][0]['shipping']['address']['region_id'].toString();
        String street = responseJson['extension_attributes']['shipping_assignments'][0]['shipping']['address']['street'][0].toString();
        addressToOrderDetail = responseJson['extension_attributes']['shipping_assignments'][0]['shipping']['address'];
        print(method);
        if(method == '' || method == "null" || regionId == "" || regionId == "0" ||regionId == "null"
        || street == "" ||street == "null") 
        {
          isAddressAdded = false;
        }else{isAddressAdded = true;}
         });
        //showToast('success');
      }
      else
      {
        final responseJson = json.decode(response.body);
        print(responseJson);
        loginInfoFromLocal();
        //showToast('Something went wrong');
      }
    }
    catch(e){
      print(e);
      setState(() {
        getToken();
      });
    }

  }





  Future<void> updateItemToCart(int itemId, int quantity, int index) async {


    var preferences = await SharedPreferences.getInstance();
    //print(preferences.getString(user_token ?? ''));
    try
    {
      print('update');
      print(itemId);
      print(quantity);
      print(index);
      Map itemInfo = { "cartItem" : { "item_id" : int.parse(itemId.toString()), "qty" : int.parse(quantity.toString()), "quoteId" : int.parse(preferences.getInt(cart_id ?? '0').toString()) } };

     // Map abc = { "cartItem" : {'sku': itemId, "qty" : quantity, "quoteId" : int.parse(preferences.getInt(cart_id ?? '0').toString()) }};

      setState(() {
        cartOnHold = true;
        updatingItemId = itemId;
      });
      final response = await http.post(
          itemToCartURL(cartId),
          headers: {HttpHeaders.authorizationHeader: 'Bearer '+ preferences.getString(user_token ?? ''),
            HttpHeaders.contentTypeHeader: contentType},
          body: json.encode(itemInfo)
      );

      if(response.statusCode == 200)
      {
        final responseJson = json.decode(response.body);
        prodList[index] = responseJson;

        print(responseJson);
      }
      else
      {
        final responseJson = json.decode(response.body);
        print(responseJson);
        showToast(response.statusCode.toString());
        showToast(responseJson['message']);
      }
      setState(() {
        cartOnHold = false;
        updatingItemId = 0;
      });
    }
    catch(e){
      print(e);
      setState(() {
        cartOnHold = false;
        updatingItemId = 0;
      });}

  }


  Future<void> deleteItemFromCart(String itemId, int index) async {

    try
    {
      var preferences = await SharedPreferences.getInstance();
      setState(() {
        //cartOnHold = true;
        itemToDelete = int.parse(itemId);
      });
      final response = await http.delete(
          deleteCartItem(itemId),
          headers: {HttpHeaders.authorizationHeader: "Bearer "+ preferences.getString(user_token ?? ''),
            HttpHeaders.contentTypeHeader: contentType},
          //body: json.encode(itemInfo)
      );
      //response.add(utf8.encode(json.encode(itemInfo)));


      if(response.statusCode == 200)
      {
        final responseJson = json.decode(response.body);
        //skuList.removeAt(skuList.indexOf(prodList[index]['sku']));
        //imageList.removeAt(skuList.indexOf(prodList[index]['sku']));
        //cartCount = cartCount - prodList[index]['qty'];
        prodList.removeAt(index);
        print(responseJson);

      }
      else
      {
        final responseJson = json.decode(response.body);
        showToast(responseJson['message']);
      }
      setState(() {
        //cartOnHold = false;
        itemToDelete = 0;
      });
    }
    catch(e){
      print(e);
      setState(() {
        //cartOnHold = false;
        itemToDelete = 0;
      });
    }

  }



   void showCheckoutMethodDialog()
  {

    final act =CupertinoActionSheet(
        title: Text('Select'),
        //message: Text('Which option?'),
        actions: <Widget>[
          CupertinoActionSheetAction(
            child: Text('Sign in'),
            onPressed: () {
              Navigator.pop(context);
              Navigator.of(context).push(
                  CupertinoPageRoute(
                      fullscreenDialog: true,
                      builder: (context) => SignIn('finish')
                  )
              );

            },
          ),
          CupertinoActionSheetAction(
            child: Text('Guest Checkout'),
            onPressed: () {
              Navigator.pop(context);

              Navigator.of(context).push(
                  CupertinoPageRoute(
                      fullscreenDialog: true,
                      builder: (context) => ShippingAddress()
                  )
              );

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


  }

  void isLoggedIn() async
  {
    gettingSavedValues = true;
    var preferences = await SharedPreferences.getInstance();
    gettingSavedValues = false;
    try{
      if(preferences.getBool(is_logged_in ?? false))
      {
        /*Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddressBook('Select Address'),
            ));*/
        loginInfoFromLocal();
      } else{
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SignIn('finish'),
            ));
      }
    }
    catch(e)
    {

    }


  }





}
