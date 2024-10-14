import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/core/constant/database_key_const.dart';
import 'package:e_commerce/core/error/exception/firebase_exception.dart';
import 'package:get/get.dart';

class BannerController extends GetxController{
 RxList<String> bannerImgList = RxList<String>([]);
 RxInt pageIndex = 0.obs;

 @override
  void onInit() {
    super.onInit();
    getBannerImage();
  }
     
  Future <void> getBannerImage () async{
       
       try{
          QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection(DbKeyConstant.bannerCollection)
          .get();
          
          if(querySnapshot.docs.isNotEmpty){
                 bannerImgList.value = querySnapshot.docs.map((singleDoc) {

                      return singleDoc[DbKeyConstant.bannerImg] as String;
                 }).toList();

          }

       } on FirebaseException catch(ex){
           FirebaseExceptionHelper.exceptionHandler(ex);
       }
      

  }   
}