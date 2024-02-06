import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../models/categories_model.dart';
import '../models/order_days_model.dart';
import '../models/order_model.dart';
import '../models/product_model.dart';
import '../models/user_model.dart';

class Common {
  static String dummyText =
      'It is a long established fact that a reader will be distracted by the readable content '
      'of a page when looking at its layout';

  static String ingredientsText = '2 cups cold milk, '
      '2 cups sliced fresh strawberries, divided, 2 medium peach or nectarines, peeled and sliced';

  static String name = 'Home';
  static String homeIndex = '0';
  //static String currency = '\$';
  static String currency = 'INR';

  static String? codeSent;
  static int? resendToken;
  static PhoneAuthCredential? credential;

  static RxBool verified = false.obs;
  static UserModel userModel = new UserModel();
  //static Rx<UserModel> userModel = UserModel().obs;

  static String? apiKey = "AIzaSyDbtJ1dV_G9nvMNo_Eh2PMRZgJR7tgUvm8";

  static RxString wallet = '0.00'.obs;

  static String? currentLat;
  static String? currentLng;
  static String? currentAddress;
  static String? currentCity;

  static RxList<CategoriesModel> categoriesList = <CategoriesModel>[].obs;
  static RxList<ProductModel> popularProductList = <ProductModel>[].obs;

  static RxList<OrderModel> orderData = <OrderModel>[].obs;
  static RxList<OrderModel> orderDataWithOnce = <OrderModel>[].obs;
  static RxList<OrderModel> getAllOrders = <OrderModel>[].obs;

  static RxList<OrderDaysModel> orderDaysData = <OrderDaysModel>[].obs;

  static RxList<OrderModel> editOrderDataWithOnce = <OrderModel>[].obs;

  static RxString quantity = ''.obs;

  static RxList<Widget> toommorowOrderList = <Widget>[].obs;

  static num minimumRequiredWalletBalance = 200;
  static int minimumUserAge = 13;
  static RxInt bottomIndex = 0.obs;

  static clearUserDetails(){
    codeSent=null;
    resendToken=null;
    credential=null;
    userModel = new UserModel();
    verified.value = false;
    categoriesList.value =[];
    popularProductList.value=[];
    orderData.value=[];
    orderDataWithOnce.value=[];
    getAllOrders.value=[];
    orderDaysData.value=[];
    editOrderDataWithOnce.value=[];
    quantity.value='';
    toommorowOrderList.value=[];
    bottomIndex.value = 0;
  }
}
