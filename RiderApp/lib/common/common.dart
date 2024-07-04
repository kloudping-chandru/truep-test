import 'dart:async';
import 'package:foodizm_driver_app/models/order_model.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';

class Common {
  static String currency = '\$';
  static String? currentLat;
  static String? currentLng;
  static String? currentAddress;
  static Location location = new Location();
  static RxList<OrderModel> orderModel = <OrderModel>[].obs;
  static RxString driverUId = "".obs;

  static late StreamSubscription<LocationData> locationStream;
  static String? apiKey = "AIzaSyDbtJ1dV_G9nvMNo_Eh2PMRZgJR7tgUvm8";


}
