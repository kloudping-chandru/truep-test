class NotificationHistoryModel {
  String? uid;
  String? title;
  String? body;
  String? deviceId;
  String? key;
  String? timeStamp;

  NotificationHistoryModel({this.uid, this.title, this.body, this.deviceId});

  NotificationHistoryModel.fromJson(Map<dynamic, dynamic> json) {
    this.uid = json["uid"];
    this.title = json["title"];
    this.body = json["body"];
    this.deviceId = json["deviceId"];
    this.key = json["key"];
    this.timeStamp = json["timeStamp"];
  }
}
