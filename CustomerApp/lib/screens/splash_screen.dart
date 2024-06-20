import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:trupressed_subscription/colors.dart';
import 'package:trupressed_subscription/common/CommonController.dart';
import 'package:trupressed_subscription/screens/profile_creation_screens/complete_profile_screen.dart';
import 'package:trupressed_subscription/utils/utils.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import '../common/common.dart';
import '../models/order_model.dart';
import '../models/user_model.dart';
import 'enable_location_screen.dart';
import 'home_screen.dart';
import 'profile_creation_screens/phone_number_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // late final AnimationController _controller = AnimationController(
  //   duration: const Duration(seconds: 2),
  //   vsync: this,
  // )..repeat(reverse: true);
  // late final Animation<double> _animation = CurvedAnimation(
  //   parent: _controller,
  //   curve: Curves.elasticOut,
  // );

  Utils utils = Utils();
  Timer? timer;
  var databaseReference = FirebaseDatabase.instance.ref();
  Common common = Common();
  CommonController commonController = CommonController();

  @override
  void initState() {
    super.initState();
    timer = Timer(const Duration(milliseconds: 500), () async {
      //  Get.offAll(() => IntroductionScreen());
      /// RUn below function checkFirstScreen
      FlutterNativeSplash.remove();
      checkFirstSeen();
      //Get.offAll(() => const PhoneNumberScreen());
    });
  }

  Future checkFirstSeen() async {
    //final box = Hive.box('credentials');
    if (utils.getUserId() != null) {
      await checkUser(utils.getUserId());
    } else {
      Get.offAll(() => PhoneNumberScreen());
    }
    // bool _seen = (box.get('seen') ?? false);
    //  if (_seen) {
    //    if (utils.getUserId() != null) {
    //      checkUser(utils.getUserId());
    //    } else {
    //      Get.offAll(() => PhoneNumberScreen());
    //    }
    //  } else {
    //    await box.put('seen', true);
    //    Get.offAll(() => PhoneNumberScreen());
    //  }
  }

  Future getOrders() async {
    databaseReference
        .child("Orders")
        .orderByChild('uid')
        .equalTo(utils.getUserId())
        .onChildAdded
        .listen((event) {
      if (event.snapshot.value != null) {
        OrderModel orderModel =
            OrderModel.fromJson(Map.from(event.snapshot.value as Map));
        String dateFormat = DateFormat("yyyy-MM-dd")
            .format(DateTime.parse(orderModel.endingDate!));
        DateTime splitOrderDate = DateTime.parse(dateFormat);

        String todayDate = DateFormat("yyyy-MM-dd").format(DateTime.now());
        DateTime todayDateInFormat = DateTime.parse(todayDate);

        if (orderModel.status == 'requested' &&
            splitOrderDate.compareTo(todayDateInFormat) > 0) {
          Common.orderData.add(orderModel);

          Common.orderDataWithOnce.add(orderModel);
        }
      }
    });
  }

  getOnceOrders() {
    databaseReference
        .child('OnceOrders')
        .orderByChild('uid')
        .equalTo(utils.getUserId())
        .onChildAdded
        .listen((event) {
      if (event.snapshot.value != null) {
        OrderModel orderModel =
            OrderModel.fromJson(Map.from(event.snapshot.value as Map));
        if (orderModel.uid == utils.getUserId()) {
          Common.orderDataWithOnce.add(orderModel);
          print('onceOrderModelLength:${Common.orderDataWithOnce.length}');
        }
      }
    });
  }

  checkUser(String uid) async {
    var status = await Permission.location.status;
    FirebaseDatabase.instance
        .ref()
        .child('Users')
        .child(uid)
        .once()
        .then((DatabaseEvent event) {
      if (event.snapshot.exists) {
        Common.userModel.value =
            UserModel.fromJson(Map.from(event.snapshot.value as Map));
        Common.wallet.value = Common.userModel.value.userWallet!;
        Common.orderDataWithOnce.clear();

        getOrders();
        getOnceOrders();
        print("!!!!!!!!!!!!!!!!!!"+Common.editOrderDataWithOnce.length.toString());
        if (Common.userModel.value.email == 'default' || Common.userModel.value.email == null || Common.userModel.value.email == '' || Common.userModel.value.email == 'null') {
       // if (Common.userModel.value.email == 'default') {
          if (status == PermissionStatus.granted) {
            utils.getUserCurrentLocation('');
            Get.offAll(() => CompleteProfileScreen());
          } else {
            Get.offAll(() => EnableLocationScreen());
          }
          //Get.offAll(() => CompleteProfileScreen());
        } else {
          if (status == PermissionStatus.granted) {
            utils.getUserCurrentLocation('');
            Get.offAll(() => HomeScreen());
          } else {
            Get.offAll(() => EnableLocationScreen());
          }
        }
      } else {
        Get.offAll(() => PhoneNumberScreen());
      }
    }).onError((error, stackTrace) {
      Get.offAll(() => PhoneNumberScreen());
    });
  }

  @override
  void dispose() {
    //  _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Center(
                child: CircularProgressIndicator(
                    backgroundColor: AppColors.primaryColor,
                    color: AppColors.whiteColor)),
            // Image.asset("assets/icons/white_logo.png",
            // height: 200, width: 200),
          ],
        ),
      ),
    );
  }
}
