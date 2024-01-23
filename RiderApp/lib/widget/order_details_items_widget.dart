import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:foodizm_driver_app/colors.dart';
import 'package:foodizm_driver_app/models/cart_model.dart';
import 'package:foodizm_driver_app/models/variation_model.dart';
import 'package:foodizm_driver_app/utils/utils.dart';
import 'package:intl/intl.dart';

import '../models/order_model.dart';

class OrderDetailsItemsWidget extends StatefulWidget {
  final CartModel orderItems;
  final OrderModel? orderModel;

  const OrderDetailsItemsWidget(
      {Key? key, required this.orderItems, required this.orderModel})
      : super(key: key);

  @override
  _OrderDetailsItemsWidgetState createState() =>
      _OrderDetailsItemsWidgetState();
}

class _OrderDetailsItemsWidgetState extends State<OrderDetailsItemsWidget> {
  Utils utils = new Utils();
  List<VariationModel>? variationModel = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    variationModel!.clear();
    if (widget.orderItems.type == 'item') {
      if (widget.orderItems.customizationForVariations != null) {
        for (int i = 0;
            i < widget.orderItems.customizationForVariations!.length;
            i++) {
          Map<String, dynamic> mapOfMaps =
              Map.from(widget.orderItems.customizationForVariations![i]!);
          variationModel!.add(VariationModel.fromJson(Map.from(mapOfMaps)));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // return Container(
    //   margin: EdgeInsets.only(top: 5),
    //   child: utils.poppinsMediumText(setText(widget.orderItems!), 14.0, AppColors.blackColor, TextAlign.start),
    // );
    return displayOrderDetails(widget.orderItems, widget.orderModel);
  }

  Widget displayOrderDetails(CartModel orderItems, OrderModel? orderModel) {
    DateTime dateTime = DateTime.now();
    String day = DateFormat('EE, dd MMM').format(dateTime);
    var selectedDay = day.split(',').first.toString();
    int selectedQuantity = -1;
    (orderModel?.orderDaysModel ?? []).forEach((OrderDaysModel element) {
      if (element.days == selectedDay) {
        selectedQuantity = element.quantity ?? 0;
      }
    });
    if (selectedQuantity == -1 &&
        (orderModel?.orderDaysModel ?? []).isNotEmpty) {
      selectedQuantity = (orderModel?.orderDaysModel ?? []).first.quantity ?? 0;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
      margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      decoration: utils.boxDecoration(Colors.white, Colors.transparent,
          radius: 15.0,
          borderWidth: 0.0,
          isShadow: true,
          shadowColor: AppColors.greyColor),
      child: Row(
        children: [
          Expanded(flex: 6, child: renderDescription(orderItems)),
          SizedBox(width: 10,),
          renderAmount(orderItems, selectedQuantity),
        ],
      ),
    );
  }

  renderDescription(CartModel orderItems) {
    return Row(
      children: [
        Container(
          height: 80,
          width: 80,
          padding: const EdgeInsets.all(10.0),
          child: ClipRRect(
            child: (orderItems.image ?? "").isNotEmpty
                ? CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl: orderItems.image ?? "",
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) => SizedBox(
                      height: 40,
                      width: 40,
                      child: Center(
                          child: CircularProgressIndicator(
                              value: downloadProgress.progress)),
                    ),
                    errorWidget: (context, url, error) => Image.asset(
                        'assets/images/placeholder_image.png',
                        fit: BoxFit.cover),
                  )
                : Image.asset('assets/images/placeholder_image.png',
                    fit: BoxFit.cover),
          ),
        ),
        Expanded(
          child: Column(
            children: [
              utils.poppinsMediumText(
                  orderItems.title, 14.0, AppColors.blackColor, TextAlign.start,
                  maxlines: 2),
              utils.poppinsMediumText(orderItems.details, 12.0,
                  AppColors.blackColor, TextAlign.start),
              utils.poppinsMediumText(
                  orderItems.type, 12.0, AppColors.blackColor, TextAlign.start),
            ],
          ),
        )
      ],
    );
  }

  renderAmount(CartModel orderItems, int selectedQuantity) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        utils.poppinsMediumText(
            "INR ${(int.parse(orderItems.newPrice ?? "0")) * (selectedQuantity > 1 ? selectedQuantity : 1)}",
            14.0,
            AppColors.blackColor,
            TextAlign.center),
        if (selectedQuantity == 1)
          utils.poppinsMediumText(
              "(INR ${orderItems.newPrice} X ${selectedQuantity})",
              12.0,
              AppColors.blackColor,
              TextAlign.center),
      ],
    );
  }

  setText(CartModel orderItems) {
    String text = '';
    if (orderItems.type == 'deal') {
      if (orderItems.customizationForDrinks!.length > 0 &&
          orderItems.customizationForFlavours!.length > 0) {
        if (orderItems.customizationForDrinks![0] != 'default' &&
            orderItems.customizationForFlavours![0] != 'default') {
          text = orderItems.title! +
              ' ( ' +
              orderItems.customizationForDrinks![0] +
              " , " +
              orderItems.customizationForFlavours![0] +
              " , )";
        } else if (orderItems.customizationForDrinks![0] != 'default') {
          text = orderItems.title! +
              ' ( ' +
              orderItems.customizationForDrinks![0] +
              " )";
        } else if (orderItems.customizationForFlavours![0] != 'default') {
          text = orderItems.title! +
              ' ( ' +
              orderItems.customizationForFlavours![0] +
              " )";
        } else {
          text = orderItems.title!;
        }
      }
    } else if (orderItems.type == 'item') {
      if (variationModel!.length > 0 &&
          orderItems.customizationForFlavours!.length > 0) {
        if (variationModel![0].name != 'default' &&
            orderItems.customizationForFlavours![0] != 'default') {
          text = orderItems.title! +
              ' ( ' +
              variationModel![0].name! +
              " , " +
              orderItems.customizationForFlavours![0] +
              " , )";
        } else if (variationModel![0].name != 'default') {
          text = orderItems.title! + ' ( ' + variationModel![0].name! + " )";
        } else if (orderItems.customizationForFlavours![0] != 'default') {
          text = orderItems.title! +
              ' ( ' +
              orderItems.customizationForFlavours![0] +
              " )";
        } else {
          text = orderItems.title!;
        }
      } else {
        text = orderItems.title!;
      }
    }

    return text.isEmpty ? "${orderItems.type}" : text;
  }
}
