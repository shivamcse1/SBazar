// ignore_for_file: avoid_unnecessary_containers

import 'package:s_bazar/controllers/auth_controller.dart';
import 'package:s_bazar/core/constant/color_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../core/constant/app_const.dart';
import '../../../core/constant/image_const.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => ForgotPasswordScreenState();
}

class ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(
      builder: (context, isKeyboardvisible) {
        return Scaffold(
            appBar: AppBar(
              iconTheme: IconThemeData(color: ColorConstant.whiteColor),
              backgroundColor: AppConstant.appSecondaryColor,
              title: Text(
                "Forgot Password",
                style: TextStyle(color: AppConstant.whiteColor),
              ),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Container(
                child: Column(
                  children: [
                    Column(
                      children: [
                        Container(
                          color: AppConstant.appSecondaryColor,
                          height: Get.height / 2.5,
                          width: Get.width,
                          child: Lottie.asset(ImageConstant.splashImg),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: Get.height / 20,
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 10, right: 10),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: TextFormField(
                        controller: authController.emailController,
                        cursorColor: AppConstant.appSecondaryColor,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.email),
                            hintText: "Email",
                            contentPadding:
                                const EdgeInsets.only(top: 2.0, left: 8.0),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0))),
                      ),
                    ),
                    SizedBox(
                      height: Get.height / 25,
                    ),
                    Container(
                      height: Get.height / 18,
                      width: Get.width / 1.8,
                      decoration: BoxDecoration(
                          color: AppConstant.appPrimaryColor,
                          borderRadius: BorderRadius.circular(20.0)),
                      child: TextButton(
                        onPressed: () async {
                          String email =
                              authController.emailController.text.trim();

                          if (email.isEmpty) {
                            Get.snackbar("Empty Field", 'Please Enter Email',
                                backgroundColor: AppConstant.appSecondaryColor,
                                snackPosition: SnackPosition.BOTTOM,
                                colorText: AppConstant.whiteColor);
                          } else {
                            await authController.forgotPassword(
                                userEmail: email);
                          }
                        },
                        child: Text(
                          "Forgot Password",
                          style: TextStyle(color: AppConstant.whiteColor),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ));
      },
    );
  }
}
