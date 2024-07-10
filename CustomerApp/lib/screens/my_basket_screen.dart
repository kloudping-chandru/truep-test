import 'package:cached_network_image/cached_network_image.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trupressed_subscription/colors.dart';
import 'package:trupressed_subscription/common/common.dart';
import 'package:trupressed_subscription/models/order_products_with_dates_model.dart';
import 'package:trupressed_subscription/utils/utils.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../common/CommonController.dart';
import '../models/order_model.dart';

class MyBasketScreen extends StatefulWidget {
  const MyBasketScreen({Key? key}) : super(key: key);

  @override
  State<MyBasketScreen> createState() => _MyBasketScreenState();
}

class _MyBasketScreenState extends State<MyBasketScreen> {
  Utils utils = Utils();
  RxInt selectedTab = 0.obs;
  var databaseReference = FirebaseDatabase.instance.ref();
  RxBool hasOrders = false.obs;
  RxString endingDate = ''.obs;
  RxInt weeklyShowOrder = 0.obs;

  List<String> datesList = [];
  RxList<OrderProductsWithDatesModel> orderProductsList =
      <OrderProductsWithDatesModel>[].obs;
  RxList<OrderModel> orderOnceData = <OrderModel>[].obs;
  CommonController commonController = CommonController();
  RxBool onceOrder = false.obs;
  Common common = Common();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // your code here
      Common.orderData.clear();
      Common.orderDataWithOnce.clear();
      orderOnceData.clear();
      getOrders();
      getWeekDays();
    });

    //getOnceOrders();
  }

  getOnceOrders() {
    orderOnceData.clear();
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
          orderOnceData.add(orderModel);
          Common.orderDataWithOnce.add(orderModel);
          print('onceOrderModelLength:${Common.orderDataWithOnce.length}');
          print('hasorder:${hasOrders.value}');
          //print('orderOnceLength${orderOnceData.length}');
        }
      }
      onceOrder.value = true;
    });
  }

  void getWeekDays() {
    DateTime weekStartingDate = DateTime.now().add(const Duration(days: 1));
    for (int i = 0; i < 7; i++) {
      if (i == 0) {
        datesList.add(DateFormat("yyyy-MM-dd").format(weekStartingDate));
      } else {
        datesList.add(DateFormat("yyyy-MM-dd")
            .format(weekStartingDate.add(Duration(days: i))));
        print('DatesList:${datesList[i]}');
      }
    }
  }

  Future getOrders() async {
    Common.orderData.clear();
    databaseReference
        .child("Orders")
        .orderByChild('uid')
        .equalTo(utils.getUserId())
        .onChildAdded
        .listen((event) {
      if (event.snapshot.value != null) {
        OrderModel orderModel;
        orderModel = OrderModel.fromJson(Map.from(event.snapshot.value as Map));
        String dateFormat = DateFormat("yyyy-MM-dd")
            .format(DateTime.parse(orderModel.endingDate!));
        DateTime splitOrderDate = DateTime.parse(dateFormat);

        String todayDate = DateFormat("yyyy-MM-dd").format(DateTime.now());
        DateTime todayDateInFormat = DateTime.parse(todayDate);

        if (orderModel.status == 'requested' &&
            splitOrderDate.compareTo(todayDateInFormat) > 0) {
          Common.orderData.add(orderModel);
          CommonController.cartValue!.value = '';
          CommonController.cartValue!.value =
              Common.orderData.length.toString();

          Common.orderDataWithOnce.add(orderModel);

          debugPrint('1stLengthCheck:${Common.orderDataWithOnce.length}');

          // databaseReference.child('Orders').child(event.snapshot.key.toString()).child('Days').get().then((value) {
          //   if (value.value != null) {
          //     for (var item in value.children) {
          //       OrderDaysModel orderDaysModel = OrderDaysModel.fromJson(Map.from(item.value as Map));
          //       Common.orderDaysData.add(orderDaysModel);
          //     }
          //   } else {
          //     print('Null Data');
          //   }
          // });
        }
      }
      hasOrders.value = true;
    });
    getOnceOrders();
    hasOrders.value = true;
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
              'myBasket'.tr, 16.0, AppColors.blackColor, TextAlign.center),
          centerTitle: true,
        ),
        body: Obx(
          () => hasOrders.value == true
              ? Column(
                  children: [
                    Container(
                      height: 65,
                      color: AppColors.whiteColor,
                      child: Row(
                        children: [
                          Expanded(child: tabWidget("tomorrowOrder".tr, 0)),
                          Expanded(child: tabWidget("comingWeek".tr, 1)),
                          Expanded(child: tabWidget("", 2)),
                          // Expanded(child: tabWidget(Common.orderOnce, 3)),
                        ],
                      ),
                    ),
                    if (selectedTab.value == 0) tomorrowOrderDataShow(),

                    if (selectedTab.value == 1) weekOrder(),

                    if (selectedTab.value == 2)
                      Common.orderDataWithOnce.isNotEmpty
                          ? calenderOrder()
                          : Expanded(
                            child: Center(
                            child: utils.helveticaSemiBoldText(
                                'No Orders Found!',
                                20.0,
                                AppColors.blackColor,
                                TextAlign.center),
                                                            ),
                          ),
                    // if(selectedTab.value ==3)
                    //   orderOnceData.isNotEmpty?
                    //   Container(
                    //     height: Get.height * 0.8,
                    //     child: ListView(children: OrderOnceDataList()),
                    //   ):
                    //  Expanded(
                    //       child: Center(
                    //         child: utils.helveticaSemiBoldText(
                    //             'No Orders Found!', 20.0, AppColors.blackColor, TextAlign.center),
                    //       )
                    //  ),
                  ],
                )
              : Center(
                  child: Container(
                  height: 200,
                  child: const Center(
                      child: CircularProgressIndicator(
                          backgroundColor: AppColors.primaryColor,
                          color: AppColors.whiteColor)),
                )),
        ));
  }

  OnceOrderData() {
    for (int i = 0; i < orderOnceData.length; i++) {
      return Container(
        margin: const EdgeInsets.only(top: 5),
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
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
                      utils.poppinsMediumText(
                          orderOnceData[i].items![0]!["title"],
                          18.0,
                          AppColors.blackColor,
                          TextAlign.start),
                      // utils.poppinsMediumText("500 ML", 14.0, AppColors.lightGreyColor, TextAlign.start),
                      Container(
                        width: 300,
                        child: utils.poppinsMediumText(
                            orderOnceData[i].items![0]!["details"],
                            14.0,
                            AppColors.lightGreyColor,
                            TextAlign.start,
                            maxlines: 2),
                      ),

                      utils.poppinsMediumText(
                          "${Common.currency} ${orderOnceData[i].items![0]!["newPrice"]}",
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
                  padding: const EdgeInsets.all(12.0),
                  child: ClipRRect(
                    child: orderOnceData[i].items![0]!["image"].isNotEmpty
                        ? CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl: orderOnceData[i].items![0]!["image"],
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
              ],
            ),
            const SizedBox(height: 10),
            //showQuantity(widget.orderModel![i], widget.date),
          ],
        ),
      );
    }
  }

  List<Widget> OrderOnceDataList() {
    List<Widget> onceOrderList = [];

    for (int i = 0; i < orderOnceData.length; i++) {
      onceOrderList.add(Container(
        margin: const EdgeInsets.only(top: 5),
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
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
                      utils.poppinsMediumText(
                          orderOnceData[i].items![0]!["title"],
                          18.0,
                          AppColors.blackColor,
                          TextAlign.start),
                      // utils.poppinsMediumText("500 ML", 14.0, AppColors.lightGreyColor, TextAlign.start),
                      Container(
                        width: 300,
                        child: utils.poppinsMediumText(
                            orderOnceData[i].items![0]!["details"],
                            14.0,
                            AppColors.lightGreyColor,
                            TextAlign.start,
                            maxlines: 2),
                      ),
                      utils.poppinsMediumText(
                          "${Common.currency} ${orderOnceData[i].items![0]!["newPrice"]}",
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
                  padding: const EdgeInsets.all(12.0),
                  child: ClipRRect(
                    child: orderOnceData[i].items![0]!["image"].isNotEmpty
                        ? CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl: orderOnceData[i].items![0]!["image"],
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
              ],
            ),
            const SizedBox(height: 10),
            //showQuantity(widget.orderModel![i], widget.date),
          ],
        ),
      ));
    }

    return onceOrderList;
  }

  Widget tabWidget(String text, int index) {
    return InkWell(
      onTap: () {
        selectedTab.value = index;
        Common.orderData.clear();
        Common.orderDataWithOnce.clear();
        getOrders();
      },
      child: Column(
        children: [
          const SizedBox(height: 10),
          Expanded(
            child: Align(
              alignment: Alignment.center,
              child: index == 2
                  ? Icon(Icons.calendar_month_outlined,
                      size: 25,
                      color: selectedTab.value == 2
                          ? AppColors.blackColor
                          : AppColors.lightGreyColor)
                  : utils.poppinsMediumText(
                      text,
                      13.0,
                      selectedTab.value == index
                          ? AppColors.blackColor
                          : AppColors.lightGreyColor,
                      TextAlign.center),
            ),
          ),
          const SizedBox(height: 10),
          Container(
              height: 2,
              color: selectedTab.value == index
                  ? AppColors.primaryColor
                  : Colors.transparent),
        ],
      ),
    );
  }

  /// New Lamda function
  updateOrderFunction() {
    print('Hello World');
    utils.showLoadingDialog();
    Common.orderData.clear();
    Common.orderDataWithOnce.clear();
    orderOnceData.clear();
    datesList.clear();
    hasOrders.value = false;
    onceOrder.value = false;
    setState(() {
      getOrders();
      getWeekDays();
    });
    Get.back();
  }

  Widget weekOrder() {
    print("inside tomorrow");
    List<OrderModel> newList = [];
    List<Widget> ordersListNew = [];
    newList.clear();
    for (int weekIndex = 1; weekIndex <= 7; weekIndex++) {
      newList = [];
      DateTime tomorrowDateDate = DateTime.parse(DateFormat("yyyy-MM-dd")
          .format(DateTime.now().add(Duration(days: weekIndex))));
      print('CommonOrderLength:${Common.orderDataWithOnce.length}');
      for (int i = 0; i < Common.orderDataWithOnce.length; i++) {
        DateTime startOrderDate =
            DateTime.parse(Common.orderDataWithOnce[i].startingDate!);
        DateTime endingOrderDate =
            DateTime.parse(Common.orderDataWithOnce[i].endingDate!);
        if ((tomorrowDateDate.compareTo(startOrderDate) > 0 ||
                tomorrowDateDate.compareTo(startOrderDate) == 0) &&
            endingOrderDate.compareTo(tomorrowDateDate) > 0) {
          String date = DateFormat("EE, dd MMM").format(tomorrowDateDate);
          RxString quantity = "".obs;
         // String day = '';

          for (var item in Common.orderDataWithOnce[i].orderDaysModel.values) {
            if (item["day"].toString() == date.split(',').first) {
              quantity.value = item["quantity"].toString();
             // day = item['day'].toString();
              if (int.parse(quantity.value.toString()) > 0) {
                newList.add(Common.orderDataWithOnce[i]);
                // hasOrder= true;
              }
              break;
            }
          }

          //  newList.add(Common.orderDataWithOnce[i]);
          // DateTime dateTimeCurrent = DateTime.parse(datesList[i].toString());
          // ordersListNew.add(OrderWidget(date: DateFormat("EE, dd MMM").format(dateTimeCurrent), orderModel:Common.orderData[j]),
          // );
        }
      }
      ordersListNew.add(
        OrderWidget(
            date: DateFormat("EE, dd MMM").format(tomorrowDateDate),
            orderModel: newList,
            function: () => updateOrderFunction()),
      );
    }
    return Expanded(
      child: ListView(
        children: ordersListNew,
      ),
    );
  }

  /// i comment
  Rx<DateTime> focusDay = DateTime.now().obs;

  Widget calenderOrder() {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            CalendarDatePicker2(
              config: CalendarDatePicker2Config(
                selectedDayHighlightColor: AppColors.primaryColor,
                weekdayLabels: [
                  'Sun',
                  'Mon',
                  'Tue',
                  'Wed',
                  'Thu',
                  'Fri',
                  'Sat'
                ],
                weekdayLabelTextStyle: const TextStyle(
                    color: Colors.black87, fontWeight: FontWeight.bold),
                firstDayOfWeek: 1,
                controlsHeight: 50,
                firstDate: DateTime.now(),
                lastDate: DateTime(2030),
                // DateTime(
                //     DateTime.now().year, DateTime.now().month, DateTime(DateTime.now().year, DateTime.now().month + 1, 0).day),
                controlsTextStyle: const TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
                dayTextStyle: const TextStyle(
                    color: AppColors.blackColor, fontWeight: FontWeight.bold),
                disabledDayTextStyle: const TextStyle(color: Colors.grey),
              ),
              value: [focusDay.value],
              onValueChanged: (dates) => focusDay.value = dates.first!,
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Container(
                  child: Column(
                    children: montlyDataShow(focusDay.value),
                  ),
                )
                // child: OrderWidget(date: DateFormat("EE, dd MMM").format(focusDay.value), orderModel: Common.orderData,body: 'Calender'),
                ),
          ],
        ),
      ),
    );
  }

  /// i comment
  List<Widget> montlyDataShow(DateTime selectedDate) {
    List<OrderModel> newList = [];
    List<Widget> ordersListNew = [];
    newList.clear();

    print('CommonOrderLength:${Common.orderDataWithOnce.length}');
    for (int i = 0; i < Common.orderDataWithOnce.length; i++) {
      DateTime startOrderDate =
          DateTime.parse(Common.orderDataWithOnce[i].startingDate!);
      DateTime endingOrderDate =
          DateTime.parse(Common.orderDataWithOnce[i].endingDate!);
      if ((selectedDate.compareTo(startOrderDate) > 0 ||
              selectedDate.compareTo(startOrderDate) == 0) &&
          endingOrderDate.compareTo(selectedDate) > 0) {
        String date = DateFormat("EE, dd MMM").format(selectedDate);
        RxString quantity = "".obs;
        //String day = '';

        for (var item in Common.orderDataWithOnce[i].orderDaysModel.values) {
          if (item["day"].toString() == date.split(',').first) {
            quantity.value = item["quantity"].toString();
           // day = item['day'].toString();
            if (int.parse(quantity.value.toString()) > 0) {
              newList.add(Common.orderDataWithOnce[i]);
              // hasOrder= true;
            }
            break;
          }
        }

        //  newList.add(Common.orderDataWithOnce[i]);
        // DateTime dateTimeCurrent = DateTime.parse(datesList[i].toString());
        // ordersListNew.add(OrderWidget(date: DateFormat("EE, dd MMM").format(dateTimeCurrent), orderModel:Common.orderData[j]),
        // );
      }
    }
    ordersListNew.add(
      OrderWidget(
          date: DateFormat("EE, dd MMM").format(selectedDate),
          orderModel: newList,
          function: () => updateOrderFunction()),
    );
    return ordersListNew;
  }

  Widget tomorrowOrderDataShow() {
    print("inside tomorrow");
    List<OrderModel> newList = [];
    List<Widget> ordersListNew = [];
    newList.clear();
    DateTime tomorrowDateDate = DateTime.parse(
        DateFormat("yyyy-MM-dd").format(DateTime.now().add(Duration(days: 1))));
    print('CommonOrderLength:${Common.orderDataWithOnce.length}');
    for (int i = 0; i < Common.orderDataWithOnce.length; i++) {
      DateTime startOrderDate =
          DateTime.parse(Common.orderDataWithOnce[i].startingDate!);
      DateTime endingOrderDate =
          DateTime.parse(Common.orderDataWithOnce[i].endingDate!);
      if ((tomorrowDateDate.compareTo(startOrderDate) > 0 ||
              tomorrowDateDate.compareTo(startOrderDate) == 0) &&
          endingOrderDate.compareTo(tomorrowDateDate) > 0) {
        String date = DateFormat("EE, dd MMM").format(tomorrowDateDate);
        RxString quantity = "".obs;
        String day = '';

        for (var item in Common.orderDataWithOnce[i].orderDaysModel.values) {
          if (item["day"].toString() == date.split(',').first) {
            quantity.value = item["quantity"].toString();
            day = item['day'].toString();
            if (int.parse(quantity.value.toString()) > 0) {
              newList.add(Common.orderDataWithOnce[i]);
              // hasOrder= true;
            }
            break;
          }
        }

        //  newList.add(Common.orderDataWithOnce[i]);
        // DateTime dateTimeCurrent = DateTime.parse(datesList[i].toString());
        // ordersListNew.add(OrderWidget(date: DateFormat("EE, dd MMM").format(dateTimeCurrent), orderModel:Common.orderData[j]),
        // );
      }
    }
    if (newList.isEmpty) {
      return Expanded(
          child: Center(
        child: utils.helveticaSemiBoldText(
            'No Orders Found!', 20.0, AppColors.blackColor, TextAlign.center),
      ));
    }
    ordersListNew.add(
      OrderWidget(
          date: DateFormat("EE, dd MMM").format(tomorrowDateDate),
          orderModel: newList,
          function: () => updateOrderFunction()),
    );
    return Expanded(
      child: ListView(
        children: ordersListNew,
      ),
    );
  }

  // Widget weekOrder1() {
  //   print("inside tomorrow");
  //   List<OrderModel> newList = [];
  //   List<Widget> ordersListNew = [];
  //
  //   print('CommonOrderLength:${Common.orderDataWithOnce.length}');
  //
  //   for (int weekIndex = 0; weekIndex < 7; weekIndex++) {
  //     newList.clear();
  //     DateTime weekIndexDate = DateTime.parse(DateFormat("yyyy-MM-dd")
  //         .format(DateTime.now().add(Duration(days: weekIndex))));
  //     for (int i = 0; i < Common.orderDataWithOnce.length; i++) {
  //       DateTime startOrderDate =
  //           DateTime.parse(Common.orderDataWithOnce[i].startingDate!);
  //       DateTime endingOrderDate =
  //           DateTime.parse(Common.orderDataWithOnce[i].endingDate!);
  //       if ((weekIndexDate.compareTo(startOrderDate) > 0 ||
  //               weekIndexDate.compareTo(startOrderDate) == 0) &&
  //           endingOrderDate.compareTo(weekIndexDate) > 0) {
  //         String date = DateFormat("EE, dd MMM").format(weekIndexDate);
  //         RxString quantity = "".obs;
  //         String day = '';
  //
  //         for (var item in Common.orderDataWithOnce[i].orderDaysModel.values) {
  //           if (item["day"].toString() == date.split(',').first) {
  //             quantity.value = item["quantity"].toString();
  //             day = item['day'].toString();
  //             if (int.parse(quantity.value.toString()) > 0) {
  //               newList.add(Common.orderDataWithOnce[i]);
  //               // hasOrder= true;
  //             }
  //             break;
  //           }
  //         }
  //
  //         //  newList.add(Common.orderDataWithOnce[i]);
  //         // DateTime dateTimeCurrent = DateTime.parse(datesList[i].toString());
  //         // ordersListNew.add(OrderWidget(date: DateFormat("EE, dd MMM").format(dateTimeCurrent), orderModel:Common.orderData[j]),
  //         // );
  //       }
  //     }
  //     if (newList.isEmpty) {
  //       ordersListNew.add(utils.helveticaSemiBoldText(
  //           'No Orders Found!', 20.0, AppColors.blackColor, TextAlign.center));
  //       //  Expanded(
  //       //     child: Center(
  //       //   child: utils.helveticaSemiBoldText(
  //       //       'No Orders Found!', 20.0, AppColors.blackColor, TextAlign.center),
  //       // ));
  //     }
  //     ordersListNew.add(
  //       OrderWidget(
  //           date: DateFormat("EE, dd MMM").format(weekIndexDate),
  //           orderModel: newList,
  //           function: () => updateOrderFunction()),
  //     );
  //   }
  //   return Container(
  //     height: Get.height * 0.8,
  //     child: ListView(
  //       children: ordersListNew,
  //     ),
  //   );
  // }
}

/// Show widgets
class OrderWidget extends StatefulWidget {
  final String? date;
  final List<OrderModel>? orderModel;
  final String? body;
  final String? status;
  final Function function;

  // final OrderModel? orderModel;

  const OrderWidget(
      {Key? key,
      this.date,
      this.orderModel,
      this.body,
      this.status,
      required this.function})
      : super(key: key);

  @override
  State<OrderWidget> createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<OrderWidget> {
  Utils utils = Utils();

  // RxInt itemIndex = 0.obs;
  var databaseReference = FirebaseDatabase.instance.ref();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getWeekDaysOrder();
  }

  @override
  Widget build(BuildContext context) {
    DateTime dateTime = DateTime.now().add(const Duration(days: 1));
    String day = DateFormat('EE, dd MMM').format(dateTime);
    String tommorowday = day.split(',').first.toString();

    print('widgetDate:${widget.date}');
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 15),
        Row(
          children: [
            const Icon(Icons.calendar_month,
                size: 25, color: AppColors.blackColor),
            const SizedBox(width: 10),
            utils.poppinsSemiBoldText(
                widget.date, 14.0, AppColors.blackColor, TextAlign.center),
          ],
        ),
        const SizedBox(height: 15),
        Column(
          children: [
            if (widget.orderModel!.isEmpty)
              Container(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: utils.poppinsMediumText(
                      'No Orders Found for this date!',
                      18.0,
                      AppColors.blackColor,
                      TextAlign.center)),
            for (int i = 0; i < widget.orderModel!.length; i++)
              // showOrders(widget.orderModel![i],widget.date!)
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                padding: const EdgeInsets.symmetric(
                    horizontal: 15.0, vertical: 10.0),
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
                              utils.poppinsMediumText(
                                  widget.orderModel![i].items![0]!["title"],
                                  18.0,
                                  AppColors.blackColor,
                                  TextAlign.start),
                              // utils.poppinsMediumText("500 ML", 14.0, AppColors.lightGreyColor, TextAlign.start),
                              Container(
                                width: 300,
                                child: utils.poppinsMediumText(
                                    widget.orderModel![i].items![0]!["details"],
                                    14.0,
                                    AppColors.lightGreyColor,
                                    TextAlign.start,
                                    maxlines: 2),
                              ),

                              utils.poppinsMediumText(
                                  "${Common.currency} ${widget.orderModel![i].items![0]!["newPrice"]}",
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
                          padding: const EdgeInsets.all(12.0),
                          child: ClipRRect(
                            child: widget.orderModel![i].items![0]!["image"]
                                    .isNotEmpty
                                ? CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    imageUrl: widget
                                        .orderModel![i].items![0]!["image"],
                                    progressIndicatorBuilder:
                                        (context, url, downloadProgress) =>
                                            SizedBox(
                                      height: 50,
                                      width: 50,
                                      child: Center(
                                          child: CircularProgressIndicator(
                                              value:
                                                  downloadProgress.progress)),
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
                      ],
                    ),
                    const SizedBox(height: 10),
                    showQuantity(widget.orderModel![i], widget.date),
                  ],
                ),
              )
          ],
        ),
      ],
    );
    // : widget.status == "weekOrders"
    //     ? widget.date!.split(',').first == tommorowday
    //         ? Container(
    //             height: Get.height / 3,
    //             child: Align(
    //               alignment: Alignment.bottomCenter,
    //               child: utils.poppinsSemiBoldText(
    //                   'No Orders Found for this date!',
    //                   18.0,
    //                   AppColors.blackColor,
    //                   TextAlign.center),
    //             ))
    //         : SizedBox()
    //     : Container(
    //         height: Get.height / 3,
    //         child: Align(
    //           alignment: Alignment.bottomCenter,
    //           child: utils.poppinsSemiBoldText(
    //               'No Orders Found for this date!',
    //               18.0,
    //               AppColors.blackColor,
    //               TextAlign.center),
    //         ));
  }

  Widget showQuantity(OrderModel orderModel, String? date) {
    RxString quantity = "".obs;
    Utils utils = Utils();
    String day = '';
    // for(int i =0; i< orderModel.orderDaysModel.values.length; i++)
    //   {
    //     if (orderModel.orderDaysModel.values[i]["day"].toString() == date!.split(',').first) {
    //       quantity.value = orderModel.orderDaysModel.values[i]["quantity"].toString();
    //       day = orderModel.orderDaysModel.values[i]['day'].toString();
    //       break;
    //     }
    //   }
    for (var item in orderModel.orderDaysModel.values) {
      if (item["day"].toString() == date!.split(',').first) {
        quantity.value = item["quantity"].toString();
        day = item['day'].toString();
        break;
      }
    }
    double newPrice = double.parse(orderModel.items![0]!["newPrice"]);
    print("Check error");
    print(quantity.value);
    print((quantity.value).runtimeType);
    return Obx(() => orderModel.orderDaysModel.values.length > 2
        ? int.parse(quantity.value) > 0
            ? Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 5),
                    child: InkWell(
                      onTap: () {
                        if (int.parse(quantity.value) > 0) {
                          if (int.parse(quantity.value) == 1) {
                            utils.showLoadingDialog();
                          }
                          int tempQty = int.parse(quantity.value);

                          quantity.value = (int.parse(quantity.value) - 1).toString();
                          databaseReference.child('Orders').get().then((snapShot) {
                            for (var item in snapShot.children) {
                              Map<dynamic, dynamic> values = item.value as Map<dynamic, dynamic>;
                              if (values['orderId'] == orderModel.orderId) {
                                for (var itemDays in orderModel.orderDaysModel.values) {
                                  if (itemDays['day'].toString() == day) {
                                    Query querry = databaseReference.child('Orders').child(item.key.toString()).child('Days').orderByChild('day').equalTo(day);
                                    querry.once().then((DatabaseEvent event) {
                                      if (event.snapshot.exists) {
                                        Map<dynamic, dynamic> mapsData = event.snapshot.value as Map<dynamic, dynamic>;
                                        mapsData.keys.forEach((value) async {
                                          await databaseReference.child('Orders').child(item.key.toString()).child('Days').child(value.toString())
                                              .update({'quantity': quantity.value}).whenComplete(() {
                                            RxInt startDay = 0.obs;
                                            databaseReference.child('OrdersHistory').get().then((value) {
                                              for(var item in value.children) {
                                                Map<dynamic,dynamic> mapData = item.value as Map<dynamic,dynamic>;
                                                if(mapData['orderId'] == orderModel.orderId) {
                                                  orderModel.status!.toLowerCase() == "delivered" ? startDay.value = 1 : startDay.value;
                                                }
                                              }
                                            });
                                            addWalletPayment(orderModel: orderModel, startDays: 1,daysName: day,isAddQty: false);
                                            if (int.parse(quantity.value) < 1) {
                                              Get.back();
                                              widget.function();
                                            }
                                            utils.showToast('Your Order has Successfully Updated');
                                          });
                                        });
                                      }
                                    });
                                  }
                                }
                              }
                            }
                          }).then((value){
                           // Common.updateUserWallet(chargeAmount: (newPrice),orderId: orderModel.orderId ?? "Cart_order");
                          });
                        } else {
                          //   widget.function();
                        }
                      },
                      child: const Icon(Icons.remove_circle_outline,
                          color: AppColors.primaryColor, size: 27.0),
                    ),
                  ),
                  //Obx(() =>   utils.poppinsSemiBoldText(quantity.value, 16.0, AppColors.blackColor, TextAlign.center),),
                  utils.poppinsSemiBoldText(quantity.value, 16.0,
                      AppColors.blackColor, TextAlign.center),
                  Container(
                    margin: const EdgeInsets.only(left: 5),
                    child: InkWell(
                      onTap: () {
                        quantity.value = (int.parse(quantity.value) + 1).toString();
                        databaseReference.child('Orders').get().then((snapShot) {
                          for (var item in snapShot.children) {
                            Map<dynamic, dynamic> values =
                                item.value as Map<dynamic, dynamic>;
                            if (values['orderId'] == orderModel.orderId) {
                              for (var itemDays
                                  in orderModel.orderDaysModel.values) {
                                if (itemDays['day'].toString() == day) {
                                  Query querry = databaseReference.child('Orders').child(item.key.toString()).child('Days').orderByChild('day').equalTo(day);
                                  querry.once().then((DatabaseEvent event) {
                                    if (event.snapshot.exists) {
                                      Map<dynamic, dynamic> mapsData = event.snapshot.value as Map<dynamic, dynamic>;
                                      mapsData.keys.forEach((value) async {
                                        await databaseReference.child('Orders').child(item.key.toString()).child('Days').child(value.toString())
                                            .update({'quantity': quantity.value
                                        }).whenComplete(() {
                                          RxInt startDay = 0.obs;
                                          databaseReference.child('OrdersHistory').get().then((value) {
                                            for(var item in value.children) {
                                              Map<dynamic,dynamic> mapData = item.value as Map<dynamic,dynamic>;
                                              if(mapData['orderId'] == orderModel.orderId) {
                                                orderModel.status!.toLowerCase() == "delivered" ? startDay.value = 1 : startDay.value;
                                              }
                                            }
                                          });
                                          addWalletPayment(orderModel: orderModel, startDays: 1,daysName: day,isAddQty: true);
                                          utils.showToast('Your Order has Successfully Updated');});
                                      });
                                    }
                                  });
                                }
                              }
                            }
                          }
                        }).then((value){
                         // Common.updateUserWallet(chargeAmount: (-newPrice),orderId: orderModel.orderId ?? "Cart_order");
                        });
                      },
                      child: const Icon(Icons.add_circle_outlined,
                          color: AppColors.primaryColor, size: 27.0),
                    ),
                  ),
                ],
              )
            :
            //  InkWell(
            //   onTap: ()
            //   {
            //     quantity.value = (int.parse(quantity.value) + 1).toString();
            //     databaseReference.child('Orders').get().then((snapShot) {
            //       for (var item in snapShot.children) {
            //         Map<dynamic, dynamic> values = item.value as Map<dynamic, dynamic>;
            //         if (values['orderId'] == orderModel.orderId) {
            //           for (var itemDays in orderModel.orderDaysModel.values) {
            //             if (itemDays['day'].toString() == day) {
            //               Query querry = databaseReference
            //                   .child('Orders')
            //                   .child(item.key.toString())
            //                   .child('Days')
            //                   .orderByChild('day')
            //                   .equalTo(day);
            //               querry.once().then((DatabaseEvent event) {
            //                 if (event.snapshot.exists) {
            //                   Map<dynamic, dynamic> mapsData = event.snapshot.value as Map<dynamic, dynamic>;
            //                   mapsData.keys.forEach((value) async {
            //                     await databaseReference
            //                         .child('Orders')
            //                         .child(item.key.toString())
            //                         .child('Days')
            //                         .child(value.toString())
            //                         .update({'quantity': quantity.value}).whenComplete(() => utils.showToast('Your Order has Sucessfully Updated'));
            //                   });
            //                 }
            //               });
            //             }
            //           }
            //         }
            //       }
            //     });
            //   },
            //   child: Container(
            //     width: 250,
            //     padding: const EdgeInsets.symmetric(
            //         horizontal: 20.0, vertical: 7.0),
            //     margin: const EdgeInsets.symmetric(
            //         horizontal: 10.0, vertical: 10.0),
            //     decoration: utils.boxDecoration(
            //         AppColors.primaryColor, Colors.transparent, 20.0, 0.0),
            //     child: Center(
            //         child: utils.poppinsMediumText('subscribe'.tr, 16.0,
            //             AppColors.whiteColor, TextAlign.center)),
            //   ),
            // )
            SizedBox()
        : int.parse(quantity.value) > 0
            ? Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 5),
                    child: InkWell(
                      onTap: () {
                        if (int.parse(quantity.value) > 0) {
                          if (int.parse(quantity.value) == 1) {
                            utils.showLoadingDialog();
                            databaseReference.child('OnceOrders').get().then((value) {
                              if (value.value != null) {
                                for (var item in value.children) {
                                  Map<dynamic, dynamic> values =
                                      item.value as Map<dynamic, dynamic>;
                                  if (values['orderId'] == orderModel.orderId) {
                                    databaseReference.child('OnceOrders').child(item.key!).remove()
                                        .whenComplete(() {
                                      Get.back();
                                      widget.function();
                                    });
                                  }
                                }
                              }
                            });
                          } else {
                            quantity.value = (int.parse(quantity.value) - 1).toString();
                            print('quantity${quantity.value}');
                            databaseReference.child('OnceOrders').get().then((snapShot) {
                              for (var item in snapShot.children) {
                                Map<dynamic, dynamic> values = item.value as Map<dynamic, dynamic>;
                                if (values['orderId'] == orderModel.orderId) {
                                  for (var itemDays in orderModel.orderDaysModel.values) {
                                    if (itemDays['day'].toString() == day) {
                                      Query querry = databaseReference.child('OnceOrders').child(item.key.toString()).child('Days')
                                          .orderByChild('day').equalTo(day);
                                      querry.once().then((DatabaseEvent event) {
                                        if (event.snapshot.exists) {
                                          Map<dynamic, dynamic> mapsData = event.snapshot.value as Map<dynamic, dynamic>;
                                          mapsData.keys.forEach((value) async {
                                            await databaseReference.child('OnceOrders').child(item.key.toString()).child('Days').child(value.toString())
                                                .update({'quantity': quantity.value
                                            }).whenComplete(() {
                                              utils.showToast('Your Order has Successfully Updated');
                                              // widget.function();
                                            });
                                          });
                                        }
                                      });
                                    }
                                  }
                                }
                              }
                            }).then((value){

                              Common.updateUserWallet(chargeAmount: (newPrice),orderId: orderModel.orderId ?? "Cart_order");
                              // Common.updateUserWallet(chargeAmount: (newPrice * (tempQty - int.parse(quantity.value.toString()))));
                            });
                          }
                        }
                      },
                      child: const Icon(Icons.remove_circle_outline,
                          color: AppColors.primaryColor, size: 27.0),
                    ),
                  ),
                  //Obx(() =>   utils.poppinsSemiBoldText(quantity.value, 16.0, AppColors.blackColor, TextAlign.center),),
                  utils.poppinsSemiBoldText(quantity.value, 16.0,
                      AppColors.blackColor, TextAlign.center),
                  Container(
                    margin: const EdgeInsets.only(left: 5),
                    child: InkWell(
                      onTap: () {
                        quantity.value = (int.parse(quantity.value) + 1).toString();
                        databaseReference.child('OnceOrders').get().then((snapShot) {
                          for (var item in snapShot.children) {
                            Map<dynamic, dynamic> values = item.value as Map<dynamic, dynamic>;
                            if (values['orderId'] == orderModel.orderId) {
                              for (var itemDays in orderModel.orderDaysModel.values) {
                                if (itemDays['day'].toString() == day) {
                                  Query querry = databaseReference.child('OnceOrders').child(item.key.toString()).child('Days').orderByChild('day').equalTo(day);
                                  querry.once().then((DatabaseEvent event) {
                                    if (event.snapshot.exists) {
                                      Map<dynamic, dynamic> mapsData = event.snapshot.value as Map<dynamic, dynamic>;
                                      mapsData.keys.forEach((value) async {
                                        await databaseReference.child('OnceOrders').child(item.key.toString()).child('Days').child(value.toString())
                                            .update({'quantity': quantity.value
                                        }).whenComplete(() => utils.showToast('Your Order has Successfully Updated'));
                                      });
                                    }
                                  });
                                }
                              }
                            }
                          }
                        }).then((value){
                          Common.updateUserWallet(chargeAmount: (-newPrice),orderId: orderModel.orderId ?? "Cart_order");
                        });
                      },
                      child: const Icon(Icons.add_circle_outlined,
                          color: AppColors.primaryColor, size: 27.0),
                    ),
                  ),
                ],
              )
            : SizedBox());
    // return utils.poppinsSemiBoldText(quantity, 16.0, AppColors.blackColor, TextAlign.center);
  }

  Widget showOrders(OrderModel orderModel, String date) {
    RxString quantity = "".obs;
    String day = '';
    bool hasOrder = false;
    for (var item in orderModel.orderDaysModel.values) {
      if (item["day"].toString() == date.split(',').first) {
        quantity.value = item["quantity"].toString();
        day = item['day'].toString();
        if (int.parse(quantity.value.toString()) > 0) {
          hasOrder = true;
        }
        break;
      }
    }
    return hasOrder == true
        ? Container(
            margin: EdgeInsets.only(top: 5),
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
                          utils.poppinsMediumText(
                              orderModel.items![0]!["title"],
                              18.0,
                              AppColors.blackColor,
                              TextAlign.start),
                          // utils.poppinsMediumText("500 ML", 14.0, AppColors.lightGreyColor, TextAlign.start),
                          Container(
                            width: 300,
                            child: utils.poppinsMediumText(
                                orderModel.items![0]!["details"],
                                14.0,
                                AppColors.lightGreyColor,
                                TextAlign.start,
                                maxlines: 2),
                          ),

                          utils.poppinsMediumText(
                              "${Common.currency} ${orderModel.items![0]!["newPrice"]}",
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
                      padding: const EdgeInsets.all(12.0),
                      child: ClipRRect(
                        child: orderModel.items![0]!["image"].isNotEmpty
                            ? CachedNetworkImage(
                                fit: BoxFit.cover,
                                imageUrl: orderModel.items![0]!["image"],
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
                showQuantity(orderModel, widget.date),
              ],
            ),
          )
        : Padding(
            padding: EdgeInsets.only(top: 200),
            child: Center(
              child: utils.helveticaSemiBoldText('No Orders Found on this Day!',
                  22.0, AppColors.blackColor, TextAlign.center),
            ),
          );
  }

  addWalletPayment({
    required OrderModel orderModel,
    required int startDays,
    required String daysName,
    required bool isAddQty
  }){
    final endDate = DateFormat("yyyy-MM-dd").parse(orderModel.endingDate!);
    DateTime startDate = DateFormat("yyyy-MM-dd").parse(orderModel.startingDate!);
    final currentDate = DateTime.now();
    startDate.isAfter(currentDate) ? startDate : startDate = currentDate;
    final difference = endDate.difference(startDate).inDays;
    print("difference:-${difference}");
    RxInt sun = 1.obs;
    for (var item in orderModel.orderDaysModel.values) {
      if (item['day'] == daysName) {
        sun.value = (item['quantity'] is String)
            ? (int.parse(item['quantity']))
            : (item['quantity']);
      }
    }
    // print("sun:-${sun.value}");
    RxInt tempSun = 0.obs;
    for (int i = startDays; i < difference; i++) {
      DateTime nextDay = DateTime.now().add(Duration(days: i));
      String dayName = DateFormat('EE').format(nextDay);
      if(dayName.toLowerCase() == daysName.toLowerCase()){
        tempSun.value = tempSun.value + 1;
      }
    }
    double finalAmount =  (double.parse(orderModel.totalPrice ?? "0") * (tempSun.value));
    print("finalQty:======>${finalAmount}");
    Common.updateUserWallet(chargeAmount: isAddQty ? -finalAmount : finalAmount,
      orderId: orderModel.orderId ?? "cart_order",
    );
  }
}