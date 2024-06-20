import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trupressed_subscription/colors.dart';
import 'package:trupressed_subscription/screens/profile_creation_screens/complete_profile_screen.dart';
import 'package:trupressed_subscription/utils/utils.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../common/common.dart';
import '../../models/user_model.dart';
import '../enable_location_screen.dart';
import '../home_screen.dart';
import 'package:path/path.dart' as p;


class AddPhotoScreen extends StatefulWidget {
  const AddPhotoScreen({Key? key}) : super(key: key);
  @override
  State<AddPhotoScreen> createState() => _AddPhotoScreenState();
}

class _AddPhotoScreenState extends State<AddPhotoScreen> {
  Utils utils = Utils();
  Rx<CroppedFile> profileImage = CroppedFile('').obs;
  FirebaseStorage storage = FirebaseStorage.instance;
  var databaseReference = FirebaseDatabase.instance.ref();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        systemOverlayStyle: const SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
        elevation: 0,
        // leading: const BackButton(color: Colors.black),
        title: utils.poppinsMediumText('1 of 2', 16.0, AppColors.blackColor, TextAlign.center),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 1, child: utils.poppinsSemiBoldText('addPhoto'.tr, 25.0, AppColors.primaryColor, TextAlign.center)),
              Expanded(
                flex: 2,
                child: utils.poppinsMediumText('goodPicture'.tr, 16.0, AppColors.lightGreyColor, TextAlign.start),
              ),
              Expanded(
                flex: 3,
                child: Obx(() => InkWell(
                      onTap: storagePermission,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: profileImage.value.path != ''
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.file(File(profileImage.value.path), width: 100, height: 100, fit: BoxFit.cover),
                              )
                            : SvgPicture.asset('assets/images/add_photo.svg', height: 100, width: 100),
                      ),
                    )),
              ),
              const Expanded(flex: 2, child: SizedBox()),
              Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: InkWell(
                          onTap: () {
                            Get.to(() => const CompleteProfileScreen());
                          },
                          child: Align(
                            alignment: Alignment.center,
                            child: utils.poppinsRegularText('skip'.tr, 16.0, AppColors.primaryColor, TextAlign.center),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Align(
                          alignment: Alignment.center,
                          child: InkWell(
                            onTap: () {
                              if (profileImage.value.path != '') {
                                utils.showLoadingDialog();
                                uploadImage();
                              } else {
                                utils.showToast('pleaseSelectImage'.tr);
                              }
                            },
                            child: Container(
                              height: 40,
                              width: 150,
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColors.primaryColor),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(30.0),
                                ),
                              ),
                              child: Center(child: utils.poppinsMediumText('next'.tr, 16.0, AppColors.primaryColor, TextAlign.center)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
              const Expanded(flex: 1, child: SizedBox()),
            ],
          ),
        ),
      ),
    );
  }

  _imgFromGallery() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 100);
    profileImage.value = await cropImage(File(pickedFile!.path));
  }

  cropImage(File pickedFile) async {
    var image = File(pickedFile.path);
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: image.path,
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
    return croppedFile;
  }

  storagePermission() async {
    var status1 = await Permission.photos.request();
   // var status2 = await Permission.storage.request();
    if (status1.isGranted) {
      _imgFromGallery();
    } else {
      Utils().showToast('needAllow'.tr);
    }
  }
  uploadImage() async {
   // print(p.extension(profileImage.value.path));
    Reference ref =
    storage.ref().child("UsersProfilePicture/").child(DateTime.now().millisecondsSinceEpoch.toString() + p.extension(profileImage.value.path));
    UploadTask uploadTask = ref.putFile(File(profileImage.value.path));
    final TaskSnapshot downloadUrl = (await uploadTask);
    String url = await downloadUrl.ref.getDownloadURL();

    Map<String, dynamic> value = {'profilePicture': url};

    databaseReference.child('Users').child(Utils().getUserId()).update(value).whenComplete(() {
      saveUser(Utils().getUserId(), true);
    }).onError((error, stackTrace) {
      Get.back();
      Utils().showToast(error.toString());
    });
  }

  saveUser(String uid, bool isNotSkip) {
    Query query = databaseReference.child('Users').child(uid);
    query.once().then((DatabaseEvent event) async {
      if (event.snapshot.exists) {
        Common.userModel.value = UserModel.fromJson(Map.from(event.snapshot.value as Map));
        Common.wallet.value= Common.userModel.value.userWallet!;
        var status = await Permission.locationWhenInUse.status;
        if (Common.userModel.value.email == 'default') {
          if (isNotSkip)
            Utils().showToast('imageUpdated'.tr);
          Get.to(() => CompleteProfileScreen());
        } else {
          //Get.offAll(() => HomeScreen());
          if (status == PermissionStatus.granted) {
            utils.getUserCurrentLocation('');
            Get.offAll(() => HomeScreen());
          } else {
            Get.offAll(() => EnableLocationScreen());
          }
        }
      } else {
        Get.back();
        Utils().showToast('noUserFound'.tr);
      }
    });
  }
}
