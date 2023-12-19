import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:foodizm_subscription/colors.dart';
import 'package:foodizm_subscription/models/order_model.dart';
import 'package:foodizm_subscription/models/product_model.dart';
import 'package:foodizm_subscription/utils/utils.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../common/CommonController.dart';
import '../common/common.dart';

class SetRepeatingOrderWidget extends StatefulWidget {
 final ProductModel? productModel;
final OrderModel? orderModel;
  const SetRepeatingOrderWidget({Key? key,this.productModel,this.orderModel}) : super(key: key);

  @override
  State<SetRepeatingOrderWidget> createState() => _SetRepeatingOrderWidgetState();
}

class _SetRepeatingOrderWidgetState extends State<SetRepeatingOrderWidget> {
  Utils utils = Utils();
  RxString staringDate = DateFormat("yyyy-MM-dd").format(DateTime.now()).obs;
  RxString endingDate = DateFormat("yyyy-MM-dd").format(DateTime.now().add(const Duration(days: 30)),).obs;
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
  RxString beforeValue=''.obs;

  String orderIdKey ='';

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
  setData()
  {
    if(widget.orderModel != null)
      {
        staringDate.value = widget.orderModel!.startingDate!;
        for(var item in widget.orderModel!.orderDaysModel.values)
          {
            if(item['day']== 'Sun')
              {

              sun.value= item['quantity'];
              }
           else if(item['day']== 'Mon')
             {


               mon.value= item['quantity'];
             }
            else if(item['day']== 'Tue')
            {


              tue.value= item['quantity'];
            }
            else if(item['day']== 'Wed')
            {


              wed.value= item['quantity'];
            }
            else if(item['day']== 'Thu')
            {


              thu.value= item['quantity'];
            }
            else if(item['day']== 'Fri')
            {


              fri.value= item['quantity'];
            }
            else if(item['day']== 'Sat')
            {


              sat.value= item['quantity'];
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
          IconButton(onPressed: () => Get.back(), icon: const Icon(Icons.close, size: 35, color: AppColors.blackColor)),
          const SizedBox(height: 20),
          utils.poppinsSemiBoldText("setQuantity".tr, 18.0, AppColors.blackColor, TextAlign.start),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: showDayQuantityWidget(sun, "Sun")),
              const SizedBox(width: 10),
              Expanded(child: showDayQuantityWidget(mon, "Mon")),
              const SizedBox(width: 10),
              Expanded(child: showDayQuantityWidget(tue, "Tue")),
              const SizedBox(width: 10),
              Expanded(child: showDayQuantityWidget(wed, "Wed")),
              const SizedBox(width: 10),
              Expanded(child: showDayQuantityWidget(thu, "Thu")),
              const SizedBox(width: 10),
              Expanded(child: showDayQuantityWidget(fri, "Fri")),
              const SizedBox(width: 10),
              Expanded(child: showDayQuantityWidget(sat, "Sat")),
            ],
          ),
          const SizedBox(height: 20),
          utils.poppinsSemiBoldText("setStartDate".tr, 18.0, AppColors.blackColor, TextAlign.start),
          const SizedBox(height: 20),
          InkWell(
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate:  DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 365)),
                builder: (context, child) {
                  return Theme(
                    data: ThemeData.dark().copyWith(
                      colorScheme: const ColorScheme.dark(
                        primary: AppColors.primaryColor,
                        onPrimary: AppColors.whiteColor,
                        surface: AppColors.whiteColor,
                        onSurface: AppColors.primaryColor,
                      ),
                      dialogBackgroundColor: AppColors.whiteColor,
                    ),
                    child: child!,
                  );
                },
              );
              staringDate.value = DateFormat("yyyy-MM-dd").format(pickedDate!);
              endingDate.value = DateFormat("yyyy-MM-dd").format(pickedDate.add(const Duration(days: 30)));
            },
            child: Container(
              height: 45.0,
              decoration: utils.boxDecoration(Colors.transparent, AppColors.blackColor, 10.0, 1.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 15.0, right: 10.0),
                    child: Icon(Icons.edit_calendar_outlined, size: 20, color: AppColors.blackColor),
                  ),
                  // widget.orderModel!.startingDate !=null?utils.poppinsSemiBoldText(widget.orderModel!.startingDate!, 16.0, AppColors.blackColor, TextAlign.start):
                  Obx(() => utils.poppinsSemiBoldText(staringDate.value, 16.0, AppColors.blackColor, TextAlign.start)
                  ),
                 //valueEmpty()
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              widget.orderModel!=null?payOrderUpdate():payOrder();
            },
            child: Container(
              height: 45,
              margin: const EdgeInsets.only(top: 20, bottom: 20),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: const BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.all(Radius.circular(30.0)),
              ),
              child: Center(child: utils.poppinsMediumText('setRepeatingOrder'.tr.toUpperCase(), 16.0, AppColors.whiteColor, TextAlign.center)),
            ),
          ),

        ],
      ),
    );
  }

  Widget showDayQuantityWidget(RxInt value, String day) {
    return Obx(() {
      return Column(
        children: [
          Container(
            height: 150.0,
            decoration: utils.boxDecoration(Colors.transparent, AppColors.blackColor, 25.0, 1.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () => value > 0 ? value.value-- : null,
                  icon: const Icon(Icons.remove, size: 20, color: AppColors.blackColor),
                ),
                utils.poppinsMediumText(value.value.toString(), 18.0, AppColors.blackColor, TextAlign.start),
                IconButton(
                  onPressed: () => value.value++,
                  icon: const Icon(Icons.add, size: 20, color: AppColors.blackColor),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          utils.poppinsMediumText(day, 16.0, AppColors.blackColor, TextAlign.start),
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

    if(hour >22 || hour == 22)
    {
      staringDate.value = DateFormat("yyyy-MM-dd").format(startingDateTime.add(const Duration(days: 2)));
      endingDate.value = DateFormat("yyyy-MM-dd").format(startingDateTime.add(const Duration(days: 32)),);
    }
    else
    {
      staringDate.value = DateFormat("yyyy-MM-dd").format(startingDateTime.add(const Duration(days: 1)));
      endingDate.value = DateFormat("yyyy-MM-dd").format(startingDateTime.add(const Duration(days: 31)),);
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
       "quantity": widget.productModel!.price,
      "uid": utils.getUserId(),
      // "timeAdded": currentTime,
      "ingredients": widget.productModel!.ingredients,
      "customizationForVariations": widget.productModel!.customizationForVariations,
      "customizationForFlavours": widget.productModel!.customizationForFlavours,
       "customizationForDrinks": widget.productModel!.customizationForFlavours,
       // "itemsIncluded": widget.productModel!.customizationForFlavours,
    };
    items.add(data);


    Map<String, dynamic> orderData = {
      "items": items,
       "totalPrice": widget.productModel!.price,
      "orderId":currentTime,
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
    await databaseReference.child('Orders').push().set(orderData).then((snapShot) {

      addDaysAndQuantity();
      Get.back();
      Common.orderData.clear();
      getOrders();
      print('AtOrderPlaced:${ Common.orderData.length.toString()}');
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

    if(hour >22 || hour == 22)
    {
      staringDate.value = DateFormat("yyyy-MM-dd").format(startingDateTime.add(const Duration(days: 2)));
      endingDate.value = DateFormat("yyyy-MM-dd").format(startingDateTime.add(const Duration(days: 32)),);
    }
    else
    {
      staringDate.value = DateFormat("yyyy-MM-dd").format(startingDateTime.add(const Duration(days: 1)));
      endingDate.value = DateFormat("yyyy-MM-dd").format(startingDateTime.add(const Duration(days: 31)),);
    }


    print('timeCreated:${widget.productModel!.timeCreated}');
    Query query = await databaseReference.child('Orders').orderByChild('itemId').equalTo(widget.productModel!.timeCreated);
    query.once().then((value) async {
      if(value.snapshot.value !=null)
        {
          // print('KeyOrder:${value.snapshot.value}');
          for(var item in value.snapshot.children)
            {
             await databaseReference.child('Orders').child(item.key!) .update({'startingDate': staringDate.value,'endingDate':endingDate.value}).whenComplete(() async{

               for(int i=0; i<7; i++)
               {
                 if(i==0)
                   {
                     Map<String, dynamic> daysAddMap= {
                       'day':'Sun',
                       'quantity': sun.value
                     };
                    // orderIdKey= item.key!;
                     Query query = databaseReference.child('Orders').child(item.key!).child('Days').orderByChild('day').equalTo('Sun');
                    await query.once().then((value) {
                       if(value.snapshot.value != null)
                       {
                         for(var itemDays in value.snapshot.children)
                         {
                           databaseReference.child('Orders').child(item.key!).child('Days').child(itemDays.key!).update(daysAddMap).whenComplete(() {

                           });
                         }
                       }
                     });
                   }
                 if(i==1)
                 {
                   Map<String, dynamic> daysAddMap= {
                     'day':'Mon',
                     'quantity': mon.value
                   };

                   Query query = databaseReference.child('Orders').child(item.key!).child('Days').orderByChild('day').equalTo('Mon');
                  await query.once().then((value) {
                     if(value.snapshot.value != null)
                     {
                       for(var itemDays in value.snapshot.children)
                       {
                         databaseReference.child('Orders').child(item.key!).child('Days').child(itemDays.key!).update(daysAddMap).whenComplete(() {

                         });
                       }
                     }
                   });
                 }
                 if(i==2)
                 {
                   Map<String, dynamic> daysAddMap= {
                     'day':'Tue',
                     'quantity': tue.value
                   };
                   Query query = databaseReference.child('Orders').child(item.key!).child('Days').orderByChild('day').equalTo('Tue');
                 await  query.once().then((value) {
                     if(value.snapshot.value != null)
                     {
                       for(var itemDays in value.snapshot.children)
                       {
                         databaseReference.child('Orders').child(item.key!).child('Days').child(itemDays.key!).update(daysAddMap).whenComplete(() {

                         });
                       }
                     }
                   });
                 }
                 if(i==3)
                 {
                   Map<String, dynamic> daysAddMap= {
                     'day':'Wed',
                     'quantity': wed.value
                   };

                   Query query = databaseReference.child('Orders').child(item.key!).child('Days').orderByChild('day').equalTo('Wed');
                 await  query.once().then((value) {
                     if(value.snapshot.value != null)
                     {
                       for(var itemDays in value.snapshot.children)
                       {
                         databaseReference.child('Orders').child(item.key!).child('Days').child(itemDays.key!).update(daysAddMap).whenComplete(() {

                         });
                       }
                     }
                   });
                 }
                 if(i==4)
                 {
                   Map<String, dynamic> daysAddMap= {
                     'day':'Thu',
                     'quantity': thu.value
                   };

                   Query query = databaseReference.child('Orders').child(item.key!).child('Days').orderByChild('day').equalTo('Thu');
                  await query.once().then((value) {
                     if(value.snapshot.value != null)
                     {
                       for(var itemDays in value.snapshot.children)
                       {
                         databaseReference.child('Orders').child(item.key!).child('Days').child(itemDays.key!).update(daysAddMap).whenComplete(() {

                         });
                       }
                     }
                   });
                 }
                 if(i==5)
                 {
                   Map<String, dynamic> daysAddMap= {
                     'day':'Fri',
                     'quantity': fri.value
                   };

                   Query query = databaseReference.child('Orders').child(item.key!).child('Days').orderByChild('day').equalTo('Fri');
                 await  query.once().then((value) {
                     if(value.snapshot.value != null)
                     {
                       for(var itemDays in value.snapshot.children)
                       {
                         databaseReference.child('Orders').child(item.key!).child('Days').child(itemDays.key!).update(daysAddMap).whenComplete(() {

                         });
                       }
                     }
                   });
                 }
                 if(i==6)
                 {
                   Map<String, dynamic> daysAddMap= {
                     'day':'Sat',
                     'quantity': sat.value
                   };

                   Query query = databaseReference.child('Orders').child(item.key!).child('Days').orderByChild('day').equalTo('Sat');
                  await query.once().then((value) {
                     if(value.snapshot.value != null)
                     {
                       for(var itemDays in value.snapshot.children)
                       {
                         databaseReference.child('Orders').child(item.key!).child('Days').child(itemDays.key!).update(daysAddMap).whenComplete(() {

                         });
                       }
                     }
                   });
                 }
               }

             });
              // Map<dynamic,dynamic> mapData = item.value as Map;
              // print('key:${item.key}');


            }
          Get.back();
          Get.back();
          Get.back();
          utils.showToast('Your Order has Updated Successfully');

        }

    });

  }

  Future addDaysAndQuantity() async
  {
    await databaseReference.child('Orders').get().then((snapShot) {
      for(var item in snapShot.children)
        {
          Map<dynamic, dynamic> mapGetOrders = item.value as Map<dynamic, dynamic>;
         if(mapGetOrders['orderId'] == currentTime)
           {
             for(int i =0; i< 7; i++)
             {
               if (i==0)
               {
                 Map<String, dynamic> daysAddMap= {
                   'day':'Sun',
                   'quantity': sun.value
                 };
                 databaseReference.child('Orders').child(item.key.toString()).child('Days').push().set(daysAddMap).whenComplete(() {
                 });
               }
               if (i==1)
               {
                 Map<String, dynamic> daysAddMap= {
                   'day':'Mon',
                   'quantity': mon.value
                 };
                 databaseReference.child('Orders').child(item.key.toString()).child('Days').push().set(daysAddMap).whenComplete(() {
                 });
               }
               if (i==2)
               {
                 Map<String, dynamic> daysAddMap= {
                   'day':'Tue',
                   'quantity': tue.value
                 };
                 databaseReference.child('Orders').child(item.key.toString()).child('Days').push().set(daysAddMap).whenComplete(() {
                 });
               }
               if (i==3)
               {
                 Map<String, dynamic> daysAddMap= {
                   'day':'Wed',
                   'quantity': wed.value
                 };
                 databaseReference.child('Orders').child(item.key.toString()).child('Days').push().set(daysAddMap).whenComplete(() {
                 });
               }
               if (i==4)
               {
                 Map<String, dynamic> daysAddMap= {
                   'day':'Thu',
                   'quantity': thu.value
                 };
                 databaseReference.child('Orders').child(item.key.toString()).child('Days').push().set(daysAddMap).whenComplete(() {
                 });
               }
               if (i==5)
               {
                 Map<String, dynamic> daysAddMap= {
                   'day':'Fri',
                   'quantity': fri.value
                 };
                 databaseReference.child('Orders').child(item.key.toString()).child('Days').push().set(daysAddMap).whenComplete(() {
                 });
               }
               if (i==6)
               {
                 Map<String, dynamic> daysAddMap= {
                   'day':'Sat',
                   'quantity': sat.value
                 };
                 databaseReference.child('Orders').child(item.key.toString()).child('Days').push().set(daysAddMap).whenComplete(() {
                 });
               }

             }
           }
        }
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
