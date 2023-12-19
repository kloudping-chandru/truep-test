class ChargesModel {
  String? freeDeliveryRadius, maxRadius, deliveryFeePerKm, taxes;

  ChargesModel({this.freeDeliveryRadius, this.maxRadius, this.deliveryFeePerKm, this.taxes});

  ChargesModel.fromJson(Map<String, dynamic> json) {
    freeDeliveryRadius = json['freeDeliveryRadius'].toString();
    maxRadius = json['maxRadius'].toString();
    deliveryFeePerKm = json['deliveryFeePerKm'].toString();
    taxes = json['taxes'].toString();
  }
}
