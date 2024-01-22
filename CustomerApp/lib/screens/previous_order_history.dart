import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foodizm_subscription/models/product_model.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../colors.dart';
import '../common/common.dart';
import '../models/order_model.dart';
import '../utils/utils.dart';

class PreviousOrderHistory extends StatefulWidget {
  const PreviousOrderHistory({Key? key}) : super(key: key);

  @override
  State<PreviousOrderHistory> createState() => _PreviousOrderHistoryState();
}

class _PreviousOrderHistoryState extends State<PreviousOrderHistory> {
  Utils utils = Utils();
  String? image;

  var databaseReference = FirebaseDatabase.instance.ref();
  RxBool hasAllOrders = false.obs;
  RxList<OrderModel> orderHistoryList = <OrderModel>[].obs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getOrderHistory();
  }

  Future getOrderHistory() async {
    orderHistoryList.clear();

    Query querry = databaseReference
        .child('OrdersByPicture')
        .orderByChild('uid')
        .equalTo(utils.getUserId());
    querry.once().then((value) {
      if (value.snapshot.value != null) {
        Map<String, dynamic> mapOfMaps = Map.from(value.snapshot.value as Map);
        mapOfMaps.values.forEach((value) {
          orderHistoryList.add(OrderModel.fromJson(Map.from(value)));
        });
        // String dateFormat = DateFormat("yyyy-MM-dd").format(DateTime.parse(orderModel.endingDate!));
        // DateTime splitOrderDate = DateTime.parse(dateFormat);
        //
        // String todayDate = DateFormat("yyyy-MM-dd").format(DateTime.now());
        // DateTime todayDateInFormat = DateTime.parse(todayDate);

        for (int i = 0; i < orderHistoryList.length; i++) {
          print('OrderHistory:${orderHistoryList[i].uid}');
        }
        // if ((orderModel.status == 'delivered' || orderModel.status =='pause')) {
        //   orderHistory.add(orderModel);
        //
        //   // databaseReference.child('Orders').child(event.snapshot.key.toString()).child('Days').get().then((value) {
        //   //
        //   // });
        // }
      }
    });

    // databaseReference.child("OrdersByPicture").orderByChild('uid').equalTo(utils.getUserId()).onChildAdded.listen((event) {
    //   if (event.snapshot.value != null) {
    //
    //      OrderModel orderModel = OrderModel.fromJson(Map.from(event.snapshot.value as Map));
    //     // String dateFormat = DateFormat("yyyy-MM-dd").format(DateTime.parse(orderModel.endingDate!));
    //     // DateTime splitOrderDate = DateTime.parse(dateFormat);
    //     //
    //     // String todayDate = DateFormat("yyyy-MM-dd").format(DateTime.now());
    //     // DateTime todayDateInFormat = DateTime.parse(todayDate);
    //     orderHistoryList.add(orderModel);
    //
    //     for(int i =0; i< orderHistoryList.length;i++)
    //       {
    //         print('OrderHistory:${orderHistoryList[i].uid}');
    //       }
    //     // if ((orderModel.status == 'delivered' || orderModel.status =='pause')) {
    //     //   orderHistory.add(orderModel);
    //     //
    //     //   // databaseReference.child('Orders').child(event.snapshot.key.toString()).child('Days').get().then((value) {
    //     //   //
    //     //   // });
    //     // }
    //   }
    //
    // });

    hasAllOrders.value = true;
    print('hasAllOrders:${hasAllOrders.value}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        systemOverlayStyle:
            SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
        elevation: 0,
        leading: BackButton(color: Colors.black),
        title: utils.poppinsMediumText(
            'Order History', 18.0, AppColors.blackColor, TextAlign.center),
        centerTitle: true,
      ),
      body: Obx(() {
        if (hasAllOrders.value == true) {
          if (orderHistoryList.isNotEmpty) {
            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  for (int i = 0; i < orderHistoryList.length; i++)
                    Container(child: productWidget(orderHistoryList[i])
                        // child: Text('Hello'),
                        )
                  // ProductsWidget(productModel: Common.popularProductList[i], width: 200.0, origin: 'popular'),
                ],
              ),
            );
          } else {
            return utils.noDataWidget('No Orders History', 200.0);
          }
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

  Widget productWidget(OrderModel productModel) {
    DateTime? deliveredOn = (productModel.timeDelivered ?? "").isEmpty
        ? null
        : DateTime.fromMillisecondsSinceEpoch(
            int.parse(productModel.timeDelivered!));
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
      margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      decoration: utils.boxDecoration(
          Colors.white, Colors.transparent, 15.0, 0.0,
          isShadow: true, shadowColor: AppColors.greyColor),
      child: InkWell(
        // onTap:()=> Get.to( ProductDetailsScreen(productModel : productModel)),

        child: Column(
          children: [
            Row(
              children: [
                Container(
                  height: 100,
                  width: 100,
                  padding: const EdgeInsets.all(12.0),
                  child: ClipRRect(
                    child: (productModel.items?[0]?["image"] ?? "").isNotEmpty
                        ? CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl: productModel.items?[0]?["image"] ?? "",
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

                      utils.poppinsMediumText(
                          productModel.items?[0]?["title"] ?? "",
                          18.0,
                          AppColors.blackColor,
                          TextAlign.start),
                      utils.poppinsMediumText(
                          productModel.items?[0]?["details"] ?? "",
                          14.0,
                          AppColors.blackColor,
                          TextAlign.start),
                      utils.poppinsMediumText(
                          productModel.items?[0]?["type"] ?? "",
                          14.0,
                          AppColors.lightGreyColor,
                          TextAlign.start),

                      // utils.poppinsMediumText("Pouch", 14.0, AppColors.lightGreyColor, TextAlign.start),
                      utils.poppinsMediumText(
                          "${Common.currency} ${productModel.totalPrice ?? "0"}",
                          18.0,
                          AppColors.blackColor,
                          TextAlign.start),
                      
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(width: 10),
            if (deliveredOn != null)
                        utils.poppinsMediumText(
                            "Delivered ${DateFormat('dd/MM/yy hh:mm a').format(deliveredOn)}",
                            12.0,
                            AppColors.blackColor,
                            TextAlign.start),
          ],
        ),
      ),
    );
  }

  renderDeletebutton(OrderModel productModel) {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: utils.helveticaBoldText(
                'Alert!', 20.0, Colors.black, TextAlign.start),
            content: utils.helveticaMediumText(
                'Do you want to delete this Order.',
                18.0,
                Colors.black,
                TextAlign.start),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  utils.showLoadingDialog();
                  databaseReference
                      .child('OrdersByPicture')
                      .get()
                      .then((value) {
                    for (var item in value.children) {
                      Map<dynamic, dynamic> mapData =
                          item.value as Map<dynamic, dynamic>;
                      if (mapData['orderId'] == productModel.orderId &&
                          mapData['timeDelivered'] ==
                              productModel.timeDelivered) {
                        // print('right');
                        databaseReference
                            .child('OrdersByPicture')
                            .child(item.key!)
                            .remove()
                            .whenComplete(() {
                          utils
                              .showToast('Your Order has Deleted Successfully');
                          orderHistoryList.clear();
                          getOrderHistory();
                          Navigator.of(ctx).pop();
                          Get.back();
                        });
                      }
                    }
                  });
                  //  Navigator.of(ctx).pop();
                },
                child: Container(
                    color: Colors.red,
                    padding: const EdgeInsets.all(14),
                    child: utils.helveticaMediumText(
                        'Yes', 16.0, Colors.white, TextAlign.center)),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: Container(
                    color: Colors.green,
                    padding: const EdgeInsets.all(14),
                    child: utils.helveticaMediumText(
                        'No', 16.0, Colors.white, TextAlign.center)),
              ),
            ],
          ),
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            width: 250,
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 7.0),
            margin: const EdgeInsets.symmetric(horizontal: 10.0),
            decoration: utils.boxDecoration(
                AppColors.redColor, Colors.transparent, 20.0, 0.0),
            child: Center(
                child: utils.poppinsMediumText(
                    "Delete", 16.0, Colors.white, TextAlign.center)),
          ),
        ],
      ),
    );
  }
}
