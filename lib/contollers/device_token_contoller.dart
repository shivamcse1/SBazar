import 'package:e_commerce/utils/Uihelper/custom_snakbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class DeviceTokenContoller extends GetxController{

 String? deviceToken;

 @override
  void onInit(){
    super.onInit();

    getDeviceToken();
  }

  Future<void> getDeviceToken() async{
   try{

    String? token = await FirebaseMessaging.instance.getToken();
    if(token!=null){

      deviceToken = token;
      update();
    }
      
   } on FirebaseException catch(ex){

         SnackbarHelper.customSnackbar(titleMsg: "Error Ocuured", msg: "$ex");
   }
  
  }

}