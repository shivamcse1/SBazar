// ignore_for_file: body_might_complete_normally_nullable

import 'package:e_commerce/core/error/exception/firebase_exception.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class SignInController extends GetxController{
final TextEditingController emailController = TextEditingController();
final TextEditingController passwordController = TextEditingController();
final RxBool isPasswordVisible = true.obs;

Future <UserCredential?> signInUser(
    {
     required String userEmail,
     required String userPassword,
    }
    ) 
    async{
             try{
                 EasyLoading.show(status: "Please wait...");

                 UserCredential userCredential =  await FirebaseAuth.instance.signInWithEmailAndPassword(
                 email: userEmail, 
                 password: userPassword);
           
                EasyLoading.dismiss();
                return userCredential;

             } on FirebaseException catch(ex){
                EasyLoading.dismiss();
             
                // exception handler
                FirebaseExceptionHelper.exceptionHandler(ex);   
             }

      }
  
}