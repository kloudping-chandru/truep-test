import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foodizm_subscription/colors.dart';
import 'package:foodizm_subscription/common/CommonController.dart';
import 'package:foodizm_subscription/screens/bottom_navigation_screens/bottom_home_screen.dart';
import 'package:foodizm_subscription/screens/bottom_navigation_screens/bottom_products_screen.dart';
import 'package:foodizm_subscription/screens/bottom_navigation_screens/bottom_profile_screen.dart';
import 'package:foodizm_subscription/screens/bottom_navigation_screens/bottom_wallet_screen.dart';
import 'package:foodizm_subscription/screens/wallet_screen.dart';
import 'package:foodizm_subscription/utils/utils.dart';
import 'package:get/get.dart';

import '../common/common.dart';
import 'my_basket_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Utils utils = Utils();

  RxInt bottomIndex = 0.obs;
  //CommonController commonController = CommonController();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.whiteColor,
          systemOverlayStyle:
              const SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
          elevation: 0,
          centerTitle: false,

          // leading: IconButton(
          //   onPressed: () {},
          //   icon: const Icon(Icons.menu, color: AppColors.blackColor, size: 30),
          // ),
          title: utils.poppinsSemiBoldText(
              'trupressed'.tr, 18.0, AppColors.lightGrey2Color, TextAlign.start),
          actions: [
            IconButton(
              onPressed: () {
              },
              icon: const Icon(Icons.notifications_none_outlined,
                  color: AppColors.blackColor, size: 30),
            ),
            InkWell(
              onTap: ()
              {
                    Get.to(() => const MyBasketScreen());
                    print('OrdersLengthList:${ Common.orderData.length.toString()}');

                    print('OrdersLength:${ CommonController.cartValue!.value.toString()}');
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Obx(() => Badge(
                      backgroundColor: AppColors.primaryColor,
                      label: Text(CommonController.cartValue!.value.toString(),style: const TextStyle(fontSize: 12,color: Colors.black,fontWeight: FontWeight.bold),),
                      // child: SvgPicture.asset('assets/images/cart.svg', height: 50, width: 50),
                      child: const Icon(Icons.shopping_basket_outlined,
                      color: AppColors.blackColor, size: 30)
                  )),
                ),
              ),
            ),

            // IconButton(
            //   onPressed: () {
            //     Get.to(() => const MyBasketScreen());
            //   },
            //   icon: const Icon(Icons.shopping_basket_outlined,
            //       color: AppColors.blackColor, size: 30),
            // ),
          ],
        ),
        bottomNavigationBar: bottomNavigationWidget(),
        body:
        WillPopScope(
            onWillPop: () async {
              Get.defaultDialog(
                  title: "confirmation".tr,
                  content: Column(
                    children: [
                      Text(
                        "Do you want exit the app".tr,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 15,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          TextButton(
                            onPressed: () async {
                              Get.back();
                            },
                            child: Container(
                                padding: EdgeInsets.only(top: 5,bottom:5,left: 10,right: 10 ),
                                decoration: utils.rectangleBox(20.0, Colors.white),
                                child: Text("No")),
                            style: TextButton.styleFrom(primary: Colors.green),
                          ),
                          TextButton(
                            onPressed: () async {
                              SystemNavigator.pop();
                            },
                            child: Container(
                                padding: EdgeInsets.only(top: 5,bottom:5,left: 10,right: 10 ),
                                decoration: utils.rectangleBox(20.0, Colors.white),
                                child: Text("Yes")),
                            style: TextButton.styleFrom(primary: Colors.red),
                          ),
                        ],
                      ),
                    ],
                  )

                // cancel: Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     IconButton(
                //       onPressed: () {
                //         Get.back();
                //       },
                //       icon: Icon(Icons.close),  // Custom icon for the "No" button
                //       color: AppColors.PrimaryColor,
                //     ),
                //     TextButton(
                //       onPressed: () {
                //         Get.back();
                //       },
                //       child: Text("No".tr),
                //       style: TextButton.styleFrom(primary: AppColors.PrimaryColor),
                //     ),
                //   ],
                // ),
                //confirm:

              );
              // Handle back button press here
              // You can return true to allow the back navigation or false to prevent it.
              // For example, you might want to show a confirmation dialog.

              // Return true to allow back navigation
              return false;
            },
            child:  SafeArea(child: changeBottomPage()),
        // body: SafeArea(child: changeBottomPage()),
      )
      );
    });
  }
  Widget bottomNavigationWidget() {
    return Container(
      padding: const EdgeInsets.only(bottom: 10.0, top: 10.0),
      height: 70.0,
      child: Row(
        children: [
          Expanded(child: bottomBarWidget(0, Icons.home, "Home")),
          Expanded(
              child: bottomBarWidget(1, Icons.storefront_outlined, "Product")),
          Expanded(
              child: bottomBarWidget(
                  2, Icons.account_balance_wallet_outlined, "Wallet")),
          Expanded(child: bottomBarWidget(3, CupertinoIcons.person, "Profile")),
        ],
      ),
    );
  }

  Widget bottomBarWidget(int index, icon, text) {
    return InkWell(
      onTap: () => bottomIndex.value = index,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon,
              color: bottomIndex.value == index
                  ? AppColors.primaryColor
                  : AppColors.lightGreyColor,
              size: 25),
          utils.poppinsMediumText(
              text,
              15.0,
              bottomIndex.value == index
                  ? AppColors.primaryColor
                  : AppColors.lightGreyColor,
              TextAlign.center)
        ],
      ),
    );
  }
  Widget changeBottomPage() {
        switch (bottomIndex.value) {
      case 0:
        return const BottomHomeScreen();
      case 1:
        return const BottomProductsScreen();
      case 2:
        return const WalletScreen();
      case 3:
        return const BottomProfileScreen();
      default:
        return const BottomHomeScreen();
    }
  }
}
