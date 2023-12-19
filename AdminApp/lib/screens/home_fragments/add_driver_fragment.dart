import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:foodizm_admin_app/colors.dart';
import 'package:foodizm_admin_app/utils/utils.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart' as p;

class AddDriverFragment extends StatefulWidget {
  const AddDriverFragment({Key? key}) : super(key: key);

  @override
  State<AddDriverFragment> createState() => _AddDriverFragmentState();
}

class _AddDriverFragmentState extends State<AddDriverFragment> {
  Utils utils = Utils();
  TextEditingController fullName = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();
  TextEditingController phoneNumber = new TextEditingController();
  TextEditingController age = new TextEditingController();
  TextEditingController userName = new TextEditingController();
  TextEditingController licenseNo = new TextEditingController();
  TextEditingController vehicle = new TextEditingController();
  TextEditingController vin = new TextEditingController();
  var formKey = GlobalKey<FormState>();
  Rx<File> profileImageDriver = File('').obs;
  FirebaseStorage storage = FirebaseStorage.instance;
  var databaseReference = FirebaseDatabase.instance.ref();

  Rx<File> driverImageFrontIdCard = File('').obs;
  Rx<File> driverImageBackIdCard = File('').obs;

  Rx<File> driverLicenseFrontLicenseCard = File('').obs;
  Rx<File> driverLicenseBackLicenseCard = File('').obs;
  String imageLocator = '';
  RxBool loader = false.obs;


  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    utils.helveticaBoldText('Add Driver'.tr, 22.0, AppColors.blackColor, TextAlign.start),
                    Form(
                      key: formKey,
                      child: Column(
                        children: [
                          Obx(() =>
                              InkWell(
                                onTap: () {
                                  imageLocator = 'profile';
                                  storagePermission(imageLocator);
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(top: 2),
                                  child: Center(
                                    child: Container(
                                      height: 100,
                                      width: 100,
                                      child: profileImageDriver.value.path != '' ?
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        child: Image.file(profileImageDriver.value, width: 100, height: 100, fit: BoxFit.cover),
                                      ) : SvgPicture.asset(
                                        'assets/images/add_photo.svg',
                                        height: 100,
                                        width: 100,
                                      ),
                                    ),
                                  ),
                                ),),),
                          Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              controller: fullName,
                              textCapitalization: TextCapitalization.words,
                              decoration: utils.inputDecorationWithLabel(
                                  'pleaseEnterFullName'.tr, 'Full Name'.tr, AppColors.whiteColor, AppColors.primaryColor),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "pleaseEnterFullName".tr;
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: TextFormField(
                              controller: email,
                              keyboardType: TextInputType.emailAddress,
                              textCapitalization: TextCapitalization.sentences,
                              minLines: 1,
                              maxLines: 10,
                              decoration: utils.inputDecorationWithLabel(
                                  'pleaseEnterEmail'.tr, 'Email'.tr, AppColors.whiteColor, AppColors.primaryColor),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "pleaseEnterEmail".tr;
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: TextFormField(
                              keyboardType: TextInputType.visiblePassword,
                              controller: password,
                              textCapitalization: TextCapitalization.words,
                              decoration: utils.inputDecorationWithLabel(
                                  'pleaseEnterPassword'.tr, 'Password'.tr, AppColors.whiteColor, AppColors.primaryColor),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "pleaseEnterPassword".tr;
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: TextFormField(
                              controller: phoneNumber,
                              textCapitalization: TextCapitalization.sentences,
                              minLines: 1,
                              keyboardType: TextInputType.number,
                              decoration: utils.inputDecorationWithLabel(
                                  'pleaseEnterPhoneNumber'.tr, 'PhoneNumber'.tr, AppColors.whiteColor, AppColors.primaryColor),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "pleaseEnterPhoneNumber".tr;
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: TextFormField(
                              controller: age,
                              keyboardType: TextInputType.number,
                              textCapitalization: TextCapitalization.words,
                              decoration: utils.inputDecorationWithLabel(
                                  'pleaseEnterAge'.tr, 'Age'.tr, AppColors.whiteColor, AppColors.primaryColor),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "pleaseEnterAge".tr;
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: TextFormField(
                              controller: userName,
                              textCapitalization: TextCapitalization.sentences,
                              minLines: 1,
                              keyboardType: TextInputType.text,
                              decoration: utils.inputDecorationWithLabel(
                                  'pleaseEnterUserName'.tr, 'UserName'.tr, AppColors.whiteColor, AppColors.primaryColor),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "pleaseEnterUserName".tr;
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: TextFormField(
                              controller: licenseNo,
                              keyboardType: TextInputType.number,
                              textCapitalization: TextCapitalization.words,
                              decoration: utils.inputDecorationWithLabel(
                                  'pleaseEnterLicenseNo'.tr, 'LicenseNo'.tr, AppColors.whiteColor, AppColors.primaryColor),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "pleaseEnterLicenseNo".tr;
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: TextFormField(
                              controller: vehicle,
                              textCapitalization: TextCapitalization.sentences,
                              minLines: 1,
                              keyboardType: TextInputType.text,
                              decoration: utils.inputDecorationWithLabel(
                                  'pleaseEnterVehicle'.tr, 'Vehicle'.tr, AppColors.whiteColor, AppColors.primaryColor),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "pleaseEnterVehicle".tr;
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: TextFormField(
                              controller: vin,
                              keyboardType: TextInputType.number,
                              textCapitalization: TextCapitalization.words,
                              decoration: utils.inputDecorationWithLabel(
                                  'pleaseEnterVin'.tr, 'Vin'.tr, AppColors.whiteColor, AppColors.primaryColor),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "pleaseEnterVin".tr;
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.only(top: 20),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: utils.helveticaBoldText(
                                    'Add License Front Photo'.tr, 18.0, AppColors.blackColor, TextAlign.start),
                              )
                          ),
                          Obx(() =>
                              InkWell(
                                onTap: () {
                                  imageLocator = 'licenseFront';
                                  storagePermission(imageLocator);
                                },
                                child: Padding(
                                    padding: EdgeInsets.only(top: 20),
                                    child: Container(
                                      height: 150,
                                      width: Get.width,
                                      decoration: utils.boxDecoration(AppColors.whiteColor, AppColors.primaryColor),
                                      child: driverLicenseFrontLicenseCard.value.path != '' ? ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.file(driverLicenseFrontLicenseCard.value, fit: BoxFit.fill,),
                                      ) : Center(
                                        child: Icon(Icons.add_box_rounded, size: 20, color: AppColors.primaryColor,),
                                      ),
                                    )
                                ),
                              )
                          ),
                          Padding(
                              padding: EdgeInsets.only(top: 20),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: utils.helveticaBoldText(
                                    'Add License Back Photo'.tr, 18.0, AppColors.blackColor, TextAlign.start),
                              )
                          ),
                          Obx(() =>
                              InkWell(
                                onTap: () {
                                  imageLocator = 'licenseBack';
                                  storagePermission(imageLocator);
                                },
                                child: Padding(
                                    padding: EdgeInsets.only(top: 20),
                                    child: Container(
                                      height: 150,
                                      width: Get.width,
                                      decoration: utils.boxDecoration(AppColors.whiteColor, AppColors.primaryColor),
                                      child: driverLicenseBackLicenseCard.value.path != '' ? ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.file(driverLicenseBackLicenseCard.value, fit: BoxFit.fill,),
                                      ) : Center(
                                        child: Icon(Icons.add_box_rounded, size: 20, color: AppColors.primaryColor,),
                                      ),
                                    )
                                ),
                              )
                          ),

                          Padding(
                              padding: EdgeInsets.only(top: 20),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: utils.helveticaBoldText(
                                    'Add IdCard Front Photo'.tr, 18.0, AppColors.blackColor, TextAlign.start),
                              )
                          ),
                          Obx(() =>
                              InkWell(
                                onTap: () {
                                  imageLocator = 'idCardFront';
                                  storagePermission(imageLocator);
                                },
                                child: Padding(
                                    padding: EdgeInsets.only(top: 20),
                                    child: Container(
                                      height: 150,
                                      width: Get.width,
                                      decoration: utils.boxDecoration(AppColors.whiteColor, AppColors.primaryColor),
                                      child: driverImageFrontIdCard.value.path != '' ? ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.file(driverImageFrontIdCard.value, fit: BoxFit.fill,),
                                      ) : Center(
                                        child: Icon(Icons.add_box_rounded, size: 20, color: AppColors.primaryColor,),
                                      ),
                                    )
                                ),
                              )
                          ),
                          Padding(
                              padding: EdgeInsets.only(top: 20),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: utils.helveticaBoldText(
                                    'Add IdCard Back Photo'.tr, 18.0, AppColors.blackColor, TextAlign.start),
                              )
                          ),
                          Obx(() =>
                              InkWell(
                                onTap: () {
                                  imageLocator = 'idCardBack';
                                  storagePermission(imageLocator);
                                },
                                child: Padding(
                                    padding: EdgeInsets.only(top: 20),
                                    child: Container(
                                      height: 150,
                                      width: Get.width,
                                      decoration: utils.boxDecoration(AppColors.whiteColor, AppColors.primaryColor),
                                      child: driverImageBackIdCard.value.path != '' ? ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.file(driverImageBackIdCard.value, fit: BoxFit.fill,),
                                      ) : Center(
                                        child: Icon(Icons.add_box_rounded, size: 20, color: AppColors.primaryColor,),
                                      ),
                                    )
                                ),
                              )
                          ),

                          InkWell(
                            onTap: () {
                              print(loader.value);
                              loader.value = true;
                              databaseReference.child('Drivers').get().then((snapShot) {
                                if(snapShot.exists)
                                  {
                                    for(var item in snapShot.children)
                                    {
                                      Map<dynamic, dynamic> mapData= item.value as Map<dynamic, dynamic>;
                                      if(mapData['userName'] == userName.text)
                                      {
                                        loader.value = false;
                                        return utils.showToast('This UserName is already in Used Try with different UserName');
                                      }
                                      else{
                                        loader.value = false;
                                        if (formKey.currentState!.validate()) {
                                          if (driverLicenseFrontLicenseCard.value.path.isEmpty) {
                                            utils.showToast('Please Upload your license Front Side Pic');
                                          }
                                          else if (driverLicenseBackLicenseCard.value.path.isEmpty) {
                                            utils.showToast('Please Upload your license Back Side Pic');
                                          }
                                          else if (driverImageBackIdCard.value.path.isEmpty) {
                                            utils.showToast('Please Upload your IdCard Back Side Pic');
                                          }
                                          else if (driverImageFrontIdCard.value.path.isEmpty) {
                                            utils.showToast('Please Upload your IdCard Front Side Pic');
                                          }
                                          else if(profileImageDriver.value.path.isEmpty)
                                          {
                                            utils.showToast('Please Upload your Profile Picture');
                                          }
                                          else {

                                            loader.value = true;
                                            registerDriver(
                                                fullName.text,
                                                email.text,
                                                password.text,
                                                phoneNumber.text,
                                                age.text,
                                                userName.text,
                                                licenseNo.text,
                                                vehicle.text,
                                                vin.text,
                                                driverLicenseFrontLicenseCard.value.path,
                                                driverLicenseBackLicenseCard.value.path,
                                                driverImageFrontIdCard.value.path,
                                                driverImageBackIdCard.value.path,
                                                profileImageDriver.value.path
                                            );
                                          }
                                        }
                                      }
                                    }
                                  }
                                else{
                                  loader.value = false;
                                  if (formKey.currentState!.validate()) {
                                    if (driverLicenseFrontLicenseCard.value.path.isEmpty) {
                                      utils.showToast('Please Upload your license Front Side Pic');
                                    }
                                    else if (driverLicenseBackLicenseCard.value.path.isEmpty) {
                                      utils.showToast('Please Upload your license Back Side Pic');
                                    }
                                    else if (driverImageBackIdCard.value.path.isEmpty) {
                                      utils.showToast('Please Upload your IdCard Back Side Pic');
                                    }
                                    else if (driverImageFrontIdCard.value.path.isEmpty) {
                                      utils.showToast('Please Upload your IdCard Front Side Pic');
                                    }
                                    else if(profileImageDriver.value.path.isEmpty)
                                    {
                                      utils.showToast('Please Upload your Profile Picture');
                                    }
                                    else {

                                      loader.value = true;
                                      registerDriver(
                                          fullName.text,
                                          email.text,
                                          password.text,
                                          phoneNumber.text,
                                          age.text,
                                          userName.text,
                                          licenseNo.text,
                                          vehicle.text,
                                          vin.text,
                                          driverLicenseFrontLicenseCard.value.path,
                                          driverLicenseBackLicenseCard.value.path,
                                          driverImageFrontIdCard.value.path,
                                          driverImageBackIdCard.value.path,
                                          profileImageDriver.value.path
                                      );
                                    }
                                  }
                                }
                              }).onError((error, stackTrace) {
                                loader.value = false;
                                utils.showToast('Something went wrong');
                              });
                            },
                            child: Container(
                              height: 45,
                              margin: EdgeInsets.symmetric(vertical: 30),
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                  color: AppColors.primaryColor, borderRadius: BorderRadius.all(Radius.circular(30.0))),
                              child: Center(child: utils.poppinsMediumText(
                                  'Create Driver Profile'.tr, 16.0, AppColors.whiteColor, TextAlign.center)),
                            ),
                          ),


                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          Obx(() =>   Center(
            child: loader.value == false ? SizedBox() : CupertinoActivityIndicator(color: AppColors.blackColor,radius: 20,),
          ))
          ],
        )
    );
  }

  storagePermission(String imageLocate) async {
    var status = await Permission.photos.request();
    if (status.isGranted) {
      if (imageLocate == 'profile') {
        _imgFromGallery(imageLocate);
      }
      else if (imageLocate == 'idCardFront') {
        _imgFromGallery(imageLocate);
      }
      else if (imageLocate == 'idCardBack') {
        _imgFromGallery(imageLocate);
      }
      else if (imageLocate == 'licenseFront') {
        _imgFromGallery(imageLocate);
      }
      else if (imageLocate == 'licenseBack') {
        _imgFromGallery(imageLocate);
      }
    } else {
      Utils().showToast('needAllow'.tr);
    }
  }

  _imgFromGallery(String profileImage) async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 100);
    if (profileImage == 'profile') {
      profileImageDriver.value = await cropImage(File(pickedFile!.path));
      setState(() {});
    }
    if (profileImage == 'idCardFront') {
      driverImageFrontIdCard.value = await cropImage(File(pickedFile!.path));
      setState(() {});
    }
    if (profileImage == 'idCardBack') {
      driverImageBackIdCard.value = await cropImage(File(pickedFile!.path));
      setState(() {});
    }
    if (profileImage == 'licenseFront') {
      driverLicenseFrontLicenseCard.value = await cropImage(File(pickedFile!.path));
      setState(() {});
    }
    if (profileImage == 'licenseBack') {
      driverLicenseBackLicenseCard.value = await cropImage(File(pickedFile!.path));
      setState(() {});
    }
  }

  cropImage(File pickedFile) async {
    var _image = File(pickedFile.path);
    CroppedFile ? croppedFile = await ImageCropper().cropImage(
      sourcePath: _image.path,
      maxHeight: 512,
      maxWidth: 512,
      cropStyle: CropStyle.circle,
      aspectRatioPresets: [CropAspectRatioPreset.square],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: AppColors.primaryColor,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true),
        IOSUiSettings(minimumAspectRatio: 1.0),
      ],
    );
    if (croppedFile != null) {
      print('empty');
      return File(croppedFile.path);
    }
  }

  registerDriver(String fullNameText, String emailText, String passwordText, String phoneNumberText, String ageText,
      String userNameText, String licenseNoText, String vehicleText, String vinText, String licenseFront, String licenseBack,
      String idCardFront,
      String idCardBack,String profileImageDriver) async
  {
    /// LicenseImageUploadFront
    print(p.extension(licenseFront));
    Reference refFirst = storage.ref().child('DriversImages/').
    child('${DateTime
        .now()
        .millisecondsSinceEpoch
        .toString()}.${p.extension(licenseFront)}');
    UploadTask uploadTask = refFirst.putFile(File(licenseFront));
    final TaskSnapshot downloadUrl = (await uploadTask);
    String urlLicenseFront = await downloadUrl.ref.getDownloadURL();

    /// LicenseImageUploadBack
    print(p.extension(licenseBack));
    Reference refSecond = storage.ref().child('DriversImages/').
    child('${DateTime
        .now()
        .millisecondsSinceEpoch
        .toString()}.${p.extension(licenseFront)}');
    UploadTask uploadTaskSecond = refSecond.putFile(File(licenseBack));
    final TaskSnapshot downloadUrlSecond = (await uploadTaskSecond);
    String urlLicenseBack = await downloadUrlSecond.ref.getDownloadURL();

    /// LicenseIdCardFront
    print(p.extension(licenseBack));
    Reference refThird = storage.ref().child('DriversImages/').
    child('${DateTime
        .now()
        .millisecondsSinceEpoch
        .toString()}.${p.extension(licenseFront)}');
    UploadTask uploadTaskThird = refThird.putFile(File(idCardFront));
    final TaskSnapshot downloadUrlThird = (await uploadTaskThird);
    String urlIdCardFront = await downloadUrlThird.ref.getDownloadURL();

    /// LicenseIdCardBack
    print(p.extension(licenseBack));
    Reference refFourth = storage.ref().child('DriversImages/').
    child('${DateTime
        .now()
        .millisecondsSinceEpoch
        .toString()}.${p.extension(licenseFront)}');
    UploadTask uploadFour = refFourth.putFile(File(idCardBack));
    final TaskSnapshot downloadUrlFour = (await uploadFour);
    String urlIdCardBAck = await downloadUrlFour.ref.getDownloadURL();

    /// ProfileImageDriver
    print(p.extension(licenseBack));
    Reference refFifth = storage.ref().child('DriversImages/').
    child('${DateTime
        .now()
        .millisecondsSinceEpoch
        .toString()}.${p.extension(licenseFront)}');
    UploadTask uploadFive = refFifth.putFile(File(profileImageDriver));
    final TaskSnapshot downloadUrlFive = (await uploadFive);
    String urlProfileImageDriver = await downloadUrlFive.ref.getDownloadURL();

    // Map<String, dynamic> value = {'profilePicture': url};


    Map<String, dynamic> data = {
      'age': ageText,
      'email': emailText,
      'fullName': fullNameText,
      'licenseNo': licenseNoText,
      'password': passwordText,
      'phoneNumber': phoneNumberText,
      'userName': userNameText,
      'vehicle': vehicleText,
      'vin': vinText,
      'idCardBAck': urlIdCardBAck,
      'idCardFront': urlIdCardFront,
      'licenseBack': urlLicenseBack,
      'licenseFront': urlLicenseFront,
      'profileImage': urlProfileImageDriver
    };
    databaseReference.child('Drivers').push().set(data).whenComplete(() async{

      databaseReference.child('Drivers').get().then((snapShot) {
        for (var item in snapShot.children) {
          Map<dynamic, dynamic> values = item.value as Map<dynamic, dynamic>;

          if(values['userName'] == userNameText)
            {
              print('key:${item.key.toString()}');
              Map<String, dynamic> uid = {
                'uid': item.key.toString(),
                'token': '',
                'onlineStatus': 'Offline',
                'userToken':'',
                'approvalStatus': 'true',
              };
              databaseReference.child('Drivers').child(item.key.toString()).update(uid).whenComplete(() {
                loader.value = false;
               return utils.showToast('You have successfully Register the Driver');
                print('Successfully Driver Registered');
              });
            }
        }
      }).onError((error, stackTrace) {
        loader.value = false;
        utils.showToast('Something went wrong');
      });

    }).onError((error, stackTrace) {
      loader.value = false;
      utils.showToast('Something went wrong');
    });
  }
}
