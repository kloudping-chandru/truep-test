import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foodizm_admin_app/colors.dart';
import 'package:foodizm_admin_app/common/common.dart';
import 'package:foodizm_admin_app/models/add_ingredients_model.dart';
import 'package:foodizm_admin_app/providers/add_ingredients_widget_provider.dart';
import 'package:foodizm_admin_app/utils/utils.dart';
import 'package:foodizm_admin_app/widget/add_ingredients_widget.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class AddIngredientsScreen extends StatefulWidget {
  const AddIngredientsScreen({Key? key}) : super(key: key);

  @override
  _AddIngredientsScreenState createState() => _AddIngredientsScreenState();
}

class _AddIngredientsScreenState extends State<AddIngredientsScreen> {
  AddIngredientsWidgetProvider? widgetProvider;
  Utils utils = new Utils();

  @override
  void initState() {
    // TODO: implement initState
    widgetProvider = Provider.of<AddIngredientsWidgetProvider>(context, listen: false);
    super.initState();
    widgetProvider!.widgets.clear();
    if (Common.selectedIngredientsList.length > 0) {
      for (int i = 0; i < Common.selectedIngredientsList.length; i++) {
        TextEditingController titleController = new TextEditingController();
        titleController.text = Common.selectedIngredientsList[i];
        widgetProvider!.widgets.add(AddIngredientsModel(AddIngredientsWidget(titleController, i), i));
      }
    } else {
      widgetProvider!.addFirstWidget();
    }
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
        title: utils.poppinsMediumText('addIngredientsHeading'.tr, 18.0, AppColors.blackColor, TextAlign.center),
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Consumer<AddIngredientsWidgetProvider>(builder: (context, build, child) {
                return Column(
                  children: widgetProvider!.widgets.map<Widget>((widgets) => widgets.addIngredientsWidget).toList(),
                );
              }),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () {
                      if (widgetProvider!.widgets[widgetProvider!.widgets.length - 1].addIngredientsWidget.titleController.text.isNotEmpty) {
                        setState(() {
                          widgetProvider!.addNewWidget();
                        });
                      } else {
                        utils.showToast('provideIngredientsTitle'.tr);
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: 10),
                      height: 35,
                      width: MediaQuery.of(context).size.width / 2,
                      decoration: BoxDecoration(color: AppColors.primaryColor, borderRadius: BorderRadius.all(Radius.circular(10.0))),
                      child: Center(child: utils.poppinsMediumText('addMoreIngredients'.tr, 16.0, AppColors.whiteColor, TextAlign.center)),
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: () {
                  if (widgetProvider!.widgets[widgetProvider!.widgets.length - 1].addIngredientsWidget.titleController.text.isNotEmpty) {
                    Common.selectedIngredientsList.clear();
                    for (int i = 0; i < widgetProvider!.widgets.length; i++) {
                      Common.selectedIngredientsList.add(widgetProvider!.widgets[i].addIngredientsWidget.titleController.text);
                    }
                    Get.back();
                  } else {
                    utils.showToast('provideIngredientsTitle'.tr);
                  }
                },
                child: Container(
                  height: 45,
                  margin: EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(color: AppColors.primaryColor, borderRadius: BorderRadius.all(Radius.circular(30.0))),
                  child: Center(child: utils.poppinsMediumText('selectIngredients'.tr, 16.0, AppColors.whiteColor, TextAlign.center)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
