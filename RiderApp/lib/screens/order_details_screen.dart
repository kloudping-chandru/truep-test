import 'dart:io';

import 'package:action_slider/action_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foodizm_driver_app/colors.dart';
import 'package:foodizm_driver_app/common/common.dart';
import 'package:foodizm_driver_app/models/cart_model.dart';
import 'package:foodizm_driver_app/models/order_model.dart';
import 'package:foodizm_driver_app/models/user_model.dart';
import 'package:foodizm_driver_app/utils/utils.dart';
import 'package:foodizm_driver_app/widget/order_details_items_widget.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

import 'home_screen.dart';

class OrderDetailsScreen extends StatefulWidget {
  final OrderModel? orderModel;
  final UserModel? userModel;
  final List<CartModel>? orderItems;
  final String? status;

  const OrderDetailsScreen({Key? key, this.status, this.orderModel, this.userModel, this.orderItems}) : super(key: key);

  @override
  _OrderDetailsScreenState createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> with WidgetsBindingObserver {
  Utils utils = new Utils();
  var dropOffLocationController = new TextEditingController();
  var databaseReference = FirebaseDatabase.instance.ref();
  var storageRef = FirebaseStorage.instance.ref();
  String url ='';
  Rx<File> profileImage = File('').obs;
  final  imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    dropOffLocationController.text = widget.orderModel!.origin!;
    WidgetsBinding.instance.addObserver(this);
    Utils().getUserCurrentLocation('');
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    Utils().driverOfflineMethod();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      Utils().getUserCurrentLocation('');
    } else if (state == AppLifecycleState.inactive) {
      Common.locationStream.cancel();
      Utils().driverOfflineMethod();
    } else if (state == AppLifecycleState.paused) {
      Common.locationStream.cancel();
      Utils().driverOfflineMethod();
    }
    print('Current state = $state');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        systemOverlayStyle: SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
        elevation: 0,
        leading: BackButton(color: Colors.black),
        title: utils.poppinsMediumText('Order Details', 18.0, AppColors.blackColor, TextAlign.center),
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.only(top: 15, left: 15, right: 15),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                constraints: BoxConstraints(minHeight: 50.0),
                color: Colors.grey.shade100,
                padding: EdgeInsets.all(10),
                alignment: Alignment.center,
                child: utils.poppinsMediumText("#" + widget.orderModel!.orderId!, 16.0, AppColors.blackColor, TextAlign.start),
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                child: Row(
                  children: [
                    Expanded(
                      flex: 8,
                      child: Row(
                        children: [
                          SvgPicture.asset('assets/images/location.svg', color: AppColors.primaryColor, height: 25, width: 25),
                          Expanded(
                            child: TextFormField(
                              controller: dropOffLocationController,
                              minLines: 1,
                              maxLines: 5,
                              enabled: false,
                              decoration: utils.inputDecorationWithLabel('', 'Drop off Location', Colors.transparent, Colors.transparent),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Expanded(
                    //   flex: 2,
                    //   child: InkWell(
                    //     onTap: () {
                    //       openMap(double.parse(widget.orderModel!.latitude!), double.parse(widget.orderModel!.longitude!));
                    //     },
                    //     child: Container(
                    //       alignment: Alignment.centerRight,
                    //       child: Image.asset('assets/images/direction.png', height: 60, width: 60),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
              Container(
                constraints: BoxConstraints(minHeight: 50.0),
                padding: EdgeInsets.all(10),
                child: Row(
                  children: [
                    Container(
                      decoration: new BoxDecoration(
                        color: AppColors.whiteColor,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.primaryColor),
                      ),
                      height: 60,
                      width: 60,
                      child: widget.userModel!.profilePicture == null
                          ? SvgPicture.asset('assets/images/man.svg')
                          : widget.userModel!.profilePicture != 'default'
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    imageUrl: widget.userModel!.profilePicture!,
                                    progressIndicatorBuilder: (context, url, downloadProgress) => Container(
                                      height: 30,
                                      width: 30,
                                      child: Center(child: CircularProgressIndicator(value: downloadProgress.progress)),
                                    ),
                                    errorWidget: (context, url, error) => SvgPicture.asset('assets/images/man.svg'),
                                  ),
                                )
                              : SvgPicture.asset('assets/images/man.svg'),
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            utils.poppinsMediumText(
                              widget.userModel!.fullName != null && widget.userModel!.fullName != 'default' ? widget.userModel!.fullName : 'N/A',
                              16.0,
                              AppColors.blackColor,
                              TextAlign.start,
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 5),
                              width: 80,
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                              decoration: BoxDecoration(color: AppColors.primaryColor, borderRadius: BorderRadius.all(Radius.circular(30.0))),
                              child: Center(
                                  child: utils.poppinsMediumText(widget.orderModel!.paymentType!, 12.0, AppColors.whiteColor, TextAlign.center)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                constraints: BoxConstraints(minHeight: 50.0),
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 8,
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: utils.poppinsMediumText(
                          widget.userModel!.phoneNumber != null && widget.userModel!.phoneNumber != 'default' ? widget.userModel!.phoneNumber : 'N/A',
                          18.0,
                          AppColors.blackColor,
                          TextAlign.center,
                        ),
                      ),
                    ),
                    // Expanded(
                    //   flex: 2,
                    //   child: InkWell(
                    //     onTap: () {
                    //       _launchCaller("tel:" + widget.userModel!.phoneNumber!);
                    //     },
                    //     child: Container(
                    //       alignment: Alignment.centerRight,
                    //       child: Image.asset('assets/images/call_user.png', height: 60, width: 60),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 5),
                child: utils.poppinsSemiBoldText('Order Items', 16.0, AppColors.blackColor, TextAlign.center),
              ),
              for (int i = 0; i < widget.orderItems!.length; i++) OrderDetailsItemsWidget(orderItems: widget.orderItems![i]),
              SizedBox(height: 20),
              if (widget.status == 'Ongoing')
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: ActionSlider.standard(
                    width: Get.size.width,
                    height: 45,
                    backgroundColor: AppColors.primaryColor,
                    actionThresholdType: ThresholdType.release,
                    child: Container(
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.only(right: 10.0),
                        child: utils.poppinsMediumText('Slide to complete this order', 14.0, AppColors.whiteColor, TextAlign.center),
                      ),
                    action: (controller) async {
                      controller.loading(); //starts loading animation
                      await Future.delayed(const Duration(seconds: 3));
                      controller.success(); //starts success animation
                      await Future.delayed(const Duration(seconds: 1));
                      controller.reset(); // resets the slider

                      if(SliderMode.success.result)
                      {
                        changeOrderStatus('Delivered', widget.orderModel!);
                      }
                    },
                  ),
                  // child: SlideAction(
                  //   onSubmit: () {
                  //     changeOrderStatus('delivered', widget.orderModel!);
                  //   },
                  //   height: 45,
                  //   submittedIcon: Icon(Icons.check_rounded, color: AppColors.whiteColor),
                  //   sliderRotate: false,
                  //   alignment: Alignment.centerRight,
                  //   innerColor: AppColors.whiteColor,
                  //   outerColor: AppColors.primaryColor,
                  //   child: Container(
                  //     alignment: Alignment.centerRight,
                  //     padding: EdgeInsets.only(right: 10.0),
                  //     child: utils.poppinsMediumText('Slide to complete this order', 14.0, AppColors.whiteColor, TextAlign.center),
                  //   ),
                  //   sliderButtonIcon: Icon(Icons.double_arrow_outlined),
                  // ),
                ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  _launchCaller(url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> openMap(double latitude, double longitude) async {
    String googleUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunchUrl(Uri.parse(googleUrl))) {
      await launchUrl(Uri.parse(googleUrl));
    } else {
      throw 'Could not open the map.';
    }
  }

  changeOrderStatus(String status, OrderModel orderModel) async {
    utils.showLoadingDialog();
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
      orderModel.status ='Delivered'.toString();

      print('deliverpicture${orderModel.deliveryPicture}');
      if(orderModel.deliveryPicture!=null) {
        Query query = databaseReference.child('OrderHistory').orderByChild("orderId").equalTo(orderModel.orderId);
        await query.once().then((DatabaseEvent event) async {
          if (event.snapshot.exists) {
            Map<String, dynamic> mapOfMaps = Map.from(event.snapshot.value as Map);
            mapOfMaps.keys.forEach((value) async {
              print("orderModel:${orderModel.toJson()}");

              await databaseReference.child('OrderHistory').child(value.toString()).update(orderModel.toJson()).then((value) {
                removeOrder(orderModel);
              });
              ///Uncoment
              await databaseReference.child('OrdersByPicture').push().set(orderModel.toJson());
              //await databaseReference.child('Drivers').child(utils.getUserId()).update({'onlineStatus': 'free'});
              Get.back();
              Get.back();
              SchedulerBinding.instance.addPostFrameCallback((_) {

                // add your code here.

                //Get.offUntil(MaterialPageRoute(builder: (_) => HomeScreen()), (route) => false);
              });

              utils.showToast("Order Delivered Successfully");
            });
          }
        });
      }
  }
  }

  removeOrder(OrderModel orderModel)async{
    Query query = databaseReference.child('Orders').orderByChild("orderId").equalTo(orderModel.orderId);
    Query tempQuery = databaseReference.child('OnceOrders').orderByChild("orderId").equalTo(orderModel.orderId);
    await query.once().then((DatabaseEvent event) async {
      if (event.snapshot.exists) {
        Map<String, dynamic> mapOfMaps = Map.from(event.snapshot.value as Map);
        mapOfMaps.keys.forEach((value) async {
          await databaseReference.child('Orders').child(value.toString()).remove();
        });
      }else{
        await tempQuery.once().then((DatabaseEvent event) async {
          if (event.snapshot.exists) {
            Map<String, dynamic> mapOfMaps = Map.from(event.snapshot.value as Map);
            mapOfMaps.keys.forEach((value) async {
              await databaseReference.child('OnceOrders').child(value.toString()).remove();
            });
          }
        });
      }
    });
  }
}
