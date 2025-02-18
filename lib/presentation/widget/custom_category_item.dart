// ignore_for_file: sized_box_for_whitespace

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:s_bazar/core/constant/color_const.dart';
import 'package:s_bazar/core/constant/database_key_const.dart';
import 'package:s_bazar/core/constant/textstyle_const.dart';
import 'package:s_bazar/data/model/category_model.dart';
import 'package:s_bazar/presentation/view/user_panel/category/all_category_product_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'product_shimmer.dart';

class CustomCategoryItem extends StatelessWidget {
  final List<Map<String, dynamic>> categoryList;
  const CustomCategoryItem({super.key, required this.categoryList});

  @override
  Widget build(BuildContext context) {
    return categoryList.isNotEmpty
        ? Container(
            margin: const EdgeInsets.symmetric(vertical: 10.0),
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            alignment: Alignment.centerLeft,
            height: Get.height / 6,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: categoryList.length,
                itemBuilder: (context, index) {
                  CategoryModel categoryModel = CategoryModel(
                    categoryId: categoryList[index][DbKeyConstant.categoryId],
                    categoryName: categoryList[index]
                        [DbKeyConstant.categoryName],
                    categoryImg: categoryList[index][DbKeyConstant.categoryImg],
                    categoryCreatedAt: categoryList[index]
                        [DbKeyConstant.createdAt],
                  );
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: () {
                          Get.to(AllCategoryProductScreen(
                              categoryId: categoryModel.categoryId));
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 10.0),
                          padding: const EdgeInsets.all(1.0),
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: ColorConstant.pinkColor),
                              color: Colors.pink,
                              borderRadius: BorderRadius.circular(10)),
                          height: Get.height / 5,
                          width: Get.width / 4,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: Image.network(
                                  categoryModel.categoryImg,
                                  height: Get.height / 8.0,
                                  width: Get.width / 4.1,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(
                                height: 2.0,
                              ),
                              Container(
                                  width: Get.width,
                                  child: Text(
                                    categoryModel.categoryName,
                                    style: TextStyleConstant.bold14Style
                                        .copyWith(
                                            color: ColorConstant.whiteColor),
                                    textAlign: TextAlign.center,
                                  ))
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                }),
          )
        : categoryItemShimmer();
  }

  Widget categoryItemShimmer() {
    return SizedBox(
      height: 160,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: 5,
          itemBuilder: (context, index) {
            return const Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.0),
              child: ProductShimmer(
                height: 160,
                width: 120,
              ),
            );
          }),
    );
  }
}
