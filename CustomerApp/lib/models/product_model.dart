class ProductModel {
  String? categoryId, title, details, image, price, type, noOfServing, timeCreated,productQuantity,itemId;
  int? viewsCount;
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
    this.customizationForVariations,
    this.customizationForFlavours,
    this.ingredients,
    this.productQuantity,
    this.itemId
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
    itemId=json['itemId'];
    // customizationForVariations = json["customizationForVariations"] =
    //     (json['customizationForVariations'] as List).map((e) => e == null ? null : Map<String, dynamic>.from(e)).toList();
    // customizationForFlavours = json['customizationForFlavours'].cast<String>();
    // ingredients = json['ingredients'].cast<String>();
    viewsCount = json['viewsCount'];
    productQuantity =json['productQuantity'];
  }
}





























// class ProductModel {
//   final String name;
//   final String description;
//   final String image;
//
//   ProductModel({
//     required this.name,
//     required this.description,
//     required this.image,
//   });
// }
//
// List<ProductModel> productModelsList = [
//   ProductModel(
//       name: 'Refresh',
//       description:
//           ' Discover the refreshing blend of watermelon, crisp mint leaves, and nutrient-rich chia seeds. Our cold-pressed juice promotes hydration, digestion, and a boost in Omega-3 fatty acids.',
//       image: 'assets/images/juiceImg1.jpeg'),
//   ProductModel(
//       name: 'Elixir',
//       description:
//           ' Energize your day with our blend of juicy apples, crunchy carrots, and earthy beetroot. This cold-pressed concoction is a vitamin powerhouse that supports immune health, eye health, and detoxification',
//       image: 'assets/images/juiceImg1.jpeg'),
//   ProductModel(
//       name: 'Sunshine',
//       description:
//           'Relish the tangy fusion of apple, orange, and carrot. This cold-pressed blend aids digestion, boosts immunity and vision, while offering a delightful morning pick-me-up.',
//       image: 'assets/images/juiceImg1.jpeg'),
//   ProductModel(
//       name: 'Nector',
//       description:
//           ' Immerse yourself in the exotic flavors of pineapple and pomegranate. This cold-pressed blend is a tropical paradise that delivers powerful antioxidants and aids digestion',
//       image: 'assets/images/juiceImg2.jpeg'),
//   ProductModel(
//       name: 'Enrich',
//       description:
//           'Enjoy the rich combination of apple, orange, and pomegranate. Our cold-pressed juice provides a potent mix of antioxidants and vitamin C for a strong immune system.',
//       image: 'assets/images/juiceImg1.jpeg'),
//   ProductModel(
//       name: 'Cosmos',
//       description:
//           'Savor the classic pairing of apple and orange. This simple yet impactful cold-pressed juice provides an invigorating vitamin C boost, aids digestion, and strengthens immunity.',
//       image: 'assets/images/juiceImg2.jpeg'),
//   ProductModel(
//       name: 'Revive',
//       description:
//           ' Experience the unique blend of carrot and pomegranate. Our cold-pressed juice aids eye health, boosts immunity, and is rich in antioxidants for a revitalizing experience.',
//       image: 'assets/images/juiceImg1.jpeg'),
//   ProductModel(
//       name: 'Greenix',
//       description:
//           'Revitalize with the cooling fusion of spinach, apple, and cucumber. Our clod-pressed offers an invigorating burst of hydration, detoxification, and an impressive dose of iron.',
//       image: 'assets/images/juiceImg2.jpeg'),
//   ProductModel(
//       name: 'Carnival',
//       description:
//           'Ignite your senses with the invigorating mix of pomegranate, orange, and a touch of ginger. This cold-pressed blend helps with digestion, boosts immunity, and energizes your day.',
//       image: 'assets/images/juiceImg1.jpeg'),
//   ProductModel(
//       name: 'Delight',
//       description:
//           ' Dive into the succulent blend of grapes and apple. This cold-pressed juice is a rich source of antioxidants that aid heart health, and vitamins for a daily wellness boost.',
//       image: 'assets/images/juiceImg2.jpeg'),
// ];
