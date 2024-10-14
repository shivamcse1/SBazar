class UserModel {
  final String userUid;
  final String userName;
  final String userEmail;
  final String userPhone;
  final String userImg;
  final String userDeviceToken;
  final String userCountry;
  final String userAddress;
  final String userStreet;
  final bool isAdmin;
  final bool isActive;
  final dynamic createdAt;
  final String userCity;

  UserModel({
    required this.userUid,
    required this.userName,
    required this.userEmail,
    required this.userPhone,
    required this.userImg,
    required this.userDeviceToken,
    required this.userCountry,
    required this.userAddress,
    required this.userStreet,
    required this.isAdmin,
    required this.isActive,
    required this.createdAt,
    required this.userCity,
  });

  // Serialize the UserModel instance to a JSON map
  Map<String, dynamic> toMap() {
    return {
      'userUid': userUid,
      'userName': userName,
      'userEmail': userEmail,
      'userPhone': userPhone,
      'userImg': userImg,
      'userDeviceToken': userDeviceToken,
      'userCountry': userCountry,
      'userAddress': userAddress,
      'userStreet': userStreet,
      'isAdmin': isAdmin,
      'isActive': isActive,
      'createdAt': createdAt,
      'userCity': userCity,
    };
  }

  // Create a UserModel instance from a JSON map
  factory UserModel.fromMap(Map<String, dynamic> json) {
    return UserModel(
      userUid: json['userUid'],
      userName: json['userName'],
      userEmail: json['userEmail'],
      userPhone: json['userPhone'],
      userImg: json['userImg'],
      userDeviceToken: json['userDeviceToken'],
      userCountry: json['userCountry'],
      userAddress: json['userAddress'],
      userStreet: json['userStreet'],
      isAdmin: json['isAdmin'],
      isActive: json['isActive'],
      createdAt: json['createdAt'],
      userCity: json['userCity'],
    );
  }
}