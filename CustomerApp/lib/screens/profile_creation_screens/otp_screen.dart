import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foodizm_subscription/colors.dart';
import 'package:foodizm_subscription/screens/profile_creation_screens/add_photo_screen.dart';
import 'package:foodizm_subscription/utils/utils.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';

import '../../common/common.dart';
import '../../models/user_model.dart';
import '../enable_location_screen.dart';
import '../home_screen.dart';
import 'complete_profile_screen.dart';

class OtpScreen extends StatefulWidget {
  final String? number, origin;

  const OtpScreen({Key? key, this.number, this.origin}) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  Utils utils = Utils();
  String currentText = "";
  RxBool otpVerified = true.obs;
  RxBool sendAgain = false.obs;
  RxBool hasError = false.obs;
  late StreamController<ErrorAnimationType> errorController;
  final CountdownController _controller = CountdownController(autoStart: true);
  final otpController = TextEditingController();
  final databaseReference = FirebaseDatabase.instance.ref();

  @override
  void initState() {
    errorController = StreamController<ErrorAnimationType>();
    super.initState();
  }

  @override
  void dispose() {
    errorController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Obx(() {
        return SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    flex: 8,
                    child: Image(
                      image: const AssetImage('assets/images/juiceImg1.jpeg'),
                      alignment: Alignment.topCenter,
                      height: Get.height,
                      width: Get.width,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const Expanded(flex: 2, child: SizedBox())
                ],
              ),
              Column(
                children: [
                  const Expanded(child: SizedBox()),
                  Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 25),
                    width: Get.width,
                    height: 350.0,
                    child: Card(
                      color: AppColors.whiteColor,
                      elevation: 1,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/images/smartphone.svg',
                                colorFilter: const ColorFilter.mode(
                                    AppColors.primaryColor, BlendMode.srcIn),
                                height: 40,
                                width: 40,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: utils.helveticaBoldText(
                                    'validationCode'.tr,
                                    20.0,
                                    AppColors.primaryColor,
                                    TextAlign.center),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: utils.poppinsRegularText(
                                    '${'otpSentTo'.tr} ${widget.number ?? "+11234567890"}',
                                    16.0,
                                    AppColors.lightGrey2Color,
                                    TextAlign.center),
                              ),
                              Obx(() => Container(
                                    margin: const EdgeInsets.only(
                                        top: 10, left: 15, right: 15),
                                    child: PinCodeTextField(
                                      appContext: context,
                                      pastedTextStyle: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                      length: 6,
                                      blinkWhenObscuring: true,
                                      animationType: AnimationType.fade,
                                      pinTheme: PinTheme(
                                        disabledColor: Colors.red,
                                        inactiveColor: Colors.grey,
                                        selectedColor: AppColors.primaryColor,
                                        shape: PinCodeFieldShape.underline,
                                        fieldHeight: 40,
                                        fieldWidth: 40,
                                        activeFillColor: hasError.value
                                            ? Colors.blue.shade100
                                            : Colors.white,
                                      ),
                                      cursorColor: Colors.black,
                                      animationDuration:
                                          const Duration(milliseconds: 300),
                                      errorAnimationController: errorController,
                                      controller: otpController,
                                      keyboardType: TextInputType.number,
                                      onCompleted: (v) {
                                        debugPrint("Completed");
                                      },
                                      onChanged: (value) {
                                        debugPrint(value);
                                        setState(() {
                                          currentText = value;
                                        });
                                      },
                                      beforeTextPaste: (text) {
                                        debugPrint("Allowing to paste $text");
                                        return true;
                                      },
                                    ),
                                  )),
                              InkWell(
                                onTap: sendAgain.value ? verifyNumber : null,
                                child: Container(
                                  margin: const EdgeInsets.only(top: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      //utils.poppinsRegularText('${'notGetCode'.tr} ', 14.0, AppColors.lightGrey2Color, TextAlign.center),
                                      utils.poppinsRegularText(
                                          '${'resend'.tr} ',
                                          14.0,
                                          sendAgain.value
                                              ? AppColors.primaryColor
                                              : AppColors.lightGrey2Color,
                                          TextAlign.center),
                                      Countdown(
                                        controller: _controller,
                                        seconds: 30,
                                        build: (BuildContext context,
                                                double time) =>
                                            utils.poppinsRegularText(
                                                time.toString(),
                                                14.0,
                                                AppColors.primaryColor,
                                                TextAlign.center),
                                        interval: const Duration(seconds: 1),
                                        onFinished: () {
                                          setState(() {
                                            sendAgain.value = true;
                                            _controller.restart();
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  if (currentText.length != 6) {
                                    errorController
                                        .add(ErrorAnimationType.shake);
                                    setState(() {
                                      hasError.value = true;
                                    });
                                  } else {
                                    if (widget.origin == 'first') {
                                      verifyOTP();
                                    } else {
                                      attachPhoneNumber();
                                    }
                                  }
                                },
                                child: makeButton(AppColors.primaryColor),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        );
      }),
    );
  }

  makeButton(color) {
    return Container(
      height: 45,
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        border: Border.all(color: color),
        borderRadius: const BorderRadius.all(
          Radius.circular(30.0),
        ),
      ),
      child: Center(
          child: utils.poppinsMediumText(
              'verify'.tr, 16.0, color, TextAlign.center)),
    );
  }

  verifyNumber() async {
    utils.showLoadingDialog();
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: widget.number!,
      verificationCompleted: (PhoneAuthCredential credential) {
        Common.credential = credential;
      },
      verificationFailed: (FirebaseAuthException e) {
        Get.back();
        utils.showToast(e.message.toString());
        print(e.message.toString());
      },
      codeSent: (String? verificationId, int? resendToken) {
        Common.codeSent = verificationId;
        Common.resendToken = resendToken;
        Get.back();
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  void verifyOTP() async {
    utils.showLoadingDialog();
    FirebaseAuth auth = FirebaseAuth.instance;

    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: Common.codeSent!, smsCode: currentText);

    await auth.signInWithCredential(credential).whenComplete(() {
      if (auth.currentUser != null) {
        Common.verified.value = true;
        checkUser(auth.currentUser!.uid, auth.currentUser!.phoneNumber!);
      } else {
        Get.back();
        hasError.value = true;
        utils.showToast('enterOtp'.tr);
      }
    });
  }

  void attachPhoneNumber() async {
    utils.showLoadingDialog();
    FirebaseAuth auth = FirebaseAuth.instance;
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: Common.codeSent!, smsCode: currentText);

    await auth.currentUser!.updatePhoneNumber(credential).whenComplete(() {
      if (auth.currentUser != null) {
        Common.verified.value = true;
        Get.back();
        Get.back();
      } else {
        Get.back();
        hasError.value = true;
        utils.showToast('enterOtp'.tr);
      }
    });
  }

  checkUser(String uid, String phoneNumber) async {
    var status = await Permission.location.status;
    await Hive.openBox('credentials');
    final box = Hive.box('credentials');
    //var status = await Permission.location.status;
    databaseReference
        .child('Users')
        .child(uid)
        .once()
        .then((DatabaseEvent event) {
      if (event.snapshot.exists) {
        box.put('uid', uid);
        Common.userModel =
            UserModel.fromJson(Map.from(event.snapshot.value as Map));
        Common.wallet.value = Common.userModel.userWallet!;
        FirebaseMessaging.instance.getToken().then((token) {
          databaseReference
              .child('Users')
              .child(uid)
              .update({'userToken': token}).whenComplete(() {
            Common.userModel.userToken = token;
          });
        });
        if (Common.userModel.profilePicture == 'default' &&
            Common.userModel.email == 'default') {
          Get.offAll(() => AddPhotoScreen());
        } else {
          Get.offAll(() => HomeScreen());
          if (status == PermissionStatus.granted) {
            utils.getUserCurrentLocation('');
            Get.offAll(() => HomeScreen());
          } else {
            Get.offAll(() => EnableLocationScreen());
          }
        }
      } else {
        box.put('uid', uid);
        createUser(uid, phoneNumber);
      }
    });
  }

  createUser(String uid, String phoneNumber) async {
    String? token = await FirebaseMessaging.instance.getToken();
    databaseReference.child('Users').child(uid).set({
      'uid': uid,
      'email': 'default',
      'fullName': 'default',
      'profilePicture': 'default',
      'userName': 'default',
      'phoneNumber': phoneNumber,
      'gender': 'default',
      'date_of_birth': 'default',
      'userAddress': 'default',
      'userLocation': 'default',
      'userWallet': '0.00',
      'userToken': token
    }).whenComplete(() {
      Get.offAll(() => AddPhotoScreen());
    }).onError((error, stackTrace) {
      Get.back();
      print(error.toString());
      utils.showToast(error.toString());
    });
  }
}
