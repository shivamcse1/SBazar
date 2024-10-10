

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SnakbarHelper{

  static showSnakbar(
  {
   required String title,
   required String message,
   EdgeInsets? margin,
   EdgeInsets? padding,
   double? borderRadius,
   SnackPosition? snackPosition,
   
  }

  ){
   
  Get.snackbar(
    title, 
    message,


    );

  }
}