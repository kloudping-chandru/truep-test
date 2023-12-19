class RestaurantDetailsModel {
  String? name, logo, address, lat, lng, phoneNumber;

  RestaurantDetailsModel({this.name, this.logo, this.address, this.lat, this.lng, this.phoneNumber});

  RestaurantDetailsModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    logo = json['logo'];
    address = json['address'];
    lat = json['lat'];
    lng = json['lng'];
    phoneNumber = json['phoneNumber'];
  }
}
