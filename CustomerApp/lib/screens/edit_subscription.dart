import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:trupressed_subscription/common/common.dart';

import '../colors.dart';
import '../utils/utils.dart';
import 'edit_subscription_tab_bar/once_order_subscription.dart';
import 'edit_subscription_tab_bar/regular_subscription.dart';

class EditSubscription extends StatefulWidget {
  const EditSubscription({Key? key}) : super(key: key);

  @override
  State<EditSubscription> createState() => _EditSubscriptionState();
}

class _EditSubscriptionState extends State<EditSubscription>with SingleTickerProviderStateMixin {
  Utils utils = Utils();
  TabController? _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController!.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
      AppBar(
        backgroundColor: AppColors.whiteColor,
        systemOverlayStyle: SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
        elevation: 0,
        leading: BackButton(color: Colors.black),
        title: utils.poppinsMediumText('Edit Subscription', 18.0, AppColors.blackColor, TextAlign.center),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //utils.poppinsSemiBoldText('Jobs', 22.0,AppColorr., TextAlign.start),
            Align(
              alignment: Alignment.center,
              child: Container(
                height: 45,
                width: Get.width,
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(vertical:10 ),
               // decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(25.0)),
                child: TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  indicator: BoxDecoration(borderRadius: BorderRadius.circular(25.0), color:Colors.blue),
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.black,
                  tabs:  [
                    Container(
                        width: 160,
                        height: 45,
                        alignment: Alignment.center,
                        child:Text('Regular',style: TextStyle(fontFamily: 'Poppins',fontSize: 16),),),
                        //child: new Tab(text: 'Regular Subscription',),),
                    Container(
                        width: 160,
                      height: 45,
                      alignment: Alignment.center,
                      child:Text(Common.orderOnce,style: TextStyle(fontFamily: 'Poppins',fontSize: 16),),),



                    // Tab(text: 'Ongoing'),
                    // Tab(text: 'New Post'),
                    // // Tab(text: 'preparing'.tr),
                    // // Tab(text: 'onTheWay'.tr),
                    // Tab(text: 'Completed'),
                    // Tab(text: 'delivered'.tr),

                  ],
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const [
                  RegularSubscription(),
                  OnceOrderSubscription(),
                ],
              ),
            )
          ],
        ),
      ),
    );

  }
}