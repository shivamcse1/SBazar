// ignore_for_file: sized_box_for_whitespace, prefer_interpolation_to_compose_strings

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:s_bazar/core/constant/color_const.dart';
import 'package:s_bazar/core/constant/database_key_const.dart';
import 'package:s_bazar/core/constant/textstyle_const.dart';
import 'package:s_bazar/data/model/product_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../view/user_panel/details/details_screen.dart';
import 'product_shimmer.dart';

class CustomFlashSale extends StatelessWidget {
  final List<Map<String, dynamic>> flashSaleProductList;
  const CustomFlashSale({
    super.key,
    required this.flashSaleProductList,
  });

  @override
  Widget build(BuildContext context) {
    return flashSaleProductList.isNotEmpty
        ? Container(
            margin: const EdgeInsets.symmetric(vertical: 10.0),
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            alignment: Alignment.centerLeft,
            height: Get.height / 6,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: flashSaleProductList.length,
                itemBuilder: (context, index) {
                  final productData = flashSaleProductList[index];
                  ProductModel productModel = ProductModel(
                      productId: productData[DbKeyConstant.productId],
                      categoryId: productData[DbKeyConstant.categoryId],
                      productName: productData[DbKeyConstant.productName],
                      categoryName: productData[DbKeyConstant.categoryName],
                      salePrice: productData[DbKeyConstant.salePrice],
                      fullPrice: productData[DbKeyConstant.fullPrice],
                      productImgList: productData[DbKeyConstant.productImgList],
                      deliveryTime: productData[DbKeyConstant.deliveryTime],
                      isSale: productData[DbKeyConstant.isSale],
                      productDescription:
                          productData[DbKeyConstant.productDescription],
                      createdAt: productData[DbKeyConstant.createdAt],
                      updatedAt: productData[DbKeyConstant.updatedAt]);

                  return Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.to(() => DetailsScreen(
                                productModel: productModel,
                              ));
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 10.0),
                          padding: const EdgeInsets.all(1.0),
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: ColorConstant.pinkColor),
                              color: ColorConstant.yellowColor,
                              borderRadius: BorderRadius.circular(10)),
                          width: Get.width / 4,
                          height: Get.height / 6,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: CachedNetworkImage(
                                    height: Get.height / 9.2,
                                    width: Get.width / 4.0,
                                    fit: BoxFit.cover,
                                    imageUrl: productModel.productImgList[0],
                                  )),
                              const SizedBox(
                                height: 2.0,
                              ),
                              Container(
                                  width: Get.width,
                                  child: Text(
                                    productModel.productName,
                                    style: TextStyleConstant.bold14Style,
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                  )),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text("Rs." + productModel.salePrice),
                                  Text(
                                    productModel.fullPrice,
                                    style: TextStyle(
                                        color: ColorConstant.secondaryColor
                                            .withOpacity(.7),
                                        decoration: TextDecoration.lineThrough),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                }),
          )
        : flashSaleItemShimmer();
  }
}

Widget flashSaleItemShimmer() {
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
