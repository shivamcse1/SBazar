// ignore_for_file: file_names, collection_methods_unrelated_type

class ProductModel {
  final String productId;
  final String categoryId;
  final String productName;
  final String categoryName;
  final String salePrice;
  final String fullPrice;
  final List productImgList;
  final String deliveryTime;
  final bool isSale;
  final bool? isWishlist;
  final String productDescription;
  final dynamic createdAt;
  final dynamic updatedAt;

  ProductModel({
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
    this.isWishlist,
    this.createdAt,
    this.updatedAt,
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
      'isWishlist': isWishlist,
      'productDescription': productDescription,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> json) {
    return ProductModel(
      productId: json['productId'],
      categoryId: json['categoryId'],
      productName: json['productName'],
      categoryName: json['categoryName'],
      salePrice: json['salePrice'],
      fullPrice: json['fullPrice'],
      productImgList: json['productImgList'],
      deliveryTime: json['deliveryTime'],
      isSale: json['isSale'],
      isWishlist: json['isWishlist'],
      productDescription: json['productDescription'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}
