// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, unnecessary_brace_in_string_interps

import 'package:get/get.dart';
import 'package:s_bazar/controllers/home_controller.dart';
import 'package:s_bazar/core/constant/color_const.dart';
import 'package:s_bazar/core/constant/textstyle_const.dart';
import 'package:flutter/material.dart';
import 'custom_shimmer_container.dart';

class CustomHeading extends StatelessWidget {
  final String categoryTitle;
  final String categorySubTitle;
  final String buttonText;
  final VoidCallback? onTap;

  const CustomHeading({
    super.key,
    required this.categoryTitle,
    required this.categorySubTitle,
    this.buttonText = 'See More',
    this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.put(HomeController());
    return Obx(() => homeController.bannerImgList.isNotEmpty
        ? Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      categoryTitle,
                      style: TextStyleConstant.bold18Style.copyWith(
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      categorySubTitle,
                      style: TextStyleConstant.bold14Style.copyWith(
                        color: Colors.grey.shade500,
                      ),
                    )
                  ],
                ),
                InkWell(
                  borderRadius: BorderRadius.circular(20),
                  splashColor: Colors.red.withOpacity(0.5),
                  onTap: onTap,
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: ColorConstant.secondaryColor, width: 1.5),
                        borderRadius: BorderRadius.circular(20)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "${buttonText} >",
                        style: TextStyleConstant.bold14Style
                            .copyWith(color: ColorConstant.secondaryColor),
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        : headingShimmer());
  }

  Widget headingShimmer() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomShimmerContainer(
                height: 15,
                width: 100,
              ),
              SizedBox(
                height: 10,
              ),
              CustomShimmerContainer(
                height: 15,
                width: 150,
              ),
            ],
          ),
          CustomShimmerContainer(
            height: 35,
            width: 80,
            radius: 30,
          ),
        ],
      ),
    );
  }
}
