class CartModel {
  String? categoryName, title, details, image, type, noOfServing, timeCreated;
  String? discount, expiryDate, newPrice, oldPrice, validDate, quantity, timeAdded, uid;
  List<Map<String, dynamic>?>? customizationForVariations;
  List<String>? customizationForFlavours;
  List<String>? ingredients;
  List<String>? customizationForDrinks;
  List<String>? itemsIncluded;

  CartModel({
    this.categoryName,
    this.title,
    this.details,
    this.image,
    this.type,
    this.discount,
    this.expiryDate,
    this.newPrice,
    this.oldPrice,
    this.validDate,
    this.noOfServing,
    this.timeCreated,
    this.quantity,
    this.timeAdded,
    this.uid,
    this.customizationForVariations,
    this.customizationForFlavours,
    this.ingredients,
    this.customizationForDrinks,
    this.itemsIncluded,
  });

  CartModel.fromJson(Map<String, dynamic> json) {
    categoryName = json['categoryName'];
    title = json['title'];
    details = json['details'];
    image = json['image'];
    type = json['type'];
    discount = json['discount'];
    expiryDate = json['expiryDate'];
    newPrice = json['newPrice'];
    oldPrice = json['oldPrice'];
    validDate = json['validDate'];
    type = json['type'];
    noOfServing = json['no_of_serving'];
    timeCreated = json['timeCreated'];
    quantity = json['quantity'];
    timeAdded = json['timeAdded'];
    uid = json['uid'];

    if (json['customizationForVariations'] != null) {
      customizationForVariations = json["customizationForVariations"] =
          (json['customizationForVariations'] as List).map((e) => e == null ? null : Map<String, dynamic>.from(e)).toList();
    } else {
      customizationForVariations = null;
    }

    if (json['customizationForFlavours'] != null) {
      customizationForFlavours = json['customizationForFlavours'].cast<String>();
    } else {
      customizationForFlavours = null;
    }
    if (json['ingredients'] != null) {
      ingredients = json['ingredients'].cast<String>();
    } else {
      ingredients = null;
    }

    if (json['customizationForDrinks'] != null) {
      customizationForDrinks = json['customizationForDrinks'].cast<String>();
    } else {
      customizationForDrinks = null;
    }
    if (json['itemsIncluded'] != null) {
      itemsIncluded = json['itemsIncluded'].cast<String>();
    } else {
      itemsIncluded = null;
    }
  }
}
