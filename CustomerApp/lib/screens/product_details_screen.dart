import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:foodizm_subscription/colors.dart';
import 'package:foodizm_subscription/common/common.dart';
import 'package:foodizm_subscription/models/product_model.dart';
import 'package:foodizm_subscription/utils/utils.dart';
import 'package:foodizm_subscription/widgets/set_repeating_order_widget.dart';
import 'package:get/get.dart';

import '../widgets/set_repeating_order_once_widget.dart';

class ProductDetailsScreen extends StatefulWidget {
  final ProductModel? productModel;
  const ProductDetailsScreen({Key? key, this.productModel}) : super(key: key);

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  dynamic arguments;
  String? name;
  String? description;
  String? image;
  String? price;
  Utils utils = Utils();

  @override
  void initState() {
    //arguments = Get.arguments;
    name = widget.productModel!.title;
    description = widget.productModel!.details;
    image = widget.productModel!.image;
    price = widget.productModel!.price!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGrey4Color,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const BackButton(color: Colors.black),
                Container(
                  height: 200,
                  width: Get.width,
                  padding: const EdgeInsets.all(12.0),
                  child: ClipRRect(
                    child: image != null
                        ? CachedNetworkImage(
                            fit: BoxFit.fill,
                            imageUrl: image!,
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
                // Image.asset(
                //   image!,
                //   height: 150,
                //   width: Get.width,
                // ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      utils.poppinsMediumText("Trupressed", 16.0,
                          AppColors.lightGrey2Color, TextAlign.start),
                      utils.poppinsMediumText(
                          name, 18.0, AppColors.blackColor, TextAlign.start),
                      // utils.poppinsMediumText("500 ML", 14.0, AppColors.lightGreyColor, TextAlign.start),
                      // Container(
                      //   width: 300,
                      //   child:utils.poppinsMediumText(description, 14.0, AppColors.lightGreyColor, TextAlign.start)
                      // ),
                      utils.poppinsMediumText("${Common.currency} $price", 18.0,
                          AppColors.blackColor, TextAlign.start),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Card(
                color: AppColors.whiteColor,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              utils.poppinsSemiBoldText("description".tr, 18.0,
                                  AppColors.blackColor, TextAlign.start),
                              const SizedBox(height: 10),
                              utils.poppinsMediumText(
                                description,
                                14.0,
                                AppColors.blackColor,
                                TextAlign.start,
                              ),
                            ],
                          ),
                        ),
                      ),

                      // const SizedBox(
                      //   height: 105,
                      //   child: Column(
                      //     children: [
                      //       Row(
                      //         mainAxisSize: MainAxisSize.min,
                      //         children: [
                      //           Text(
                      //             '•',
                      //             style: TextStyle(fontSize: 30),
                      //           ),
                      //           SizedBox(width: 10),
                      //           Text(
                      //             'Vitamin A: contain 100g of it',
                      //             style: TextStyle(fontSize: 13),
                      //           ),
                      //         ],
                      //       ),
                      //       Row(
                      //         mainAxisSize: MainAxisSize.min,
                      //         children: [
                      //           Text(
                      //             '•',
                      //             style: TextStyle(fontSize: 30),
                      //           ),
                      //           SizedBox(width: 10),
                      //           Text(
                      //             'Vitamin A: contain 100g of it',
                      //             style: TextStyle(fontSize: 13),
                      //           ),
                      //         ],
                      //       ),
                      //       Row(
                      //         mainAxisSize: MainAxisSize.min,
                      //         children: [
                      //           Text(
                      //             '•',
                      //             style: TextStyle(fontSize: 30),
                      //           ),
                      //           SizedBox(width: 10),
                      //           Text(
                      //             'Vitamin A: contain 100g of it',
                      //             style: TextStyle(fontSize: 13),
                      //           ),
                      //         ],
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      renderErrorText(),
                      InkWell(
                        onTap: () {
                                //print(widget.productModel!.productQuantity!.toString());
                                double.parse(widget
                                            .productModel!.productQuantity!
                                            .toString()) >
                                        10.0
                                    ? Get.bottomSheet(
                                        SizedBox(
                                            height: 530,
                                            child: SetRepeatingOrderWidget(
                                                productModel:
                                                    widget.productModel!)),
                                        backgroundColor: AppColors.whiteColor,
                                        isScrollControlled: true,
                                        enableDrag: false,
                                        isDismissible: false,
                                      )
                                    : utils
                                        .showToast('Product is out of Stock');
                              },
                        child: Container(
                          height: 45,
                          margin: const EdgeInsets.only(top: 20),
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius:
                                BorderRadius.all(Radius.circular(30.0)),
                          ),
                          child: Center(
                              child: utils.poppinsMediumText(
                                  'placeRepeatingOrder'.tr,
                                  16.0,
                                  AppColors.whiteColor,
                                  TextAlign.center)),
                        ),
                      ),

                      // InkWell(
                      //   onTap: () {
                      //     //print(widget.productModel!.productQuantity!.toString());
                      //     double.parse(widget.productModel!.productQuantity!.toString()) > 10.0 ?
                      //     Get.bottomSheet(
                      //       SizedBox(height: 530,
                      //           child: SetRepeatingOrderOnceWidget(productModel: widget.productModel!)),
                      //       backgroundColor: AppColors.whiteColor,
                      //       isScrollControlled: true,
                      //       enableDrag: false,
                      //       isDismissible: false,
                      //     ): utils.showToast('Product is out of Stock');
                      //   },
                      //   child: Container(
                      //     height: 45,
                      //     margin: const EdgeInsets.only(top: 20),
                      //     padding: const EdgeInsets.symmetric(horizontal: 10),
                      //     decoration: const BoxDecoration(
                      //       color: AppColors.primaryColor,
                      //       borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      //     ),
                      //     child: Center(child: utils.poppinsMediumText('Place Order for Once', 16.0, AppColors.whiteColor, TextAlign.center)),
                      //   ),
                      // ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget renderErrorText() {
    if (num.parse(Common.wallet.value) < Common.minimumRequiredWalletBalance) {
      return Container(
        margin: const EdgeInsets.only(top: 10),
        child: utils.poppinsSemiBoldText(
            "Your wallet balance is below INR ${Common.minimumRequiredWalletBalance.toStringAsFixed(2)}. Please recharge your wallet to enjoy uninterrupted service.",
            12.0,
            AppColors.redColor,
            TextAlign.start),
      );
    } else if (num.parse(Common.wallet.value) < num.parse(price ?? "0")) {
      return Container(
        margin: const EdgeInsets.only(top: 10),
        child: utils.poppinsSemiBoldText(
            "Your wallet balance is lower than the order value. Please recharge your wallet to place the order.",
            12.0,
            AppColors.redColor,
            TextAlign.start),
      );
    }
    return SizedBox.shrink();
  }
}
