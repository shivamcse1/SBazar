class AddressModel {
  final String userName;
  final String userPhone;
  final String userCity;
  final String userPincode;
  final String userState;
  final String userStreet;
  // final dynamic updatedAt;
  final dynamic createdAt;
  final String userUid;
  final String addressId;
  final String userNearbyShop;

  AddressModel({
    // required this.updatedAt,
    required this.createdAt,
    required this.userUid,
    required this.userCity,
    required this.userPhone,
    required this.userName,
    required this.userPincode,
    required this.userState,
    required this.userStreet,
    required this.userNearbyShop,
    required this.addressId,
  });

  Map<String, dynamic> toMap() {
    return {
      "userName": userName,
      "userPhone": userPhone,
      "userStreet": userStreet,
      "userPincode": userPincode,
      "userCity": userCity,
      "userState": userState,
      "userNearbyShop": userNearbyShop,
      "userUid": userUid,
      "createdAt": createdAt,
      "addressId": addressId,
      // "updatedAt": updatedAt,
    };
  }

  factory AddressModel.fromMap(Map<String, dynamic> json) {
    return AddressModel(
      // updatedAt: json["updatedAt"],
      createdAt: json["createdAt"],
      userUid: json["userUid"],
      userCity: json["userCity"],
      userPhone: json["userPhone"],
      userName: json["userName"],
      userPincode: json["userPincode"],
      userState: json["userState"],
      userStreet: json["userStreet"],
      userNearbyShop: json["userNearbyShop"],
      addressId: json["addressId"],
    );
  }
}
