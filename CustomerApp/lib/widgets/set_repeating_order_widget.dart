import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:trupressed_subscription/colors.dart';
import 'package:trupressed_subscription/models/order_model.dart';
import 'package:trupressed_subscription/models/product_model.dart';
import 'package:trupressed_subscription/utils/utils.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../common/CommonController.dart';
import '../common/common.dart';

class SetRepeatingOrderWidget extends StatefulWidget {
  final ProductModel? productModel;
  final OrderModel? orderModel;
  const SetRepeatingOrderWidget({Key? key, this.productModel, this.orderModel})
      : super(key: key);

  @override
  State<SetRepeatingOrderWidget> createState() =>
      _SetRepeatingOrderWidgetState();
}

class _SetRepeatingOrderWidgetState extends State<SetRepeatingOrderWidget> {
  Utils utils = Utils();
  RxString staringDate = DateFormat("yyyy-MM-dd").format(DateTime.now().add(Duration(days: 1))).obs;
  RxString endingDate = DateFormat("yyyy-MM-dd")
      .format(
        DateTime.now().add(const Duration(days: 30)),
      )
      .obs;
  String? currentTime;
  var databaseReference = FirebaseDatabase.instance.ref();
  RxInt mon = 1.obs;
  RxInt tue = 1.obs;
  RxInt wed = 1.obs;
  RxInt thu = 1.obs;
  RxInt fri = 1.obs;
  RxInt sat = 1.obs;
  RxInt sun = 1.obs;

  RxString? lat = ''.obs;
  RxString? lng = ''.obs;
  RxString? address = ''.obs;
  RxString beforeValue = ''.obs;

  String orderIdKey = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (Common.currentAddress != null) {
      lat!.value = Common.currentLat!;
      lng!.value = Common.currentLng!;
      address!.value = Common.currentAddress!;

      //RxString staringDate = ''.obs;

      setData();

      // print('Status:${widget.orderModel != null? 'Not find': 'Available'}');
    }
  }

  setData() {
    if (widget.orderModel != null) {
      staringDate.value = widget.orderModel!.startingDate!;
      for (var item in widget.orderModel!.orderDaysModel.values) {
        print(item);
        if (item['day'] == 'Sun') {
          sun.value = (item['quantity'] is String)
              ? (int.parse(item['quantity']))
              : (item['quantity']);
        } else if (item['day'] == 'Mon') {
          mon.value = (item['quantity'] is String)
              ? (int.parse(item['quantity']))
              : (item['quantity']);
        } else if (item['day'] == 'Tue') {
          tue.value = (item['quantity'] is String)
              ? (int.parse(item['quantity']))
              : (item['quantity']);
        } else if (item['day'] == 'Wed') {
          wed.value = (item['quantity'] is String)
              ? (int.parse(item['quantity']))
              : (item['quantity']);
        } else if (item['day'] == 'Thu') {
          thu.value = (item['quantity'] is String)
              ? (int.parse(item['quantity']))
              : (item['quantity']);
        } else if (item['day'] == 'Fri') {
          fri.value = (item['quantity'] is String)
              ? (int.parse(item['quantity']))
              : (item['quantity']);
        } else if (item['day'] == 'Sat') {
          sat.value = (item['quantity'] is String)
              ? (int.parse(item['quantity']))
              : (item['quantity']);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          IconButton(
              onPressed: () => Get.back(),
              icon: const Icon(Icons.close,
                  size: 35, color: AppColors.blackColor)),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Obx(
                    () => NewOrderCounter(
                        productModel: widget.productModel,
                        incrementFunction: (weekday) {
                          print(weekday);
                          switch (weekday) {
                            case 'Sunday':
                              sun.value < Common.maximumQuantityCanbeOrdered
                                  ? sun.value++
                                  : null;
                            case 'Monday':
                              mon.value < Common.maximumQuantityCanbeOrdered
                                  ? mon.value++
                                  : null;
                            case 'Tuesday':
                              tue.value < Common.maximumQuantityCanbeOrdered
                                  ? tue.value++
                                  : null;
                            case 'Wednesday':
                              wed.value < Common.maximumQuantityCanbeOrdered
                                  ? wed.value++
                                  : null;
                            case 'Thursday':
                              thu.value < Common.maximumQuantityCanbeOrdered
                                  ? thu.value++
                                  : null;
                            case 'Friday':
                              fri.value < Common.maximumQuantityCanbeOrdered
                                  ? fri.value++
                                  : null;
                            case 'Saturday':
                              sat.value < Common.maximumQuantityCanbeOrdered
                                  ? sat.value++
                                  : null;
                              break;
                          }
                        },
                        decrementFunction: (weekday) {
                          print(weekday);
                          switch (weekday) {
                            case 'Sunday':
                              sun.value > 0 ? sun.value-- : null;
                              break;

                            case 'Monday':
                              mon.value > 0 ? mon.value-- : null;
                            case 'Tuesday':
                              tue.value > 0 ? tue.value-- : null;
                            case 'Wednesday':
                              wed.value > 0 ? wed.value-- : null;
                            case 'Thursday':
                              thu.value > 0 ? thu.value-- : null;
                            case 'Friday':
                              fri.value > 0 ? fri.value-- : null;
                            case 'Saturday':
                              sat.value > 0 ? sat.value-- : null;
                              break;
                          }
                        },
                        weekdays: [
                          "Sunday",
                          "Monday",
                          "Tuesday",
                          "Wednesday",
                          "Thursday",
                          "Friday",
                          "Saturday"
                        ],
                        weekvalues: [
                          sun.value,
                          mon.value,
                          tue.value,
                          wed.value,
                          thu.value,
                          fri.value,
                          sat.value
                        ],
                        startingDate: staringDate.value,
                        onDateClick: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now().add(Duration(days: 1)),
                            firstDate: DateTime.now().add(Duration(days: 1)),
                            lastDate:
                                DateTime.now().add(const Duration(days: 365)),
                            builder: (context, child) {
                              return Theme(
                                data: ThemeData.dark().copyWith(
                                  colorScheme: ColorScheme.dark(
                                    primary: AppColors.whiteColor,
                                    onPrimary:
                                    AppColors.primaryColor,
                                    surface:
                                    AppColors.primaryColor,
                                    onSurface:
                                    AppColors.whiteColor,
                                    // primary: AppColors.primaryColor,
                                    // onPrimary: AppColors.whiteColor,
                                    // surface: AppColors.primaryColor,
                                    // onSurface: Colors.white,
                                  ),
                                  dialogBackgroundColor:
                                      AppColors.primaryColorLight,
                                ),
                                child: child!,
                              );
                            },
                          );
                          staringDate.value =
                              DateFormat("yyyy-MM-dd").format(pickedDate!);
                          endingDate.value = DateFormat("yyyy-MM-dd")
                              .format(pickedDate.add(const Duration(days: 30)));
                        }),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
          Obx(() => renderErrorText()),
          Obx(() => renderActionButton()),
        ],
      ),
    );
  }

  Widget renderErrorText() {
    if ((num.parse(Common.wallet.value) <
        Common.minimumRequiredWalletBalance)) {
      return Container(
        margin: const EdgeInsets.only(top: 10),
        child: utils.poppinsSemiBoldText(
            "Your wallet balance is below INR ${Common.minimumRequiredWalletBalance.toStringAsFixed(2)}. Please recharge your wallet to enjoy uninterrupted service.",
            12.0,
            AppColors.redColor,
            TextAlign.start),
      );
    } else if (num.parse(Common.wallet.value) <
        ((sun.value +
                mon.value +
                tue.value +
                wed.value +
                thu.value +
                fri.value +
                sat.value) *
            num.parse(widget.productModel?.price ?? "0"))) {
      return Container(
        margin: const EdgeInsets.only(top: 10),
        child: utils.poppinsSemiBoldText(
            "Your wallet balance is lower than the order value for a week(INR ${(sun.value + mon.value + tue.value + wed.value + thu.value + fri.value + sat.value) * num.parse(widget.productModel?.price ?? "0")}). Please recharge your wallet to place the order.",
            12.0,
            AppColors.redColor,
            TextAlign.start),
      );
    }
    return SizedBox.shrink();
  }

  Widget renderActionButton() {
    bool shouldDisable = ((num.parse(Common.wallet.value) <
            ((sun.value +
                    mon.value +
                    tue.value +
                    wed.value +
                    thu.value +
                    fri.value +
                    sat.value) *
                num.parse(widget.productModel?.price ?? "0"))) ||
        ((sun.value +
                mon.value +
                tue.value +
                wed.value +
                thu.value +
                fri.value +
                sat.value) ==
            0));
    return InkWell(
      onTap: shouldDisable
          ? null
          : () {
              widget.orderModel != null ? payOrderUpdate() : payOrder();
            },
      child: Container(
        height: 45,
        margin: const EdgeInsets.only(top: 10, bottom: 20),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: shouldDisable ? AppColors.greyColor : AppColors.primaryColor,
          borderRadius: BorderRadius.all(Radius.circular(30.0)),
        ),
        child: Center(
          child: utils.poppinsMediumText(
            'setRepeatingOrder'.tr.toUpperCase(),
            16.0,
            AppColors.whiteColor,
            TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget showDayQuantityWidget(RxInt value, String day) {
    return Obx(() {
      return Column(
        children: [
          Container(
            height: 150.0,
            decoration: utils.boxDecoration(
                Colors.transparent, AppColors.blackColor, 25.0, 1.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () => value > 0 ? value.value-- : null,
                  icon: const Icon(Icons.remove,
                      size: 20, color: AppColors.blackColor),
                ),
                utils.poppinsMediumText(value.value.toString(), 18.0,
                    AppColors.blackColor, TextAlign.start),
                IconButton(
                  onPressed: () => value.value++,
                  icon: const Icon(Icons.add,
                      size: 20, color: AppColors.blackColor),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          utils.poppinsMediumText(
              day, 16.0, AppColors.blackColor, TextAlign.start),
        ],
      );
    });
  }

  payOrder() async {
    utils.showLoadingDialog();
    List<Map<String, dynamic>?>? items = [];

    currentTime = DateTime.now().millisecondsSinceEpoch.toString();

    DateTime now = DateTime.now();
    int hour = now.hour;
    print('Hour:${hour.toString()}');
    DateTime startingDateTime = DateTime.parse(staringDate.value);

    if (hour >= 22 && utils.isToday(startingDateTime)) {
      staringDate.value = DateFormat("yyyy-MM-dd")
          .format(startingDateTime.add(const Duration(days: 1)));
      endingDate.value = DateFormat("yyyy-MM-dd").format(
        startingDateTime.add(const Duration(days: 32)),
      );
    } else if (utils.isToday(startingDateTime)) {
      staringDate.value = DateFormat("yyyy-MM-dd")
          .format(startingDateTime.add(const Duration(days: 1)));
      endingDate.value = DateFormat("yyyy-MM-dd").format(
        startingDateTime.add(const Duration(days: 31)),
      );
    } else {
      staringDate.value = DateFormat("yyyy-MM-dd").format(startingDateTime);
      endingDate.value = DateFormat("yyyy-MM-dd").format(
        startingDateTime.add(const Duration(days: 30)),
      );
    }
    Map<String, dynamic> data = {
      "categoryId": widget.productModel!.categoryId,
      "title": widget.productModel!.title,
      "details": widget.productModel!.details,
      "image": widget.productModel!.image,
      "type": widget.productModel!.type,
      // "no_of_serving": widget.productModel!.noOfServing,
      // "timeCreated": widget.productModel!.timeCreated,
      // "oldPrice": widget.productModel!.price,
      "newPrice": widget.productModel!.price,
      "quantity": widget.productModel!.productQuantity,
      "uid": utils.getUserId(),
      // "timeAdded": currentTime,
      "ingredients": widget.productModel!.ingredients,
      "customizationForVariations":
          widget.productModel!.customizationForVariations,
      "customizationForFlavours": widget.productModel!.customizationForFlavours,
      "customizationForDrinks": widget.productModel!.customizationForFlavours,
      // "itemsIncluded": widget.productModel!.customizationForFlavours,
    };
    print("dataOrderMOdel===============>${data}");
    items.add(data);
    print("itemsOrderMOdel===============>${items}");
    Map<String, dynamic> orderData = {
      "items": items,
      "totalPrice": widget.productModel!.price,
      "orderId": currentTime,
      "status": 'requested',
      "origin": address!.value,
      "latitude": lat!.value,
      "longitude": lng!.value,
      "timeRequested": currentTime,
      "paymentType": 'Card',
      // "timeAccepted": 'default',
      // "timeStartPreparing": 'default',
      // "timeOnTheWay": 'default',
      // "timeDelivered": 'default',
      "uid": utils.getUserId(),
      'startingDate': staringDate.value,
      'endingDate': endingDate.value,
      'itemId': widget.productModel!.timeCreated
    };
    await databaseReference
        .child('Orders')
        .push()
        .set(orderData)
        .then((snapShot) {
      addDaysAndQuantity();
      Get.back();
      Common.orderData.clear();
      Common.orderDataWithOnce.clear();
      getOrders();
      getOnceOrders();
      print('AtOrderPlaced:${Common.orderData.length.toString()}');
      utils.showToast('Your Order has Successfully Placed');

      Get.back();
      Get.back();
    }).onError((error, stackTrace) {
      Get.back();
      utils.showToast(error.toString());
    });
  }

  payOrderUpdate() async {
    utils.showLoadingDialog();
    List<Map<String, dynamic>?>? items = [];

    DateTime now = DateTime.now();
    int hour = now.hour;
    DateTime startingDateTime = DateTime.parse(staringDate.value);

    if (hour > 22 || hour == 22) {
      staringDate.value = DateFormat("yyyy-MM-dd")
          .format(startingDateTime.add(const Duration(days: 2)));
      endingDate.value = DateFormat("yyyy-MM-dd").format(
        startingDateTime.add(const Duration(days: 32)),
      );
    } else {
      staringDate.value = DateFormat("yyyy-MM-dd")
          .format(startingDateTime.add(const Duration(days: 1)));
      endingDate.value = DateFormat("yyyy-MM-dd").format(
        startingDateTime.add(const Duration(days: 31)),
      );
    }

    print('timeCreated:${widget.productModel!.timeCreated}');
    Query query = await databaseReference
        .child('Orders')
        .orderByChild('itemId')
        .equalTo(widget.productModel!.timeCreated);
    query.once().then((value) async {
      if (value.snapshot.value != null) {
        // print('KeyOrder:${value.snapshot.value}');
        for (var item in value.snapshot.children) {
          await databaseReference.child('Orders').child(item.key!).update({
            'startingDate': staringDate.value,
            'endingDate': endingDate.value
          }).whenComplete(() async {
            for (int i = 0; i < 7; i++) {
              if (i == 0) {
                Map<String, dynamic> daysAddMap = {
                  'day': 'Sun',
                  'quantity': sun.value
                };
                // orderIdKey= item.key!;
                Query query = databaseReference
                    .child('Orders')
                    .child(item.key!)
                    .child('Days')
                    .orderByChild('day')
                    .equalTo('Sun');
                await query.once().then((value) {
                  if (value.snapshot.value != null) {
                    for (var itemDays in value.snapshot.children) {
                      databaseReference
                          .child('Orders')
                          .child(item.key!)
                          .child('Days')
                          .child(itemDays.key!)
                          .update(daysAddMap)
                          .whenComplete(() {});
                    }
                  }
                });
              }
              if (i == 1) {
                Map<String, dynamic> daysAddMap = {
                  'day': 'Mon',
                  'quantity': mon.value
                };

                Query query = databaseReference
                    .child('Orders')
                    .child(item.key!)
                    .child('Days')
                    .orderByChild('day')
                    .equalTo('Mon');
                await query.once().then((value) {
                  if (value.snapshot.value != null) {
                    for (var itemDays in value.snapshot.children) {
                      databaseReference
                          .child('Orders')
                          .child(item.key!)
                          .child('Days')
                          .child(itemDays.key!)
                          .update(daysAddMap)
                          .whenComplete(() {});
                    }
                  }
                });
              }
              if (i == 2) {
                Map<String, dynamic> daysAddMap = {
                  'day': 'Tue',
                  'quantity': tue.value
                };
                Query query = databaseReference
                    .child('Orders')
                    .child(item.key!)
                    .child('Days')
                    .orderByChild('day')
                    .equalTo('Tue');
                await query.once().then((value) {
                  if (value.snapshot.value != null) {
                    for (var itemDays in value.snapshot.children) {
                      databaseReference
                          .child('Orders')
                          .child(item.key!)
                          .child('Days')
                          .child(itemDays.key!)
                          .update(daysAddMap)
                          .whenComplete(() {});
                    }
                  }
                });
              }
              if (i == 3) {
                Map<String, dynamic> daysAddMap = {
                  'day': 'Wed',
                  'quantity': wed.value
                };

                Query query = databaseReference
                    .child('Orders')
                    .child(item.key!)
                    .child('Days')
                    .orderByChild('day')
                    .equalTo('Wed');
                await query.once().then((value) {
                  if (value.snapshot.value != null) {
                    for (var itemDays in value.snapshot.children) {
                      databaseReference
                          .child('Orders')
                          .child(item.key!)
                          .child('Days')
                          .child(itemDays.key!)
                          .update(daysAddMap)
                          .whenComplete(() {});
                    }
                  }
                });
              }
              if (i == 4) {
                Map<String, dynamic> daysAddMap = {
                  'day': 'Thu',
                  'quantity': thu.value
                };

                Query query = databaseReference
                    .child('Orders')
                    .child(item.key!)
                    .child('Days')
                    .orderByChild('day')
                    .equalTo('Thu');
                await query.once().then((value) {
                  if (value.snapshot.value != null) {
                    for (var itemDays in value.snapshot.children) {
                      databaseReference
                          .child('Orders')
                          .child(item.key!)
                          .child('Days')
                          .child(itemDays.key!)
                          .update(daysAddMap)
                          .whenComplete(() {});
                    }
                  }
                });
              }
              if (i == 5) {
                Map<String, dynamic> daysAddMap = {
                  'day': 'Fri',
                  'quantity': fri.value
                };

                Query query = databaseReference
                    .child('Orders')
                    .child(item.key!)
                    .child('Days')
                    .orderByChild('day')
                    .equalTo('Fri');
                await query.once().then((value) {
                  if (value.snapshot.value != null) {
                    for (var itemDays in value.snapshot.children) {
                      databaseReference
                          .child('Orders')
                          .child(item.key!)
                          .child('Days')
                          .child(itemDays.key!)
                          .update(daysAddMap)
                          .whenComplete(() {});
                    }
                  }
                });
              }
              if (i == 6) {
                Map<String, dynamic> daysAddMap = {
                  'day': 'Sat',
                  'quantity': sat.value
                };

                Query query = databaseReference
                    .child('Orders')
                    .child(item.key!)
                    .child('Days')
                    .orderByChild('day')
                    .equalTo('Sat');
                await query.once().then((value) {
                  if (value.snapshot.value != null) {
                    for (var itemDays in value.snapshot.children) {
                      databaseReference
                          .child('Orders')
                          .child(item.key!)
                          .child('Days')
                          .child(itemDays.key!)
                          .update(daysAddMap)
                          .whenComplete(() {});
                    }
                  }
                });
              }
            }
          });
          // Map<dynamic,dynamic> mapData = item.value as Map;
          // print('key:${item.key}');
        }
        getOrders();
        getOnceOrders();
        Get.back();
        Get.back();
        Get.back();
        utils.showToast('Your Order has Updated Successfully');
      }
    });
  }

  Future addDaysAndQuantity() async {
    await databaseReference.child('Orders').get().then((snapShot) {
      for (var item in snapShot.children) {
        Map<dynamic, dynamic> mapGetOrders =
            item.value as Map<dynamic, dynamic>;
        if (mapGetOrders['orderId'] == currentTime) {
          for (int i = 0; i < 7; i++) {
            if (i == 0) {
              Map<String, dynamic> daysAddMap = {
                'day': 'Sun',
                'quantity': sun.value
              };
              databaseReference
                  .child('Orders')
                  .child(item.key.toString())
                  .child('Days')
                  .push()
                  .set(daysAddMap)
                  .whenComplete(() {});
            }
            if (i == 1) {
              Map<String, dynamic> daysAddMap = {
                'day': 'Mon',
                'quantity': mon.value
              };
              databaseReference
                  .child('Orders')
                  .child(item.key.toString())
                  .child('Days')
                  .push()
                  .set(daysAddMap)
                  .whenComplete(() {});
            }
            if (i == 2) {
              Map<String, dynamic> daysAddMap = {
                'day': 'Tue',
                'quantity': tue.value
              };
              databaseReference
                  .child('Orders')
                  .child(item.key.toString())
                  .child('Days')
                  .push()
                  .set(daysAddMap)
                  .whenComplete(() {});
            }
            if (i == 3) {
              Map<String, dynamic> daysAddMap = {
                'day': 'Wed',
                'quantity': wed.value
              };
              databaseReference
                  .child('Orders')
                  .child(item.key.toString())
                  .child('Days')
                  .push()
                  .set(daysAddMap)
                  .whenComplete(() {});
            }
            if (i == 4) {
              Map<String, dynamic> daysAddMap = {
                'day': 'Thu',
                'quantity': thu.value
              };
              databaseReference
                  .child('Orders')
                  .child(item.key.toString())
                  .child('Days')
                  .push()
                  .set(daysAddMap)
                  .whenComplete(() {});
            }
            if (i == 5) {
              Map<String, dynamic> daysAddMap = {
                'day': 'Fri',
                'quantity': fri.value
              };
              databaseReference
                  .child('Orders')
                  .child(item.key.toString())
                  .child('Days')
                  .push()
                  .set(daysAddMap)
                  .whenComplete(() {});
            }
            if (i == 6) {
              Map<String, dynamic> daysAddMap = {
                'day': 'Sat',
                'quantity': sat.value
              };
              databaseReference
                  .child('Orders')
                  .child(item.key.toString())
                  .child('Days')
                  .push()
                  .set(daysAddMap)
                  .whenComplete(() {});
            }
          }
        }
      }
    });
  }

  getOnceOrders() {
    databaseReference
        .child('OnceOrders')
        .orderByChild('uid')
        .equalTo(utils.getUserId())
        .onChildAdded
        .listen((event) {
      if (event.snapshot.value != null) {
        OrderModel orderModel =
            OrderModel.fromJson(Map.from(event.snapshot.value as Map));
        if (orderModel.uid == utils.getUserId()) {
          Common.orderDataWithOnce.add(orderModel);
          print("OnceOrderModel=================>${orderModel.toJson()}");
          print('onceOrderModelLength:${Common.orderDataWithOnce.length}');
        }
      }
    });
  }

  Future getOrders() async {
    Query query = databaseReference
        .child("Orders")
        .orderByChild('uid')
        .equalTo(utils.getUserId());
    query.once().then((value) {
      if (value.snapshot.value != null) {
        for (var item in value.snapshot.children) {
          OrderModel orderModel =
              OrderModel.fromJson(Map.from(item.value as Map));
          String dateFormat = DateFormat("yyyy-MM-dd")
              .format(DateTime.parse(orderModel.endingDate!));
          DateTime splitOrderDate = DateTime.parse(dateFormat);

          String todayDate = DateFormat("yyyy-MM-dd").format(DateTime.now());
          DateTime todayDateInFormat = DateTime.parse(todayDate);

          if (orderModel.status == 'requested' &&
              splitOrderDate.compareTo(todayDateInFormat) > 0) {
            Common.orderData.add(orderModel);
            Common.orderDataWithOnce.add(orderModel);
            CommonController.cartValue!.value = '';
            CommonController.cartValue!.value =
                Common.orderData.length.toString();
          }
        }
      }
    });
  }
}

class NewOrderCounter extends StatelessWidget {
  final ProductModel? productModel;
  final Function incrementFunction;
  final Function decrementFunction;
  final Function onDateClick;
  final String startingDate;

  final List<String> weekdays;
  final List<int> weekvalues;
  NewOrderCounter({
    super.key,
    this.productModel,
    required this.incrementFunction,
    required this.onDateClick,
    required this.weekdays,
    required this.weekvalues,
    required this.decrementFunction,
    required this.startingDate,
  });

  final Utils utils = Utils();

  @override
  Widget build(BuildContext context) {
    return (productModel != null)
        ? Container(
            margin: EdgeInsets.symmetric(horizontal: 5),
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
            decoration: utils.boxDecoration(
                Colors.white, Colors.transparent, 15.0, 0.0,
                isShadow: true, shadowColor: AppColors.greyColor),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          utils.poppinsMediumText("trupressed".tr, 16.0,
                              AppColors.lightGrey2Color, TextAlign.start),
                          utils.poppinsMediumText(productModel?.title, 18.0,
                              AppColors.blackColor, TextAlign.start),
                          // utils.poppinsMediumText("500 ML", 14.0, AppColors.lightGreyColor, TextAlign.start),
                          Container(
                            width: 300,
                            child: utils.poppinsMediumText(
                                productModel?.details ?? "",
                                14.0,
                                AppColors.lightGreyColor,
                                TextAlign.start,
                                maxlines: 2),
                          ),

                          utils.poppinsMediumText(
                              "${Common.currency} ${productModel?.price ?? ""}",
                              18.0,
                              AppColors.blackColor,
                              TextAlign.start),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      height: 100,
                      width: 100,

                      // margin: const EdgeInsets.all(12.0),
                      child: ClipRRect(
                        child: (productModel?.image ?? "").isNotEmpty
                            ? CachedNetworkImage(
                                fit: BoxFit.cover,
                                imageUrl: (productModel?.image ?? ""),
                                progressIndicatorBuilder:
                                    (context, url, downloadProgress) =>
                                        SizedBox(
                                  height: 50,
                                  width: 50,
                                  child: Center(
                                      child: CircularProgressIndicator(
                                          value: downloadProgress.progress)),
                                ),
                                errorWidget: (context, url, error) =>
                                    Image.asset(
                                        'assets/images/placeholder_image.png',
                                        fit: BoxFit.cover),
                              )
                            : Image.asset('assets/images/placeholder_image.png',
                                fit: BoxFit.cover),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                if (weekdays.length == weekvalues.length)
                  Wrap(
                    spacing: 5,
                    runSpacing: 5,
                    alignment: WrapAlignment.center,
                    children: [
                      for (int i = 0; i < weekdays.length; i++)
                        showQuantity(weekdays[i], weekvalues[i])
                    ],
                  ),
                SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () => onDateClick(),
                  child: Container(
                    height: 45,
                    child: Stack(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 8),
                          height: 35.0,
                          decoration: utils.boxDecoration(Colors.transparent,
                              AppColors.lightRedColor, 10.0, 1.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Padding(
                                padding:
                                    EdgeInsets.only(left: 15.0, right: 10.0),
                                child: Icon(Icons.edit_calendar_outlined,
                                    size: 20, color: AppColors.primaryColor),
                              ),
                              // widget.orderModel!.startingDate !=null?utils.poppinsSemiBoldText(widget.orderModel!.startingDate!, 16.0, AppColors.blackColor, TextAlign.start):
                              utils.poppinsSemiBoldText(startingDate, 16.0,
                                  AppColors.blackColor, TextAlign.start),
                              //valueEmpty()
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            color: Colors.white,
                            margin: EdgeInsets.only(left: 5),
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            child: utils.poppinsSemiBoldText("setStartDate".tr,
                                10.0, AppColors.primaryColor, TextAlign.start),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        : SizedBox();
  }

  Widget showQuantity(String weekday, int weekValue) {
    Utils utils = Utils();
    return Container(
      width: 90,
      child: Stack(
        children: [
          Container(
              width: 90.0,
              height: 45.0,
              margin: EdgeInsets.only(top: 6),
              decoration: utils.boxDecoration(
                  AppColors.whiteColor, AppColors.lightRedColor, 10.0, 1.0),
              child: Row(
                children: [
                  if (weekValue != 0)
                    Container(
                      margin: const EdgeInsets.only(left: 5),
                      child: InkWell(
                        onTap: () => decrementFunction(weekday),
                        child: const Icon(Icons.remove_circle_outline,
                            color: AppColors.primaryColor, size: 27.0),
                      ),
                    ),
                  Expanded(
                    child: utils.poppinsSemiBoldText(
                        "${weekValue == 0 ? "Add" : weekValue}",
                        16.0,
                        AppColors.blackColor,
                        TextAlign.center),
                  ),
                  if (weekValue != Common.maximumQuantityCanbeOrdered)
                    Container(
                      margin: const EdgeInsets.only(right: 5),
                      child: InkWell(
                        onTap: () => incrementFunction(weekday),
                        child: const Icon(Icons.add_circle_outline,
                            color: AppColors.primaryColor, size: 27.0),
                      ),
                    ),
                ],
              )),
          Align(
              alignment: Alignment.topCenter,
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: utils.poppinsSemiBoldText(
                    weekday, 10.0, AppColors.primaryColor, TextAlign.center),
              ))
        ],
      ),
    );
  }
}
