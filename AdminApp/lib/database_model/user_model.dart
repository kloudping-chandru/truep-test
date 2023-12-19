class UserModel {
  String? uid, email, fullName, userName, profilePicture, phoneNumber, gender, dateOfBirth, userToken;
  String? address, latitude, longitude;

  UserModel({
    this.uid,
    this.email,
    this.fullName,
    this.userName,
    this.profilePicture,
    this.phoneNumber,
    this.gender,
    this.address,
    this.latitude,
    this.dateOfBirth,
    this.userToken,
    this.longitude,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    email = json['email'];
    fullName = json['fullName'];
    userName = json['userName'];
    profilePicture = json['profilePicture'];
    phoneNumber = json['phoneNumber'];
    address = json['address'];
    gender = json['gender'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    dateOfBirth = json['date_of_birth'];
    userToken = json['userToken'];
  }
}
