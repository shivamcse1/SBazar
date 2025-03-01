// ignore_for_file: avoid_unnecessary_containers

import 'package:s_bazar/core/constant/color_const.dart';
import 'package:s_bazar/data/services/firebase_notification_service.dart';
import 'package:s_bazar/main.dart';
import 'package:s_bazar/presentation/view/auth_ui/sign_in_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';

import '../../../controllers/auth_controller.dart';
import '../../../core/constant/app_const.dart';
import '../../widget/custom_textfield.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
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
                "Sign Up",
                style: TextStyle(color: AppConstant.whiteColor),
              ),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: Get.height / 40,
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        "Welcome to My App",
                        style: TextStyle(
                            color: AppConstant.appSecondaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0),
                      ),
                    ),
                    SizedBox(
                      height: Get.height / 30,
                    ),
                    CustomTextField(
                      keyboardType: TextInputType.name,
                      controller: authController.nameController,
                      height: 50,
                      hintText: "Name",
                      prefix: const Icon(Icons.person),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomTextField(
                      keyboardType: TextInputType.phone,
                      controller: authController.phoneController,
                      height: 50,
                      hintText: "Phone",
                      prefix: const Icon(Icons.phone_android),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomTextField(
                      controller: authController.emailController,
                      keyboardType: TextInputType.emailAddress,
                      height: 50,
                      hintText: "Email",
                      prefix: const Icon(Icons.email),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomTextField(
                      controller: authController.streetController,
                      keyboardType: TextInputType.streetAddress,
                      height: 50,
                      hintText: "House number, Colony, Street .etc",
                      prefix: const Icon(Icons.home),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomTextField(
                      controller: authController.cityController,
                      keyboardType: TextInputType.name,
                      height: 50,
                      hintText: "City",
                      prefix: const Icon(Icons.location_pin),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomTextField(
                      controller: authController.stateController,
                      keyboardType: TextInputType.name,
                      height: 50,
                      hintText: "State",
                      prefix: const Icon(Icons.maps_home_work),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Obx(
                      () => CustomTextField(
                        controller: authController.passwordController,
                        obscureText: authController.isPasswordVisible.value,
                        keyboardType: TextInputType.emailAddress,
                        height: 50,
                        hintText: "Password",
                        prefix: const Icon(Icons.password),
                        suffix: IconButton(
                          onPressed: () {
                            authController.isPasswordVisible.toggle();
                          },
                          icon: Icon(authController.isPasswordVisible.value
                              ? Icons.visibility_off
                              : Icons.visibility),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: Get.height / 20,
                    ),
                    Container(
                      height: Get.height / 18,
                      width: Get.width / 1.8,
                      decoration: BoxDecoration(
                          color: AppConstant.appPrimaryColor,
                          borderRadius: BorderRadius.circular(20.0)),
                      child: TextButton(
                        onPressed: () async {
                          String userName =
                              authController.nameController.text.trim();
                          String userPhone =
                              authController.phoneController.text.trim();
                          String userEmail =
                              authController.emailController.text.trim();
                          String userPassword =
                              authController.passwordController.text.trim();
                          String userCity =
                              authController.cityController.text.trim();
                          String userState =
                              authController.stateController.text.trim();
                          String userStreet =
                              authController.streetController.text.trim();
                          String userDeviceToken =
                              await FirebaseNotificationService
                                  .getDeviceToken();

                          if (userName.isEmpty ||
                              userEmail.isEmpty ||
                              userPassword.isEmpty ||
                              userCity.isEmpty ||
                              userPhone.isEmpty ||
                              userStreet.isEmpty ||
                              userState.isEmpty) {
                            Get.snackbar("Something Missing",
                                'Please Enter All Details!',
                                backgroundColor: AppConstant.appSecondaryColor,
                                colorText: AppConstant.whiteColor,
                                snackPosition: SnackPosition.BOTTOM);
                          } else {
                            await localDataBaseHelper.setUserData(
                              name: userName,
                              phone: userPhone,
                              city: userCity,
                              state: userState,
                              deviceToken: userDeviceToken,
                              email: userEmail,
                              street: userStreet,
                            );
                            UserCredential? userCredential =
                                await authController.emailSignUpUser(
                                    userName: userName,
                                    userEmail: userEmail,
                                    userPhone: userPhone,
                                    userPassword: userPassword,
                                    userCity: userCity,
                                    userDeviceToken: userDeviceToken,
                                    userState: userState,
                                    userStreet: userStreet);

                            if (userCredential != null) {
                              Get.snackbar(
                                  "Verification Email Sent On $userEmail",
                                  'Please Verify Email Before Login!',
                                  backgroundColor:
                                      AppConstant.appSecondaryColor,
                                  colorText: AppConstant.whiteColor,
                                  snackPosition: SnackPosition.BOTTOM,
                                  );
                              FirebaseAuth.instance.signOut();
                              Get.offAll(() => const SignInScreen());
                            }
                          }
                        },
                        child: Text(
                          "SIGN UP",
                          style: TextStyle(color: AppConstant.whiteColor),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: Get.height / 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account? ",
                          style: TextStyle(
                            color: AppConstant.appSecondaryColor,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.offAll(() => const SignInScreen());
                          },
                          child: Text(
                            "Sign In",
                            style: TextStyle(
                                color: AppConstant.appSecondaryColor,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ));
      },
    );
  }
}
