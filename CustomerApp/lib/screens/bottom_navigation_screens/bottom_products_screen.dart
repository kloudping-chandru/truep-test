import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:foodizm_subscription/colors.dart';
import 'package:foodizm_subscription/common/common.dart';
import 'package:foodizm_subscription/models/categories_model.dart';
import 'package:foodizm_subscription/models/product_model.dart';
import 'package:foodizm_subscription/screens/product_details_screen.dart';
import 'package:foodizm_subscription/utils/utils.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../models/order_days_model.dart';
import '../../models/order_model.dart';
import '../../widgets/set_repeating_order_once_widget.dart';

class BottomProductsScreen extends StatefulWidget {
  const BottomProductsScreen({Key? key}) : super(key: key);

  @override
  State<BottomProductsScreen> createState() => _BottomProductsScreenState();
}

class _BottomProductsScreenState extends State<BottomProductsScreen> {
  Utils utils = Utils();
  var databaseReference = FirebaseDatabase.instance.ref();
  RxString selectedCategory = "".obs;
  RxBool hasPopular = false.obs;
  int selectedIndex = 0;
  String? categoryId;
  RxList<ProductModel> productList = <ProductModel>[].obs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    productList.clear();
    getDataAccordingCategories(Common.categoriesList[0].timeCreated.toString());
    // getData();
    // selectedCategory.value = categoriesModel.first.title!;
  }

  // getData()
  // {
  //   hasPopular.value = false;
  //   showPopularItems();
  // }
  // showPopularItems() async {
  //   Common.popularProductList.clear();
  //   Query query = databaseReference.child('Items').orderByChild('viewsCount');
  //   await query.once().then((DatabaseEvent event) {
  //     if (event.snapshot.value != null) {
  //       Map<String, dynamic> mapOfMaps = Map.from(event.snapshot.value as Map);
  //       mapOfMaps.values.forEach((value) {
  //         Common.popularProductList.add(ProductModel.fromJson(Map.from(value)));
  //       });
  //     }
  //     hasPopular.value = true;
  //   });
  // }
  getDataAccordingCategories(String categoryid) {
    Query query;
    query = databaseReference
        .child('Items')
        .orderByChild('categoryId')
        .equalTo(categoryid);
    query.once().then((DatabaseEvent event) {
      if (event.snapshot.value != null) {
        Map<String, dynamic> mapOfMaps = Map.from(event.snapshot.value as Map);
        mapOfMaps.values.forEach((value) {
          productList.add(ProductModel.fromJson(Map.from(value)));
        });
      }
      hasPopular.value = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (hasPopular.value) {
          return Padding(
            padding: EdgeInsets.only(left: 10, right: 10, top: 10),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: 50,
                    child: ListView.builder(
                        itemCount: Common.categoriesList.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int index) {
                          bool isSelected = index == selectedIndex;
                          return InkWell(
                            onTap: () {
                              setState(() {
                                hasPopular.value = false;
                                productList.clear();
                                selectedIndex = index;
                                categoryId = Common
                                    .categoriesList[index].timeCreated
                                    .toString();
                                getDataAccordingCategories(categoryId!);
                                print('CatgoryId: $categoryId');
                              });
                            },
                            child: Container(
                                height: 50,
                                width: 150,
                                margin: EdgeInsets.only(right: 10),
                                padding: EdgeInsets.only(left: 10, right: 10),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30.0),
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.transparent,
                                ),
                                child: utils.poppinsMediumText(
                                    '${Common.categoriesList[index].title}',
                                    14.0,
                                    isSelected
                                        ? AppColors.primaryColor
                                        : Colors.grey,
                                    TextAlign.center)),
                          );
                        }),
                  ),
                  hasPopular.value == true
                      ? ListView.builder(
                          shrinkWrap: true,
                          itemCount: productList.length,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            if (productList.isNotEmpty) {
                              return productWidget(
                                  name: productList[index].title!,
                                  description: productList[index].details!,
                                  image: productList[index].image!,
                                  price: productList[index].price!,
                                  productModel: productList[index]);
                            } else {
                              return utils.noDataWidget(
                                  'noItemsFound'.tr, 200.0);
                            }
                          })
                      : Container(
                          height: 200,
                          child: Center(
                              child: CircularProgressIndicator(
                                  backgroundColor: AppColors.primaryColor,
                                  color: AppColors.whiteColor)),
                        )
                ],
              ),
            ),
          );
          // if (Common.popularProductList.isNotEmpty) {
          //   return
          //     SingleChildScrollView(
          //       scrollDirection: Axis.vertical,
          //       child:
          //       Column(
          //         children: [
          //           for (int i = 0; i < Common.popularProductList.length; i++)
          //             Container(
          //                 child: productWidget(name:Common.popularProductList[i].title!,description: Common.popularProductList[i].details!,image: Common.popularProductList[i].image!,price: Common.popularProductList[i].price!, productModel:Common.popularProductList[i] )
          //             )
          //           // ProductsWidget(productModel: Common.popularProductList[i], width: 200.0, origin: 'popular'),
          //         ],
          //       ),
          //     );
          // }
          // else {
          //   return utils.noDataWidget('noItemsFound'.tr, 200.0);
          // }
        } else {
          return Container(
            height: 200,
            child: Center(
                child: CircularProgressIndicator(
                    backgroundColor: AppColors.primaryColor,
                    color: AppColors.whiteColor)),
          );
        }
      }),
    );
  }

  Widget productWidget(
      {required String name,
      required String description,
      required String image,
      required String price,
      required ProductModel productModel}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
      margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      decoration: utils.boxDecoration(
          Colors.white, Colors.transparent, 15.0, 0.0,
          isShadow: true, shadowColor: AppColors.greyColor),
      child: InkWell(
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  height: 100,
                  width: 100,
                  padding: const EdgeInsets.all(12.0),
                  child: ClipRRect(
                    child: image.isNotEmpty
                        ? CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl: image,
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
                // Image.network(
                //   "https://i.pinimg.com/736x/3d/f0/08/3df00837ee2dcd3e05da01509bdbe55c.jpg",
                //   height: 100,
                //   width: 100,
                // ),
                // Image.asset(
                //   image,
                //   height: 100,
                //   width: 100,
                // ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      utils.poppinsMediumText("Trupressed", 16.0,
                          AppColors.lightGrey2Color, TextAlign.start),
                      // utils.poppinsMediumText("A2 Desi Cow Milk", 18.0,
                      //     AppColors.blackColor, TextAlign.start),
                      utils.poppinsMediumText(
                          name, 18.0, AppColors.blackColor, TextAlign.start),
                      // utils.poppinsMediumText("500 ML", 14.0,
                      //     AppColors.lightGreyColor, TextAlign.start),
                      Container(
                          width: 200,
                          child: utils.poppinsMediumText(description, 14.0,
                              AppColors.lightGreyColor, TextAlign.start,
                              maxlines: 2)),
                      utils.poppinsMediumText("${Common.currency} $price", 18.0,
                          AppColors.blackColor, TextAlign.start),
                    ],
                  ),
                ),
              ],
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.end,
            //   children: [
            //     // Container(
            //     //   padding: const EdgeInsets.symmetric(
            //     //       horizontal: 20.0, vertical: 7.0),
            //     //   decoration: utils.boxDecoration(
            //     //       Colors.transparent, AppColors.blackColor, 20.0, 0.0),
            //     //   child: Center(
            //     //       child: utils.poppinsRegularText("add".tr, 16.0,
            //     //           AppColors.blackColor, TextAlign.center)),
            //     // ),
            //     Container(
            //       width: 250,
            //       padding: const EdgeInsets.symmetric(
            //           horizontal: 20.0, vertical: 7.0),
            //       margin: const EdgeInsets.symmetric(
            //           horizontal: 10.0, vertical: 10.0),
            //       decoration: utils.boxDecoration(
            //           AppColors.primaryColor, Colors.transparent, 20.0, 0.0),
            //       child: Center(
            //           child: utils.poppinsMediumText('subscribe'.tr, 16.0,
            //               AppColors.whiteColor, TextAlign.center)),
            //     ),
            //   ],
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      double.parse(productModel.productQuantity!.toString()) >
                              10.0
                          ? Get.bottomSheet(
                              SizedBox(
                                  height: 530,
                                  child: SetRepeatingOrderOnceWidget(
                                      productModel: productModel)),
                              backgroundColor: AppColors.whiteColor,
                              isScrollControlled: true,
                              enableDrag: false,
                              isDismissible: false,
                            )
                          : utils.showToast('Product is out of Stock');
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 7.0),
                      margin: const EdgeInsets.symmetric(),
                      decoration: utils.boxDecoration(AppColors.primaryColor,
                          Colors.transparent, 20.0, 0.0),
                      child: Center(
                          child: utils.poppinsMediumText('Once Order', 16.0,
                              AppColors.whiteColor, TextAlign.center)),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: InkWell(
                    onTap: () => Get.to(
                        ProductDetailsScreen(productModel: productModel)),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 7.0),
                      margin: const EdgeInsets.symmetric(vertical: 10.0),
                      decoration: utils.boxDecoration(AppColors.primaryColor,
                          Colors.transparent, 20.0, 0.0),
                      child: Center(
                          child: utils.poppinsMediumText('subscribe'.tr, 16.0,
                              AppColors.whiteColor, TextAlign.center)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
    //   InkWell(
    //   onTap: () => Get.to(() => const ProductDetailsScreen(), arguments: {
    //     'name': name,
    //     'description': description,
    //     'image': image,
    //   }),
    //   child:
    //
    // );
  }
}
