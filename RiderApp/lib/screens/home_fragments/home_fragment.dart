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
  String url ='';
  final  imagePicker= ImagePicker();

  @override
  void initState() {
    super.initState();
    Common.orderModel.clear();
    getOngoingOrder();
    //getCurrentLocation();
  }

  getOngoingOrder() async {
    orderAdded = databaseReference.child('Orders').orderByChild('driverUid').equalTo(utils.getUserId()).onChildAdded.listen((event) {
      if (event.snapshot.value != null) {
        Common.orderModel.add(OrderModel.fromJson(Map.from(event.snapshot.value as Map)));
      }
    });

    orderRemoved = databaseReference.child('Orders').orderByChild('driverUid').equalTo(utils.getUserId()).onChildRemoved.listen((event) {
      if (event.snapshot.value != null) {
        OrderModel list = OrderModel.fromJson(Map.from(event.snapshot.value as Map));
        Common.orderModel.removeWhere((element) => element.orderId == list.orderId);
      }
    });

    orderUpdate = databaseReference.child('Orders').orderByChild('driverUid').equalTo(utils.getUserId()).onChildChanged.listen((event) {
      if (event.snapshot.value != null) {
        OrderModel list = OrderModel.fromJson(Map.from(event.snapshot.value as Map));
        var index = Common.orderModel.indexWhere((item) => item.orderId == list.orderId);
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
            child: utils.helveticaBoldText('My Orders', 22.0, AppColors.blackColor, TextAlign.start),
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
                  child: Center(child: CircularProgressIndicator(backgroundColor: AppColors.primaryColor, color: AppColors.whiteColor)),
                );
              }
            }),
          )
        ],
      ),
    );
  }

  changeOrderStatus(String status, OrderModel orderModel) async {

       final pickedFile = await imagePicker.pickImage(source: ImageSource.camera);
       if (pickedFile!.path.isNotEmpty)

       {
         utils.showLoadingDialog();
       utils.getUserCurrentLocation('current');
       orderModel.deliveryCurrentAddress = Common.currentAddress.toString();
       print( 'CurrentAddress${orderModel.deliveryCurrentAddress.toString()}');
         profileImage.value = File(pickedFile.path);
         final file = File(profileImage.value.path);
         String extension = profileImage.value.path.split('.').last;
         var ref = storageRef.child("Profile_images").child("${DateTime.now().millisecondsSinceEpoch.toString()}.$extension");
         TaskSnapshot downloadurl = await ref.putFile(file);
         url = await downloadurl.ref.getDownloadURL();
         orderModel.deliveryPicture = url.toString();
         orderModel.status ='delivered'.toString();

         print('deliverpicture${orderModel.deliveryPicture}');

        if(orderModel.deliveryPicture!=null)
          {
            Query query = databaseReference.child('Orders').orderByChild("orderId").equalTo(orderModel.orderId);
            await query.once().then((DatabaseEvent event) async {
              if (event.snapshot.exists) {
                Map<String, dynamic> mapOfMaps = Map.from(event.snapshot.value as Map);
                mapOfMaps.keys.forEach((value) async {
                  await databaseReference.child('Orders').child(value.toString()).update({
                    'timeDelivered': DateTime.now().millisecondsSinceEpoch.toString(),
                    'driverUid':'',

                  });
                  print("orderModel:${orderModel.toJson()}");

                  ///Uncoment
                  await databaseReference.child('OrdersByPicture').push().set(orderModel.toJson());
                  Get.back();
                  utils.showToast("Order Delivered Successfully");

                  //await databaseReference.child('Drivers').child(utils.getUserId()).update({'onlineStatus': 'free'});
                  // Get.back();
                  // utils.showToast("Order Delivered Successfully");

                  /// Uncomment
                  //addToDelivered(value.toString());
                });
              }
            });
          }

       }

   else
     {
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

}
