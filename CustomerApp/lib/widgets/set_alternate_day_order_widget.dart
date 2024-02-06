import 'package:flutter/material.dart';
import 'package:foodizm_subscription/colors.dart';
import 'package:foodizm_subscription/utils/utils.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class SetAlternateDayOrderWidget extends StatefulWidget {
  const SetAlternateDayOrderWidget({Key? key}) : super(key: key);

  @override
  State<SetAlternateDayOrderWidget> createState() =>
      _SetAlternateDayOrderWidgetState();
}

class _SetAlternateDayOrderWidgetState
    extends State<SetAlternateDayOrderWidget> {
  Utils utils = Utils();

  RxString staringDate = DateFormat("EE, MMMM yy").format(DateTime.now()).obs;

  RxInt startingDay = 0.obs;
  RxInt succeedingDay = 0.obs;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          IconButton(
              onPressed: () => Get.back(),
              icon: const Icon(Icons.close,
                  size: 35, color: AppColors.blackColor)),
          const SizedBox(height: 20),
          utils.poppinsSemiBoldText("quantityStartingDay".tr, 18.0,
              AppColors.blackColor, TextAlign.start),
          const SizedBox(height: 20),
          showDayQuantityWidget(startingDay),
          const SizedBox(height: 20),
          utils.poppinsSemiBoldText("quantitySucceedingDay".tr, 18.0,
              AppColors.blackColor, TextAlign.start),
          const SizedBox(height: 20),
          showDayQuantityWidget(succeedingDay),
          const SizedBox(height: 20),
          utils.poppinsSemiBoldText("setDeliveryDate".tr, 18.0,
              AppColors.blackColor, TextAlign.start),
          const SizedBox(height: 20),
          InkWell(
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 365)),
                builder: (context, child) {
                  return Theme(
                    data: ThemeData.dark().copyWith(
                      colorScheme: ColorScheme.dark(
                        primary: AppColors.primaryColor,
                        onPrimary: AppColors.whiteColor,
                        surface: AppColors.primaryColor,
                        onSurface: Colors.white,
                      ),
                      dialogBackgroundColor: AppColors.primaryColorLight,
                    ),
                    child: child!,
                  );
                },
              );
              staringDate.value = DateFormat("EE, MMMM yy").format(pickedDate!);
            },
            child: Container(
              height: 45.0,
              decoration: utils.boxDecoration(
                  Colors.transparent, AppColors.blackColor, 10.0, 1.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 15.0, right: 10.0),
                    child: Icon(Icons.edit_calendar_outlined,
                        size: 20, color: AppColors.blackColor),
                  ),
                  Obx(() => utils.poppinsSemiBoldText(staringDate.value, 16.0,
                      AppColors.blackColor, TextAlign.start)),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Get.back();
            },
            child: Container(
              height: 45,
              margin: const EdgeInsets.only(top: 20, bottom: 20),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: const BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.all(Radius.circular(30.0)),
              ),
              child: Center(
                  child: utils.poppinsMediumText(
                      'addSubscription'.tr.toUpperCase(),
                      16.0,
                      AppColors.whiteColor,
                      TextAlign.center)),
            ),
          ),
        ],
      ),
    );
  }

  Widget showDayQuantityWidget(RxInt value) {
    return Obx(() {
      return Container(
        height: 40.0,
        width: 140.0,
        decoration: utils.boxDecoration(
            Colors.transparent, AppColors.blackColor, 25.0, 1.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () => value > 0 ? value.value-- : null,
              icon: const Icon(Icons.remove,
                  size: 20, color: AppColors.blackColor),
            ),
            utils.poppinsMediumText(value.value.toString(), 18.0,
                AppColors.blackColor, TextAlign.start),
            IconButton(
              onPressed: () => value.value++,
              icon:
                  const Icon(Icons.add, size: 20, color: AppColors.blackColor),
            ),
          ],
        ),
      );
    });
  }
}
