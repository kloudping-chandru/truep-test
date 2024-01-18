import 'dart:convert';

import 'package:get/get.dart';

class SendNotificationInterface extends GetConnect {
  sendNotification(String? title, String? body, String deviceId, String key) async {
    try {
      Map<String, String> headers = {
        "Authorization": 
            "key=AAAAm7HX6z8:APA91bFhVqo7Fi6aC90hmL7B6HAQAA_Z-w2vqhYjlHqZVAe3T7TtS3EI3A-XDb_0yvmSC-9QOVLSoZ73AxWH4gXcPFlZA6KGRwyyuDGFEYECpVDAw_kUMtr4_9zjfad2tCpZBbdLYb0o",
        "Content-Type": "application/json"
      };
      Map<dynamic, dynamic> data = {
        "to": deviceId,
        "collapse_key": key,
        "priority": "high",
        "sound": "default",
        "notification": {"title": title, "body": body}
      };
      print(jsonEncode(data));
      var response = await post("https://fcm.googleapis.com/fcm/send", jsonEncode(data), headers: headers);
      print("Status Code : " + response.statusCode.toString() + " body : " + response.bodyString!);
    } catch (e) {
      print(e);
    }
  }
}
