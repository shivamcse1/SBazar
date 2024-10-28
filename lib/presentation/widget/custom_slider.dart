// ignore_for_file: must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce/controllers/banner_contoller.dart';
import 'package:e_commerce/core/constant/color_const.dart';
import 'package:e_commerce/core/constant/image_const.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';

class CustomSlider extends StatelessWidget {
  CustomSlider({super.key});

  BannerController bannerController = Get.put(BannerController());
  // PageController pageController = PageController(viewportFraction: 0.8);
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(() => SizedBox(
          height: Get.height/4,
          child: PageView.builder(
            // controller: pageController,
            itemCount: bannerController.bannerImgList.length,
            itemBuilder: ((context, index) {

                
              return Padding(
                padding: const EdgeInsets.only(left: 5.0,top: 5.0,right: 10.0),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  child: CachedNetworkImage(
                    imageUrl: bannerController.bannerImgList[index],
                    fit: BoxFit.cover,
                  
                    // Placeholder while the image is loading
                    placeholder: (context, imgUrl) {
                      return Container(
                        color: Colors.white,
                        child: const Center(
                          child: CupertinoActivityIndicator(),
                        ),
                      );
                    },
                  
                    errorWidget: (context, url, error) {
                      return Image.asset(ImageConstant.previewImg);
                    },
                  ),
                ),
              );
            }),
            onPageChanged: (value) {
              bannerController.pageIndex.value = value;
            },
          ),
        )),
        const SizedBox(height: 5.0),

        SizedBox(
          height: 10.0,
          child: Obx(() => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(bannerController.bannerImgList.length, (index) {
              return AnimatedContainer(
                margin: const EdgeInsets.symmetric(horizontal: 1),
                duration: const Duration(milliseconds: 200),
                height: bannerController.pageIndex.value == index ? 10 : 10,
                width: bannerController.pageIndex.value == index ? 10 : 10,
                decoration: BoxDecoration(
                  shape: bannerController.pageIndex.value == index ? BoxShape.rectangle : BoxShape.circle,
                  color: bannerController.pageIndex.value == index ? ColorConstant.primaryColor : Colors.grey,
                ),
              );
            }),
          )),
        ),
      ],
    );
  }
}
