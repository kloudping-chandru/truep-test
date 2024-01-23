import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

import '../colors.dart';
import '../models/notification_history_model.dart';
import '../utils/utils.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  RxList<NotificationHistoryModel> notificationHistoryList =
      <NotificationHistoryModel>[].obs;
  var databaseReference = FirebaseDatabase.instance.ref();
  Utils utils = Utils();
  RxBool hasAllOrders = false.obs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNotificationHistory();
  }

  Future getNotificationHistory() async {
    notificationHistoryList.clear();

    Query querry = databaseReference
        .child('NotificationData')
        .orderByChild('uid')
        .equalTo(utils.getUserId());
    querry.once().then((value) {
      if (value.snapshot.value != null) {
        Map<String, dynamic> mapOfMaps = Map.from(value.snapshot.value as Map);
        mapOfMaps.values.forEach((value) {
          notificationHistoryList
              .add(NotificationHistoryModel.fromJson(Map.from(value)));
        });
        notificationHistoryList
            .sort((a, b) => (b.timeStamp ?? "0").compareTo(a.timeStamp ?? "0"));
        print(notificationHistoryList);
      }
      hasAllOrders.value = true;
    });

    print('hasAllOrders:${hasAllOrders.value}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: utils.poppinsMediumText(
            'notifications'.tr, 16.0, AppColors.blackColor, TextAlign.center),
        centerTitle: true,
      ),
      body: Obx(() {
        if (hasAllOrders.value == true) {
          if (notificationHistoryList.isNotEmpty) {
            return Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: ListView.separated(
                      itemBuilder: (context, index) =>
                          productWidget(notificationHistoryList[index]),
                      separatorBuilder: (context, index) => Container(),
                      itemCount: notificationHistoryList.length),
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

  Widget productWidget(NotificationHistoryModel transaction) {
    DateTime timeAdded = DateTime.fromMillisecondsSinceEpoch(
        int.parse(transaction.timeStamp ?? "0"));
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
      margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      decoration: utils.boxDecoration(
          Colors.white, Colors.transparent, 15.0, 0.0,
          isShadow: true, shadowColor: AppColors.greyColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            width: double.infinity,
            child: utils.poppinsMediumText((transaction.title ?? ""), 16.0,
                AppColors.blackColor, TextAlign.center),
          ),
          Container(
            width: double.infinity,
            child: utils.poppinsRegularText((transaction.body ?? ""), 14.0,
                AppColors.blackColor, TextAlign.center),
          ),
          SizedBox(height: 10,),
          utils.poppinsRegularText(
              "${DateFormat('dd/MM/yy hh:mm a').format(timeAdded)}",
              10.0,
              AppColors.lightGrey2Color,
              TextAlign.end),
        ],
      ),
    );
  }
}
