class OrderModel {
  String? driverUid, orderId,date,endingDate,itemId,orderType,startingDate, status, totalPrice, origin, latitude, longitude,deliveryPicture,deliveryCurrentAddress;
  String? timeRequested, paymentType, timeAccepted, timeStartPreparing, timeOnTheWay, timeDelivered, uid;
  List<Map<String, dynamic>?>? items;
  List<Map<String, dynamic>?>? days;

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
    this.items,
    this.deliveryPicture,
    this.deliveryCurrentAddress,
    this.date,
    this.days,
    this.endingDate,
    this.itemId,
    this.orderType,
    this.startingDate
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
    deliveryPicture=json['deliveryPicture'];
    deliveryCurrentAddress=json['deliveryCurrentAddress'];
    if (json['items'] != null) {
      items = json["items"] = (json['items'] as List).map((e) => e == null ? null : Map<String, dynamic>.from(e)).toList();
    } else {
      items = null;
    }
    // if (json['Days'] != null) {
    //   days = json["Days"] = (json['Days'] as List).map((e) => e == null ? null : Map<String, dynamic>.from(e)).toList();
    // } else {
    //   days = null;
    // }
    // if (json['Days'] != null) {
    //   days = json['Days'];
    //   // json['Days'].foreach((e) {
    //   //   orderDaysModel!.add(OrderDaysModel.fromJson(e));
    //   // });
    // } else {
    //   days = null;
    // }
    date = json['date'];
    endingDate = json['endingDate'];
    itemId = json['itemId'];
    orderType = json['orderType'];
    startingDate = json['startingDate'];
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
        'deliveryPicture':deliveryPicture,
        //'Days': days,
        'items': items,
        'deliveryCurrentAddress':deliveryCurrentAddress,
         'date': date,
         'endingDate': endingDate,
         'itemId': itemId,
         'orderType': orderType,
         'startingDate': startingDate,
      };
}

class OrderDaysModel{

  String? days;
  int? quantity;
  OrderDaysModel(this.days,this.quantity);

  OrderDaysModel.fromJson(Map<String, dynamic>json)  {
    days=json['day'];
    quantity=json['quantity'];
  }
  Map<String, dynamic> toJson() => {
    'day': days,
    'quantity': quantity,
  };

}