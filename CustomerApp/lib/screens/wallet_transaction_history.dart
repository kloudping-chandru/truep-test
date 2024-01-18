import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foodizm_subscription/models/wallet_history_model.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../colors.dart';
import '../common/common.dart';
import '../models/order_model.dart';
import '../utils/utils.dart';

class WalletTransactionHistory extends StatefulWidget {
  const WalletTransactionHistory({Key? key}) : super(key: key);

  @override
  State<WalletTransactionHistory> createState() =>
      _WalletTransactionHistoryState();
}

class _WalletTransactionHistoryState extends State<WalletTransactionHistory> {
  Utils utils = Utils();
  String? image;

  var databaseReference = FirebaseDatabase.instance.ref();
  RxBool hasAllOrders = false.obs;
  RxList<WalletHistoryModel> walletHistoryList = <WalletHistoryModel>[].obs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getWalletHistory();
  }

  Future getWalletHistory() async {
    walletHistoryList.clear();

    Query querry = databaseReference
        .child('WalletHistory')
        .orderByChild('uid')
        .equalTo(utils.getUserId());
    querry.once().then((value) {
      if (value.snapshot.value != null) {
        Map<String, dynamic> mapOfMaps = Map.from(value.snapshot.value as Map);
        mapOfMaps.values.forEach((value) {
          walletHistoryList.add(WalletHistoryModel.fromJson(Map.from(value)));
        });
        walletHistoryList
            .sort((a, b) => (b.timeAdded ?? "0").compareTo(a.timeAdded ?? "0"));
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
        title: utils.poppinsMediumText('Transaction History', 18.0,
            AppColors.blackColor, TextAlign.center),
        centerTitle: true,
      ),
      body: Obx(() {
        if (hasAllOrders.value == true) {
          if (walletHistoryList.isNotEmpty) {
            return Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                renderWalletBalance(),
                Expanded(
                  child: ListView.separated(
                      itemBuilder: (context, index) =>
                          productWidget(walletHistoryList[index]),
                      separatorBuilder: (context, index) => Container(),
                      itemCount: walletHistoryList.length),
                ),
              ],
            );
            // return SingleChildScrollView(
            //   scrollDirection: Axis.vertical,
            //   child: Column(
            //     children: [
            //       for (int i = 0; i < walletHistoryList.length; i++)
            //         Container(child: productWidget(walletHistoryList[i])
            //             // child: Text('Hello'),
            //             )
            //       // ProductsWidget(productModel: Common.popularProductList[i], width: 200.0, origin: 'popular'),
            //     ],
            //   ),
            // );
          } else {
            return utils.noDataWidget('No Transaction History', 200.0);
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

  Widget renderWalletBalance() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
      margin: const EdgeInsets.symmetric(horizontal: 15.0),
      decoration: utils.boxDecoration(
          Colors.white, Colors.transparent, 15.0, 0.0,
          isShadow: true, shadowColor: AppColors.greyColor),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: utils.poppinsSemiBoldText("walletBalance".tr, 18.0,
                      AppColors.blackColor, TextAlign.start)),
              utils.poppinsSemiBoldText("${Common.currency} ${Common.wallet}",
                  18.0, AppColors.blackColor, TextAlign.end)
            ],
          ),
        ],
      ),
      // Row(
      //   children: [
      //     Expanded(child: utils.poppinsRegularText("tomorrowValue".tr, 14.0, AppColors.blackColor, TextAlign.start)),
      //     utils.poppinsRegularText("${Common.currency} 88.00", 14.0, AppColors.blackColor, TextAlign.end)
      //   ],
      // ),
    );
  }

  Widget productWidget(WalletHistoryModel transaction) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
      margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      decoration: utils.boxDecoration(
          Colors.white, Colors.transparent, 15.0, 0.0,
          isShadow: true, shadowColor: AppColors.greyColor),
      child: Row(
        children: [
          Expanded(flex: 6, child: renderDescription(transaction)),
          Expanded(flex: 4, child: renderAmount(transaction)),
          SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }

  renderDescription(WalletHistoryModel transaction) {
    DateTime timeAdded = DateTime.fromMillisecondsSinceEpoch(
        int.parse(transaction.timeAdded ?? "0"));
    if (transaction.amountAdded != null) {
      return Column(
        children: [
          utils.poppinsMediumText(
              "Added to Wallet", 14.0, AppColors.blackColor, TextAlign.start),
          utils.poppinsMediumText(
              "${DateFormat('dd/MM/yy hh:mm a').format(timeAdded)}",
              14.0,
              AppColors.blackColor,
              TextAlign.start),
        ],
      );
    }
    return Column(
      children: [
        Row(
          children: [
            Container(
              height: 80,
              width: 80,
              padding: const EdgeInsets.all(10.0),
              child: ClipRRect(
                child: (transaction.itemImage ?? "").isNotEmpty
                    ? CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl: transaction.itemImage ?? "",
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) => SizedBox(
                          height: 40,
                          width: 40,
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
            Expanded(
              child: Column(
                children: [
                  utils.poppinsMediumText(transaction.itemTitle, 14.0,
                      AppColors.blackColor, TextAlign.start,
                      maxlines: 2),
                  utils.poppinsMediumText(transaction.itemDetails, 12.0,
                      AppColors.blackColor, TextAlign.start),
                  utils.poppinsMediumText(transaction.itemType, 12.0,
                      AppColors.blackColor, TextAlign.start),
                ],
              ),
            )
          ],
        ),
        utils.poppinsMediumText(
            "${DateFormat('dd/MM/yy hh:mm a').format(timeAdded)}",
            14.0,
            AppColors.blackColor,
            TextAlign.start),
      ],
    );
  }

  renderAmount(WalletHistoryModel transaction) {
    if (transaction.amountAdded != null) {
      return utils.poppinsMediumText(
          "+ ${double.parse(transaction.amountAdded ?? "0").toStringAsFixed(2)}",
          18.0,
          AppColors.phoneNoColor,
          TextAlign.end);
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          utils.poppinsMediumText(
              "- ${double.parse(transaction.amountDeducted ?? "0").toStringAsFixed(2)}",
              18.0,
              AppColors.redColor,
              TextAlign.end),
          if (int.parse(transaction.unitQuantity ?? "1") > 1)
            utils.poppinsMediumText(
                "(${transaction.unitPrice ?? transaction.amountAdded ?? "0"} X ${transaction.unitQuantity ?? "1"})",
                12.0,
                AppColors.redColor,
                TextAlign.center),
        ],
      );
    }
  }
}
