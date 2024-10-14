
// ignore_for_file: avoid_print, unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/contollers/device_token_contoller.dart';
import 'package:e_commerce/core/constant/database_key_const.dart';
import 'package:e_commerce/core/error/exception/firebase_exception.dart';
import 'package:e_commerce/data/model/user_model.dart';
import 'package:e_commerce/presentation/view/user_panel/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInContoller extends GetxController{
 

Future<void> signInWithGoogleAccount () async{
 final DeviceTokenContoller deviceTokenContoller = Get.put(DeviceTokenContoller());
 try{
      
      EasyLoading.show(
       status: "Please wait...",
      );
      // it object use to authenticate and fetch details to google server 
      final GoogleSignIn googleSignIn = GoogleSignIn();

      // signIn() show all google account popUP and authenticate with google and response me google send idToken, access token
      final GoogleSignInAccount? userAccount = await googleSignIn.signIn();

      // if user not tap any account just go back 
      if(userAccount == null){
  
          EasyLoading.dismiss();  
          Fluttertoast.showToast(msg: "Please Selecet One Of Them");
          return;
      }

      // it use for generate acces token and id token by google
      final GoogleSignInAuthentication googleAuthentication = await userAccount.authentication;


      // use this for create credentail because we can not sign in without credentials
      AuthCredential userInfoCredential = GoogleAuthProvider.credential(
        accessToken: googleAuthentication.accessToken,
        idToken: googleAuthentication.idToken
      );

      // use this for signIn in firebase using credential
      final UserCredential userCredential =  await FirebaseAuth.instance.signInWithCredential(userInfoCredential);
      
      final User? user = userCredential.user;
        
        if(user!=null){

          UserModel userModel =UserModel(
            userUid: user.uid, 
            userName: user.displayName.toString(), 
            userEmail: user.email.toString(), 
            userPhone: user.phoneNumber.toString(), 
            userImg: user.photoURL.toString(), 
            userDeviceToken: deviceTokenContoller.deviceToken.toString(), 
            userCountry: '', 
            userAddress: '', 
            userStreet: '', 
            isAdmin: false, 
            isActive: true, 
            createdAt: DateTime.now(), 
            userCity:''
            
            );


          await FirebaseFirestore.instance
          .collection(DbKeyConstant.userCollection)
          .doc(user.uid)
          .set(userModel.toMap());

        EasyLoading.dismiss();  
        Fluttertoast.showToast(msg: "Login SuccessFull");
        Get.offAll(()=> const UserHomeScreen());
       
        }
       

 }
   on FirebaseException catch(ex){
     EasyLoading.dismiss();  
     FirebaseExceptionHelper.exceptionHandler(ex);

 }

}
}