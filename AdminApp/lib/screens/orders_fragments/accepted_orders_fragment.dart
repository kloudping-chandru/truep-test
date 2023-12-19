import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:foodizm_admin_app/colors.dart';
import 'package:foodizm_admin_app/common/common.dart';
import 'package:foodizm_admin_app/database_model/order_model.dart';
import 'package:foodizm_admin_app/database_model/user_model.dart';
import 'package:foodizm_admin_app/utils/send_notification_interface.dart';
import 'package:foodizm_admin_app/utils/utils.dart';
import 'package:foodizm_admin_app/widget/order_widget.dart';
import 'package:get/get.dart';

class AcceptedOrdersFragment extends StatefulWidget {
  const AcceptedOrdersFragment({Key? key}) : super(key: key);

  @override
  _AcceptedOrdersFragmentState createState() => _AcceptedOrdersFragmentState();
}

class _AcceptedOrdersFragmentState extends State<AcceptedOrdersFragment> {
  Utils utils = new Utils();
  var databaseReference = FirebaseDatabase.instance.ref();
  RxBool hasData = false.obs;
  late StreamSubscription orderUpdate;
  late StreamSubscription orderAdded;
  late StreamSubscription orderRemoved;

  @override
  void initState() {
    super.initState();
    Common.acceptedOrderModel.clear();
    showAcceptedOrders();
  }

  showAcceptedOrders() async {
    orderAdded = databaseReference.child('Orders').orderByChild('status').equalTo('accepted').onChildAdded.listen((event) {
      if (event.snapshot.value != null) {
        Common.acceptedOrderModel.add(OrderModel.fromJson(Map.from(event.snapshot.value as Map)));
      }
    });

    orderRemoved = databaseReference.child('Orders').orderByChild('status').equalTo('accepted').onChildRemoved.listen((event) {
      if (event.snapshot.value != null) {
        OrderModel list = OrderModel.fromJson(Map.from(event.snapshot.value as Map));
        Common.acceptedOrderModel.removeWhere((element) => element.orderId == list.orderId);
      }
    });

    orderUpdate = databaseReference.child('Orders').orderByChild('status').equalTo('accepted').onChildChanged.listen((event) {
      if (event.snapshot.value != null) {
        OrderModel list = OrderModel.fromJson(Map.from(event.snapshot.value as Map));
        var index = Common.acceptedOrderModel.indexWhere((item) => item.orderId == list.orderId);
        Common.acceptedOrderModel[index] = list;
      }
    });

    hasData.value = true;
  }

  @override
  void dispose() {
    orderAdded.cancel();
    orderUpdate.cancel();
    orderRemoved.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (hasData.value) {
        if (Common.acceptedOrderModel.length > 0) {
          return SingleChildScrollView(
            child: Column(children: [
              for (int i = 0; i < Common.acceptedOrderModel.length; i++)
                OrderWidget(
                  status: 'Accepted',
                  orderModel: Common.acceptedOrderModel[i],
                  function: (String status, OrderModel orderModel) {
                    if (status == 'preparing') {
                      changeOrderStatus(status, orderModel);
                    }
                  },
                )
            ]),
          );
        } else {
          return utils.noDataWidget('noOrders'.tr, Get.height);
        }
      } else {
        return Container(
          height: Get.height,
          child: Center(child: CircularProgressIndicator(backgroundColor: AppColors.primaryColor, color: AppColors.whiteColor)),
        );
      }
    });
  }

  changeOrderStatus(String status, OrderModel orderModel) async {
    utils.showLoadingDialog();
    Query query = databaseReference.child('Orders').orderByChild("orderId").equalTo(orderModel.orderId);
    await query.once().then((DatabaseEvent event) async {
      if (event.snapshot.exists) {
        Map<String, dynamic> mapOfMaps = Map.from(event.snapshot.value as Map);
        mapOfMaps.keys.forEach((value) async {
          await databaseReference.child('Orders').child(value.toString()).update({
            'timeStartPreparing': DateTime.now().millisecondsSinceEpoch.toString(),
            'status': status,
          });
          Get.back();
          utils.showToast("orderStarted".tr);
          getUserToken(orderModel, 'orderStartTitle'.tr);
        });
      }
    });
  }

  getUserToken(OrderModel orderModel, String title) async {
    await databaseReference.child('Users').child(orderModel.uid!).once().then((DatabaseEvent event) {
      if (event.snapshot.exists) {
        UserModel userModel = UserModel.fromJson(Map.from(event.snapshot.value as Map));
        if (userModel.userToken != null) {
          String body = 'orderStartBody'.tr + ' ' + orderModel.orderId!;

          SendNotificationInterface().sendNotification(title, body, userModel.userToken!, 'Order');
        }
      }
    });
  }
}
