import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:s_bazar/core/constant/database_key_const.dart';
import 'package:s_bazar/core/error/exception/firebase_exception_handler.dart';
import 'package:s_bazar/data/model/product_model.dart';

class WishlistController extends GetxController {
  RxList<Map<String, dynamic>> productWishList = <Map<String, dynamic>>[].obs;
  User? user = FirebaseAuth.instance.currentUser;
  RxBool isFavProduct = false.obs;

  Future<void> fetchWishlistProduct() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection(DbKeyConstant.wishlistCollection)
          .doc(user!.uid)
          .collection(DbKeyConstant.wishlistProductCollection)
          .where(DbKeyConstant.isWishlist, isEqualTo: true)
          .get();

      Future.delayed(const Duration(seconds: 2), () {
        productWishList.value = querySnapshot.docs.map((doc) {
          return doc.data() as Map<String, dynamic>;
        }).toList();
      });
    } on FirebaseException catch (ex) {
      FirebaseExceptionHelper.exceptionHandler(ex);
    }
  }

  Future<void> addProductInWishlist({required ProductModel model}) async {
    try {
      ProductModel productModel = ProductModel(
        productId: model.productId,
        categoryId: model.categoryId,
        categoryName: model.categoryName,
        salePrice: model.salePrice,
        productName: model.productName,
        fullPrice: model.fullPrice,
        productImgList: model.productImgList,
        deliveryTime: model.deliveryTime,
        isSale: model.isSale,
        isWishlist: true,
        createdAt: DateTime.now(),
        productDescription: model.productDescription,
      );

      DocumentReference docref = FirebaseFirestore.instance
          .collection(DbKeyConstant.wishlistCollection)
          .doc(user!.uid)
          .collection(DbKeyConstant.wishlistProductCollection)
          .doc(model.productId);
      DocumentSnapshot documentSnapshot = await docref.get();

      if (documentSnapshot.exists) {
        bool fav = documentSnapshot[DbKeyConstant.isWishlist];
        await docref.update(
          {
            DbKeyConstant.isWishlist: fav ? false : true,
            DbKeyConstant.updatedAt: DateTime.now()
          },
        );
      } else {
        await docref.set(productModel.toMap());
      }
    } on FirebaseException catch (ex) {
      FirebaseExceptionHelper.exceptionHandler(ex);
    }
  }

  Future<void> checkProduct({required ProductModel productModel}) async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection(DbKeyConstant.wishlistCollection)
          .doc(user!.uid)
          .collection(DbKeyConstant.wishlistProductCollection)
          .doc(productModel.productId)
          .get();

      if (doc.exists) {
        isFavProduct.value = doc[DbKeyConstant.isWishlist];
      } else {
        isFavProduct.value = false;
      }
    } on FirebaseException catch (ex) {
      FirebaseExceptionHelper.exceptionHandler(ex);
    }
  }
}
