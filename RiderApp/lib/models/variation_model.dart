class VariationModel {
  String? name, price;

  VariationModel({this.name, this.price});

  VariationModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    price = json['price'];
  }
}
