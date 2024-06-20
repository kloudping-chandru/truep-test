import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trupressed_subscription/colors.dart';
import 'package:trupressed_subscription/common/common.dart';
import 'package:trupressed_subscription/screens/profile_creation_screens/phone_number_screen.dart';
import 'package:trupressed_subscription/utils/utils.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:url_launcher/url_launcher.dart';

import '../previous_order_history.dart';
import '../update_profile_screen.dart';

class BottomProfileScreen extends StatefulWidget {
  const BottomProfileScreen({Key? key}) : super(key: key);

  @override
  State<BottomProfileScreen> createState() => _BottomProfileScreenState();
}

class _BottomProfileScreenState extends State<BottomProfileScreen> {
  Utils utils = Utils();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Get.height,
      width: Get.width,
      child: Stack(
        children: [
          Column(
            children: [
              Expanded(
                flex: 4,
                child: Stack(
                  children: [
                    Image(
                      image: const AssetImage('assets/images/male_place.png'),
                      fit: BoxFit.cover,
                      width: Get.width,
                      alignment: Alignment.topCenter,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: const Alignment(1, 1),
                          end: const Alignment(1, 1),
                          colors: [
                            Colors.transparent,
                            AppColors.primaryColor.withAlpha(120)
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Expanded(flex: 6, child: SizedBox())
            ],
          ),
          Column(
            children: [
              const Expanded(flex: 3, child: SizedBox()),
              Expanded(
                flex: 3,
                child: Container(
                  width: Get.width,
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  child: Card(
                    elevation: 1,
                    shadowColor: AppColors.whiteColor,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Obx(()=> Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: utils.poppinsMediumText(
                                //Common.flName.value,
                                Common.userModel.value.fullName,
                                16.0,
                                AppColors.blackColor,
                                TextAlign.center),
                          ),
                        ),
                        utils.poppinsMediumText(Common.userModel.value.phoneNumber,
                            16.0, AppColors.blackColor, TextAlign.center),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () {},
                                child: buildWidget('payment.svg', 'Legal'),
                              ),
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  Get.to(UpdateProfileScreen())?.then((value) {

                                   // Get.reload();
                                  });
                                },
                                child: buildWidget('general_settings.svg',
                                    'profileSettings'.tr),
                              ),
                            ),
                            Expanded(
                              child: InkWell(
                                // onTap: _launchWhatsapp,
                                child: buildWidget(
                                    'gears.svg', 'Terms & Conditions'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            Expanded(
                                child: InkWell(
                              onTap: _launchWhatsapp,
                              child: buildWidget('support.svg', 'support'.tr),
                            )),
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  showLogoutDialog();
                                },
                                child: buildWidget('logout.svg', 'logout'.tr),
                              ),
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  Get.to(() => const PreviousOrderHistory());
                                  //showLogoutDialog();
                                },
                                child: buildWidget2(
                                    'logout.svg', 'Order History'.tr),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20)
                  ],
                ),
              )
            ],
          ),
          Column(
            children: [
              const Expanded(flex: 2, child: SizedBox()),
              Align(
                alignment: Alignment.center,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.primaryColor),
                  ),
                  height: 60,
                  width: 60,
                  child: Obx(()=>ClipRRect(
                      borderRadius: BorderRadius.circular(50.0),
                      child: Common.userModel.value.profilePicture!.isNotEmpty
                          ? CachedNetworkImage(
                              fit: BoxFit.cover,
                              imageUrl: Common.userModel.value.profilePicture!,
                              progressIndicatorBuilder:
                                  (context, url, downloadProgress) => SizedBox(
                                height: 50,
                                width: 50,
                                child: Center(
                                    child: CircularProgressIndicator(
                                        value: downloadProgress.progress)),
                              ),
                              errorWidget: (context, url, error) => Image.asset(
                                  'assets/images/placeholder_image.png',
                                  fit: BoxFit.cover),
                            )
                          : Image.asset('assets/images/placeholder_image.png',
                              fit: BoxFit.cover),
                    ),
                  ),
                ),
              ),
              const Expanded(flex: 6, child: SizedBox())
            ],
          ),
        ],
      ),
    );
  }

  _launchWhatsapp() async {
    const url = "whatsapp://send?phone=+917075007393";
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      utils.showToast("There is no whatsapp installed on your mobile");
    }
  }

  buildWidget(image, title) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
      child: Card(
        elevation: 1,
        shadowColor: AppColors.whiteColor,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset('assets/images/$image', height: 25, width: 25),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: utils.poppinsRegularText(
                  title, 14.0, AppColors.blackColor, TextAlign.center),
            )
          ],
        ),
      ),
    );
  }

  buildWidget2(image, title) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
      child: Card(
        elevation: 1,
        shadowColor: AppColors.whiteColor,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //SvgPicture.asset('assets/images/$image', height: 25, width: 25),
            const Icon(
              Icons.work_history_sharp,
              color: AppColors.redColor,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: utils.poppinsRegularText(
                  title, 14.0, AppColors.blackColor, TextAlign.center),
            )
          ],
        ),
      ),
    );
  }

  void showLogoutDialog() {
    Get.defaultDialog(
      title: "confirmation".tr,
      content: Text(
        "wantLogout".tr,
        textAlign: TextAlign.center,
      ),
      cancel: ElevatedButton(
        onPressed: () {
          Get.back();
        },
        style:
            ElevatedButton.styleFrom(backgroundColor: AppColors.primaryColor),
        child: Text("no".tr),
      ),
      confirm: ElevatedButton(
        onPressed: () async {
          Common.clearUserDetails();
          Hive.box('credentials').clear();
          Get.back();
          Get.offAll(() => PhoneNumberScreen());
          Get.back();
        },
        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
        child: Text("yes".tr),
      ),
    );
  }
}
