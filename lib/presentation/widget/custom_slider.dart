// ignore_for_file: must_be_immutable

import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:s_bazar/controllers/banner_contoller.dart';
import 'package:s_bazar/core/constant/color_const.dart';
import 'package:s_bazar/core/constant/image_const.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';

class CustomSlider extends StatefulWidget {
 final List<String> imgList;
 final double? imgHeight;
 final double? imgWidth;
 final double? radius;
 final double? viewportFraction;
 final bool isSliderPointVisible;
 final bool autoScroll;
 final EdgeInsetsGeometry? padding;
 final Color? selcetedDotColor;
 final Color? unselectedDotColor;

  const CustomSlider({
    super.key,
    this.autoScroll = false,
    this.selcetedDotColor,
    this.unselectedDotColor,
    this.viewportFraction,
    this.padding,
    this.isSliderPointVisible = true,
    this.radius,
    this.imgWidth,
    this.imgHeight,
    required this.imgList,
  });

  @override
  State<CustomSlider> createState() => _CustomSliderState();
}

class _CustomSliderState extends State<CustomSlider> {
  BannerController bannerController = Get.put(BannerController());

  PageController pageController =
      PageController(keepPage: false, viewportFraction: 1);
  int currentPage = 0;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    autoScroll();
  }

  void autoScroll() {
    timer?.cancel(); // pahle se koi timer ho use cancel kar dega
    if (widget.autoScroll!) {
      // timer me isiliye store karna pada jisse scroll ko cancel karne ka option ho
      timer = Timer.periodic(const Duration(seconds: 5), (timer) {
        if (currentPage < 4) {
          currentPage++;
        } else {
          pageController.jumpToPage(0);
          currentPage = 0;

          timer.cancel();
          Future.delayed(const Duration(seconds: 4), () {
            currentPage = 1;
            autoScroll();
            pageController.animateToPage(
              currentPage,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
          });
          return;
        }

        pageController.animateToPage(currentPage,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut);
      });
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(() => SizedBox(
              height: Get.height / 4,
              width: double.infinity,
              child: PageView.builder(
                controller: pageController,
                itemCount: bannerController.bannerImgList.length,
                itemBuilder: ((context, index) {
                  return Padding(
                    padding:
                        const EdgeInsets.only(left: 5.0, top: 5.0, right: 10.0),
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
                  currentPage = value;
                },
              ),
            )),
        const SizedBox(height: 5.0),
        widget.isSliderPointVisible == null || widget.isSliderPointVisible == true
            ? SizedBox(
                height: 10.0,
                child: Obx(() => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                          bannerController.bannerImgList.length, (index) {
                        return AnimatedContainer(
                          margin: const EdgeInsets.symmetric(horizontal: 1),
                          duration: const Duration(milliseconds: 200),
                          height: bannerController.pageIndex.value == index
                              ? 10
                              : 10,
                          width: bannerController.pageIndex.value == index
                              ? 10
                              : 10,
                          decoration: BoxDecoration(
                            shape: bannerController.pageIndex.value == index
                                ? BoxShape.rectangle
                                : BoxShape.circle,
                            color: bannerController.pageIndex.value == index
                                ? ColorConstant.primaryColor
                                : Colors.grey,
                          ),
                        );
                      }),
                    )))
            : const SizedBox.shrink()
      ],
    );
  }
}
