import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../core/constant/database_key_const.dart';
import '../core/error/exception/firebase_exception_handler.dart';

class BannerController extends GetxController {
  RxList<String> bannerImgList = RxList<String>([]);
  RxInt pageIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    getBannerImage();
  }

  @override
  void onClose() {
    BannerController().dispose();
    super.onClose();
  }

  Future<void> getBannerImage() async {
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
}
