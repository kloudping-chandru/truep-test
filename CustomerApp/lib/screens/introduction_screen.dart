import 'package:flutter/material.dart';
import 'package:trupressed_subscription/colors.dart';
import 'package:trupressed_subscription/screens/profile_creation_screens/phone_number_screen.dart';
import 'package:trupressed_subscription/utils/utils.dart';
import 'package:get/get.dart';

class IntroductionScreen extends StatefulWidget {
  const IntroductionScreen({Key? key}) : super(key: key);

  @override
  State<IntroductionScreen> createState() => _IntroductionScreenState();
}

class _IntroductionScreenState extends State<IntroductionScreen> with SingleTickerProviderStateMixin {
  Utils utils = Utils();
  RxInt pageViewIndex = 0.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Obx(() => pageView()));
  }

  pageView() {
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity! > 0) {
          if (pageViewIndex.value > 0) {
            pageViewIndex.value = pageViewIndex.value - 1;
          }
        }
        if (details.primaryVelocity! < 0) {
          if (pageViewIndex.value < 2) {
            pageViewIndex.value = pageViewIndex.value + 1;
          }
        }
      },
      child: Stack(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: Container(
              key: UniqueKey(),
              child: Image(
                image: showImage(),
                alignment: Alignment.topCenter,
                height: Get.height,
                width: Get.width,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            children: [
              const Expanded(flex: 6, child: SizedBox()),
              Expanded(
                flex: 4,
                child: Card(
                  color: AppColors.whiteColor,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(50), topRight: Radius.circular(50)),
                  ),
                  child: Column(
                    children: [
                      const Expanded(flex: 1, child: SizedBox()),
                      Expanded(
                        flex: 2,
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 500),
                          child: Container(
                            key: UniqueKey(),
                            child: utils.poppinsSemiBoldText(showTitle(), 25.0, AppColors.blackColor, TextAlign.center),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 500),
                          child: Container(
                            key: UniqueKey(),
                            child: utils.poppinsRegularText(showSubTitle(), 22.0, AppColors.lightGrey2Color, TextAlign.center),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 500),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 15.0),
                            key: UniqueKey(),
                            child: utils.helveticaMediumText(showDes(), 16.0, AppColors.lightGrey2Color, TextAlign.center),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Row(
                          children: [
                            const Expanded(flex: 1, child: SizedBox()),
                            Expanded(
                              flex: 1,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  makeCircle(pageViewIndex.value == 0 ? AppColors.primaryColor : AppColors.lightGreyColor),
                                  makeCircle(pageViewIndex.value == 1 ? AppColors.primaryColor : AppColors.lightGreyColor),
                                  makeCircle(pageViewIndex.value == 2 ? AppColors.primaryColor : AppColors.lightGreyColor),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: InkWell(
                                onTap: () {
                                  if (pageViewIndex.value < 2) {
                                    pageViewIndex.value = pageViewIndex.value + 1;
                                  } else {
                                    Get.to(() => const PhoneNumberScreen());
                                  }
                                },
                                child: Container(
                                  height: 30,
                                  margin: const EdgeInsets.only(left: 30, right: 10),
                                  decoration: utils.gradient(AppColors.primaryColor, AppColors.primaryColor, 25.0),
                                  child: Center(
                                    child: pageViewIndex.value == 2
                                        ? const Icon(Icons.check_rounded, size: 20, color: AppColors.whiteColor)
                                        : utils.poppinsSemiBoldText('next'.tr, 12.0, AppColors.whiteColor, TextAlign.center),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  showImage() {
    switch (pageViewIndex.value) {
      case 0:
        return const AssetImage('assets/images/img_1.png');
      case 1:
        return const AssetImage('assets/images/img_2.png');
      case 2:
        return const AssetImage('assets/images/img_3.png');
    }
  }

  showTitle() {
    switch (pageViewIndex.value) {
      case 0:
        return 'Order Food Online';
      case 1:
        return 'Enjoy your food';
      case 2:
        return 'Get Delivered Easily';
    }
  }

  showSubTitle() {
    switch (pageViewIndex.value) {
      case 0:
        return 'Faster & Easier';
      case 1:
        return 'Thanks for choosing';
      case 2:
        return 'Track your food & parcel';
    }
  }

  showDes() {
    switch (pageViewIndex.value) {
      case 0:
        return 'Lorem ipsum dolor sit amet,consectetur adipiscing elit';
      case 1:
        return 'Lorem ipsum dolor sit amet,consectetur adipiscing elit';
      case 2:
        return 'Lorem ipsum dolor sit amet,consectetur adipiscing elit';
    }
  }

  makeCircle(color) {
    return Container(
      width: 15.0,
      height: 15.0,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
