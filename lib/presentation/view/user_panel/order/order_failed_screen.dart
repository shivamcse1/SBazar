import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:s_bazar/core/constant/app_const.dart';
import 'package:s_bazar/presentation/view/user_panel/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:s_bazar/presentation/widget/custom_button.dart';

import '../../../../core/constant/image_const.dart';

class OrderFailedScreen extends StatefulWidget {
  const OrderFailedScreen({super.key});

  @override
  State<OrderFailedScreen> createState() => _OrderFailedScreenState();
}

class _OrderFailedScreenState extends State<OrderFailedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          const SizedBox(
            height: 100,
          ),
          Container(
            child: Lottie.asset(
              ImageConstant.failedImg,
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          const Text(
            "Whoops!",
            style: TextStyle(
                color: Colors.redAccent,
                fontSize: 25,
                fontWeight: FontWeight.w500),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            "Order Does Not Placed!",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.red[400]
                // color: Colors.greenAccent
                ),
          ),
          const SizedBox(
            height: 50,
          ),
          const Text(
            "It seems there is in issue while placing \nan order please try again",
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 30,
          ),
          CustomElevatedButton(
            buttonColor: AppConstant.appPrimaryColor,
            buttonText: "Go Back",
            onTap: () {
              Get.offAll(() => const BottomNavBar());
            },
            buttonTextStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          )
        ]),
      ),
    );
  }
}
