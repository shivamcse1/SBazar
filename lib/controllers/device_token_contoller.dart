// ignore_for_file: body_might_complete_normally_nullable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:s_bazar/utils/Uihelper/ui_helper.dart';

class DeviceTokenContoller extends GetxController {
  String deviceToken = '';

  @override
  void onInit() {
    super.onInit();

    getCustomerDeviceToken();
  }

  Future<String> getCustomerDeviceToken() async {
    try {
      String? token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        deviceToken = token;
        update();
        return deviceToken;
      } else {
        UiHelper.customSnackbar(
            titleMsg: "Error Ocuured", msg: "Device Token Null");
        throw Exception("Error occured");
      }
    } on FirebaseException catch (ex) {
      UiHelper.customSnackbar(titleMsg: "Error Ocuured", msg: "$ex");
      throw Exception("Error occured : $ex");
    }
  }
}
