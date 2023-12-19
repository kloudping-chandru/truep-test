class AllOrderModel {
  String? orderId, timeStamp;

  AllOrderModel({this.orderId, this.timeStamp});

  AllOrderModel.fromJson(Map<String, dynamic> json) {
    orderId = json['name'];
    timeStamp = json['timeStamp'];
  }
}
