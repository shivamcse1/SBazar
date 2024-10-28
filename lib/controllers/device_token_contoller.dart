// ignore_for_file: body_might_complete_normally_nullable

import 'package:e_commerce/utils/Uihelper/custom_snakbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class DeviceTokenContoller extends GetxController{

 String deviceToken = '';

 @override
  void onInit(){
    super.onInit();

    getCustomerDeviceToken();
  }

  Future<String> getCustomerDeviceToken() async{
   try{

    String? token = await FirebaseMessaging.instance.getToken();
    if(token!=null){
      deviceToken = token;
      update();
      return deviceToken ;
    }else{
       SnackbarHelper.customSnackbar(titleMsg: "Error Ocuured", msg: "Device Token Null");
       throw Exception("Error occured");
    }
      
   } on FirebaseException catch(ex){

         SnackbarHelper.customSnackbar(titleMsg: "Error Ocuured", msg: "$ex");
         throw Exception("Error occured : $ex");
   }
  
  }

}