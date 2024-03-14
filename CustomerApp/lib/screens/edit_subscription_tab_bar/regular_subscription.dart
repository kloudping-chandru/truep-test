import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trupressed_subscription/models/product_model.dart';
import 'package:trupressed_subscription/utils/utils.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../colors.dart';
import '../../common/CommonController.dart';
import '../../common/common.dart';
import '../../models/order_model.dart';
import '../../widgets/set_repeating_order_widget.dart';

class RegularSubscription extends StatefulWidget {
  const RegularSubscription({Key? key}) : super(key: key);

  @override
  State<RegularSubscription> createState() => _RegularSubscriptionState();
}

class _RegularSubscriptionState extends State<RegularSubscription> {
  Utils utils = Utils();
  var databaseReference = FirebaseDatabase.instance.ref();
  RxBool hasOrders = false.obs;
  ProductModel productModel=ProductModel();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // your code here
      Common.orderData.clear();
      getOrders();
    });

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
        hasOrders.value = true;
        print('Not Available');
      }
      hasOrders.value = true;
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

  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child: Scaffold(
          appBar:
          AppBar(
            backgroundColor: AppColors.whiteColor,
            systemOverlayStyle: SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
            elevation: 0,
            leading: BackButton(color: Colors.black),
            title: utils.poppinsMediumText('Update & Delete Subscription', 18.0, AppColors.blackColor, TextAlign.center),
            centerTitle: true,
          ),

          body: Obx(() =>hasOrders.value == true?   Common.orderData.isNotEmpty?  SingleChildScrollView(
            child:
            Container(
              margin: EdgeInsets.only(left: 10,right: 10),
              child: Column(
                children: [
                  SizedBox(height: 20,),
                  for (int i = 0; i <Common.orderData.length; i++)
                  // showOrders(widget.orderModel![i],widget.date!)
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                      decoration: utils.boxDecoration(Colors.white, Colors.transparent, 15.0, 0.0,
                          isShadow: true, shadowColor: Colors.grey.shade200),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    utils.poppinsMediumText("trupressed".tr, 16.0, AppColors.lightGrey2Color, TextAlign.start),
                                    utils.poppinsMediumText(
                                        Common.orderData[i].items![0]!["title"], 18.0, AppColors.blackColor, TextAlign.start),
                                    // utils.poppinsMediumText("500 ML", 14.0, AppColors.lightGreyColor, TextAlign.start),
                                    Container(
                                      width: 300,
                                      child: utils.poppinsMediumText( Common.orderData[i].items![0]!["details"], 14.0, AppColors.lightGreyColor, TextAlign.start,maxlines:2),
                                    ),

                                    utils.poppinsMediumText("${Common.currency} ${ Common.orderData[i].items![0]!["newPrice"]}", 18.0,
                                        AppColors.blackColor, TextAlign.start),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10),
                              Container(
                                height: 100,
                                width: 100,
                                padding: const EdgeInsets.all(12.0),
                                child: ClipRRect(
                                  child:  Common.orderData[i].items![0]!["image"].isNotEmpty
                                      ? CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    imageUrl:  Common.orderData[i].items![0]!["image"],
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
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    utils.showLoadingDialog();
                                    //print(widget.productModel!.productQuantity!.toString());
                                    getProductDetails(Common.orderData[i].itemId!,Common.orderData[i]);
                                  },
                                  child: Container(
                                    height: 45,
                                    margin: const EdgeInsets.only(top: 20),
                                    padding: const EdgeInsets.symmetric(horizontal: 10),
                                    decoration: const BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                                    ),
                                    child: Center(child: utils.poppinsMediumText('Edit Order', 16.0, AppColors.whiteColor, TextAlign.center)),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10,),
                              Expanded(child: InkWell(
                                onTap: ()
                                {
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
                                                if(mapData['orderId']==Common.orderData[i].orderId )
                                                {
                                                  // print('right');
                                                  databaseReference.child('Orders').child(item.key!)
                                                      .remove().whenComplete(() {
                                                    Common.orderData.clear();
                                                    getOrders();
                                                    Navigator.of(ctx).pop();
                                                    Get.back();
                                                    utils.showToast('Your Order has Deleted Successfully');
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
                                  margin: const EdgeInsets.only(top: 20),
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  decoration: const BoxDecoration(
                                    color: AppColors.redColor,
                                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                                  ),
                                  child: Center(child: utils.poppinsMediumText('Delete Order', 16.0, AppColors.whiteColor, TextAlign.center)),
                                ),
                              ))

                            ],
                          )
                          //showQuantity( Common.orderData[i]),
                        ],
                      ),
                    )
                ],
              ),
            ),
          ):
          Center(child:utils.helveticaSemiBoldText('No Orders Found', 22.0, Colors.black, TextAlign.center) ,):
          Center(
              child: Container(
                height: 200,
                child: const Center(
                    child: CircularProgressIndicator(backgroundColor: AppColors.primaryColor, color: AppColors.whiteColor)),
              )),)

      ),
    );
  }
  getProductDetails(String itemId,OrderModel orderModel)async
  {
    print('itemId:${itemId}');
    Query query = databaseReference.child('Items').orderByChild('timeCreated').equalTo(itemId.toString());
    query.once().then((value) {
      if(value.snapshot.value != null)
      {
        Get.back();
        for(var item in value.snapshot.children)
          {
             Map<dynamic, dynamic>mapData = item.value as Map<dynamic,dynamic>;
             productModel = ProductModel.fromJson(Map.from(mapData));
            print('timeCreatedRegular:${productModel.title}');
          }
        Get.bottomSheet(
          SizedBox(height: 530,
              child: SetRepeatingOrderWidget(productModel: productModel,orderModel:orderModel)),
          backgroundColor: AppColors.whiteColor,
          isScrollControlled: true,
          enableDrag: false,
          isDismissible: false,
        );
      }
      else
        {
          print('Not Available');
        }
    });
  }
  // Widget showQuantity(OrderModel orderModel, ) {
  //   RxString quantity = "".obs;
  //   String day = '';
  //   // for(int i =0; i< orderModel.orderDaysModel.values.length; i++)
  //   //   {
  //   //     if (orderModel.orderDaysModel.values[i]["day"].toString() == date!.split(',').first) {
  //   //       quantity.value = orderModel.orderDaysModel.values[i]["quantity"].toString();
  //   //       day = orderModel.orderDaysModel.values[i]['day'].toString();
  //   //       break;
  //   //     }
  //   //   }
  //   for (var item in orderModel.orderDaysModel.values) {
  //     if (item["day"].toString() == date!.split(',').first) {
  //       quantity.value = item["quantity"].toString();
  //       day = item['day'].toString();
  //       break;
  //     }
  //   }
  //   return
  //     Obx(() =>
  //     Row(
  //       children: [
  //         Container(
  //           margin: const EdgeInsets.only(right: 5),
  //           child: InkWell(
  //             onTap: () {
  //               if (int.parse(quantity.value) > 0) {
  //                 quantity.value = (int.parse(quantity.value) - 1).toString();
  //                 databaseReference.child('Orders').get().then((snapShot) {
  //                   for (var item in snapShot.children) {
  //                     Map<dynamic, dynamic> values = item.value as Map<dynamic, dynamic>;
  //                     if (values['orderId'] == orderModel.orderId) {
  //                       for (var itemDays in orderModel.orderDaysModel.values) {
  //                         if (itemDays['day'].toString() == day) {
  //                           Query querry = databaseReference
  //                               .child('Orders')
  //                               .child(item.key.toString())
  //                               .child('Days')
  //                               .orderByChild('day')
  //                               .equalTo(day);
  //                           querry.once().then((DatabaseEvent event) {
  //                             if (event.snapshot.exists) {
  //                               Map<dynamic, dynamic> mapsData = event.snapshot.value as Map<dynamic, dynamic>;
  //                               mapsData.keys.forEach((value) async {
  //                                 await databaseReference
  //                                     .child('Orders')
  //                                     .child(item.key.toString())
  //                                     .child('Days')
  //                                     .child(value.toString())
  //                                     .update({'quantity': quantity.value}).whenComplete(() => utils.showToast('Your Order has Successfully Updated'));
  //                               });
  //                             }
  //                           });
  //                         }
  //                       }
  //                     }
  //                   }
  //                 });
  //
  //               }
  //             },
  //             child: const Icon(Icons.remove_circle_outline, color: AppColors.primaryColor, size: 27.0),
  //           ),
  //         ),
  //         //Obx(() =>   utils.poppinsSemiBoldText(quantity.value, 16.0, AppColors.blackColor, TextAlign.center),),
  //         utils.poppinsSemiBoldText(quantity.value, 16.0, AppColors.blackColor, TextAlign.center),
  //         Container(
  //           margin: const EdgeInsets.only(left: 5),
  //           child: InkWell(
  //             onTap: ()
  //             {
  //               quantity.value = (int.parse(quantity.value) + 1).toString();
  //               databaseReference.child('Orders').get().then((snapShot) {
  //                 for (var item in snapShot.children) {
  //                   Map<dynamic, dynamic> values = item.value as Map<dynamic, dynamic>;
  //                   if (values['orderId'] == orderModel.orderId) {
  //                     for (var itemDays in orderModel.orderDaysModel.values) {
  //                       if (itemDays['day'].toString() == day) {
  //                         Query querry = databaseReference
  //                             .child('Orders')
  //                             .child(item.key.toString())
  //                             .child('Days')
  //                             .orderByChild('day')
  //                             .equalTo(day);
  //                         querry.once().then((DatabaseEvent event) {
  //                           if (event.snapshot.exists) {
  //                             Map<dynamic, dynamic> mapsData = event.snapshot.value as Map<dynamic, dynamic>;
  //                             mapsData.keys.forEach((value) async {
  //                               await databaseReference
  //                                   .child('Orders')
  //                                   .child(item.key.toString())
  //                                   .child('Days')
  //                                   .child(value.toString())
  //                                   .update({'quantity': quantity.value}).whenComplete(() => utils.showToast('Your Order has Sucessfully Updated'));
  //
  //                             });
  //                           }
  //                         });
  //                       }
  //                     }
  //                   }
  //                 }
  //               });
  //             },
  //             child: const Icon(Icons.add_circle_outlined, color: AppColors.primaryColor, size: 27.0),
  //           ),
  //         ),
  //       ],
  //     )
  //
  //
  //     );
  //   // return utils.poppinsSemiBoldText(quantity, 16.0, AppColors.blackColor, TextAlign.center);
  // }
}
