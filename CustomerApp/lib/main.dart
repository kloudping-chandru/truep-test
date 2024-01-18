import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:foodizm_subscription/colors.dart';
import 'package:foodizm_subscription/common/common.dart';
import 'package:foodizm_subscription/firebase_options.dart';
import 'package:foodizm_subscription/locale/translation_file.dart';
import 'package:foodizm_subscription/screens/enable_location_screen.dart';
import 'package:foodizm_subscription/screens/splash_screen.dart';
import 'package:foodizm_subscription/utils/firebase_utils.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;

import 'screens/profile_creation_screens/complete_profile_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseUtils().initNotification();
  Directory directory = await pathProvider.getApplicationSupportDirectory();
  Hive.init(directory.path);
  await Hive.openBox('credentials');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: AppColors.primaryColor,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ));
    return GetMaterialApp(
      defaultTransition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 700),
      title: 'Foodizm Subscription',
      translations: TranslationsFile(),
      fallbackLocale: const Locale('en', 'US'),
      locale: const Locale('en', 'US'),
      theme: ThemeData(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          primaryColor: AppColors.primaryColor,
          colorScheme: ThemeData().colorScheme.copyWith(
              secondary: AppColors.accentColor,
              primary: AppColors.primaryColor),
          platform: TargetPlatform.iOS),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}
