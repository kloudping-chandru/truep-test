class OrderModel {
  String? driverUid,
      orderId,
      status,
      totalPrice,
      origin,
      latitude,
      longitude,
      deliveryPicture,
      deliveryCurrentAddress;
  String? timeRequested,
      paymentType,
      timeAccepted,
      timeStartPreparing,
      timeOnTheWay,
      timeDelivered,
      uid;
  List<Map<String, dynamic>?>? items;
  List<OrderDaysModel>? orderDaysModel;

  OrderModel({
    this.driverUid,
    this.orderId,
    this.status,
    this.totalPrice,
    this.origin,
    this.timeRequested,
    this.paymentType,
    this.timeAccepted,
    this.timeStartPreparing,
    this.timeOnTheWay,
    this.latitude,
    this.longitude,
    this.timeDelivered,
    this.uid,
    this.orderDaysModel,
    this.items,
    this.deliveryPicture,
    this.deliveryCurrentAddress,
  });

  OrderModel.fromJson(Map<String, dynamic> json) {
    driverUid = json['driverUid'];
    orderId = json['orderId'];
    status = json['status'];
    totalPrice = json['totalPrice'];
    origin = json['origin'];
    timeRequested = json['timeRequested'];
    paymentType = json['paymentType'];
    timeAccepted = json['timeAccepted'];
    timeStartPreparing = json['timeStartPreparing'];
    timeOnTheWay = json['timeOnTheWay'];
    origin = json['origin'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    timeDelivered = json['timeDelivered'];
    uid = json['uid'];
    deliveryPicture = json['deliveryPicture'];
    deliveryCurrentAddress = json['deliveryCurrentAddress'];
    if (json['items'] != null) {
      items = json["items"] = (json['items'] as List)
          .map((e) => e == null ? null : Map<String, dynamic>.from(e))
          .toList();
    } else {
      items = null;
    }
    if (json['Days'] != null) {
      orderDaysModel = [];
      (json['Days'] ?? {}).forEach((key, value) {
        orderDaysModel!
            .add(OrderDaysModel.fromJson(Map<String, dynamic>.from(value)));
      });
    } else {
      orderDaysModel = null;
    }
  }

  Map<String, dynamic> toJson() => {
        'driverUid': driverUid,
        'orderId': orderId,
        'status': status,
        'totalPrice': totalPrice,
        'origin': origin,
        'timeRequested': timeRequested,
        'paymentType': paymentType,
        'timeAccepted': timeAccepted,
        'timeStartPreparing': timeStartPreparing,
        'timeOnTheWay': timeOnTheWay,
        'latitude': latitude,
        'longitude': longitude,
        'timeDelivered': timeDelivered,
        'uid': uid,
        'deliveryPicture': deliveryPicture,
        'items': items,
        'deliveryCurrentAddress': deliveryCurrentAddress
      };
}

class OrderDaysModel {
  String? days;
  int? quantity;
  OrderDaysModel(this.days, this.quantity);

  OrderDaysModel.fromJson(Map<String, dynamic> json) {
    days = json['day'];
    quantity = json['quantity'];
  }
}
