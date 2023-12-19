import 'package:action_slider/action_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foodizm_admin_app/colors.dart';
import 'package:foodizm_admin_app/database_model/cart_model.dart';
import 'package:foodizm_admin_app/database_model/driver_model.dart';
import 'package:foodizm_admin_app/database_model/order_model.dart';
import 'package:foodizm_admin_app/database_model/user_model.dart';
import 'package:foodizm_admin_app/screens/my_drivers_screen.dart';
import 'package:foodizm_admin_app/screens/order_details_screen.dart';
import 'package:foodizm_admin_app/utils/utils.dart';
import 'package:foodizm_admin_app/widget/order_details_items_widget.dart';
import 'package:get/get.dart';

class OrderWidget extends StatefulWidget {
  final String? status;
  final OrderModel? orderModel;
  final Function? function;

  const OrderWidget({Key? key, this.status, this.orderModel, this.function}) : super(key: key);

  @override
  _OrderWidgetState createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<OrderWidget> {
  Utils utils = new Utils();
  var dropOffLocationController = new TextEditingController();
  RxList<CartModel> orderItems = <CartModel>[].obs;
  Rx<UserModel> userModel = new UserModel().obs;
  Rx<DriverModel> driverModel = new DriverModel().obs;

  @override
  void initState() {
    super.initState();
    dropOffLocationController.text = widget.orderModel!.origin!;
    getCustomerDetails();

    print('status${widget.status}');

    if (widget.status == 'OnTheWay' || widget.status == 'Delivered') {
      if (widget.orderModel!.driverUid != null) {
        getDriverDetails();
      }
    }

    if (widget.orderModel!.items != null) {
      for (int i = 0; i < widget.orderModel!.items!.length; i++) {
        Map<String, dynamic> mapOfMaps = Map.from(widget.orderModel!.items![i]!);
        orderItems.add(CartModel.fromJson(Map.from(mapOfMaps)));
      }
    }
  }

  getCustomerDetails() async {
    await FirebaseDatabase.instance.ref().child('Users').child(widget.orderModel!.uid!).once().then((DatabaseEvent event) {
      if (event.snapshot.exists) {
        userModel.value = UserModel.fromJson(Map.from(event.snapshot.value as Map));
      }
    });
  }

  getDriverDetails() async {
    await FirebaseDatabase.instance
        .ref()
        .child('Drivers')
        .child(widget.orderModel!.driverUid!)
        .once()
        .then((DatabaseEvent event) {
      if (event.snapshot.exists) {
        driverModel.value = DriverModel.fromJson(Map.from(event.snapshot.value as Map));
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
         Get.to(() => OrderDetailsScreen(status: widget.status, orderModel: widget.orderModel!, orderItems: orderItems));
      },
      child: Container(
        margin: EdgeInsets.all(5),
        child: Obx(() => Column(
              children: [
                Container(
                  constraints: BoxConstraints(minHeight: 50.0),
                  color: Colors.grey.shade100,
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
                        child: userModel.value.profilePicture == null
                            ? SvgPicture.asset('assets/images/man.svg')
                            : userModel.value.profilePicture != 'default'
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: CachedNetworkImage(
                                      fit: BoxFit.cover,
                                      imageUrl: userModel.value.profilePicture!,
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
                                userModel.value.fullName != null && userModel.value.fullName != 'default'
                                    ? userModel.value.fullName
                                    : 'N/A',
                                16.0,
                                AppColors.blackColor,
                                TextAlign.start,
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 5),
                                width: 80,
                                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                                decoration: BoxDecoration(
                                    color: AppColors.primaryColor, borderRadius: BorderRadius.all(Radius.circular(30.0))),
                                child: Center(
                                    child: utils.poppinsMediumText(
                                        widget.orderModel!.paymentType!, 12.0, AppColors.whiteColor, TextAlign.center)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  color: AppColors.orderBgColor,
                  padding: EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (int i = 0; i < orderItems.length; i++) OrderDetailsItemsWidget(orderItems: orderItems[i]),
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        child: Row(
                          children: [
                            SvgPicture.asset('assets/images/location.svg', color: AppColors.primaryColor, height: 25, width: 25),
                            Expanded(
                              child: TextFormField(
                                controller: dropOffLocationController,
                                minLines: 1,
                                maxLines: 5,
                                enabled: false,
                                decoration: utils.inputDecorationWithLabel(
                                    '', 'Drop off Location', Colors.transparent, Colors.transparent),
                              ),
                            )
                          ],
                        ),
                      ),
                      if (widget.status == 'OnTheWay' || widget.status == 'Delivered')
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 5),
                              child:
                                  utils.poppinsMediumText('Assigned Driver : ', 14.0, AppColors.lightGrey2Color, TextAlign.start),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 5),
                              child: utils.poppinsMediumText(
                                driverModel.value.fullName != null && driverModel.value.fullName != 'default'
                                    ? driverModel.value.fullName
                                    : 'N/A',
                                14.0,
                                AppColors.blackColor,
                                TextAlign.start,
                              ),
                            )
                          ],
                        ),
                      if (widget.status == 'Pending' || widget.status == 'Accepted' || widget.status == 'Preparing')

                        Container(
                          margin: EdgeInsets.only(top: 10),
                          child: ActionSlider.standard(
                            width: Get.size.width,
                            actionThresholdType: ThresholdType.release,
                            child: Text(setText()),
                            height: 45,
                            backgroundColor: AppColors.primaryColor,
                            action: (controller) async {
                              controller.loading(); //starts loading animation
                              await Future.delayed(const Duration(seconds: 3));
                              controller.success(); //starts success animation
                              await Future.delayed(const Duration(seconds: 1));
                              controller.reset(); //resets the slider

                               if(SliderMode.success.result)
                                 {
                                   if (widget.status == 'Pending') {
                                     print('Hello_Order_Widget');
                                     widget.function!('completed', widget.orderModel!);
                                   } else if (widget.status == 'Accepted') {
                                     widget.function!('preparing', widget.orderModel!);
                                   } else if (widget.status == 'Preparing') {
                                     Get.to(() => MyDriverScreen(orderModel: widget.orderModel!));
                                   }
                                 }
                            },
                          ),
                        ),
                      // if (widget.status == 'Pending')
                      //   Container(
                      //     margin: EdgeInsets.only(top: 20),
                      //     child: ActionSlider.standard(
                      //       width: Get.size.width,
                      //       actionThresholdType: ThresholdType.release,
                      //       child: Text("Slide To Reject"),
                      //       height: 45,
                      //       backgroundColor: AppColors.primaryColor,
                      //       action: (controller) async {
                      //         controller.loading(); //starts loading animation
                      //         await Future.delayed(const Duration(seconds: 3));
                      //         controller.success(); //starts success animation
                      //         await Future.delayed(const Duration(seconds: 1));
                      //         controller.reset(); //resets the slider
                      //
                      //         if (SliderMode.success.result) {
                      //           showRejectDialog();
                      //         }
                      //       },
                      //     ),
                      //   ),
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }

  setText() {
    if (widget.status == 'Pending')
      return 'Slide To Ended Order';
    else if (widget.status == 'Accepted')
      return 'Slide To Start Preparing';
    else if (widget.status == 'Preparing') return 'Slide To Assign Driver';
  }

  setColors() {
    if (widget.status == 'Pending')
      return AppColors.greenColor;
    else if (widget.status == 'Accepted')
      return AppColors.primaryColor;
    else if (widget.status == 'Preparing') return AppColors.primaryColor;
  }

  void showRejectDialog() {
    Get.defaultDialog(
      title: "Confirmation",
      content: Text(
        "Do you want to reject this order?",
        textAlign: TextAlign.center,
      ),
      cancel: ElevatedButton(
        onPressed: () {
          Get.back();
        },
        child: Text("No"),
        style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryColor),
      ),
      confirm: ElevatedButton(
        onPressed: () async {
          Get.back();
          widget.function!('rejected', widget.orderModel!);
        },
        child: Text("Yes"),
        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
      ),
    );
  }
}
