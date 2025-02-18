// ignore_for_file: body_might_complete_normally_nullable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:s_bazar/presentation/view/user_panel/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:s_bazar/utils/Uihelper/ui_helper.dart';

import '../core/constant/app_const.dart';
import '../core/constant/database_key_const.dart';
import '../core/error/exception/firebase_exception_handler.dart';
import '../data/model/user_model.dart';
import '../presentation/view/auth_ui/sign_in_screen.dart';

class AuthController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController streetController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  RxString deviceToken = ''.obs;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final RxBool isPasswordVisible = true.obs;

  @override
  void onInit() {
    getCustomerDeviceToken();
    super.onInit();
  }

  Future<UserCredential?> signInWithEmailAndPassword({
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
          userDeviceToken: deviceToken.value,
          userCountry: '',
          userStreet: '',
          isAdmin: false,
          isActive: true,
          createdAt: DateTime.now(),
          userCity: '',
          userState: "",
        );

        await FirebaseFirestore.instance
            .collection(DbKeyConstant.userCollection)
            .doc(user.uid)
            .set(userModel.toMap());

        EasyLoading.dismiss();
        Fluttertoast.showToast(msg: "Login SuccessFull");
        Get.offAll(() => const BottomNavBar());
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
    required String userStreet,
    required String userState,
    required String userDeviceToken,
  }) async {
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
        userDeviceToken: deviceToken.value,
        userCountry: 'IN',
        userStreet: userStreet,
        isAdmin: false,
        isActive: true,
        createdAt: DateTime.now(),
        userCity: userCity,
        userState: userState,
      );

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

  Future<String> getCustomerDeviceToken() async {
    try {
      String? token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        deviceToken.value = token;

        return deviceToken.value;
      } else {
        UiHelper.customSnackbar(
            titleMsg: "Error Ocuured", msg: "Device Token Null");
        throw Exception("Error occured");
      }
    } on FirebaseException catch (ex) {
      FirebaseExceptionHelper.exceptionHandler(ex);
      throw Exception("Error occured : $ex");
    }
  }

  void assignDataToController({required UserModel userModel}) {
    nameController.text = userModel.userName;
    phoneController.text = userModel.userPhone;
    emailController.text = userModel.userEmail;
    streetController.text = userModel.userStreet;
    cityController.text = userModel.userCity;
    stateController.text = userModel.userState;
  }
}
