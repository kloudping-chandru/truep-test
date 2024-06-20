class NotificationHistoryModel {
  String? uid;
  String? title;
  String? body;
  String? deviceId;
  String? key;
  String? timeStamp;

  NotificationHistoryModel({this.uid, this.title, this.body, this.deviceId});

  NotificationHistoryModel.fromJson(Map<dynamic, dynamic> json) {
    uid = json["uid"];
    title = json["title"];
    body = json["body"];
    deviceId = json["deviceId"];
    key = json["key"];
    timeStamp = json["timeStamp"];
  }
}
