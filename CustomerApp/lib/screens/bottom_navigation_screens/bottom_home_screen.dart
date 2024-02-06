import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodizm_subscription/colors.dart';
import 'package:foodizm_subscription/common/common.dart';
import 'package:foodizm_subscription/models/bannerImages.dart';
import 'package:foodizm_subscription/models/categories_model.dart';
import 'package:foodizm_subscription/screens/edit_subscription_tab_bar/regular_subscription.dart';
import 'package:foodizm_subscription/screens/my_basket_screen.dart';
import 'package:foodizm_subscription/screens/pause_deliveries.dart';
import 'package:foodizm_subscription/screens/wallet_screen.dart';
import 'package:foodizm_subscription/utils/utils.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../models/order_days_model.dart';
import '../../models/order_model.dart';
import '../category_item_screen.dart';
import '../edit_subscription.dart';
import '../previous_order_history.dart';

class BottomHomeScreen extends StatefulWidget {
  const BottomHomeScreen({Key? key}) : super(key: key);

  @override
  State<BottomHomeScreen> createState() => _BottomHomeScreenState();
}

class _BottomHomeScreenState extends State<BottomHomeScreen> {
  Utils utils = Utils();
  RxBool hasCategories = false.obs;
  var databaseReference = FirebaseDatabase.instance.ref();
  RxBool hasAllOrders = false.obs;
  List<BannerImages> bannerImagesList = <BannerImages>[].obs;

  RxList<String> sliderImages = <String>[].obs;
  RxBool hasImage = false.obs;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
    Common.getAllOrders.clear();
    getAllOrders();
    getBannerImages();
    // print(Common.orderData.length);
  }

  getData() {
    hasCategories.value = false;
    showCategories();
  }

  getBannerImages() {
    databaseReference.child('BannerImages').get().then((value) {
      if (value.value != null) {
        for (var item in value.children) {
          Map<dynamic, dynamic> mapdata = item.value as Map;
          BannerImages bannerImages = BannerImages.fromJson(Map.from(mapdata));
          bannerImagesList.add(bannerImages);
          sliderImages.add(bannerImages.image.toString());
          // print('sliderImage:$sliderImages');
        }
        hasImage.value = true;
      }
    });
  }

  showCategories() async {
    Common.categoriesList.clear();
    Query query = databaseReference
        .child('Categories')
        .orderByChild('viewsCount')
        .limitToLast(4);
    await query.once().then((DatabaseEvent event) {
      if (event.snapshot.value != null) {
        Map<String, dynamic> mapOfMaps = Map.from(event.snapshot.value as Map);
        mapOfMaps.values.forEach((value) {
          Common.categoriesList.add(CategoriesModel.fromJson(Map.from(value)));
        });
      }
      hasCategories.value = true;
    });
  }

  Future getAllOrders() async {
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

        if ((orderModel.status == 'accepted' || orderModel.status == 'pause') &&
            splitOrderDate.compareTo(todayDateInFormat) > 0) {
          Common.getAllOrders.add(orderModel);

          databaseReference
              .child('Orders')
              .child(event.snapshot.key.toString())
              .child('Days')
              .get()
              .then((value) {
            // if (value.value != null) {
            //   for (var item in value.children) {
            //     OrderDaysModel orderDaysModel = OrderDaysModel.fromJson(Map.from(item.value as Map));
            //     Common.orderDaysData.add(orderDaysModel);
            //   }
            // } else {
            //   print('Null Data');
            // }
          });
        }
      }
      hasAllOrders.value = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if ((num.parse(Common.wallet.value) <
              Common.minimumRequiredWalletBalance))
            InkWell(
              onTap: () {
                Common.bottomIndex.value = 2;
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                    horizontal: 15.0, vertical: 20.0),
                margin: const EdgeInsets.symmetric(
                    horizontal: 15.0, vertical: 10.0),
                decoration: utils.boxDecoration(
                    Colors.white, Colors.transparent, 15.0, 0.0,
                    isShadow: true, shadowColor: AppColors.greyColor),
                child: utils.poppinsSemiBoldText(
                    "Your wallet balance is below INR ${Common.minimumRequiredWalletBalance.toStringAsFixed(2)}. Please recharge your wallet to enjoy uninterrupted service.",
                    12.0,
                    AppColors.redColor,
                    TextAlign.start),
              ),
            ),
          const SizedBox(height: 20),

          Obx(
            () => hasImage.value == true
                ? CarouselSlider(
                    options: CarouselOptions(
                        aspectRatio: 20 / 10, enlargeCenterPage: true),
                    items: sliderImages.map((i) {
                      return Builder(
                        builder: (BuildContext context) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: CachedNetworkImage(
                              imageUrl: i.toString(),
                              width: MediaQuery.of(context).size.width,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                height: 25,
                                width: 25,
                                alignment: Alignment.center,
                                child: const CircularProgressIndicator(
                                    backgroundColor: AppColors.primaryColor),
                              ),
                              errorWidget: (context, url, error) => Image.asset(
                                  "assets/images/placeholder_image.png",
                                  fit: BoxFit.cover),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  )
                : Container(
                    height: 200,
                  ),
          ),

          // const SizedBox(height: 30),
          // Container(
          //   padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
          //   margin: const EdgeInsets.symmetric(horizontal: 15.0),
          //   decoration: utils.boxDecoration(Colors.white, Colors.transparent, 15.0, 0.0, isShadow: true, shadowColor: AppColors.greyColor),
          //   child: Row(
          //     children: [
          //       Image.network("https://cdn-icons-png.flaticon.com/128/819/819781.png", height: 70, width: 70),
          //       const SizedBox(width: 10),
          //       Expanded(
          //         child: Obx(()=>
          //             Column(
          //           crossAxisAlignment: CrossAxisAlignment.start,
          //           children: [
          //             utils.poppinsMediumText(hasAllOrders.value == true? Common.getAllOrders.length.toString(): '0', 30.0, AppColors.blackColor, TextAlign.start),
          //             utils.poppinsMediumText("Items in your basket", 16.0, AppColors.blackColor, TextAlign.start),
          //             utils.poppinsMediumText("Monday, 22 May 2023", 14.0, AppColors.lightGreyColor, TextAlign.start),
          //           ],
          //         ),)
          //       )
          //     ],
          //   ),
          // ),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: utils.poppinsSemiBoldText('topCategories'.tr, 20.0,
                AppColors.blackColor, TextAlign.start),
          ),
          Obx(() {
            if (hasCategories.value) {
              if (Common.categoriesList.length > 0) {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (int i = 0; i < Common.categoriesList.length; i++)
                        buildCategories(Common.categoriesList[i]),
                    ],
                  ),
                );
              } else {
                return utils.noDataWidget('noCategoriesFound'.tr, 150.0);
              }
            } else {
              return Container(
                height: 150,
                child: Center(
                    child: CircularProgressIndicator(
                        backgroundColor: AppColors.primaryColor,
                        color: AppColors.whiteColor)),
              );
            }
          }),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: utils.poppinsSemiBoldText(
                'quickActions'.tr, 20.0, AppColors.blackColor, TextAlign.start),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Container(
              height: 150,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  // InkWell(
                  //     onTap: () {
                  //     //  Get.to(() =>  PreviousOrderHistory());
                  //     },
                  //     child: quickActionWidget(Colors.brown.withOpacity(0.6), "Previous", "Order History", icon: Icons.work_history_sharp)
                  // ),
                  // const SizedBox(width: 10),
                  InkWell(
                      onTap: () {
                        Get.to(const PauseDeliveries());
                      },
                      child: quickActionWidget(
                          Colors.deepOrange.withOpacity(0.6),
                          "Pause",
                          "Deliveries",
                          icon: Icons.pause_circle_rounded)),
                  const SizedBox(width: 10),
                  InkWell(
                      onTap: () {
                        //Get.to(EditSubscription());
                        Get.to(RegularSubscription());
                      },
                      child: quickActionWidget(
                          Colors.blueAccent.withOpacity(0.6),
                          "Edit",
                          "Subscriptions",
                          icon: CupertinoIcons.pencil_ellipsis_rectangle)),
                  const SizedBox(width: 10),
                  InkWell(
                    onTap: () {
                      Common.bottomIndex.value = 2;
                    },
                    child: quickActionWidget(Colors.green.withOpacity(0.6),
                        "Recharge", "Your Wallet",
                        price: "${Common.currency} ${Common.wallet}"),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 30),
          // Padding(
          //   padding: const EdgeInsets.only(left: 15.0),
          //   child: RichText(
          //     text: TextSpan(
          //       text: 'clickHereToView'.tr,
          //       style: const TextStyle(color: AppColors.blackColor, fontSize: 14, fontFamily: "Poppins"),
          //       children: [
          //         TextSpan(
          //           text: ' ${'orderStatement'.tr}',
          //           style: const TextStyle(color: AppColors.blueColor, fontSize: 14, fontFamily: "Poppins"),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          // const SizedBox(height: 20),
          // Padding(
          //   padding: const EdgeInsets.only(left: 15.0),
          //   child: RichText(
          //     text: TextSpan(
          //       text: 'clickToWatch'.tr,
          //       style: const TextStyle(color: AppColors.blackColor, fontSize: 14, fontFamily: "Poppins"),
          //       children: [
          //         TextSpan(
          //           text: ' ${'youtube'.tr} ',
          //           style: const TextStyle(color: AppColors.blueColor, fontSize: 14, fontFamily: "Poppins"),
          //         ),
          //         TextSpan(
          //           text: 'tutorial'.tr,
          //           style: const TextStyle(color: AppColors.blackColor, fontSize: 14, fontFamily: "Poppins"),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  buildCategories(CategoriesModel categoriesModel) {
    return InkWell(
      onTap: () {
        Get.to(() => CategoryItemScreen(
            categoriesModel: categoriesModel, title: categoriesModel.title));
      },
      child: Container(
        height: 155,
        width: 140,
        margin: const EdgeInsets.only(right: 10),
        child: Stack(
          children: [
            Column(
              children: [
                const Expanded(flex: 2, child: SizedBox()),
                Expanded(
                  flex: 4,
                  child: Card(
                    color: HexColor(categoriesModel.colorCode!),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        const Expanded(flex: 3, child: SizedBox()),
                        Expanded(
                          flex: 7,
                          child: Center(
                            child: utils.poppinsMediumText(
                                categoriesModel.title!,
                                14.0,
                                AppColors.whiteColor,
                                TextAlign.center,
                                maxlines: 2),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: 105,
                width: 105,
                padding: const EdgeInsets.all(12.0),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(50)),
                  child: categoriesModel.image != null
                      ? CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl: categoriesModel.image!,
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
          ],
        ),
      ),
    );
  }

  quickActionWidget(color, text, subtitle, {icon, price}) {
    return Container(
      height: 170.0,
      width: 130,
      decoration: utils.boxDecoration(color, Colors.transparent, 15.0, 0.0),
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: icon != null
                ? Icon(icon, size: 40, color: AppColors.whiteColor)
                : Center(
                    child: utils.poppinsSemiBoldText(
                        price, 20.0, AppColors.whiteColor, TextAlign.center)),
          ),
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                utils.poppinsMediumText(
                    text, 15.0, AppColors.whiteColor, TextAlign.center),
                utils.poppinsRegularText(
                    subtitle, 15.0, AppColors.whiteColor, TextAlign.center),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
