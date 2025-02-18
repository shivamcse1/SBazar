import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../core/constant/database_key_const.dart';
import '../core/error/exception/firebase_exception_handler.dart';

class HomeController extends GetxController {
  RxList<Map<String, dynamic>> categoryList = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> flashSaleList = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> allProductList = <Map<String, dynamic>>[].obs;
  RxList<String> bannerImgList = RxList<String>([]);
  RxInt pageIndex = 0.obs;

  User? user = FirebaseAuth.instance.currentUser;

  Future<void> fetchCategory() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection(DbKeyConstant.categoryCollection)
          .get();

      Future.delayed(const Duration(seconds: 2), () {
        categoryList.value = querySnapshot.docs.map((doc) {
          return doc.data() as Map<String, dynamic>;
        }).toList();
      });
    } on FirebaseException catch (ex) {
      categoryList.value = [];
      FirebaseExceptionHelper.exceptionHandler(ex);
    }
  }

  Future<void> fetchFlashSaleProduct() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection(DbKeyConstant.productCollection)
          .where('isSale', isEqualTo: true)
          .get();

      Future.delayed(const Duration(seconds: 2), () {
        flashSaleList.value = querySnapshot.docs.map((doc) {
          return doc.data() as Map<String, dynamic>;
        }).toList();
      });
    } on FirebaseException catch (ex) {
      flashSaleList.value = [];
      FirebaseExceptionHelper.exceptionHandler(ex);
    }
  }

  Future<void> fetchAllProduct() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection(DbKeyConstant.productCollection)
          .get();

      Future.delayed(const Duration(seconds: 2), () {
        allProductList.value = querySnapshot.docs.map((doc) {
          return doc.data() as Map<String, dynamic>;
        }).toList();
      });
    } on FirebaseException catch (ex) {
      allProductList.value = [];
      FirebaseExceptionHelper.exceptionHandler(ex);
    }
  }

  Future<void> fetchBannerImage() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection(DbKeyConstant.bannerCollection)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        Future.delayed(const Duration(seconds: 2), () {
          bannerImgList.value = querySnapshot.docs.map((singleDoc) {
            return singleDoc[DbKeyConstant.bannerImg] as String;
          }).toList();
        });
      }
    } on FirebaseException catch (ex) {
      FirebaseExceptionHelper.exceptionHandler(ex);
    }
  }

  @override
  void onClose() {
    HomeController().dispose();
    super.onClose();
  }

}
