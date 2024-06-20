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








// class CategoriesModel {
//   String? image, title, colorCode;
//   CategoriesModel({this.image, this.title, this.colorCode});
// }
//
// List<CategoriesModel> categoriesModel = [
//   CategoriesModel(image: "https://images.unsplash.com/photo-1600271886742-f049cd451bba?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8anVpY2V8ZW58MHx8MHx8fDA%3D&w=1000&q=80", title: "Refresh Antioxidants Energy", colorCode: "#E48379"),
//   CategoriesModel(image: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ15QBVG9jFJoKMCdgC73rD368BMJoVLqMluQ&usqp=CAU", title: "Elixir Immunity Detox", colorCode: "#e27474"),
//   CategoriesModel(image: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTiY3Tl-KJTizCeyi44PqaspdSW-iQKeI8xuA&usqp=CAU", title: "Sunshine Energy Immunity", colorCode: "#E48379"),
//   CategoriesModel(image: "https://images.unsplash.com/photo-1600271886742-f049cd451bba?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8anVpY2V8ZW58MHx8MHx8fDA%3D&w=1000&q=80", title: "Nectar Antioxidants Energy", colorCode: "#FA7268"),
//   CategoriesModel(image: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ15QBVG9jFJoKMCdgC73rD368BMJoVLqMluQ&usqp=CAU", title: "Enrich Immunity Antioxidants", colorCode: "#76d1f8"),
// ];
