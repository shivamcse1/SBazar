// ignore_for_file: avoid_unnecessary_containers

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:s_bazar/core/constant/color_const.dart';
import 'package:s_bazar/core/constant/database_key_const.dart';
import 'package:s_bazar/core/error/exception/firebase_exception_handler.dart';
import 'package:s_bazar/data/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:s_bazar/presentation/widget/custom_button.dart';
import 'package:s_bazar/presentation/widget/custom_textfield.dart';
import 'package:s_bazar/utils/Uihelper/ui_helper.dart';
import '../../../../controllers/auth_controller.dart';
import '../../../../core/constant/app_const.dart';
import '../../../../core/constant/textstyle_const.dart';

class UpdateProfileScreen extends StatefulWidget {
  final String? userImage;
  const UpdateProfileScreen({super.key, this.userImage});

  @override
  State<UpdateProfileScreen> createState() => UpdateProfileScreenState();
}

class UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final AuthController authController = Get.put(AuthController());
  User? user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(
      builder: (context, isKeyboardvisible) {
        return Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(color: ColorConstant.whiteColor),
            backgroundColor: AppConstant.appSecondaryColor,
            title: Text(
              "Update Profile",
              style: TextStyle(color: AppConstant.whiteColor),
            ),
            centerTitle: false,
          ),
          body: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  CustomTextField(
                    controller: authController.nameController,
                    height: 45,
                    hintText: "Name",
                    prefix: const Icon(Icons.person),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomTextField(
                    controller: authController.phoneController,
                    height: 45,
                    hintText: "Phone",
                    prefix: const Icon(Icons.phone_android),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomTextField(
                    controller: authController.emailController,
                    height: 45,
                    hintText: "Email",
                    prefix: const Icon(Icons.email),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomTextField(
                    controller: authController.streetController,
                    height: 45,
                    hintText: "House number, Colony, Street .etc",
                    prefix: const Icon(Icons.home),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomTextField(
                    controller: authController.cityController,
                    height: 45,
                    hintText: "City",
                    prefix: const Icon(Icons.location_pin),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomTextField(
                    controller: authController.stateController,
                    height: 45,
                    hintText: "State",
                    prefix: const Icon(Icons.maps_home_work),
                  ),
                  SizedBox(
                    height: Get.height / 15,
                  ),
                  CustomElevatedButton(
                    buttonText: "Update Profile",
                    buttonTextStyle: TextStyleConstant.bold16Style.copyWith(
                        fontWeight: FontWeight.bold,
                        color: ColorConstant.whiteColor),
                    onTap: () async {
                      String userName =
                          authController.nameController.text.trim();
                      String userPhone =
                          authController.phoneController.text.trim();
                      String userEmail =
                          authController.emailController.text.trim();
                      String userCity =
                          authController.cityController.text.trim();
                      String userState =
                          authController.stateController.text.trim();
                      String userStreet =
                          authController.streetController.text.trim();

                      UserModel userModel = UserModel(
                        userUid: user!.uid,
                        userName: userName,
                        userEmail: userEmail,
                        userPhone: userPhone,
                        userImg: "",
                        userDeviceToken: "",
                        userCountry: "",
                        userStreet: userStreet,
                        isAdmin: false,
                        isActive: true,
                        createdAt: DateTime.now(),
                        userCity: userCity,
                        userState: userState,
                      );

                      if (userName.isEmpty ||
                          userEmail.isEmpty ||
                          userCity.isEmpty ||
                          userPhone.isEmpty ||
                          userStreet.isEmpty ||
                          userState.isEmpty) {
                        Get.snackbar(
                            "Somthing Missing", 'Please Enter All Details!',
                            backgroundColor: AppConstant.appSecondaryColor,
                            colorText: AppConstant.whiteColor,
                            snackPosition: SnackPosition.BOTTOM);
                      } else {
                        try {
                          EasyLoading.show(status: "Please wait");
                          FirebaseFirestore.instance
                              .collection(DbKeyConstant.userCollection)
                              .doc(user!.uid)
                              .update({
                            DbKeyConstant.userName: userName,
                            DbKeyConstant.userPhone: userPhone,
                            DbKeyConstant.userEmail: userEmail,
                            DbKeyConstant.userStreet: userStreet,
                            DbKeyConstant.userCity: userCity,
                            DbKeyConstant.userState: userState,
                          }).then((value) {
                            authController.assignDataToController(
                                userModel: userModel);

                            Future.delayed(const Duration(seconds: 1), () {
                              EasyLoading.dismiss();
                              UiHelper.customToast(msg: "Updated Successfully");
                              Get.back();
                            });
                          });
                        } on FirebaseException catch (ex) {
                          EasyLoading.dismiss();
                          FirebaseExceptionHelper.exceptionHandler(ex);
                        }
                      }
                    },
                    buttonColor: AppConstant.appPrimaryColor,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
