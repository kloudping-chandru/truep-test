import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:trupressed_subscription/common/common.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../screens/wallet_screen.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> handleBackgroundMessaging(RemoteMessage message) async {
  print('Title ${message.notification?.title}');
  print('Body ${message.notification?.body}');
  print('Payload ${message.data}');
}

class FirebaseUtils {
  final _firebaseMessaging = FirebaseMessaging.instance;
  late Box box;

  Future<void> initPushNotifications() async {
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessaging);
  }

  Future<void> initNotification() async {
    await _firebaseMessaging.requestPermission();

    registerNotification();
    initPushNotifications();
  }

  registerNotification() async {
    var initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification:
            (int? id, String? title, String? body, String? payload) async {});
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse? response) async {
      if (response != null) {
        print('notification payload:  ${response.payload ?? ""}');
      }
    });
    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
        alert: true, badge: true, sound: true);
    final fCMToken = await _firebaseMessaging.getToken();
    print('Token $fCMToken');
    _firebaseMessaging.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessage.listen((RemoteMessage? message) {
      Common.bottomIndex.value = 2;

      RemoteNotification notification = message!.notification!;
      AndroidNotification? android = message.notification?.android!;
      print('Title ${message.notification?.title}');
      print('Body ${message.notification?.body}');
      print('Payload ${message.data}');
      print("added to myList");
      if (android != null) {
        FlutterLocalNotificationsPlugin().show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              'notification',
              'Channel for notification',
              icon: 'app_icon',
            ),
          ),
        );
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
  }

  handleMessage(RemoteMessage? message) {
    if (message != null) {
      print(message.collapseKey);
      print('Title ${message.notification?.title}');
      print('Body ${message.notification?.body}');
      print('Payload ${message.data}');

      Common.bottomIndex.value = 2;
    }
  }

}
