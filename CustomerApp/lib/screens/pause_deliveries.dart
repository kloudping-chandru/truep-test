import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trupressed_subscription/utils/utils.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../colors.dart';
import '../common/CommonController.dart';
import '../common/common.dart';
import '../models/order_model.dart';

class PauseDeliveries extends StatefulWidget {
  const PauseDeliveries({Key? key}) : super(key: key);

  @override
  State<PauseDeliveries> createState() => _PauseDeliveriesState();
}

class _PauseDeliveriesState extends State<PauseDeliveries> {

  Utils utils = Utils();
  String? image ;
  var databaseReference = FirebaseDatabase.instance.ref();
  RxBool hasAllOrders = true.obs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllOrders();
    // print(Common.orderData.length);
  }

  Future getAllOrders() async {
    Common.getAllOrders.clear();
  Query query=  databaseReference.child('Orders').orderByChild('uid').equalTo(utils.getUserId());
    query.once().then((value) {
      if (value.snapshot.value != null) {
        for(var item in value.snapshot.children)
          {
            OrderModel orderModel = OrderModel.fromJson(Map.from(item.value as Map));
            String dateFormat = DateFormat("yyyy-MM-dd").format(DateTime.parse(orderModel.endingDate!));
            DateTime splitOrderDate = DateTime.parse(dateFormat);

            String todayDate = DateFormat("yyyy-MM-dd").format(DateTime.now());
            DateTime todayDateInFormat = DateTime.parse(todayDate);

            if ((orderModel.status == 'requested' || orderModel.status =='pause') && splitOrderDate.compareTo(todayDateInFormat) > 0) {
              Common.getAllOrders.add(orderModel);

              databaseReference.child('Orders').child(item.key.toString()).child('Days').get().then((value) {
                // if (value.value != null) {
                //   for (var item in value.children) {
                //     OrderDaysModel orderDaysModel = OrderDaysModel.fromJson(Map.from(item.value as Map));
                //     Common.orderDaysData.add(orderDaysModel);
                //   }
                // } else {
                //   print('Null Data');
                // }
              });
            }
          }
        hasAllOrders.value = true;
        print(hasAllOrders.value);

      }

    });
    // databaseReference.child("Orders").orderByChild('uid').equalTo(utils.getUserId()).onChildAdded.listen((event) {
    //   if (event.snapshot.value != null) {
    //     OrderModel orderModel = OrderModel.fromJson(Map.from(event.snapshot.value as Map));
    //     String dateFormat = DateFormat("yyyy-MM-dd").format(DateTime.parse(orderModel.endingDate!));
    //     DateTime splitOrderDate = DateTime.parse(dateFormat);
    //
    //     String todayDate = DateFormat("yyyy-MM-dd").format(DateTime.now());
    //     DateTime todayDateInFormat = DateTime.parse(todayDate);
    //
    //     if ((orderModel.status == 'requested' || orderModel.status =='pause') && splitOrderDate.compareTo(todayDateInFormat) > 0) {
    //       Common.getAllOrders.add(orderModel);
    //
    //       databaseReference.child('Orders').child(event.snapshot.key.toString()).child('Days').get().then((value) {
    //         // if (value.value != null) {
    //         //   for (var item in value.children) {
    //         //     OrderDaysModel orderDaysModel = OrderDaysModel.fromJson(Map.from(item.value as Map));
    //         //     Common.orderDaysData.add(orderDaysModel);
    //         //   }
    //         // } else {
    //         //   print('Null Data');
    //         // }
    //       });
    //     }
    //   }
    //   hasAllOrders.value = true;
    //   print(hasAllOrders.value);
    //
    // });

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        systemOverlayStyle: SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
        elevation: 0,
        leading: BackButton(color: Colors.black),
        title: utils.poppinsMediumText('Pause Deliveries', 18.0, AppColors.blackColor, TextAlign.center),
        centerTitle: true,
      ),
      body:
      Obx(() {
        if (hasAllOrders.value) {
          if ( Common.getAllOrders.isNotEmpty) {
            return
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child:
                Column(
                  children: [
                    for (int i = 0; i <  Common.getAllOrders.length; i++)
                      Container(
                           child: productWidget( Common.getAllOrders[i])
                       // child: Text('Hello'),
                      )
                    // ProductsWidget(productModel: Common.popularProductList[i], width: 200.0, origin: 'popular'),
                  ],
                ),
              );
          } else {
            return utils.noDataWidget('No Items Found', 200.0);
          }
        } else {
          return Container(
            height: 200,
            child: Center(child: CircularProgressIndicator(backgroundColor: AppColors.primaryColor, color: AppColors.whiteColor)),
          );
        }
      }),
    );
  }

  Widget productWidget(OrderModel productModel) {
    return  Container(
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
                    child: productModel.items![0]!["image"].isNotEmpty
                        ? CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl:   productModel.items![0]!["image"],
                      progressIndicatorBuilder: (context, url, downloadProgress) => SizedBox(
                        height: 50,
                        width: 50,
                        child: Center(child: CircularProgressIndicator(value: downloadProgress.progress)),
                      ),
                      errorWidget: (context, url, error) => Image.asset('assets/images/placeholder_image.png', fit: BoxFit.cover),
                    )
                        : Image.asset('assets/images/placeholder_image.png', fit: BoxFit.cover),
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    utils.poppinsMediumText("Trupressed", 16.0,
                        AppColors.lightGrey2Color, TextAlign.start),
                    // utils.poppinsMediumText("A2 Desi Cow Milk", 18.0,
                    //     AppColors.blackColor, TextAlign.start),
                    utils.poppinsMediumText(
                        productModel.items![0]!["title"], 18.0, AppColors.blackColor, TextAlign.start),
                    utils.poppinsMediumText("500 ML", 14.0,
                        AppColors.lightGreyColor, TextAlign.start),
                    utils.poppinsMediumText("Pouch", 14.0,
                        AppColors.lightGreyColor, TextAlign.start),
                    utils.poppinsMediumText("${Common.currency} ${ productModel.items![0]!["newPrice"]}", 18.0,
                        AppColors.blackColor, TextAlign.start),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                Expanded(child:
                InkWell(
                  onTap: ()
                  {
                    productModel.status =='requested'?
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: utils.helveticaBoldText('Alert!',20.0,Colors.black,TextAlign.start),
                        content:utils.helveticaMediumText('Do you want to pause this delivery.',18.0,Colors.black,TextAlign.start),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              utils.showLoadingDialog();
                              databaseReference.child('Orders').get().then((value) {
                                for(var item in value.children)
                                {
                                  Map<dynamic,dynamic> mapData = item.value as Map<dynamic,dynamic>;
                                  if(mapData['orderId']==productModel.orderId )
                                  {
                                    // print('right');
                                    databaseReference.child('Orders').child(item.key!).update({'status': 'pause'}).whenComplete(() {
                                      utils.showToast('Your Order has Paused Successfully');
                                      Common.getAllOrders.clear();
                                      getAllOrders();
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
                                child: utils.helveticaMediumText('Yes',16.0,Colors.white,TextAlign.center)
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(ctx).pop();
                            },
                            child: Container(
                                color: Colors.green,
                                padding: const EdgeInsets.all(14),
                                child: utils.helveticaMediumText('No',16.0,Colors.white,TextAlign.center)
                            ),
                          ),
                        ],
                      ),
                    ):  showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: utils.helveticaBoldText('Alert!',20.0,Colors.black,TextAlign.start),
                        content:utils.helveticaMediumText('Do you want to restart the order.',18.0,Colors.black,TextAlign.start),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              utils.showLoadingDialog();
                              databaseReference.child('Orders').get().then((value) {
                                for(var item in value.children)
                                {
                                  Map<dynamic,dynamic> mapData = item.value as Map<dynamic,dynamic>;
                                  if(mapData['orderId']==productModel.orderId )
                                  {
                                    // print('right');
                                    databaseReference.child('Orders').child(item.key!)
                                        .update({'status': 'requested'}).whenComplete(() {
                                      utils.showToast('Your Order has restart Successfully');
                                      Common.getAllOrders.clear();
                                      getAllOrders();
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
                                child: utils.helveticaMediumText('Yes',16.0,Colors.white,TextAlign.center)
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(ctx).pop();
                            },
                            child: Container(
                                color: Colors.green,
                                padding: const EdgeInsets.all(14),
                                child: utils.helveticaMediumText('No',16.0,Colors.white,TextAlign.center)
                            ),
                          ),
                        ],
                      ),
                    );
                   // utils.showToast('Your Order has already paused');
                  },
                  child: Container(
                    height: 45,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 7.0),
                    margin: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 10.0),
                    decoration: utils.boxDecoration(
                        productModel.status == 'pause'? AppColors.redColor:
                        Colors.green, Colors.transparent, 20.0, 0.0),
                    child: Center(
                        child: utils.poppinsMediumText( productModel.status == 'pause'?"Resume":"Pause", 16.0,
                            productModel.status == 'pause'? Colors.white:
                            AppColors.whiteColor, TextAlign.center)
                    ),
                  ),
                ),
                ),
                SizedBox(width: 3,),

                Expanded(child: InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: utils.helveticaBoldText('Alert!',20.0,Colors.black,TextAlign.start),
                        content:utils.helveticaMediumText('Do you want to delete this Order.',18.0,Colors.black,TextAlign.start),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              utils.showLoadingDialog();
                              databaseReference.child('Orders').get().then((value) {
                                for(var item in value.children)
                                {
                                  Map<dynamic,dynamic> mapData = item.value as Map<dynamic,dynamic>;
                                  if(mapData['orderId']==productModel.orderId)
                                  {
                                    RxInt startDay = 0.obs;
                                    databaseReference.child('OrdersHistory').get().then((value) {
                                      for(var item in value.children) {
                                        Map<dynamic,dynamic> mapData = item.value as Map<dynamic,dynamic>;
                                        if(mapData['orderId'] == productModel.orderId) {
                                          productModel.status!.toLowerCase() == "delivered" ? startDay.value = 1 : startDay.value;
                                        }
                                      }
                                    });
                                    addWalletPayment(startDays: startDay.value, productModel: productModel);
                                    databaseReference.child('Orders').child(item.key!).remove().whenComplete(() {
                                      utils.showToast('Your Order has Deleted Successfully');
                                      Common.getAllOrders.clear();
                                      Common.orderData.clear();
                                      getAllOrders();
                                      getOrders();
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
                                child: utils.helveticaMediumText('Yes',16.0,Colors.white,TextAlign.center)
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(ctx).pop();
                            },
                            child: Container(
                                color: Colors.green,
                                padding: const EdgeInsets.all(14),
                                child: utils.helveticaMediumText('No',16.0,Colors.white,TextAlign.center)
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  child: Container(
                    height: 45,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 7.0),
                    margin: const EdgeInsets.symmetric(
                        horizontal: 10.0),
                    decoration: utils.boxDecoration(
                        AppColors.redColor,
                        Colors.transparent, 20.0, 0.0),
                    child: Center(
                        child: utils.poppinsMediumText( "Delete", 16.0,
                            Colors.white,
                            TextAlign.center)
                    ),
                  ),
                ),
                )
              ],
            )
          ],
        ),
      ),
    );
    //   InkWell(
    //   onTap: () => Get.to(() => const ProductDetailsScreen(), arguments: {
    //     'name': name,
    //     'description': description,
    //     'image': image,
    //   }),
    //   child:
    //
    // );
  }

  showAlertDialog(BuildContext context)
  {
    return AlertDialog(
      title: Text('Hello World'),
      actions: [
       ElevatedButton(
          child: new Text('SUBMIT'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }


  addWalletPayment({required OrderModel productModel,required int startDays}){
    final endDate = DateFormat("yyyy-MM-dd").parse(productModel.endingDate!);
    DateTime startDate = DateFormat("yyyy-MM-dd").parse(productModel.startingDate!);
    final currentDate = DateTime.now();
    startDate.isAfter(currentDate) ? startDate : startDate = currentDate;
    final difference = endDate.difference(startDate).inDays;
    print("difference:-${difference}");
    RxInt mon = 1.obs;
    RxInt tue = 1.obs;
    RxInt wed = 1.obs;
    RxInt thu = 1.obs;
    RxInt fri = 1.obs;
    RxInt sat = 1.obs;
    RxInt sun = 1.obs;
    for (var item in productModel.orderDaysModel.values) {
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
    // print("sun:-${sun.value}");
    // print("mon:-${mon.value}");
    // print("tue:-${tue.value}");
    // print("thu:-${thu.value}");
    // print("wed:-${wed.value}");
    // print("fri:-${fri.value}");
    // print("sat:-${sat.value}");
    RxInt tempMon = 0.obs;
    RxInt tempTue = 0.obs;
    RxInt tempWed = 0.obs;
    RxInt tempThu = 0.obs;
    RxInt tempFri = 0.obs;
    RxInt tempSat = 0.obs;
    RxInt tempSun = 0.obs;
    for (int i = startDays; i < difference; i++) {
      DateTime nextDay = DateTime.now().add(Duration(days: i));
      String dayName = DateFormat('EE').format(nextDay);
      if(dayName.toLowerCase() == "mon"){
        tempMon.value = tempMon.value + mon.value;
      }else if(dayName.toLowerCase() == "tue"){
        tempTue.value = tempTue.value + tue.value;
      }else if(dayName.toLowerCase() == "wed"){
        tempWed.value = tempWed.value + wed.value;
      }else if(dayName.toLowerCase() == "thu"){
        tempThu.value = tempThu.value + thu.value;
      }else if(dayName.toLowerCase() == "fri"){
        tempFri.value = tempFri.value + fri.value;
      }else if(dayName.toLowerCase() == "sat"){
        tempSat.value = tempSat.value + sat.value;
      }else if(dayName.toLowerCase() == "sun"){
        tempSun.value = tempSun.value + sun.value;
      }
    }
    int finalQty =  (tempSun.value + tempMon.value + tempTue.value + tempWed.value + tempThu.value + tempFri.value + tempSat.value);
    print("finalQty:======>${finalQty}");
    print("productModel.orderId:- ${productModel.orderId}");
    Common.updateUserWallet(chargeAmount: (double.parse(productModel.totalPrice ?? "0") * (finalQty)),
      orderId: productModel.orderId ?? "push_order",
    );
  }

  Future getOrders() async {

    Query query = databaseReference.child("Orders").orderByChild('uid').equalTo(utils.getUserId());
    query.once().then((value) {
      if (value.snapshot.value != null) {

        for(var item in value.snapshot.children)
        {
          OrderModel orderModel = OrderModel.fromJson(Map.from(item.value as Map));
          String dateFormat = DateFormat("yyyy-MM-dd").format(DateTime.parse(orderModel.endingDate!));
          DateTime splitOrderDate = DateTime.parse(dateFormat);

          String todayDate = DateFormat("yyyy-MM-dd").format(DateTime.now());
          DateTime todayDateInFormat = DateTime.parse(todayDate);

          if (orderModel.status == 'requested' && splitOrderDate.compareTo(todayDateInFormat) > 0) {
            Common.orderData.add(orderModel);
            CommonController.cartValue!.value='';
            CommonController.cartValue!.value = Common.orderData.length.toString();

            //Common.orderDataWithOnce.add(orderModel);
            //debugPrint('1stLengthCheck:${ Common.orderDataWithOnce.length}');


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
      }

      else{
        // hasOrders.value = true;
        // print('Not Available');
      }
      //hasOrders.value = true;
    });

    // databaseReference.child("Orders").orderByChild('uid').equalTo(utils.getUserId()).onChildAdded.listen((event) {
    //   if (event.snapshot.value != null) {
    //     OrderModel orderModel = OrderModel.fromJson(Map.from(event.snapshot.value as Map));
    //     String dateFormat = DateFormat("yyyy-MM-dd").format(DateTime.parse(orderModel.endingDate!));
    //     DateTime splitOrderDate = DateTime.parse(dateFormat);
    //
    //     String todayDate = DateFormat("yyyy-MM-dd").format(DateTime.now());
    //     DateTime todayDateInFormat = DateTime.parse(todayDate);
    //
    //     if (orderModel.status == 'requested' && splitOrderDate.compareTo(todayDateInFormat) > 0) {
    //       Common.orderData.add(orderModel);
    //       //Common.orderDataWithOnce.add(orderModel);
    //       //debugPrint('1stLengthCheck:${ Common.orderDataWithOnce.length}');
    //
    //
    //       // databaseReference.child('Orders').child(event.snapshot.key.toString()).child('Days').get().then((value) {
    //       //   if (value.value != null) {
    //       //     for (var item in value.children) {
    //       //       OrderDaysModel orderDaysModel = OrderDaysModel.fromJson(Map.from(item.value as Map));
    //       //       Common.orderDaysData.add(orderDaysModel);
    //       //     }
    //       //   } else {
    //       //     print('Null Data');
    //       //   }
    //       // });
    //     }
    //   }
    //   hasOrders.value = true;
    // });

  }


}
