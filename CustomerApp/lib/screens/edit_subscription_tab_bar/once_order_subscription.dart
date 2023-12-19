import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../colors.dart';
import '../../common/common.dart';
import '../../models/order_model.dart';
import '../../models/product_model.dart';
import '../../utils/utils.dart';
import '../../widgets/set_repeating_order_once_widget.dart';

class OnceOrderSubscription extends StatefulWidget {
  const OnceOrderSubscription({Key? key}) : super(key: key);

  @override
  State<OnceOrderSubscription> createState() => _OnceOrderSubscriptionState();
}

class _OnceOrderSubscriptionState extends State<OnceOrderSubscription> {
  Utils utils = Utils();
  var databaseReference = FirebaseDatabase.instance.ref();
  RxBool hasOrders = false.obs;
  ProductModel productModel = ProductModel();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // your code here
      getOrdersOnce();
    });
  }

  Future getOrdersOnce() async {
    Common.editOrderDataWithOnce.clear();
   await databaseReference.child("OnceOrders").orderByChild('uid').equalTo(utils.getUserId()).onChildAdded.listen((event) {
      if (event.snapshot.value != null) {
        OrderModel orderModel = OrderModel.fromJson(Map.from(event.snapshot.value as Map));
        String dateFormat = DateFormat("yyyy-MM-dd").format(DateTime.parse(orderModel.endingDate!));
        DateTime splitOrderDate = DateTime.parse(dateFormat);

        String todayDate = DateFormat("yyyy-MM-dd").format(DateTime.now());
        DateTime todayDateInFormat = DateTime.parse(todayDate);

        if (orderModel.status == 'requested' && splitOrderDate.compareTo(todayDateInFormat) > 0) {
          Common.editOrderDataWithOnce.add(orderModel);
        }
      }
      print('length:${Common.editOrderDataWithOnce.length}');
      hasOrders.value = true;
    });

  }
  @override
  Widget build(BuildContext context) {
  //  return Container(child: Text('Hello'));
    return Obx(() =>
    hasOrders.value == true ? Common.editOrderDataWithOnce.isNotEmpty?
    SingleChildScrollView(
      child:
      Column(
        children: [
          for (int i = 0; i < Common.editOrderDataWithOnce.length; i++)
            Container(
              margin: EdgeInsets.only(top: 10),
              padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
              decoration: utils.boxDecoration(Colors.white, Colors.transparent, 15.0, 0.0,
                  isShadow: true, shadowColor: Colors.grey.shade200),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            utils.poppinsMediumText("trupressed".tr, 16.0, AppColors.lightGrey2Color, TextAlign.start),
                            utils.poppinsMediumText(
                                Common.editOrderDataWithOnce[i].items![0]!["title"], 18.0, AppColors.blackColor, TextAlign.start),
                            // utils.poppinsMediumText("500 ML", 14.0, AppColors.lightGreyColor, TextAlign.start),
                            Container(
                              width: 300,
                              child: utils.poppinsMediumText(
                                  Common.editOrderDataWithOnce[i].items![0]!["details"], 14.0, AppColors.lightGreyColor,
                                  TextAlign.start, maxlines: 2),
                            ),

                            utils.poppinsMediumText(
                                "${Common.currency} ${ Common.editOrderDataWithOnce[i].items![0]!["newPrice"]}", 18.0,
                                AppColors.blackColor, TextAlign.start),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        height: 100,
                        width: 100,
                        padding: const EdgeInsets.all(12.0),
                        child: ClipRRect(
                          child: Common.editOrderDataWithOnce[i].items![0]!["image"].isNotEmpty
                              ? CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl: Common.editOrderDataWithOnce[i].items![0]!["image"],
                            progressIndicatorBuilder: (context, url, downloadProgress) =>
                                SizedBox(
                                  height: 50,
                                  width: 50,
                                  child: Center(child: CircularProgressIndicator(value: downloadProgress.progress)),
                                ),
                            errorWidget: (context, url, error) =>
                                Image.asset('assets/images/placeholder_image.png', fit: BoxFit.cover),
                          )
                              : Image.asset('assets/images/placeholder_image.png', fit: BoxFit.cover),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  InkWell(
                    onTap: () {
                      utils.showLoadingDialog();
                      //print('itemId${Common.editOrderDataWithOnce[i].itemId!.toString()}');
                      getProductDetails(Common.editOrderDataWithOnce[i].itemId!, Common.editOrderDataWithOnce[i]);
                    },
                    child: Container(
                      height: 45,
                      margin: const EdgeInsets.only(top: 20),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      ),
                      child: Center(child: utils.poppinsMediumText('Edit Order', 16.0, AppColors.whiteColor, TextAlign.center)),
                    ),
                  ),
                  //showQuantity( Common.orderData[i]),
                ],
              ),
            )
        ],
      ),
    ) : Center(
      child: utils.helveticaSemiBoldText('No Orders Found', 22.0, Colors.black, TextAlign.center),
    ):
    Center(
        child: Container(
          height: 200,
          child: const Center(
              child: CircularProgressIndicator(backgroundColor: AppColors.primaryColor, color: AppColors.whiteColor)),
        )),
    );
  }

  getProductDetails(String itemId, OrderModel orderModel) async
  {
    Query query = await databaseReference.child('Items').orderByChild('timeCreated').equalTo(itemId);
    query.once().then((value) {
      if (value.snapshot.value != null) {
        Get.back();
        for (var item in value.snapshot.children) {
          Map<dynamic, dynamic>mapData = item.value as Map<dynamic, dynamic>;
          productModel = ProductModel.fromJson(Map.from(mapData));
          print('timeCreatedRegular:${productModel.title}');
        }
        Get.bottomSheet(
          SizedBox(height: 530,
              child: SetRepeatingOrderOnceWidget(productModel: productModel, orderModel: orderModel)),
          backgroundColor: AppColors.whiteColor,
          isScrollControlled: true,
          enableDrag: false,
          isDismissible: false,
        );
      }
      else {
        print('Not Available');
      }
    });
  }
}
