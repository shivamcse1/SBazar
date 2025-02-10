// ignore_for_file: body_might_complete_normally_nullable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../core/constant/app_const.dart';
import '../core/constant/database_key_const.dart';
import '../core/error/exception/firebase_exception_handler.dart';
import '../data/model/user_model.dart';
import '../presentation/view/auth_ui/sign_in_screen.dart';
import '../presentation/view/user_panel/home/user_home_screen.dart';
import 'device_token_contoller.dart';

class AuthController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();

  final FirebaseAuth auth = FirebaseAuth.instance;
  final RxBool isPasswordVisible = true.obs;

  Future<UserCredential?> signInWithEmail({
    required String userEmail,
    required String userPassword,
  }) async {
    try {
      EasyLoading.show(status: "Please wait...");

      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: userEmail, password: userPassword);

      EasyLoading.dismiss();
      return userCredential;
    } on FirebaseException catch (ex) {
      EasyLoading.dismiss();
      // exception handler
      FirebaseExceptionHelper.exceptionHandler(ex);
    }
  }

  Future<void> signInWithGoogleAccount() async {
    final DeviceTokenContoller deviceTokenContoller =
        Get.put(DeviceTokenContoller());
    try {
      EasyLoading.show(
        status: "Please wait...",
      );
      // it object use to authenticate and fetch details to google server
      final GoogleSignIn googleSignIn = GoogleSignIn();

      // signIn() show all google account popUP and authenticate with google and response me google send idToken, access token
      final GoogleSignInAccount? userAccount = await googleSignIn.signIn();

      // if user not tap any account just go back
      if (userAccount == null) {
        EasyLoading.dismiss();
        Fluttertoast.showToast(msg: "Please Selecet One Of Them");
        return;
      }

      // it use for generate acces token and id token by google
      final GoogleSignInAuthentication googleAuthentication =
          await userAccount.authentication;

      // use this for create credentail because we can not sign in without credentials
      AuthCredential userInfoCredential = GoogleAuthProvider.credential(
          accessToken: googleAuthentication.accessToken,
          idToken: googleAuthentication.idToken);

      // use this for signIn in firebase using credential
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(userInfoCredential);

      final User? user = userCredential.user;

      if (user != null) {
        UserModel userModel = UserModel(
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
            userCity: '');

        await FirebaseFirestore.instance
            .collection(DbKeyConstant.userCollection)
            .doc(user.uid)
            .set(userModel.toMap());

        EasyLoading.dismiss();
        Fluttertoast.showToast(msg: "Login SuccessFull");
        Get.offAll(() => const UserHomeScreen());
      }
    } on FirebaseException catch (ex) {
      print("avaja");
      EasyLoading.dismiss();
      FirebaseExceptionHelper.exceptionHandler(ex);
    }
  }

  Future<UserCredential?> emailSignUpUser({
    required String userName,
    required String userEmail,
    required String userPhone,
    required String userPassword,
    required String userCity,
    required String userDeviceToken,
  }) async {
    final DeviceTokenContoller deviceTokenContoller =
        Get.put(DeviceTokenContoller());
    try {
      EasyLoading.show(status: 'Please wait...');
      // sign up or create user In using email

      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: userEmail, password: userPassword);

      // after signup instant send email verificatin link
      await userCredential.user!.sendEmailVerification();

      UserModel userModel = UserModel(
          userUid: userCredential.user!.uid,
          userName: userName,
          userEmail: userEmail,
          userPhone: userPhone,
          userImg: '',
          userDeviceToken: deviceTokenContoller.deviceToken.toString(),
          userCountry: 'IN',
          userAddress: '',
          userStreet: '',
          isAdmin: false,
          isActive: true,
          createdAt: DateTime.now(),
          userCity: userCity);

      // store data of user in firestore

      await FirebaseFirestore.instance
          .collection(DbKeyConstant.userCollection)
          .doc(userCredential.user!.uid)
          .set(userModel.toMap());

      EasyLoading.dismiss();
      return userCredential;
    } on FirebaseException catch (ex) {
      EasyLoading.dismiss();
      FirebaseExceptionHelper.exceptionHandler(ex);
    }
  }

  Future<void> forgotPassword({required String userEmail}) async {
    try {
      EasyLoading.show(status: "Please Wait...");
      await FirebaseAuth.instance.sendPasswordResetEmail(email: userEmail);

      Get.snackbar("Reset Request Sent Successfully",
          'Password Reset Link Sent To $userEmail',
          backgroundColor: AppConstant.appSecondaryColor,
          snackPosition: SnackPosition.BOTTOM,
          colorText: AppConstant.whiteColor);
      EasyLoading.dismiss();
      Get.offAll(() => const SignInScreen());
    } on FirebaseException catch (ex) {
      EasyLoading.dismiss();
      FirebaseExceptionHelper.exceptionHandler(ex);
    }
  }
}
