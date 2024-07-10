import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:trupressed_subscription/colors.dart';
import 'package:trupressed_subscription/models/order_model.dart';
import 'package:trupressed_subscription/models/product_model.dart';
import 'package:trupressed_subscription/utils/utils.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../common/common.dart';

class SetRepeatingOrderOnceWidget extends StatefulWidget {
  final ProductModel? productModel;
  final OrderModel? orderModel;
  const SetRepeatingOrderOnceWidget(
      {Key? key, this.productModel, this.orderModel})
      : super(key: key);

  @override
  State<SetRepeatingOrderOnceWidget> createState() =>
      _SetRepeatingOrderOnceWidgetState();
}

class _SetRepeatingOrderOnceWidgetState extends State<SetRepeatingOrderOnceWidget> {
  Utils utils = Utils();
  RxString staringDate = DateFormat("yyyy-MM-dd").format(DateTime.now().add(Duration(days: DateTime.now().hour >= 22 ? 2 : 1))).obs;
  RxString endingDate = DateFormat("yyyy-MM-dd")
      .format(
        DateTime.now().add(const Duration(days: 30)),
      )
      .obs;
  String? currentTime;
  var databaseReference = FirebaseDatabase.instance.ref();

  // RxInt selectedDay = 0.obs;

  RxInt mon = 0.obs;
  RxInt tue = 0.obs;
  RxInt wed = 0.obs;
  RxInt thu = 0.obs;
  RxInt fri = 0.obs;
  RxInt sat = 0.obs;
  RxInt sun = 1.obs;

  RxString? lat = ''.obs;
  RxString? lng = ''.obs;
  RxString? address = ''.obs;
  RxString? selectedDay = ''.obs;
  String orderIdKey = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (Common.currentAddress != null) {
      lat!.value = Common.currentLat!;
      lng!.value = Common.currentLng!;
      address!.value = Common.currentAddress!;
      print("Address is ${address!.value}");
    }
    DateTime dateTime = DateTime.now();
    String day = DateFormat('EE, dd MMM').format(dateTime);
    selectedDay!.value = day.split(',').first.toString();
    print('currentDay${selectedDay}');
    setData();
  }

  setData() {
    if (widget.orderModel != null) {
      staringDate.value = widget.orderModel!.startingDate!;
      for (var item in widget.orderModel!.orderDaysModel.values) {
        sun.value = item['quantity'];
        selectedDay!.value = item['day'];
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
                  utils.poppinsSemiBoldText("setQuantity".tr, 18.0,
                      AppColors.blackColor, TextAlign.start),
                  const SizedBox(height: 10),
                  Obx(
                    () => NewOrderCounter(
                      productModel: widget.productModel,
                      incrementFunction: () {
                        sun.value < Common.maximumQuantityCanbeOrdered
                            ? sun.value++
                            : null;
                      },
                      decrementFunction: () {
                        sun.value > 0 ? sun.value-- : null;
                      },
                      value: sun.value,
                      onDateClick: () async {
                        DateTime now = DateTime.now();
                        int hour = now.hour;
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now().add(Duration(days: hour >= 22 ? 2 : 1)),
                          firstDate: DateTime.now().add(Duration(days: hour >= 22 ? 2 : 1)),
                          lastDate: DateTime.now().add(const Duration(days: 365)),
                          builder: (context, child) {
                            return Theme(
                              data: ThemeData.dark().copyWith(
                                colorScheme: ColorScheme.dark(
                                  primary: AppColors.whiteColor,
                                  onPrimary: AppColors.primaryColor,
                                  surface: AppColors.primaryColor,
                                  onSurface: AppColors.whiteColor,
                                  // primary: AppColors.primaryColor,
                                  // onPrimary: AppColors.whiteColor,
                                  // surface: AppColors.primaryColor,
                                  // onSurface: Colors.white,
                                ),
                                dialogBackgroundColor: AppColors.primaryColorLight,
                              ),
                              child: child!,
                            );
                          },
                        );

                        staringDate.value = DateFormat("yyyy-MM-dd").format(pickedDate!);
                        print(staringDate.value);
                        endingDate.value = DateFormat("yyyy-MM-dd").format(pickedDate.add(const Duration(days: 1)));

                        String day = DateFormat('EE, dd MMM').format(pickedDate);
                        selectedDay!.value = day.split(",").first.toString();

                        //DateTime selectedDate=DateTime.parse( DateFormat('EE,dd MMM').format(pickedDate));
                        //print('selectedDay${selectedDate.toString().split(",").first.toString()}');
                      },
                      startingDate: staringDate.value,
                    ),
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
    } else if ((num.parse(Common.wallet.value) <
        (sun.value * num.parse(widget.productModel?.price ?? "0")))) {
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

  Widget renderActionButton() {
    bool shouldDisable = (sun.value == 0 ||
        num.parse(Common.wallet.value) <
            (sun.value * num.parse(widget.productModel?.price ?? "0")));
    return InkWell(
      onTap: shouldDisable ? null :
          () {
        if((DateFormat("yyyy-MM-dd").parse(staringDate.value) == DateFormat("yyyy-MM-dd").format(DateTime.now().add(Duration(days: DateTime.now().hour >= 22 ? 2 : 1))))
            &&( DateTime.now().hour >= 22)){
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      widget.orderModel != null ? payOrderUpdate() : payOrder();
                    },
                    child: const Text('OK'),
                  ),
                ],
                content: Text('Your Order Will Place On Date ${staringDate.value}'),
              );
            },
          );}else{
          widget.orderModel != null ? payOrderUpdate() : payOrder();
        }
          //     .then((value){
          //   widget.orderModel != null ? payOrderUpdate() : payOrder();
          // });
            //  widget.orderModel != null ? payOrderUpdate() : payOrder();
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
            child: utils.poppinsMediumText('Place Order for Once'.toUpperCase(),
                16.0, AppColors.whiteColor, TextAlign.center)),
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
                  onPressed: () => value > 1 ? value.value-- : null,
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
          // const SizedBox(height: 10),
          // utils.poppinsMediumText(day, 16.0, AppColors.blackColor, TextAlign.start),
        ],
      );
    });
  }

  payOrder() async {
    utils.showLoadingDialog();
    List<Map<String, dynamic>?>? items = [];

    DateTime now = DateTime.now();
    int hour = now.hour;
    print('Hour:${hour.toString()}');
    DateTime startingDateTime = DateTime.parse(staringDate.value);

    if ((hour >= 22) && utils.isToday(startingDateTime)) {
      staringDate.value = DateFormat("yyyy-MM-dd")
          .format(startingDateTime.add(const Duration(days: 2)));

      endingDate.value = DateFormat("yyyy-MM-dd").format(
        startingDateTime.add(const Duration(days: 3)),
      );
      String day = DateFormat('EE, dd MMM')
          .format(startingDateTime.add(const Duration(days: 2)));
      selectedDay!.value = day.split(",").first.toString();
    } else if (utils.isToday(startingDateTime)) {
      staringDate.value = DateFormat("yyyy-MM-dd")
          .format(startingDateTime.add(const Duration(days: 1)));

      endingDate.value = DateFormat("yyyy-MM-dd").format(
        startingDateTime.add(const Duration(days: 2)),
      );
      String day = DateFormat('EE, dd MMM')
          .format(startingDateTime.add(const Duration(days: 1)));
      selectedDay!.value = day.split(",").first.toString();
    } else {
      staringDate.value = DateFormat("yyyy-MM-dd").format(startingDateTime);

      endingDate.value = DateFormat("yyyy-MM-dd").format(
        startingDateTime.add(const Duration(days: 1)),
      );
      String day = DateFormat('EE, dd MMM').format(startingDateTime);
      selectedDay!.value = day.split(",").first.toString();
    }
    currentTime = DateTime.now().millisecondsSinceEpoch.toString();

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
      "quantity": widget.productModel!.price,
      "uid": utils.getUserId(),
      // "timeAdded": currentTime,
      "ingredients": widget.productModel!.ingredients,
      "customizationForVariations":
          widget.productModel!.customizationForVariations,
      "customizationForFlavours": widget.productModel!.customizationForFlavours,
      "customizationForDrinks": widget.productModel!.customizationForFlavours,
      // "itemsIncluded": widget.productModel!.customizationForFlavours,
    };
    items.add(data);

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
      'onceOrder': staringDate.value,
      'startingDate': staringDate.value,
      'endingDate': endingDate.value,
      'itemId': widget.productModel!.timeCreated
    };
    await databaseReference
        .child('OnceOrders')
        .push()
        .set(orderData)
        .then((snapShot) {
      addDaysAndQuantity();
      Get.back();
      utils.showToast('Your Order has Successfully Placed');
      Get.back();
      Get.back();
    }).onError((error, stackTrace) {
      Get.back();
      utils.showToast(error.toString());
    });
  }

  Future addDaysAndQuantity() async {
    await databaseReference.child('OnceOrders').get().then((snapShot) {
      for (var item in snapShot.children) {
        Map<dynamic, dynamic> mapGetOrders =
            item.value as Map<dynamic, dynamic>;
        if (mapGetOrders['orderId'] == currentTime) {
          for (int i = 0; i < 7; i++) {
            if (i == 0) {
              Map<String, dynamic> daysAddMap = {
                'day': selectedDay!.value.toString(),
                'quantity': sun.value
              };
              databaseReference
                  .child('OnceOrders')
                  .child(item.key.toString())
                  .child('Days')
                  .push()
                  .set(daysAddMap)
                  .whenComplete(() {});
            }
            // if (i==1)
            // {
            //   Map<String, dynamic> daysAddMap= {
            //     'day':'Mon',
            //     'quantity': mon.value
            //   };
            //   databaseReference.child('Orders').child(item.key.toString()).child('Days').push().set(daysAddMap).whenComplete(() {
            //   });
            // }
            // if (i==2)
            // {
            //   Map<String, dynamic> daysAddMap= {
            //     'day':'Tue',
            //     'quantity': tue.value
            //   };
            //   databaseReference.child('Orders').child(item.key.toString()).child('Days').push().set(daysAddMap).whenComplete(() {
            //   });
            // }
            // if (i==3)
            // {
            //   Map<String, dynamic> daysAddMap= {
            //     'day':'Wed',
            //     'quantity': wed.value
            //   };
            //   databaseReference.child('Orders').child(item.key.toString()).child('Days').push().set(daysAddMap).whenComplete(() {
            //   });
            // }
            // if (i==4)
            // {
            //   Map<String, dynamic> daysAddMap= {
            //     'day':'Thu',
            //     'quantity': thu.value
            //   };
            //   databaseReference.child('Orders').child(item.key.toString()).child('Days').push().set(daysAddMap).whenComplete(() {
            //   });
            // }
            // if (i==5)
            // {
            //   Map<String, dynamic> daysAddMap= {
            //     'day':'Fri',
            //     'quantity': fri.value
            //   };
            //   databaseReference.child('Orders').child(item.key.toString()).child('Days').push().set(daysAddMap).whenComplete(() {
            //   });
            // }
            // if (i==6)
            // {
            //   Map<String, dynamic> daysAddMap= {
            //     'day':'Sat',
            //     'quantity': sat.value
            //   };
            //   databaseReference.child('Orders').child(item.key.toString()).child('Days').push().set(daysAddMap).whenComplete(() {
            //   });
            // }
          }
        }
      }

    });
    Common.updateUserWallet(chargeAmount: (-(double.parse(widget.productModel?.price ?? "0") * (sun.value))),
     orderId: currentTime ??"once_order"
    );
  }

  payOrderUpdate() async {
    utils.showLoadingDialog();

    DateTime now = DateTime.now();
    int hour = now.hour;
    print('Hour:${hour.toString()}');
    DateTime startingDateTime = DateTime.parse(staringDate.value);

    if (hour > 22 || hour == 22) {
      staringDate.value = DateFormat("yyyy-MM-dd")
          .format(startingDateTime.add(const Duration(days: 2)));
      endingDate.value = DateFormat("yyyy-MM-dd").format(
        startingDateTime.add(const Duration(days: 33)),
      );
    } else {
      staringDate.value = DateFormat("yyyy-MM-dd")
          .format(startingDateTime.add(const Duration(days: 1)));
      endingDate.value = DateFormat("yyyy-MM-dd").format(
        startingDateTime.add(const Duration(days: 31)),
      );
    }
    // Query query = await databaseReference
    //     .child('OnceOrders')
    //     .orderByChild('itemId')
    //     .equalTo(widget.productModel!.timeCreated);
    // query.once().then((value) async {
    //   if (value.snapshot.value != null) {
    //     for (var item in value.snapshot.children) {
    //       await databaseReference.child('OnceOrders').child(item.key!).update({
    //         'startingDate': staringDate.value,
    //         'endingDate': endingDate.value
    //       }).whenComplete(() {});
    //       orderIdKey = item.key!;
    //       Query query = databaseReference
    //           .child('OnceOrders')
    //           .child(orderIdKey)
    //           .child('Days');
    //       query.once().then((value) {
    //         if (value.snapshot.value != null) {
    //           for (var item in value.snapshot.children) {
    //             databaseReference
    //                 .child('OnceOrders')
    //                 .child(orderIdKey)
    //                 .child('Days')
    //                 .child(item.key!)
    //                 .update({
    //               'day': selectedDay!.value,
    //               'quantity': sun.value
    //             }).whenComplete(() {
    //               Get.back();
    //               Get.back();
    //               Get.back();
    //               utils.showToast('Your Order has Updated Successfully');
    //             });
    //           }
    //         }
    //       });
    //     }
    //   }
    // });
  }
}

class NewOrderCounter extends StatelessWidget {
  final ProductModel? productModel;
  final Function incrementFunction;
  final Function decrementFunction;
  final Function onDateClick;
  final String startingDate;
  final int value;
  NewOrderCounter({
    super.key,
    this.productModel,
    required this.incrementFunction,
    required this.decrementFunction,
    required this.value,
    required this.onDateClick,
    required this.startingDate,
  });

  final Utils utils = Utils();

  @override
  Widget build(BuildContext context) {
    return (productModel != null)
        ? Container(
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
                      height: 120,
                      width: 120,
                      child: Stack(
                        children: [
                          Center(
                            child: Container(
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
                                                  value: downloadProgress
                                                      .progress)),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Image.asset(
                                                'assets/images/placeholder_image.png',
                                                fit: BoxFit.cover),
                                      )
                                    : Image.asset(
                                        'assets/images/placeholder_image.png',
                                        fit: BoxFit.cover),
                              ),
                            ),
                          ),
                          Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: showQuantity()),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
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

  Widget showQuantity() {
    Utils utils = Utils();
    return Container(
        width: 100.0,
        height: 45.0,
        decoration: utils.boxDecoration(
            AppColors.whiteColor, AppColors.lightRedColor, 10.0, 1.0),
        child: Row(
          children: [
            if (value != 0)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 5),
                child: InkWell(
                  onTap: () => decrementFunction(),
                  child: const Icon(Icons.remove_circle_outline,
                      color: AppColors.primaryColor, size: 27.0),
                ),
              ),
            Expanded(
              child: utils.poppinsSemiBoldText("${value == 0 ? "Add" : value}",
                  16.0, AppColors.blackColor, TextAlign.center),
            ),
            if (value != Common.maximumQuantityCanbeOrdered)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 5),
                child: InkWell(
                  onTap: () => incrementFunction(),
                  child: const Icon(Icons.add_circle_outline,
                      color: AppColors.primaryColor, size: 27.0),
                ),
              ),
          ],
        ));
  }
}
