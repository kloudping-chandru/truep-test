import 'order_days_model.dart';

class OrderModel {
  String? driverUid, orderId, status, totalPrice, origin, latitude, longitude,endingDate,startingDate,itemId,deliveryPicture;
  String? timeRequested, paymentType, timeAccepted, timeStartPreparing, timeOnTheWay, timeDelivered, uid;
  List<Map<String, dynamic>?>? items;
  dynamic orderDaysModel;



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
    this.endingDate,
    this.startingDate,
    this.orderDaysModel,
    this.itemId,
    this.deliveryPicture


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
    endingDate = json['endingDate'];
    startingDate =json['startingDate'];
    itemId=json['itemId'];
    deliveryPicture=json['deliveryPicture'];


    if (json['items'] != null) {
      items = json["items"] = (json['items'] as List).map((e) => e == null ? null : Map<String, dynamic>.from(e)).toList();
    } else {
      items = null;
    }



    if (json['Days'] != null) {
      orderDaysModel = json['Days'];
      // json['Days'].foreach((e) {
      //   orderDaysModel!.add(OrderDaysModel.fromJson(e));
      // });
    } else {
      orderDaysModel = null;
    }
  }



  OrderModel.fromJson1(Map<dynamic, dynamic> json) {
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
    endingDate = json['endingDate'];
    startingDate =json['startingDate'];
    OrderDaysModel;

    if (json['items'] != null) {
      items = json["items"] = (json['items'] as List).map((e) => e == null ? null : Map<String, dynamic>.from(e)).toList();
    } else {
      items = null;
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
        'items': items,
         'endingDate': endingDate,
        'startingDate':startingDate,

      };
}
