import 'dart:convert';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:foodizm_subscription/colors.dart';
import 'package:foodizm_subscription/screens/profile_creation_screens/otp_screen.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foodizm_subscription/utils/utils.dart';
import 'package:get/get.dart';

import '../../common/common.dart';

class PhoneNumberScreen extends StatefulWidget {
  const PhoneNumberScreen({Key? key}) : super(key: key);

  @override
  State<PhoneNumberScreen> createState() => _PhoneNumberScreenState();
}

class _PhoneNumberScreenState extends State<PhoneNumberScreen> {
  Utils utils = Utils();
  String phoneCode = "";
  RxString countryName = "".obs;
  final myController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getIpV4();
  }

  void getIpV4() async {
    try {
      http.get(Uri.parse("http://ip-api.com/json")).then((value) {
        debugPrint("${json.decode(value.body)}");
        countryName.value = json.decode(value.body)['countryCode'].toString();
      });
    } catch (err) {
      debugPrint(err.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  flex: 8,
                  child: Image(
                    image: const AssetImage('assets/images/juiceImg2.jpeg'),
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
                  margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
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
                              colorFilter: const ColorFilter.mode(AppColors.primaryColor, BlendMode.srcIn),
                              height: 40,
                              width: 40,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: utils.helveticaBoldText('login'.tr, 20.0, AppColors.primaryColor, TextAlign.center),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 20, left: 15, right: 15),
                              child: utils.poppinsRegularText('validPhoneNumber'.tr, 16.0, AppColors.lightGrey2Color, TextAlign.center),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 10),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.lightGrey4Color,
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                                child: Obx(() {
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      countryName.value == ''
                                          ? const Padding(padding: EdgeInsets.only(left: 20), child: CupertinoActivityIndicator())
                                          : CountryCodePicker(
                                              onChanged: (value) {
                                                phoneCode = value.dialCode!;
                                                if (kDebugMode) {
                                                  print(value.dialCode);
                                                }
                                              },
                                              onInit: (value) {
                                                phoneCode = value!.dialCode!;
                                                if (kDebugMode) {
                                                  print(value.dialCode);
                                                }
                                              },
                                              initialSelection: countryName.value,
                                              showCountryOnly: false,
                                              showOnlyCountryWhenClosed: false,
                                              alignLeft: false,
                                            ),
                                      Expanded(
                                        flex: 8,
                                        child: TextField(
                                          controller: myController,
                                          keyboardType: TextInputType.number,
                                          decoration: utils.inputDecoration('enterPhoneNumber'.tr),
                                        ),
                                      ),
                                    ],
                                  );
                                }),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                if (myController.text.isNotEmpty) {
                                  verifyNumber();
                                } else {
                                  utils.showToast('enterPhone'.tr);
                                }
                              },
                              child: makeButton(AppColors.primaryColor),
                            )
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
      ),
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
      child: Center(child: utils.poppinsMediumText('Next'.tr, 16.0, color, TextAlign.center)),
    );
  }
  verifyNumber() async {
    utils.showLoadingDialog();
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneCode + myController.text,
      verificationCompleted: (PhoneAuthCredential credential) {
        Common.credential = credential;
      },
      verificationFailed: (FirebaseAuthException e) {
        print("verification failed");
        Get.back();
        utils.showToast(e.message.toString());
        print(e.message.toString());
        print('${phoneCode + myController.text}');
      },
      codeSent: (String? verificationId, int? resendToken) {
        Common.codeSent = verificationId;
        Common.resendToken = resendToken;
        Get.back();
        Get.to(() => OtpScreen(number: phoneCode + myController.text, origin: 'first'));
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }
}
