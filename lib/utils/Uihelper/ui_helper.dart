// ignore_for_file: unnecessary_brace_in_string_interps, prefer_interpolation_to_compose_strings, prefer_adjacent_string_concatenation

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:s_bazar/core/constant/color_const.dart';

import '../../core/constant/app_const.dart';
import '../../core/constant/image_const.dart';

class UiHelper {

  static Widget noProductFound({
    String heading = "No Product Found",
    String subHeading =
        "It seems like there is not any product in this category so please go to another category products!",
    String image = ImageConstant.noProductFound2Img,
  }) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            image,
            height: 150,
          ),
          Text(
            heading,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            subHeading,
            style: const TextStyle(
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }

  static void customSnackbar({required String titleMsg, required String msg}) {
    Get.snackbar(titleMsg, msg,
        backgroundColor: AppConstant.appSecondaryColor,
        colorText: AppConstant.whiteColor,
        snackPosition: SnackPosition.BOTTOM)
        ;
  }

  static void customToast({
    required String msg,
    ToastGravity? toastGravity,
    Color? textColor,
    Color? bgColor,
  }) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: toastGravity ?? ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor:bgColor ?? ColorConstant.primaryColor,
        textColor: textColor ?? ColorConstant.whiteColor,
        fontSize: 16.0);
  }

  void loadingIndigator() {
    EasyLoading.instance
      ..displayDuration = const Duration(milliseconds: 2000)
      ..indicatorType = EasyLoadingIndicatorType.fadingCircle
      ..loadingStyle = EasyLoadingStyle.dark
      ..indicatorSize = 45.0
      ..radius = 10.0
      ..progressColor = Colors.yellow
      ..backgroundColor = Colors.green
      ..indicatorColor = Colors.yellow
      ..textColor = Colors.yellow
      ..maskColor = Colors.blue.withOpacity(0.5)
      ..userInteractions = true
      ..dismissOnTap = false;
  }

  static void hideKeyboard(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

   // generate unique id
  static String generateUniqueId({
    String? idType
  }) {
    DateTime now = DateTime.now();
    int randomNumber = Random().nextInt(10000);
    String orderId = idType == null 
                      ? "OD" + "${now.millisecondsSinceEpoch}" + "${randomNumber}"
                      : idType + "${now.millisecondsSinceEpoch}" + "${randomNumber}";
    return orderId;
  }
}
