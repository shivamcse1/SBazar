// ignore_for_file: file_names, collection_methods_unrelated_type


class OrderModel {
  final String productId;
  final String categoryId;
  final String productName;
  final String categoryName;
  final String salePrice;
  final String fullPrice;
  final List productImgList;
  final String deliveryTime;
  final bool isSale;
  final String productDescription;
  final dynamic createdAt;
  final dynamic updatedAt;
  final int productQuantity;
  final double productTotalPrice;
  final String userUid;
  final bool orderStatus;
  final String userName;
  final String userPhone;
  final String userAddress;
  final String userDeviceToken;
  final String orderId ;

  OrderModel({
     required this.productId,
     required this.categoryId,
     required this.productName,
     required this.categoryName,
     required this.salePrice,
     required this.fullPrice,
     required this.productImgList,
     required this.deliveryTime,
     required this.isSale,
     required this.productDescription,
     required this.createdAt,
     required this.updatedAt,
     required this.productQuantity,
     required this.productTotalPrice,
     required this.userUid, 
     required this.orderStatus, 
     required this.userName, 
     required this.userPhone,
     required this.userAddress, 
     required this.userDeviceToken, 
     this.orderId ='',
  });

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'categoryId': categoryId,
      'productName': productName,
      'categoryName': categoryName,
      'salePrice': salePrice,
      'fullPrice': fullPrice,
      'productImgList': productImgList,
      'deliveryTime': deliveryTime,
      'isSale': isSale,
      'productDescription': productDescription,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'productQuantity': productQuantity,
      'productTotalPrice': productTotalPrice,
      'userUid':userUid,
      'orderStatus':orderStatus,
      'userName':userName,
      'userPhone' : userPhone,
      'userAddress' :userAddress,
      'userDeviceToken' :userDeviceToken,
      'orderId' : orderId
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> json) {
    return OrderModel(
      productId: json['productId'],
      categoryId: json['categoryId'],
      productName: json['productName'],
      categoryName: json['categoryName'],
      salePrice: json['salePrice'],
      fullPrice: json['fullPrice'],
      productImgList: json['productImgList'],
      deliveryTime: json['deliveryTime'],
      isSale: json['isSale'],
      productDescription: json['productDescription'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      productQuantity: json['productQuantity'],
      productTotalPrice :json['productTotalPrice'],
      userUid : json['userUid'],
      orderStatus : json['orderStatus'],
      userName : json['userName'],
      userPhone : json['userPhone'],
      userAddress : json['userAddress'],
      userDeviceToken : json['userDeviceToken'],
      orderId : json['orderId']

    );
  }
}