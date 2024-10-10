// ignore_for_file: unused_local_variable, body_might_complete_normally_nullable, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/core/constant/database_key_const.dart';
import 'package:e_commerce/core/error/exception/firebase_exception.dart';
import 'package:e_commerce/data/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import 'device_token_contoller.dart';

class EmailSignUpController extends GetxController{

  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();

  final FirebaseAuth auth = FirebaseAuth.instance;
  RxBool isPasswordVisible = true.obs;

  Future<UserCredential?> emailSignUpUser (

    { 
   required String userName,
   required String userEmail,
   required String userPhone,
   required String userPassword,
   required String userCity,
   required String userDeviceToken,}
  ) async{
      final DeviceTokenContoller deviceTokenContoller = Get.put(DeviceTokenContoller());
     try{
             EasyLoading.show(status: 'Please wait...');
            // sign up or create user In using email

            UserCredential userCredential = await auth.createUserWithEmailAndPassword(
            email: userEmail,
            password:userPassword
            );
            
            // after signup instant send email verificatin link
           await userCredential.user!.sendEmailVerification();


            UserModel userModel =UserModel(
              uId:userCredential.user!.uid , 
              username: userName, 
              email: userEmail, 
              phone: userPhone, 
              userImg: '', 
              userDeviceToken: deviceTokenContoller.deviceToken.toString(), 
              country: 'IN', 
              userAddress: '', 
              street: '', 
              isAdmin: false, 
              isActive: true, 
              createdOn: DateTime.now(), 
              city: userCity
              );

            
            // store data of user in firestore

           await FirebaseFirestore.instance
            .collection(DatabaseKeyConstant.userCollection)
            .doc(userCredential.user!.uid)
            .set(userModel.toMap());
            
            EasyLoading.dismiss();
            return userCredential;

        } on FirebaseException catch(ex){

          EasyLoading.dismiss();
          FirebaseExceptionHelper.exceptionHandler(ex);

     }
  }

}