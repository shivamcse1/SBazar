// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:s_bazar/core/constant/app_const.dart';
import 'package:s_bazar/presentation/widget/custom_button.dart';

import '../../../../core/constant/image_const.dart';
import '../../controllers/internet_controller.dart';

class NoInternetConnectionWidget extends StatefulWidget {
  const NoInternetConnectionWidget({super.key});

  @override
  State<NoInternetConnectionWidget> createState() =>
      _NoInternetConnectionWidgetState();
}

class _NoInternetConnectionWidgetState
    extends State<NoInternetConnectionWidget> {
  final InternetController internetController =
      Get.put(InternetController(), permanent: true);
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            const SizedBox(
              height: 50,
            ),
            SizedBox(
              height: 350,
              child: Lottie.asset(
                ImageConstant.noInternetImg,
              ),
            ),
            const Text(
              "Whoops!",
              style: TextStyle(
                  color: Colors.redAccent,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              "No Internet Connection Available!",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.red[400],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const SizedBox(
              width: 300,
              child: Text(
                "Please Check Your Internet Connection And Try Again",
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Obx(
              () => CustomElevatedButton(
                buttonColor: AppConstant.appPrimaryColor,
                buttonText: "Try Again",
                onTap: () async {
                  internetController.isLoading.value = true;

                  Future.delayed(const Duration(seconds: 3), () {
                    internetController.isLoading.value =
                        internetController.internetStatus.value;
                    if (internetController.internetStatus.value == true) {
                      Get.back();
                    }
                  });
                },
                isLoading: internetController.isLoading.value,
                buttonTextStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
