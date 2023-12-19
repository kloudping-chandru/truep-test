class ProductModel {
  String? categoryId, title, details, image, price, type, noOfServing, timeCreated,productQuantity;
  int? viewsCount, totalOrder;
  List<Map<String, dynamic>?>? customizationForVariations;
  List<String>? customizationForFlavours;
  List<String>? ingredients;

  ProductModel({
    this.categoryId,
    this.title,
    this.details,
    this.image,
    this.price,
    this.type,
    this.noOfServing,
    this.timeCreated,
    this.viewsCount,
    this.totalOrder,
    this.customizationForVariations,
    this.customizationForFlavours,
    this.ingredients,
    this.productQuantity
  });

  ProductModel.fromJson(Map<String, dynamic> json) {
    categoryId = json['categoryId'];
    title = json['title'];
    details = json['details'];
    image = json['image'];
    price = json['price'].toString();
    type = json['type'];
    noOfServing = json['no_of_serving'];
    timeCreated = json['timeCreated'];
    // customizationForVariations = json["customizationForVariations"] =
    //     (json['customizationForVariations'] as List).map((e) => e == null ? null : Map<String, dynamic>.from(e)).toList();
    // customizationForFlavours = json['customizationForFlavours'].cast<String>();
    // ingredients = json['ingredients'].cast<String>();
    viewsCount = json['viewsCount'];
    totalOrder = json['totalOrder'];
    productQuantity=json['productQuantity'];
  }
}
