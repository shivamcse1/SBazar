// ignore_for_file: avoid_unnecessary_containers

import 'package:s_bazar/core/constant/image_const.dart';
import 'package:s_bazar/presentation/view/auth_ui/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../controllers/auth_controller.dart';
import '../../../core/constant/app_const.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => WelcomeScreenState();
}

class WelcomeScreenState extends State<WelcomeScreen> {
  final AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstant.appSecondaryColor,
        title: Text(
          "Welcome to my S-Mart",
          style: TextStyle(color: AppConstant.whiteColor),
        ),
        centerTitle: true,
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              color: AppConstant.appSecondaryColor,
              height: Get.height / 2.5,
              width: Get.width,
              child: Lottie.asset(ImageConstant.loginImg),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20.0),
              child: const Text(
                "Happy Shopping",
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: Get.height / 15,
            ),
            Container(
              height: Get.height / 15,
              width: Get.width / 1.5,
              decoration: BoxDecoration(
                  color: AppConstant.appPrimaryColor,
                  borderRadius: BorderRadius.circular(20.0)),
              child: TextButton.icon(
                onPressed: () async {
                  await authController.signInWithGoogleAccount();
                },
                icon: Image.asset(ImageConstant.googleIc),
                label: Text(
                  "Sign in with google",
                  style: TextStyle(color: AppConstant.whiteColor),
                ),
              ),
            ),
            SizedBox(
              height: Get.height / 50,
            ),
            Container(
              height: Get.height / 15,
              width: Get.width / 1.5,
              decoration: BoxDecoration(
                  color: AppConstant.appPrimaryColor,
                  borderRadius: BorderRadius.circular(20.0)),
              child: TextButton.icon(
                onPressed: () {
                  Get.to(() => const SignInScreen());
                },
                icon: Icon(
                  Icons.email,
                  color: AppConstant.whiteColor,
                ),
                label: Text(
                  "Sign in with email",
                  style: TextStyle(color: AppConstant.whiteColor),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
