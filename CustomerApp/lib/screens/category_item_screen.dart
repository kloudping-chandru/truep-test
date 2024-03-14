import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trupressed_subscription/models/categories_model.dart';
import 'package:trupressed_subscription/screens/product_details_screen.dart';
import 'package:get/get.dart';
import '../colors.dart';
import '../common/common.dart';
import '../models/product_model.dart';
import '../utils/utils.dart';
import '../widgets/set_repeating_order_once_widget.dart';

class CategoryItemScreen extends StatefulWidget {
  final CategoriesModel? categoriesModel;
  final String? title;

  const CategoryItemScreen({Key? key, this.categoriesModel, this.title}) : super(key: key);

  @override
  State<CategoryItemScreen> createState() => _CategoryItemScreenState();
}

class _CategoryItemScreenState extends State<CategoryItemScreen> {
  RxList<ProductModel> productList = <ProductModel>[].obs;
  var databaseReference = FirebaseDatabase.instance.ref();
  RxBool hasItems = false.obs;
  Utils utils = Utils();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    showCategoryItems(widget.title != 'Search' ? widget.categoriesModel!.timeCreated! : '');
  }

  showCategoryItems(String categoryId) async {
    productList.clear();
    Query query;
    if (widget.title == 'Search') {
      query = databaseReference.child('Items');
    } else {
      query = databaseReference.child('Items').orderByChild('categoryId').equalTo(categoryId);
    }
    await query.once().then((DatabaseEvent event) {
      if (event.snapshot.value != null) {
        Map<String, dynamic> mapOfMaps = Map.from(event.snapshot.value as Map);
        mapOfMaps.values.forEach((value) {
          productList.add(ProductModel.fromJson(Map.from(value)));
        });
      }
      hasItems.value = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        systemOverlayStyle: SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
        elevation: 0,
        leading: BackButton(color: Colors.black),
        title: utils.poppinsMediumText(widget.title, 18.0, AppColors.blackColor, TextAlign.center),
        centerTitle: true,
      ),
      body: Obx(() {
        if (hasItems.value) {
          if (productList.isNotEmpty) {
            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  for (int i = 0; i < productList.length; i++) Container(child: productWidget(productList[i]))
                  // ProductsWidget(productModel: Common.popularProductList[i], width: 200.0, origin: 'popular'),
                ],
              ),
            );
          } else {
            return utils.noDataWidget('noItemsFound'.tr, 200.0);
          }
        } else {
          return Container(
            height: 200,
            child: Center(child: CircularProgressIndicator(backgroundColor: AppColors.primaryColor, color: AppColors.whiteColor)),
          );
        }
      }),
    );
  }

  Widget productWidget(ProductModel productModel) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
      margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      decoration:
          utils.boxDecoration(Colors.white, Colors.transparent, 15.0, 0.0, isShadow: true, shadowColor: AppColors.greyColor),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                height: 100,
                width: 100,
                padding: const EdgeInsets.all(12.0),
                child: ClipRRect(
                  child: productModel.image!.isNotEmpty
                      ? CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl: productModel.image!,
                          progressIndicatorBuilder: (context, url, downloadProgress) => SizedBox(
                            height: 50,
                            width: 50,
                            child: Center(child: CircularProgressIndicator(value: downloadProgress.progress)),
                          ),
                          errorWidget: (context, url, error) =>
                              Image.asset('assets/images/placeholder_image.png', fit: BoxFit.cover),
                        )
                      : Image.asset('assets/images/placeholder_image.png', fit: BoxFit.cover),
                ),
              ),

              // Image.network(
              //   "https://i.pinimg.com/736x/3d/f0/08/3df00837ee2dcd3e05da01509bdbe55c.jpg",
              //   height: 100,
              //   width: 100,
              // ),
              // Image.asset(
              //   image,
              //   height: 100,
              //   width: 100,
              // ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    utils.poppinsMediumText("Trupressed", 16.0, AppColors.lightGrey2Color, TextAlign.start),
                    // utils.poppinsMediumText("A2 Desi Cow Milk", 18.0,
                    //     AppColors.blackColor, TextAlign.start),
                    utils.poppinsMediumText(productModel.title!, 18.0, AppColors.blackColor, TextAlign.start),
                    // utils.poppinsMediumText("500 ML", 14.0,
                    //     AppColors.lightGreyColor, TextAlign.start),
                    Container(
                      width: 200,
                      child: utils.poppinsMediumText(productModel.details!, 14.0, AppColors.lightGreyColor, TextAlign.start,
                          maxlines: 2),
                    ),
              
                    utils.poppinsMediumText(
                        "${Common.currency} ${productModel.price}", 18.0, AppColors.blackColor, TextAlign.start),
                  ],
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: InkWell(
                  onTap: ()
                  {
                    double.parse(productModel.productQuantity!.toString()) > 10.0 ?
                    Get.bottomSheet(
                      SizedBox(height: 530,
                          child: SetRepeatingOrderOnceWidget(productModel: productModel)),
                      backgroundColor: AppColors.whiteColor,
                      isScrollControlled: true,
                      enableDrag: false,
                      isDismissible: false,
                    ): utils.showToast('Product is out of Stock');

                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 7.0),
                    margin: const EdgeInsets.symmetric(
                    ),
                    decoration: utils.boxDecoration(
                        AppColors.primaryColor, Colors.transparent, 20.0, 0.0),
                    child: Center(
                        child: utils.poppinsMediumText('Once Order', 16.0,
                            AppColors.whiteColor, TextAlign.center)),
                  ),
                ),
              ),
              const SizedBox(width: 10,),
              Expanded(
                child: InkWell(
                  onTap: () => Get.to(ProductDetailsScreen(productModel: productModel)),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 7.0),
                    margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                    decoration: utils.boxDecoration(AppColors.primaryColor, Colors.transparent, 20.0, 0.0),
                    child: Center(child: utils.poppinsMediumText('subscribe'.tr, 16.0, AppColors.whiteColor, TextAlign.center)),
                  ),
                ),
              ),

            ],
          ),
        ],
      ),
    );
    //   InkWell(
    //   onTap: () => Get.to(() => const ProductDetailsScreen(), arguments: {
    //     'name': name,
    //     'description': description,
    //     'image': image,
    //   }),
    //   child:
    //
    // );
  }
}
