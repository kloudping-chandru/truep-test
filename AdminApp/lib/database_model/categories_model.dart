class CategoriesModel {
  String? colorCode, icon, image, title, timeCreated;
  int? viewsCount;

  CategoriesModel({this.colorCode, this.icon, this.image, this.title, this.timeCreated, this.viewsCount});

  CategoriesModel.fromJson(Map<String, dynamic> json) {
    colorCode = json['colorCode'];
    icon = json['icon'];
    image = json['image'];
    title = json['title'];
    timeCreated = json['timeCreated'];
    viewsCount = json['viewsCount'];
  }
}
