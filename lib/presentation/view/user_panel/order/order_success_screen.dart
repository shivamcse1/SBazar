import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:lottie/lottie.dart';
import 'package:s_bazar/controllers/cart_controller.dart';
import 'package:s_bazar/core/constant/app_const.dart';
import 'package:s_bazar/presentation/view/user_panel/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:s_bazar/presentation/widget/custom_button.dart';

import '../../../../core/constant/database_key_const.dart';
import '../../../../core/constant/image_const.dart';
import '../../../../core/constant/textstyle_const.dart';

class OrderSuccessScreen extends StatefulWidget {
  final String paymentMode;
  final String totalAmount;
  const OrderSuccessScreen({
    super.key,
    required this.paymentMode,
    required this.totalAmount,
  });

  @override
  State<OrderSuccessScreen> createState() => _OrderSuccessScreenState();
}

class _OrderSuccessScreenState extends State<OrderSuccessScreen> {
  DateTime now = DateTime.now();
  final CartController cartController = Get.put(CartController());

  @override
  Widget build(BuildContext context) {
    String date = "${now.day}/${now.month}/${now.year}";

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          const SizedBox(
            height: 50,
          ),
          Container(
            child: Lottie.asset(
              ImageConstant.successImg,
            ),
          ),
          const Text(
            "Thank You For Shopping",
            style: TextStyle(
                color: Colors.greenAccent,
                fontSize: 25,
                fontWeight: FontWeight.w500),
          ),
          const SizedBox(
            height: 5,
          ),
          const Text(
            "Order Placed Successfully!",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              // color: Colors.greenAccent
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(width: .01),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Order Details",
                  style: TextStyleConstant.bold16Style,
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Payment Mode",
                      style: TextStyleConstant.normal14Style,
                    ),
                    Text(
                      widget.paymentMode,
                      style: TextStyleConstant.bold14Style
                          .copyWith(color: Colors.green),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Date",
                      style: TextStyleConstant.normal14Style,
                    ),
                    Text(
                      date,
                      style: TextStyleConstant.bold14Style,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Status",
                      style: TextStyleConstant.normal14Style
                          .copyWith(color: Colors.green),
                    ),
                    Text(
                      "Success",
                      style: TextStyleConstant.bold14Style
                          .copyWith(color: Colors.green),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total Amount",
                      style: TextStyleConstant.bold16Style,
                    ),
                    Text(
                      DbKeyConstant.ruppeeSign + widget.totalAmount,
                      style: TextStyleConstant.bold16Style,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            "You will be redirected to the your home page\n"
            "by clicking continue shopping",
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 30,
          ),
          CustomElevatedButton(
            buttonColor: AppConstant.appPrimaryColor,
            buttonText: "Continue Shopping",
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
