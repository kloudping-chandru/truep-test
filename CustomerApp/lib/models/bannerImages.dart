class BannerImages{

  String? image;
  BannerImages({this.image});

  BannerImages.fromJson(Map<String,dynamic>json){
    image=json['image'];
  }
}