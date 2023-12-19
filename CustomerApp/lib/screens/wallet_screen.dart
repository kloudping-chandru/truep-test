import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foodizm_subscription/colors.dart';
import 'package:foodizm_subscription/common/common.dart';
import 'package:foodizm_subscription/utils/utils.dart';
import 'package:get/get.dart';

class WalletScreen extends StatefulWidget {
  final String? status;
  const WalletScreen({Key? key,this.status}) : super(key: key);

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  Utils utils = Utils();
  Rx<TextEditingController> amountController = new TextEditingController().obs;
  RxString amount = "".obs;
  List<String> amountList = ["1000.00", "2000.00", "3000.00",];
  var firebaseDatabase = FirebaseDatabase.instance.ref();
  RxBool hasData = false.obs;
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserWallet();
  }
  Future getUserWallet()async {
    firebaseDatabase.child("Users").child(utils.getUserId().toString()).get().then((value) {
      if(value.value != null)
        {
          Map<dynamic,dynamic> mapDatavalue = Map.from(value.value as Map);
          amountController.value.text = mapDatavalue['userWallet'];
          Common.wallet.value =  mapDatavalue['userWallet'];
          print(mapDatavalue);
        }
    });
    hasData.value = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
         leading:widget.status =='wallet'? BackButton(color: Colors.black):null,
        systemOverlayStyle: const SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
        elevation: 0,
        title: utils.poppinsMediumText('wallet'.tr, 16.0, AppColors.blackColor, TextAlign.center),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
                margin: const EdgeInsets.symmetric(horizontal: 15.0),
                decoration: utils.boxDecoration(Colors.white, Colors.transparent, 15.0, 0.0, isShadow: true, shadowColor: AppColors.greyColor),
                child: Column(
                  children: [
                 hasData.value == true? Obx(() =>   Row(
                    children: [
                      Expanded(child: utils.poppinsSemiBoldText("walletBalance".tr, 18.0, AppColors.blackColor, TextAlign.start)),
                      utils.poppinsSemiBoldText("${Common.currency} ${Common.wallet}", 18.0, AppColors.blackColor, TextAlign.end)
                    ],
                  ),
                 ): CupertinoActivityIndicator()
                    // Row(
                    //   children: [
                    //     Expanded(child: utils.poppinsRegularText("tomorrowValue".tr, 14.0, AppColors.blackColor, TextAlign.start)),
                    //     utils.poppinsRegularText("${Common.currency} 88.00", 14.0, AppColors.blackColor, TextAlign.end)
                    //   ],
                    // ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: Get.size.width,
                padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
                margin: const EdgeInsets.symmetric(horizontal: 15.0),
                decoration: utils.boxDecoration(Colors.white, Colors.transparent, 15.0, 0.0, isShadow: true, shadowColor: AppColors.greyColor),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    utils.poppinsRegularText("enterAmount".tr, 14.0, AppColors.blackColor, TextAlign.start),
                   Obx(() =>   TextFormField(
                     controller: amountController.value,
                     decoration: const InputDecoration(border: UnderlineInputBorder()),
                     validator: (value) {
                       if (value!.isEmpty) {
                         return "enterAmountToPay".tr;
                       }
                       return null;
                     },
                   ),),
                    const SizedBox(height: 20),
                    chooseAmountWidget(),
                    const SizedBox(height: 20),
                    utils.poppinsRegularText("rechargeAmount".tr, 14.0, AppColors.lightGreyColor, TextAlign.start),
                    InkWell(
                      onTap: ()
                      {
                        firebaseDatabase.child('Users').child(utils.getUserId()).update({'userWallet':  (double.parse(amountController.value.text.toString())+ double.parse(Common.wallet.value)).toString()}).whenComplete((){
                          Common.userModel.userWallet= amountController.value.text.toString();
                          Common.wallet.value = (double.parse(amountController.value.text.toString())+ double.parse(Common.wallet.value)).toString();
                          utils.showToast('Your wallet has Updated');
                        });
                      },
                      child: Container(
                        height: 45,
                        margin: const EdgeInsets.only(top: 20),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: const BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        ),
                        child: Center(child: utils.poppinsMediumText('pay'.tr, 16.0, AppColors.whiteColor, TextAlign.center)),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget chooseAmountWidget() {
    return Obx(() {
      return Wrap(
        spacing: 10.0,
        runSpacing: 10.0,
        alignment: WrapAlignment.start,
        crossAxisAlignment: WrapCrossAlignment.start,
        runAlignment: WrapAlignment.start,
        children: [
          for (int i = 0; i < amountList.length; i++)
            InkWell(
              onTap: () async {
                amount.value = amountList[i];
                amountController.value.text =amountList[i];
              },
              hoverColor: Colors.transparent,
              child: IntrinsicWidth(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
                  decoration: utils.boxDecoration(
                      AppColors.whiteColor, amount.value == amountList[i] ? AppColors.primaryColor : AppColors.lightGreyColor, 20.0, 1.0),
                  child: Center(
                      child: utils.poppinsRegularText("${Common.currency} ${amountList[i]}", 16.0,
                          amount.value == amountList[i] ? AppColors.primaryColor : AppColors.blackColor, TextAlign.center)),
                ),
              ),
            ),
        ],
      );
    });
  }

 
}
