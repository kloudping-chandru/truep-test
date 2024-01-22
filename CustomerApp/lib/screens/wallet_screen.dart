import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foodizm_subscription/colors.dart';
import 'package:foodizm_subscription/common/common.dart';
import 'package:foodizm_subscription/screens/previous_order_history.dart';
import 'package:foodizm_subscription/screens/wallet_transaction_history.dart';
import 'package:foodizm_subscription/utils/utils.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class WalletScreen extends StatefulWidget {
  final String? status;
  const WalletScreen({Key? key, this.status}) : super(key: key);

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  Utils utils = Utils();
  Rx<TextEditingController> amountController = new TextEditingController().obs;
  RxString amount = "0".obs;
  List<String> amountList = [
    "1000.00",
    "2000.00",
    "3000.00",
  ];
  var firebaseDatabase = FirebaseDatabase.instance.ref();
  RxBool hasData = false.obs;
  late Razorpay _razorpay;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentErrorResponse);
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccessResponse);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWalletSelected);
    getUserWallet();
  }

  void handlePaymentErrorResponse(PaymentFailureResponse response) {
    /*
    * PaymentFailureResponse contains three values:
    * 1. Error Code
    * 2. Error Description
    * 3. Metadata
    * */
    print("Error");
    print(response.code);
    utils.showToast('Payment Failed - ${response.message}');

    // showAlertDialog(context, "Payment Failed", "Code: ${response.code}\nDescription: ${response.message}\nMetadata:${response.error.toString()}");
  }

  void handlePaymentSuccessResponse(PaymentSuccessResponse response) {
    /*
    * Payment Success Response contains three values:
    * 1. Order ID
    * 2. Payment ID
    * 3. Signature
    * */
    print("Success");
    print(response.orderId);
    firebaseDatabase.child('Users').child(utils.getUserId()).update({
      'userWallet': (double.parse(amountController.value.text.toString()) +
              double.parse(Common.wallet.value))
          .toString()
    }).whenComplete(() {
      Common.userModel.userWallet = amountController.value.text.toString();
      Common.wallet.value =
          (double.parse(amountController.value.text.toString()) +
                  double.parse(Common.wallet.value))
              .toString();

      Map<String, dynamic> orderData = {
        "paymentId": response.paymentId,
        "orderId": response.orderId,
        "signatureId": response.signature,
        "amountAdded": amountController.value.text.toString(),
        "uid": Common.userModel.uid,
        "timeAdded": DateTime.now().millisecondsSinceEpoch.toString(),
      };
      firebaseDatabase
          .child('WalletHistory')
          .push()
          .set(orderData)
          .then((snapShot) {
        utils.showToast('Your wallet has Updated');
      });
    });
    // showAlertDialog(context, "Payment Successful", "Payment ID: ${response.paymentId}");
  }

  void handleExternalWalletSelected(ExternalWalletResponse response) {
    print("external value");
    print(response.walletName);
    // showAlertDialog(context, "External Wallet Selected", "${response.walletName}");
  }

  Future getUserWallet() async {
    amount.value = amountList[0];
    amountController.value.text = amountList[0];
    firebaseDatabase
        .child("Users")
        .child(utils.getUserId().toString())
        .get()
        .then((value) {
      if (value.value != null) {
        Map<dynamic, dynamic> mapDatavalue = Map.from(value.value as Map);
        amount.value = amountController.value.text.isEmpty
            ? "0"
            : amountController.value.text;
        Common.wallet.value = mapDatavalue['userWallet'];
        print(mapDatavalue);
      }
    });
    hasData.value = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 15.0, vertical: 20.0),
                margin: const EdgeInsets.symmetric(horizontal: 15.0),
                decoration: utils.boxDecoration(
                    Colors.white, Colors.transparent, 15.0, 0.0,
                    isShadow: true, shadowColor: AppColors.greyColor),
                child: Column(
                  children: [
                    hasData.value == true
                        ? Obx(
                            () => Row(
                              children: [
                                Expanded(
                                    child: utils.poppinsSemiBoldText(
                                        "walletBalance".tr,
                                        18.0,
                                        AppColors.blackColor,
                                        TextAlign.start)),
                                utils.poppinsSemiBoldText(
                                    "${Common.currency} ${num.parse(Common.wallet.value).toStringAsFixed(2)}",
                                    18.0,
                                    AppColors.blackColor,
                                    TextAlign.end)
                              ],
                            ),
                          )
                        : CupertinoActivityIndicator()
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
                padding: const EdgeInsets.symmetric(
                    horizontal: 15.0, vertical: 20.0),
                margin: const EdgeInsets.symmetric(horizontal: 15.0),
                decoration: utils.boxDecoration(
                    Colors.white, Colors.transparent, 15.0, 0.0,
                    isShadow: true, shadowColor: AppColors.greyColor),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    utils.poppinsRegularText("enterAmount".tr, 14.0,
                        AppColors.blackColor, TextAlign.start),
                    Obx(
                      () => TextFormField(
                        controller: amountController.value,
                        decoration: const InputDecoration(
                            border: UnderlineInputBorder()),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "enterAmountToPay".tr;
                          }
                          return null;
                        },
                        onChanged: (value) {
                          amount.value = value.isEmpty ? "0" : value;
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    chooseAmountWidget(),
                    const SizedBox(height: 20),
                    utils.poppinsRegularText("rechargeAmount".tr, 14.0,
                        AppColors.lightGreyColor, TextAlign.start),
                    Obx(
                      () => InkWell(
                        onTap: double.parse(amount.value) < 1
                            ? null
                            : () {
                                var options = {
                                  // 'key': 'rzp_live_ILgsfZCZoFIKMb',
                                  'key': 'rzp_test_PENDeiNbw1WXUl',
                                  'amount': double.parse(amountController
                                          .value.text
                                          .toString()) *
                                      100,
                                  'name': 'Trupressed',
                                  'description': 'Add to Wallet',
                                  'retry': {'enabled': true, 'max_count': 1},
                                  'send_sms_hash': true,
                                  'prefill': {
                                    'contact':
                                        Common.userModel.phoneNumber ?? "",
                                    'email': Common.userModel.email ?? "",
                                  },
                                  'external': {
                                    'wallets': ['paytm']
                                  }
                                };
                                _razorpay.open(options);
                              },
                        child: Container(
                          height: 45,
                          margin: const EdgeInsets.only(top: 20),
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: (double.parse(amount.value) < 1)
                                ? AppColors.greyColor
                                : AppColors.primaryColor,
                            borderRadius:
                                BorderRadius.all(Radius.circular(30.0)),
                          ),
                          child: Center(
                              child: utils.poppinsMediumText('pay'.tr, 16.0,
                                  AppColors.whiteColor, TextAlign.center)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              InkWell(
                onTap: () {
                  Get.to(() => const WalletTransactionHistory());
                  //showLogoutDialog();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 15.0, vertical: 20.0),
                  margin: const EdgeInsets.symmetric(horizontal: 15.0),
                  decoration: utils.boxDecoration(
                      Colors.white, Colors.transparent, 15.0, 0.0,
                      isShadow: true, shadowColor: AppColors.greyColor),
                  child: Column(
                    children: [
                      Center(
                          child: utils.poppinsSemiBoldText(
                              "walletTransactions".tr,
                              18.0,
                              AppColors.blackColor,
                              TextAlign.start)),
                      // Row(
                      //   children: [
                      //     Expanded(child: utils.poppinsRegularText("tomorrowValue".tr, 14.0, AppColors.blackColor, TextAlign.start)),
                      //     utils.poppinsRegularText("${Common.currency} 88.00", 14.0, AppColors.blackColor, TextAlign.end)
                      //   ],
                      // ),
                    ],
                  ),
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
                amountController.value.text = amountList[i];
              },
              hoverColor: Colors.transparent,
              child: IntrinsicWidth(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
                  decoration: utils.boxDecoration(
                      AppColors.whiteColor,
                      amount.value == amountList[i]
                          ? AppColors.primaryColor
                          : AppColors.lightGreyColor,
                      20.0,
                      1.0),
                  child: Center(
                      child: utils.poppinsRegularText(
                          "${Common.currency} ${amountList[i]}",
                          16.0,
                          amount.value == amountList[i]
                              ? AppColors.primaryColor
                              : AppColors.blackColor,
                          TextAlign.center)),
                ),
              ),
            ),
        ],
      );
    });
  }
}
