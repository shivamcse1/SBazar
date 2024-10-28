import 'package:e_commerce/core/constant/app_const.dart';
import 'package:e_commerce/core/error/exception/firebase_exception.dart';
import 'package:e_commerce/presentation/view/auth_ui/sign_in_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class ForgotPasswordController extends GetxController{
  final TextEditingController emailController = TextEditingController();
   

   Future<void> forgotPassword({required String userEmail}) async{

     try{ 
           EasyLoading.show(status: "Please Wait...");
           await FirebaseAuth.instance.sendPasswordResetEmail(email: userEmail);
           
           Get.snackbar(
            "Reset Request Sent Successfully", 
            'Password Reset Link Sent To $userEmail',
             backgroundColor: AppConstant.appSecondaryColor,
             snackPosition: SnackPosition.BOTTOM,
             colorText: AppConstant.whiteColor
            
            );
            EasyLoading.dismiss();
            Get.to( () => const SignInScreen());
           
       }on FirebaseException catch(ex){
         
         EasyLoading.dismiss();
         FirebaseExceptionHelper.exceptionHandler(ex);
           
     }

   }

}