import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:trupressed_subscription/colors.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:location_geocoder/location_geocoder.dart';
import 'package:permission_handler/permission_handler.dart';

import '../common/common.dart';
import '../screens/home_screen.dart';
import '../screens/profile_creation_screens/complete_profile_screen.dart';

class Utils {
  inputDecoration(text) {
    return InputDecoration(
      hintStyle: const TextStyle(fontSize: 14),
      hintText: text,
      counterText: '',
      border: InputBorder.none,
      contentPadding: const EdgeInsets.all(15),
    );
  }

  boxDecoration(color, borderColor, radius, borderWidth,
      {isShadow, shadowColor}) {
    return BoxDecoration(
      color: color,
      border: Border.all(color: borderColor, width: borderWidth),
      borderRadius: BorderRadius.circular(radius),
      boxShadow: isShadow != null && isShadow ? shadow(shadowColor) : [],
    );
  }

  List<BoxShadow> shadow(shadowColor) {
    return [
      BoxShadow(
          color: shadowColor,
          spreadRadius: 1,
          blurRadius: 10,
          offset: const Offset(0, 3))
    ];
  }

  inputDecorationWithLabel(hint, labelText, color) {
    return InputDecoration(
      hintStyle: const TextStyle(
          fontSize: 14,
          color: AppColors.lightGreyColor,
          height: 1.5,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w500),
      hintText: hint,
      labelStyle: const TextStyle(
          fontSize: 14,
          color: AppColors.blackColor,
          height: 1,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w500),
      labelText: labelText,
      filled: true,
      alignLabelWithHint: true,
      fillColor: AppColors.whiteColor,
      contentPadding: const EdgeInsets.all(15),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: color)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.primaryColor)),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: color)),
    );
  }

  gradient(color1, color2, circularValue) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(circularValue),
      gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color1, color2]),
    );
  }

  poppinsSemiBoldText(text, size, color, textAlign) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
          color: color,
          fontSize: size,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w700),
    );
  }

  poppinsRegularText(text, size, color, textAlign) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
          color: color,
          fontSize: size,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.normal),
    );
  }

  poppinsBoldText(text, size, color, textAlign) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
          color: color,
          fontSize: size,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w900),
    );
  }

  poppinsMediumText(text, size, color, textAlign, {maxlines}) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxlines,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
          color: color,
          fontSize: size,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w500),
    );
  }

  helveticaBoldText(text, size, color, textAlign) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
          color: color,
          fontSize: size,
          fontFamily: 'Helvetica',
          fontWeight: FontWeight.bold),
    );
  }

  helveticaMediumText(text, size, color, textAlign) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
          color: color,
          fontSize: size,
          fontFamily: 'Helvetica',
          fontWeight: FontWeight.normal),
    );
  }

  helveticaSemiBoldText(text, size, color, textAlign) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
          color: color,
          fontSize: size,
          fontFamily: 'Helvetica',
          fontWeight: FontWeight.w500),
    );
  }

  helveticaSemiBold2Lines(text, size, color, textAlign) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
          height: 1.1,
          color: color,
          fontSize: size,
          fontFamily: 'Helvetica',
          fontWeight: FontWeight.w500),
    );
  }

  poppinsRegularTextLineTrough(text, size, color, textAlign) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
          color: color,
          fontSize: size,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.normal,
          decoration: TextDecoration.lineThrough),
    );
  }

  poppinsMediumText1Lines(text, size, color, textAlign) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
          color: color,
          fontSize: size,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w500),
    );
  }

  poppinsMediumTextLineHeight(text, size, color, textAlign, height) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
          color: color,
          fontSize: size,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w500,
          height: height),
    );
  }

  showSnakeBar(title, text) {
    return Get.snackbar(title, text,
        snackPosition: SnackPosition.BOTTOM,
        overlayBlur: 5.0,
        backgroundColor: AppColors.primaryColor,
        colorText: AppColors.accentColor);
  }

  showLoadingDialog() {
    Get.dialog(
      const Center(
          child: CircularProgressIndicator(
              backgroundColor: AppColors.primaryColor,
              color: AppColors.whiteColor)),
      barrierDismissible: false,
      useSafeArea: true,
    );
  }

  showToast(text) {
    return Fluttertoast.showToast(
        msg: "" + text,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        fontSize: 16.0);
  }

  noDataWidget(text, height) {
    return SizedBox(
      height: height,
      child: Center(
        child: Text(
          text,
          softWrap: false,
          style: const TextStyle(
              color: AppColors.primaryColor,
              fontSize: 20,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  getUserId() {
    var credentials = Hive.box('credentials');
    return credentials.get('uid');
  }

  void getUserCurrentLocation(String origin) async {
    // showLoadingDialog();
    var status = await Permission.locationWhenInUse.request();

    if (status == PermissionStatus.granted) {
      await Geolocator.getCurrentPosition().then((value) async {
        final LocatitonGeocoder geocoder = LocatitonGeocoder(Common.apiKey!);
        var address = await geocoder.findAddressesFromCoordinates(
            Coordinates(value.latitude, value.longitude));
        print(' ${address.first.addressLine}, ${address.first.locality}, ${address.first.postalCode}');
        Common.currentLat = value.latitude.toString();
        Common.currentLng = value.longitude.toString();
        Common.currentAddress = address.first.addressLine;
        Common.currentCity = address.first.locality;
        if (origin == 'location') {
          print("aaaabbab=>${Common.userModel.value.email}");
          print("aaaabbab=>${Common.userModel.value.fullName}");
          if (Common.userModel.value.email == 'default' || Common.userModel.value.email == null || Common.userModel.value.email == '' || Common.userModel.value.email == 'null') {
              Get.offAll(() => CompleteProfileScreen());
            } else {
               Get.offAll(() => HomeScreen());
            }
            // Get.offAll(() => CompleteProfileScreen());
            // Get.offAll(() => EnableLocationScreen());
          }
          else{
          //showToast('You need to allow location permission in order to continue');
        }
         // Get.offAll(() => CompleteProfileScreen());
      });
    }

      else {
      showToast('You need to allow location permission in order to continue');
    }
  }

  rectangleBox(radious, color) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(radious),
      color: color,
      boxShadow: const [
        BoxShadow(
          color: Colors.grey,
          offset: Offset(0.0, 1.0), //(x,y)
          blurRadius: 1.0,
        ),
      ],
    );
  }

   bool isToday(DateTime checkDate) {
    DateTime today = DateTime.now();
    return (checkDate.year == today.year &&
        checkDate.month == today.month &&
        checkDate.day == today.day);
  }
}
