import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
//62A308
const primaryColor = Color(0xFF62A308);
const darkChatPrimaryColor = Color(0xFF365904);
const white = Color(0xffffffff);
const accent = Color(0xFF62A308);
const darkText = Color(0xFF222222);
const background = Color(0xFFf8f8f8);
const lightText = Color(0xFF454545);
const lightestText = Color(0xFF656565);
const blue = Color(0xFF5391cf);
const transparent = Color(0x005391cf);
const transparentBlack = Color(0xa0000000);
const transparentBackground = Color(0x20000000);
const lightGrey = Color(0xa0d8d8d8);
const iconColor = Color(0xa0888888);
const transparentREd = Color(0x70df0000);
const backgroundGrey = Color(0xFF90a4ae);
const statusBarColor = Color(0xFFababab);

const auth = 'Bearer 64tdnqc6cuwr56a3yk2qlazwt1n8bmgf';
const contentType = 'application/json';
const domainURL = 'https://lanesopen.com/';
String storeUrl = domainURL+'index.php/rest/V1/mstore/categories';
// products
String categoriesURLPre =  domainURL+'index.php/rest/V1/mstore/products/?searchCriteria[filter_groups][0][filters][0][field]=category_id&searchCriteria[filter_groups][0][filters][0][value]=';
String categoriesURLPost = '&searchCriteria[filter_groups][0][filters][0][condition_type]=eq&searchCriteria[pageSize]=10&searchCriteria[currentPage]=1';

String categoriesURLPostProd = '&searchCriteria[filter_groups][0][filters][0][condition_type]=eq&searchCriteria[pageSize]=';
String urlPrefix = domainURL;

// get cartID
String createCartId = domainURL+'index.php/rest/V1/carts/mine';
//item to cart
String itemToCartURL(String qouteID)
{
  String url = domainURL+ 'index.php/rest/V1/carts/mine/items';
  return url;
}
// delete cart Item
String deleteCartItem(String itemId)
{
  String url = domainURL+ 'index.php/rest/V1/carts/mine/items/'+ itemId;
  //https://lanesopen.com/index.php/rest/V1/guest-carts/QibmjQIzGii6uRG98GANHtQanrOaPERU/items/11945
  return url;
}
// cart items
String cartItems = domainURL+'index.php/rest/V1/guest-carts/';
//login
String loginUrl = domainURL+'index.php/rest/V1/integration/customer/token';
String signUpUrl = domainURL+'index.php/rest/V1/customers';
String saveAddress = domainURL+ 'index.php/rest/V1/carts/mine/shipping-information';

String userInfo = domainURL+ 'index.php/rest/V1/customers/me';
String deleteAddress = domainURL+ 'index.php/rest/V1/addresses/';
String forgotPassword = domainURL+ 'rest/V1/customers/password';
String changePasswordURL = domainURL+ 'rest/V1/customers/me/password';
String sendDateTime = domainURL+ 'index.php/rest/V1/Iorderaddons/details/';
String clearCart = domainURL+ 'index.php/rest/V1/Iclearcart/details/';
String orders = domainURL+ 'index.php/rest/V1/Icustomerorder/details/';
String ordersDetail = domainURL+ 'index.php/rest/V1/Iorder/groupitems/';
String createOrderURl = domainURL+ 'index.php/rest/V1/carts/mine/order';
String getCartValuesUrl = domainURL+ 'index.php/rest/V1/guest-carts/';
String cartTotals = domainURL+'index.php/rest/V1/carts/mine/totals';
String addProductURL = domainURL + "rest/V1/products/"; 
List skuList = new List();
List imageList = new List();
List cartList = new List();


//Cart Contatnts
String cartId = '';
bool cartOnHold= false;
int itemToDelete= 0;
int cartCount =0;
bool gettingCartId = false;
int updatingItemId = 0;
bool addressAdded = false;
List<String> cartProdTitle = new List();
List<String> cartProdImages = new List();


// shared Prefrence
String user_token = 'user_token';
String is_logged_in = 'is_logged_in';
String username = 'username';
String password = 'password';
String savedEmail = 'savedEmail';
String savedtelephone = "telephone";
String firstname = 'firstname';
String lastname = 'lastname';
String id = 'id';
String store_id = 'store_id';
String cart_id = 'cart_id';
String cart_count = 'cart_count';
String min_cart_value = 'min_cart_value';
String today_timing = 'today_timing';
dynamic userInfoObject = '';

String savedPostalCode = '';


dynamic addressToOrderDetail;

List<dynamic> instructionList = new List();

// userInfo







void showToast(String message)
{
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: darkText,
      textColor: Colors.white,
      fontSize: 16.0
  );
}

