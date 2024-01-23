import 'dart:async';
import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:foodizm_driver_app/colors.dart';
import 'package:foodizm_driver_app/common/common.dart';
import 'package:foodizm_driver_app/models/order_model.dart';
import 'package:foodizm_driver_app/utils/utils.dart';
import 'package:foodizm_driver_app/widget/order_widget.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../utils/send_notification_interface.dart';

class HomeFragment extends StatefulWidget {
  const HomeFragment({Key? key}) : super(key: key);

  @override
  _HomeFragmentState createState() => _HomeFragmentState();
}

class _HomeFragmentState extends State<HomeFragment> {
  Utils utils = new Utils();
  var databaseReference = FirebaseDatabase.instance.ref();
  RxBool hasData = false.obs;

  late StreamSubscription orderUpdate;
  late StreamSubscription orderAdded;
  late StreamSubscription orderRemoved;
  Rx<File> profileImage = File('').obs;
  var storageRef = FirebaseStorage.instance.ref();
  String url = '';
  final imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    Common.orderModel.clear();
    getOngoingOrder();
    //getCurrentLocation();
  }

  getOngoingOrder() async {
    orderAdded = databaseReference
        .child('Orders')
        .orderByChild('driverUid')
        .equalTo(utils.getUserId())
        .onChildAdded
        .listen((event) {
      if (event.snapshot.value != null) {
        Common.orderModel
            .add(OrderModel.fromJson(Map.from(event.snapshot.value as Map)));
      }
    });

    orderRemoved = databaseReference
        .child('Orders')
        .orderByChild('driverUid')
        .equalTo(utils.getUserId())
        .onChildRemoved
        .listen((event) {
      if (event.snapshot.value != null) {
        OrderModel list =
            OrderModel.fromJson(Map.from(event.snapshot.value as Map));
        Common.orderModel
            .removeWhere((element) => element.orderId == list.orderId);
      }
    });

    orderUpdate = databaseReference
        .child('Orders')
        .orderByChild('driverUid')
        .equalTo(utils.getUserId())
        .onChildChanged
        .listen((event) {
      if (event.snapshot.value != null) {
        OrderModel list =
            OrderModel.fromJson(Map.from(event.snapshot.value as Map));
        var index = Common.orderModel
            .indexWhere((item) => item.orderId == list.orderId);
        Common.orderModel[index] = list;
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
    return Container(
      height: Get.height,
      width: Get.width,
      padding: EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: utils.helveticaBoldText(
                'My Orders', 22.0, AppColors.blackColor, TextAlign.start),
          ),
          Expanded(
            child: Obx(() {
              if (hasData.value) {
                if (Common.orderModel.length > 0) {
                  return SingleChildScrollView(
                    child: Column(children: [
                      for (int i = 0; i < Common.orderModel.length; i++)
                        OrderWidget(
                          status: 'Ongoing',
                          orderModel: Common.orderModel[i],
                          function: (String status, OrderModel orderModel) {
                            if (status == 'delivered') {
                              changeOrderStatus(status, orderModel);
                            }
                          },
                        )
                    ]),
                  );
                } else {
                  return utils.noDataWidget('No Orders Found', Get.height);
                }
              } else {
                return Container(
                  height: Get.height,
                  child: Center(
                      child: CircularProgressIndicator(
                          backgroundColor: AppColors.primaryColor,
                          color: AppColors.whiteColor)),
                );
              }
            }),
          )
        ],
      ),
    );
  }

  changeOrderStatus(String status, OrderModel orderModel) async {
    print("changeOrderStatus inside home");
    final pickedFile = await imagePicker.pickImage(source: ImageSource.camera);
    if (pickedFile!.path.isNotEmpty) {
      utils.showLoadingDialog();
      utils.getUserCurrentLocation('current');
      orderModel.deliveryCurrentAddress = Common.currentAddress.toString();
      print('CurrentAddress${orderModel.deliveryCurrentAddress.toString()}');
      profileImage.value = File(pickedFile.path);
      final file = File(profileImage.value.path);
      String extension = profileImage.value.path.split('.').last;
      var ref = storageRef.child("Profile_images").child(
          "${DateTime.now().millisecondsSinceEpoch.toString()}.$extension");
      TaskSnapshot downloadurl = await ref.putFile(file);
      url = await downloadurl.ref.getDownloadURL();
      orderModel.deliveryPicture = url.toString();
      orderModel.status = 'delivered'.toString();
      var timeNow = DateTime.now().millisecondsSinceEpoch.toString();
      if (orderModel.timeDelivered == null) {
        orderModel.timeDelivered = timeNow;
      }

      print('deliverpicture${orderModel.deliveryPicture}');

      if (orderModel.deliveryPicture != null) {
        Query query = databaseReference
            .child('Orders')
            .orderByChild("orderId")
            .equalTo(orderModel.orderId);
        await query.once().then((DatabaseEvent event) async {
          if (event.snapshot.exists) {
            Map<String, dynamic> mapOfMaps =
                Map.from(event.snapshot.value as Map);
            mapOfMaps.keys.forEach((value) async {
              await databaseReference
                  .child('Orders')
                  .child(value.toString())
                  .update({
                'timeDelivered': timeNow,
                'driverUid': '',
              });
              print("orderModel:${orderModel.toJson()}");

              ///Uncoment
              await databaseReference
                  .child('OrdersByPicture')
                  .push()
                  .set(orderModel.toJson());
              Get.back();
              utils.showToast("Order Delivered Successfully");
              updateUserWallet(orderModel);
              await databaseReference
                  .child('Drivers')
                  .child(utils.getUserId())
                  .update({'onlineStatus': 'free'});
              // Get.back();
              // utils.showToast("Order Delivered Successfully");

              /// Uncomment
              //addToDelivered(value.toString());
            });
          }
        });
      }
    } else {
      // utils.showLoadingDialog();
      // Query query = databaseReference.child('Orders').orderByChild("orderId").equalTo(orderModel.orderId);
      // await query.once().then((DatabaseEvent event) async {
      //   if (event.snapshot.exists) {
      //     Map<String, dynamic> mapOfMaps = Map.from(event.snapshot.value as Map);
      //     mapOfMaps.keys.forEach((value) async {
      //       await databaseReference.child('Orders').child(value.toString()).update({
      //         'timeDelivered': DateTime.now().millisecondsSinceEpoch.toString(),
      //         'driverUid':''
      //       });
      //       //await databaseReference.child('Drivers').child(utils.getUserId()).update({'onlineStatus': 'free'});
      //       // Get.back();
      //       // utils.showToast("Order Delivered Successfully");
      //       addToDelivered(value.toString());
      //     });
      //   }
      // });
    }
  }

  updateUserWallet(OrderModel orderModel) {
    DateTime dateTime = DateTime.now();
    String day = DateFormat('EE, dd MMM').format(dateTime);
    var selectedDay = day.split(',').first.toString();
    var selectedQuantity = -1;
    (orderModel.orderDaysModel ?? []).forEach((OrderDaysModel element) {
      if (element.days == selectedDay) {
        selectedQuantity = element.quantity ?? 0;
      }
    });
    if (selectedQuantity == -1 &&
        (orderModel.orderDaysModel ?? []).isNotEmpty) {
      selectedQuantity = (orderModel.orderDaysModel ?? []).first.quantity ?? 0;
    }
    String userWalletBalance = "0";
    databaseReference
        .child("Users")
        .child(orderModel.uid ?? "")
        .get()
        .then((value) {
      if (value.value != null) {
        Map<dynamic, dynamic> mapDatavalue = Map.from(value.value as Map);
        userWalletBalance = mapDatavalue['userWallet'] ?? "0";
        databaseReference.child('Users').child(orderModel.uid ?? "").update({
          'userWallet': (double.parse(userWalletBalance) -
                  (double.parse(orderModel.totalPrice ?? "0") *
                      selectedQuantity))
              .toString()
        }).whenComplete(() {
          if (mapDatavalue["userToken"] != null) {
            sendNotification(mapDatavalue["userToken"], orderModel);
          }
          Map<String, dynamic> orderData = {
            "itemTitle": orderModel.items?[0]?["title"],
            "itemDetails": orderModel.items?[0]?["details"],
            "itemType": orderModel.items?[0]?["type"],
            "itemImage": orderModel.items?[0]?["image"],
            "unitPrice": orderModel.items?[0]?["newPrice"],
            "unitQuantity": selectedQuantity,
            "amountDeducted": (double.parse(orderModel.items?[0]?["newPrice"]) *
                    selectedQuantity)
                .toString(),
            "uid": orderModel.uid ?? "",
            "timeAdded": DateTime.now().millisecondsSinceEpoch.toString(),
          };
// print(orderData);
          databaseReference
              .child('WalletHistory')
              .push()
              .set(orderData)
              .then((snapShot) {
            utils.showToast('User wallet has been Updated');
          });
        });
      }
    });
  }

  sendNotification(String deviceToken, OrderModel orderModel) {
    SendNotificationInterface().sendNotification(
        "Order Delivered",
        "Your ${orderModel.items?[0]?["title"] ?? "order"} has been delivered.",
        deviceToken,
        "wallet",
        userId: orderModel.uid);
  }

  addToDelivered(String node) async {
    await databaseReference
        .child('Orders')
        .child(node)
        .once()
        .then((DatabaseEvent event) async {
      if (event.snapshot.exists) {
        OrderModel orderModel =
            new OrderModel.fromJson(Map.from(event.snapshot.value as Map));
        await databaseReference
            .child('All_Orders')
            .child(DateFormat('dd-MM-yyyy').format(DateTime.now()))
            .push()
            .set({
          'orderId': orderModel.orderId,
          'timeStamp': DateTime.now().millisecondsSinceEpoch.toString(),
        });
        increaseTotalOrder(orderModel.items);
        await databaseReference
            .child('Delivered_Orders')
            .push()
            .set(orderModel.toJson());
        //await databaseReference.child('Orders').child(node).remove();
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
        query = databaseReference
            .child('Deals')
            .orderByChild("timeCreated")
            .equalTo(items[i]!['timeCreated']);
      } else {
        query = databaseReference
            .child('Items')
            .orderByChild("timeCreated")
            .equalTo(items[i]!['timeCreated']);
      }

      await query.once().then((DatabaseEvent event) {
        print('yes2');
        if (event.snapshot.value != null) {
          Map<String, dynamic> mapOfMaps =
              Map.from(event.snapshot.value as Map);
          mapOfMaps.keys.forEach((value) async {
            print('yes3');
            Query query1;
            if (items[i]!['type'] == 'deal') {
              query1 = databaseReference
                  .child('Deals')
                  .child(value)
                  .child('totalOrder');
            } else {
              query1 = databaseReference
                  .child('Items')
                  .child(value)
                  .child('totalOrder');
            }
            await query1.once().then((DatabaseEvent event) {
              if (event.snapshot.exists) {
                print('yes4');
                // Map<dynamic, dynamic> map = Map.from(event.snapshot.value as Map);
                int integerValue = event.snapshot.value as int;

                if (items[i]!['type'] == 'deal') {
                  databaseReference
                      .child('Deals')
                      .child(value)
                      .update({'totalOrder': integerValue + 1});
                } else {
                  print('yes5');
                  databaseReference
                      .child('Items')
                      .child(value)
                      .update({'totalOrder': integerValue + 1});
                }
              } else {
                if (items[i]!['type'] == 'deal') {
                  databaseReference
                      .child('Deals')
                      .child(value)
                      .update({'totalOrder': 1});
                } else {
                  databaseReference
                      .child('Items')
                      .child(value)
                      .update({'totalOrder': 1});
                }
              }
            });
          });
        }
      });
    }
  }
}
