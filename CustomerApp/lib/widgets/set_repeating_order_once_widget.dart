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

import '../common/common.dart';

class SetRepeatingOrderOnceWidget extends StatefulWidget {
 final ProductModel? productModel;
 final OrderModel? orderModel;
  const SetRepeatingOrderOnceWidget({Key? key,this.productModel,this.orderModel}) : super(key: key);

  @override
  State<SetRepeatingOrderOnceWidget> createState() => _SetRepeatingOrderOnceWidgetState();
}

class _SetRepeatingOrderOnceWidgetState extends State<SetRepeatingOrderOnceWidget> {
  Utils utils = Utils();
  RxString staringDate = DateFormat("yyyy-MM-dd").format(DateTime.now()).obs;
  RxString endingDate = DateFormat("yyyy-MM-dd").format(DateTime.now().add(const Duration(days: 30)),).obs;
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
  RxString? selectedDay=''.obs;
  String orderIdKey ='';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (Common.currentAddress != null) {
      lat!.value = Common.currentLat!;
      lng!.value = Common.currentLng!;
      address!.value = Common.currentAddress!;
    }
   DateTime dateTime = DateTime.now();
    String day = DateFormat('EE, dd MMM').format(dateTime);
    selectedDay!.value = day.split(',').first.toString();
    print('currentDay${selectedDay}');
    setData();

  }
  setData()
  {

    if(widget.orderModel != null)
    {
      staringDate.value = widget.orderModel!.startingDate!;
      for(var item in widget.orderModel!.orderDaysModel.values)
      {
        sun.value= item['quantity'];
        selectedDay!.value=item['day'];
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
              // const SizedBox(width: 10),
              // Expanded(child: showDayQuantityWidget(mon, "Mon")),
              // const SizedBox(width: 10),
              // Expanded(child: showDayQuantityWidget(tue, "Tue")),
              // const SizedBox(width: 10),
              // Expanded(child: showDayQuantityWidget(wed, "Wed")),
              // const SizedBox(width: 10),
              // Expanded(child: showDayQuantityWidget(thu, "Thu")),
              // const SizedBox(width: 10),
              // Expanded(child: showDayQuantityWidget(fri, "Fri")),
              // const SizedBox(width: 10),
              // Expanded(child: showDayQuantityWidget(sat, "Sat")),
            ],
          ),

          const SizedBox(height: 20),
          utils.poppinsSemiBoldText("setStartDate".tr, 18.0, AppColors.blackColor, TextAlign.start),
          const SizedBox(height: 20),
          InkWell(
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
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
              print(staringDate.value);
              endingDate.value = DateFormat("yyyy-MM-dd").format(pickedDate.add(const Duration(days: 1)));

              String day  = DateFormat('EE, dd MMM').format(pickedDate);
              selectedDay!.value = day.split(",").first.toString();

              //DateTime selectedDate=DateTime.parse( DateFormat('EE,dd MMM').format(pickedDate));
              //print('selectedDay${selectedDate.toString().split(",").first.toString()}');
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
                  Obx(() => utils.poppinsSemiBoldText(staringDate.value, 16.0, AppColors.blackColor, TextAlign.start)),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              widget.orderModel!=null?payOrderUpdate():payOrder();            },
            child: Container(
              height: 45,
              margin: const EdgeInsets.only(top: 20, bottom: 20),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: const BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.all(Radius.circular(30.0)),
              ),
              child: Center(child: utils.poppinsMediumText('Place Order for Once'.toUpperCase(), 16.0, AppColors.whiteColor, TextAlign.center)),
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
                  onPressed: () => value > 1 ? value.value-- : null,
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

    if(hour >22 || hour == 22)
    {
      staringDate.value = DateFormat("yyyy-MM-dd").format(startingDateTime.add(const Duration(days: 2)));
      endingDate.value = DateFormat("yyyy-MM-dd").format(startingDateTime.add(const Duration(days: 32)),);

      String day  = DateFormat('EE, dd MMM').format(startingDateTime.add(const Duration(days: 2)));
      selectedDay!.value = day.split(",").first.toString();
    }
    else
    {
      staringDate.value = DateFormat("yyyy-MM-dd").format(startingDateTime.add(const Duration(days: 1)));
      endingDate.value = DateFormat("yyyy-MM-dd").format(startingDateTime.add(const Duration(days: 31)),);

      String day  = DateFormat('EE, dd MMM').format(startingDateTime.add(const Duration(days: 1)));
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
      'onceOrder': staringDate.value,
      'startingDate': staringDate.value,
      'endingDate': endingDate.value,
      'itemId':widget.productModel!.timeCreated
    };
    await databaseReference.child('OnceOrders').push().set(orderData).then((snapShot) {
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

  Future addDaysAndQuantity() async
  {
    await databaseReference.child('OnceOrders').get().then((snapShot) {
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
                   'day':selectedDay!.value.toString(),
                   'quantity': sun.value
                 };
                 databaseReference.child('OnceOrders').child(item.key.toString()).child('Days').push().set(daysAddMap).whenComplete(() {
                 });
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





  }
  payOrderUpdate()async
  {
    utils.showLoadingDialog();

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
    Query query = await databaseReference.child('OnceOrders').orderByChild('itemId').equalTo(widget.productModel!.timeCreated);
    query.once().then((value) async {
      if(value.snapshot.value !=null)
      {
        for(var item in value.snapshot.children)
        {
          await databaseReference.child('OnceOrders').child(item.key!) .update({'startingDate': staringDate.value,'endingDate':endingDate.value}).whenComplete(() {});
          orderIdKey= item.key!;
       Query query= databaseReference.child('OnceOrders').child(orderIdKey).child('Days');
       query.once().then((value) {
         if(value.snapshot.value !=null)
           {
             for(var item in value.snapshot.children)
               {
                  databaseReference.child('OnceOrders').child(orderIdKey).child('Days').child(item.key!).update({'day':selectedDay!.value,'quantity':sun.value}).whenComplete(() {
                    Get.back();
                    Get.back();
                    Get.back();
                    utils.showToast('Your Order has Updated Successfully');
                  });
               }

           }
       });
          }

        }




    });


  }
}
