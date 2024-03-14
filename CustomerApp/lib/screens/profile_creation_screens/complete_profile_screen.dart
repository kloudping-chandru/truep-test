import 'dart:convert';
import 'dart:math' as math;
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:trupressed_subscription/colors.dart';
import 'package:trupressed_subscription/screens/home_screen.dart';
import 'package:trupressed_subscription/utils/utils.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../common/common.dart';
import '../../models/user_model.dart';
import '../enable_location_screen.dart';

class CompleteProfileScreen extends StatefulWidget {
  const CompleteProfileScreen({Key? key}) : super(key: key);

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  Utils utils = Utils();
  var userNameController = TextEditingController();
  var phoneNumberController = TextEditingController();
  var emailController = TextEditingController();
  var fullNameController = TextEditingController();
  var dobController = TextEditingController().obs;
  RxInt genderIndex = 3.obs;
  var formKey = GlobalKey<FormState>();
  RxBool emailReadOnly = false.obs;
  RxBool phoneReadOnly = false.obs;
  bool newValue = true;
  String phoneCode = "";
  late DateTime selectedDate;
  late DateTime restrictedDate;
  RxString countryName = "".obs;
  var databaseReference = FirebaseDatabase.instance.ref();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getIpV4();
    populateUserDetails();
    populateDateRestrictions();
  }

  populateUserDetails() {
    if ((Common.userModel.email ?? "").isNotEmpty &&
        Common.userModel.email != 'default') {
      emailController.text = Common.userModel.email ?? "";
    }
    print(Common.userModel.fullName);
    if ((Common.userModel.fullName ?? "").isNotEmpty &&
        Common.userModel.email != 'default') {
      fullNameController.text = Common.userModel.fullName ?? "";
    }
    if ((Common.userModel.gender ?? "").toLowerCase() == "male") {
      genderIndex.value = 0;
    } else if ((Common.userModel.gender ?? "").toLowerCase() == "female") {
      genderIndex.value = 1;
    }
    if ((Common.userModel.dateOfBirth ?? "").isNotEmpty) {
      dobController.value.text = Common.userModel.dateOfBirth.toString();
    }
  }

  populateDateRestrictions() {
    DateTime date = DateTime.now();
    selectedDate = DateTime.now();
    restrictedDate =
        DateTime(date.year - Common.minimumUserAge, date.month, date.day);
    if (dobController.value.text.isEmpty) {
      selectedDate = restrictedDate;
    } else {
      selectedDate = DateFormat("dd-MMM-yyyy").parse(dobController.value.text);
      if (restrictedDate.isBefore(selectedDate)) {
        selectedDate = restrictedDate;
        dobController.value.text =
            DateFormat("dd-MMM-yyyy").format(selectedDate);
      }
    }
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
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: utils.poppinsMediumText(
            '2 of 2', 16.0, AppColors.blackColor, TextAlign.center),
        centerTitle: true,
      ),
      body: Obx(() {
        return SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  utils.poppinsSemiBoldText('completeYourProfile'.tr, 25.0,
                      AppColors.primaryColor, TextAlign.center),
                  Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Padding(
                        //   padding: const EdgeInsets.only(top: 10),
                        //   child: TextFormField(
                        //     controller: userNameController,
                        //     keyboardType: TextInputType.text,
                        //     decoration: utils.inputDecorationWithLabel('userNameEg'.tr, 'userName'.tr, AppColors.lightGrey2Color),
                        //     validator: (value) {
                        //       if (value!.isEmpty) {
                        //         return "enterUserName".tr;
                        //       }
                        //       return null;
                        //     },
                        //   ),
                        // ),
                        // Obx(() => Padding(
                        //       padding: const EdgeInsets.only(top: 10),
                        //       child: Row(
                        //         children: [
                        //           Container(
                        //             height: 50,
                        //             margin: const EdgeInsets.only(right: 5),
                        //             decoration: utils.boxDecoration(
                        //                 Colors.transparent,
                        //                 AppColors.blackColor,
                        //                 10.0,
                        //                 1.0),
                        //             child: countryName.value == ''
                        //                 ? const Padding(
                        //                     padding: EdgeInsets.symmetric(
                        //                         horizontal: 15),
                        //                     child: CupertinoActivityIndicator())
                        //                 : CountryCodePicker(
                        //                     enabled: newValue,
                        //                     onChanged: (value) {
                        //                       phoneCode = value.dialCode!;
                        //                     },
                        //                     onInit: (value) {
                        //                       phoneCode = value!.dialCode!;
                        //                     },
                        //                     initialSelection: countryName.value,
                        //                     showCountryOnly: false,
                        //                     showOnlyCountryWhenClosed: false,
                        //                     alignLeft: false,
                        //                   ),
                        //           ),
                        //           Expanded(
                        //             flex: 1,
                        //             child: TextFormField(
                        //               controller: phoneNumberController,
                        //               readOnly: phoneReadOnly.value,
                        //               onChanged: (value) {},
                        //               keyboardType: TextInputType.phone,
                        //               decoration:
                        //                   utils.inputDecorationWithLabel(
                        //                       'phoneEg'.tr,
                        //                       'phoneNumber'.tr,
                        //                       AppColors.lightGrey2Color),
                        //               validator: (value) {
                        //                 if (value!.isEmpty) {
                        //                   return "enterPhone".tr;
                        //                 }
                        //                 return null;
                        //               },
                        //             ),
                        //           ),
                        //           InkWell(
                        //             onTap: () {},
                        //             child: Container(
                        //               margin: const EdgeInsets.only(left: 5),
                        //               child: Image.asset(
                        //                 'assets/images/correct.png',
                        //                 height: 30,
                        //                 width: 30,
                        //                 color: AppColors.lightGreyColor,
                        //               ),
                        //             ),
                        //           ),
                        //         ],
                        //       ),
                        //     )),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: TextFormField(
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: utils.inputDecorationWithLabel(
                                'emailEg'.tr,
                                'email'.tr,
                                AppColors.lightGrey2Color),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "enterEmail".tr;
                              }
                              if (!RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(value)) {
                                return 'enterCorrectEmail'.tr;
                              }
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 20),
                          child: TextFormField(
                            controller: fullNameController,
                            textCapitalization: TextCapitalization.words,
                            decoration: utils.inputDecorationWithLabel(
                                'fullNameEg'.tr,
                                'fullName'.tr,
                                AppColors.lightGrey2Color),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "enterFullName".tr;
                              }
                              return null;
                            },
                          ),
                        ),
                        utils.poppinsRegularText('chooseGender'.tr, 18.0,
                            AppColors.primaryColor, TextAlign.center),
                        Container(
                          margin: const EdgeInsets.only(top: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 1,
                                child: InkWell(
                                  onTap: () {
                                    genderIndex.value = 0;
                                  },
                                  child: SizedBox(
                                    height: 100,
                                    child: buildBox(
                                        0, 'male'.tr, 'assets/images/male.svg'),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: InkWell(
                                  onTap: () {
                                    genderIndex.value = 1;
                                  },
                                  child: SizedBox(
                                    height: 100,
                                    child: buildBox(1, 'female'.tr,
                                        'assets/images/female.svg'),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 20),
                          child: TextFormField(
                            controller: dobController.value,
                            readOnly: true,
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: selectedDate,
                                firstDate: DateTime(1900),
                                lastDate: restrictedDate,
                                builder: (context, child) {
                                  return Theme(
                                    data: ThemeData.dark().copyWith(
                                      colorScheme: ColorScheme.dark(
                                        primary: AppColors.primaryColor,
                                        onPrimary: AppColors.whiteColor,
                                        surface: AppColors.primaryColor,
                                        onSurface: Colors.white,
                                      ),
                                      dialogBackgroundColor:
                                          AppColors.primaryColorLight,
                                    ),
                                    child: child!,
                                  );
                                },
                              );
                              if (pickedDate != null) {
                                dobController.value.text =
                                    DateFormat("dd-MMM-yyyy")
                                        .format(pickedDate);
                              }
                            },
                            decoration: utils.inputDecorationWithLabel(
                                'dobEg'.tr,
                                'dob'.tr,
                                AppColors.lightGrey2Color),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "selectDob".tr;
                              }
                              return null;
                            },
                          ),
                        ),
                      utils.poppinsRegularText('userAgeLimit'.tr, 12.0,
                            AppColors.primaryColor, TextAlign.center),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: InkWell(
                      onTap: () {
                        if (formKey.currentState!.validate()) {
                          if (genderIndex.value != 3) {
                            saveData();
                            // if (Common.verified.value) {
                            //   checkUserNameBeforeUploading();
                            // } else {
                            //   utils.showToast('verifyNumber'.tr);
                            // }
                          } else {
                            utils.showToast('pleaseChooseGender'.tr);
                          }
                        }

                        // Get.to(() => const HomeScreen());
                      },
                      child: Container(
                        height: 40,
                        width: 250,
                        margin: EdgeInsets.only(top: 15),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.primaryColor),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(30.0),
                          ),
                        ),
                        child: Center(
                            child: utils.poppinsMediumText('next'.tr, 16.0,
                                AppColors.primaryColor, TextAlign.center)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  buildBox(index, text, icon) {
    return Card(
      color: genderIndex.value == index ? AppColors.primaryColor : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(color: AppColors.primaryColor, width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (text == 'female'.tr)
            Transform.rotate(
              angle: 90 * math.pi / 21,
              child: SvgPicture.asset(
                icon,
                height: 20,
                width: 20,
                colorFilter: ColorFilter.mode(
                    genderIndex.value == index
                        ? AppColors.whiteColor
                        : AppColors.primaryColor,
                    BlendMode.srcIn),
              ),
            ),
          if (text == 'male'.tr)
            SvgPicture.asset(
              icon,
              height: 20,
              width: 20,
              colorFilter: ColorFilter.mode(
                  genderIndex.value == index
                      ? AppColors.whiteColor
                      : AppColors.primaryColor,
                  BlendMode.srcIn),
            ),
          utils.poppinsRegularText(
              text,
              18.0,
              genderIndex.value == index
                  ? AppColors.whiteColor
                  : AppColors.primaryColor,
              TextAlign.center)
        ],
      ),
    );
  }

  saveData() async {
    utils.showLoadingDialog();
    Map<String, dynamic> value = {
      // 'userName': userNameController.text,
      'gender': genderIndex.value == 0 ? 'male'.tr : 'female'.tr,
      'date_of_birth': dobController.value.text,
      'fullName': fullNameController.text,
      // 'phoneNumber': phoneNumberController.text,
      'email': emailController.text,
      'userAddress': 'default',
      'userLocation': 'default',
    };
    databaseReference
        .child('Users')
        .child(Utils().getUserId())
        .update(value)
        .whenComplete(() async {
      // await databaseReference.child('UsersName').push().set({'userName': userNameController.text});
      saveUser(Utils().getUserId());
    }).onError((error, stackTrace) {
      Get.back();
      Utils().showToast(error.toString());
    });
  }

  saveUser(String uid) {
    Query query = databaseReference.child('Users').child(uid);
    query.once().then((DatabaseEvent event) {
      if (event.snapshot.exists) {
        Common.userModel =
            UserModel.fromJson(Map.from(event.snapshot.value as Map));
        Common.wallet.value = Common.userModel.userWallet!;
        Utils().showToast('profileUpdated'.tr);
        Get.offAll(() => EnableLocationScreen());
      } else {
        Get.back();
        Utils().showToast('noUserFound'.tr);
      }
    });
  }
}
