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
  final String customerId;
  final bool orderStatus;
  final String customerName;
  final String customerPhone;
  final String customerAddress;
  final String customerDeviceToken;

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
     required this.customerId, 
     required this.orderStatus, 
     required this.customerName, 
     required this.customerPhone,
     required this.customerAddress, 
     required this.customerDeviceToken, 
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
      'customerId':customerId,
      'orderStatus':orderStatus,
      'customerName':customerName,
      'customerPhone' : customerPhone,
      'customerAddress' :customerAddress,
      'customerDeviceToken' :customerDeviceToken
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
      customerId : json['productTotalPrice'],
      orderStatus : json['orderStatus'],
      customerName : json['customerName'],
      customerPhone : json['customerPhone'],
      customerAddress : json['customerAddress'],
      customerDeviceToken : json['customerDeviceToken'],

    );
  }
}