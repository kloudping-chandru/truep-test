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
import 'package:intl/intl.dart';

class PendingOrdersFragment extends StatefulWidget {
  const PendingOrdersFragment({Key? key}) : super(key: key);

  @override
  _PendingOrdersFragmentState createState() => _PendingOrdersFragmentState();
}

class _PendingOrdersFragmentState extends State<PendingOrdersFragment> {
  Utils utils = new Utils();
  var databaseReference = FirebaseDatabase.instance.ref();
  RxBool hasData = false.obs;

  late StreamSubscription orderUpdate;
  late StreamSubscription orderAdded;
  late StreamSubscription orderRemoved;

  @override
  void initState() {
    super.initState();
    Common.pendingOrderModel.clear();
    showPendingOrders();
  }

  showPendingOrders() async {
    orderAdded = databaseReference.child('Orders').orderByChild('status').equalTo('requested').onChildAdded.listen((event) {
      if (event.snapshot.value != null) {
        Common.pendingOrderModel.add(OrderModel.fromJson(Map.from(event.snapshot.value as Map)));
      }
    });

    orderRemoved = databaseReference.child('Orders').orderByChild('status').equalTo('requested').onChildRemoved.listen((event) {
      if (event.snapshot.value != null) {
        OrderModel list = OrderModel.fromJson(Map.from(event.snapshot.value as Map));
        Common.pendingOrderModel.removeWhere((element) => element.orderId == list.orderId);
      }
    });

    orderUpdate = databaseReference.child('Orders').orderByChild('status').equalTo('requested').onChildChanged.listen((event) {
      if (event.snapshot.value != null) {
        OrderModel list = OrderModel.fromJson(Map.from(event.snapshot.value as Map));
        var index = Common.pendingOrderModel.indexWhere((item) => item.orderId == list.orderId);
        Common.pendingOrderModel[index] = list;
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
        if (Common.pendingOrderModel.length > 0) {
          return SingleChildScrollView(
            child: Column(children: [
              for (int i = 0; i < Common.pendingOrderModel.length; i++)
                OrderWidget(
                  status: 'Pending',
                  orderModel: Common.pendingOrderModel[i],
                  function: (String status, OrderModel orderModel) {
                    if (status == 'completed') {
                      changeOrderStatus(status, orderModel);
                    } else if (status == 'rejected') {
                      addToCancelledOrder(status, orderModel);
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
            'timeDelivered': DateTime.now().millisecondsSinceEpoch.toString(),
            'status': status,
          });
          //Get.back();
          //utils.showToast("orderAccepted".tr);
          addToDelivered(value.toString());
          getUserToken(orderModel, 'orderAcceptedTitle'.tr);
        });
      }
    });
  }
  addToDelivered(String node) async {
    await databaseReference.child('Orders').child(node).once().then((DatabaseEvent event) async {
      if (event.snapshot.exists) {
        OrderModel orderModel = new OrderModel.fromJson(Map.from(event.snapshot.value as Map));
        await databaseReference.child('All_Orders').child(DateFormat('dd-MM-yyyy').format(DateTime.now())).push().set({
          'orderId': orderModel.orderId,
          'timeStamp': DateTime.now().millisecondsSinceEpoch.toString(),
        });
        increaseTotalOrder(orderModel.items);
        await databaseReference.child('Delivered_Orders').push().set(orderModel.toJson());
        await databaseReference.child('Orders').child(node).remove();
        Get.back();
        utils.showToast("orderCompleted".tr);
      }
    });
  }
  increaseTotalOrder(List<Map<String, dynamic>?>? items) async {
    print('yes1');
    for (int i = 0; i < items!.length; i++) {
      Query query;
      if (items[i]!['type'] == 'deal') {
        query = databaseReference.child('Deals').orderByChild("timeCreated").equalTo(items[i]!['timeCreated']);
      } else {
        query = databaseReference.child('Items').orderByChild("timeCreated").equalTo(items[i]!['timeCreated']);
      }

      await query.once().then((DatabaseEvent event) {
        print('yes2');
        if (event.snapshot.value != null) {
          Map<String, dynamic> mapOfMaps = Map.from(event.snapshot.value as Map);
          mapOfMaps.keys.forEach((value) async {
            print('yes3');
            Query query1;
            if (items[i]!['type'] == 'deal') {
              query1 = databaseReference.child('Deals').child(value).child('totalOrder');
            } else {
              query1 = databaseReference.child('Items').child(value).child('totalOrder');
            }
            await query1.once().then((DatabaseEvent event) {
              if (event.snapshot.exists) {
                print('yes4');
                // Map<dynamic, dynamic> map = Map.from(event.snapshot.value as Map);
                int integerValue = event.snapshot.value as int;


                if (items[i]!['type'] == 'deal') {
                  databaseReference.child('Deals').child(value).update({'totalOrder': integerValue + 1});
                } else {
                  print('yes5');
                  databaseReference.child('Items').child(value).update({'totalOrder': integerValue+ 1});
                }
              } else {
                if (items[i]!['type'] == 'deal') {
                  databaseReference.child('Deals').child(value).update({'totalOrder': 1});
                } else {
                  databaseReference.child('Items').child(value).update({'totalOrder': 1});
                }
              }
            });
          });
        }
      });
    }
  }

  addToCancelledOrder(String status, OrderModel orderModel) async {
    utils.showLoadingDialog();
    Query query = databaseReference.child('Orders').orderByChild("orderId").equalTo(orderModel.orderId);
    await query.once().then((DatabaseEvent event) async {
      if (event.snapshot.exists) {
        Map<String, dynamic> mapOfMaps = Map.from(event.snapshot.value as Map);
        mapOfMaps.keys.forEach((value) async {
          await databaseReference.child('Orders').child(value.toString()).update({'status': status});
          await databaseReference.child('Cancelled_Orders').push().set(orderModel.toJson());
          await databaseReference.child('Orders').child(value).remove();
          Get.back();
          utils.showToast("orderRejected".tr);
          getUserToken(orderModel, 'orderRejectedTitle'.tr);
        });
      }
    });
  }

  getUserToken(OrderModel orderModel, String title) async {
    await databaseReference.child('Users').child(orderModel.uid!).once().then((DatabaseEvent event) {
      if (event.snapshot.exists) {
        UserModel userModel = UserModel.fromJson(Map.from(event.snapshot.value as Map));
        if (userModel.userToken != null) {
          String body = '';
          if (title == 'orderRejected'.tr) {
            body = 'orderRejectedBody'.tr + ' ' + orderModel.orderId!;
          } else {
            body = 'orderAcceptedBody'.tr + ' ' + orderModel.orderId!;
          }
          SendNotificationInterface().sendNotification(title, body, userModel.userToken!, 'Order');
        }
      }
    });
  }
}
