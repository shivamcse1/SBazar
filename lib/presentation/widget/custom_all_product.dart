// ignore_for_file: sized_box_for_whitespace, prefer_interpolation_to_compose_strings

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:s_bazar/core/constant/color_const.dart';
import 'package:s_bazar/core/constant/database_key_const.dart';
import 'package:s_bazar/core/constant/textstyle_const.dart';
import 'package:s_bazar/data/model/product_model.dart';
import 'package:s_bazar/presentation/view/user_panel/details/details_screen.dart';
import 'package:flutter/cupertino.dart';

import 'package:get/get.dart';
import 'package:s_bazar/presentation/widget/product_shimmer.dart';

class CustomAllProduct extends StatelessWidget {
  const CustomAllProduct({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: FutureBuilder(
          future: Future.delayed(
              const Duration(seconds: 2),
              () => FirebaseFirestore.instance
                  .collection(DbKeyConstant.productCollection)
                  .where('isSale', isEqualTo: false)
                  .get()),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return allProductShimmer();
            }

            if (snapshot.hasError) {
              return const Center(
                child: Text("Error Ocurred"),
              );
            }

            if (snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text("No category found"),
              );
            }

            if (snapshot.data != null) {
              return GridView.builder(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: snapshot.data!.docs.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (context, index) {
                    final productData = snapshot.data!.docs[index];
                    ProductModel productModel = ProductModel(
                        productId: productData[DbKeyConstant.productId],
                        categoryId: productData[DbKeyConstant.categoryId],
                        productName: productData[DbKeyConstant.productName],
                        categoryName: productData[DbKeyConstant.categoryName],
                        salePrice: productData[DbKeyConstant.salePrice],
                        fullPrice: productData[DbKeyConstant.fullPrice],
                        productImgList:
                            productData[DbKeyConstant.productImgList],
                        deliveryTime: productData[DbKeyConstant.deliveryTime],
                        isSale: productData[DbKeyConstant.isSale],
                        productDescription:
                            productData[DbKeyConstant.productDescription],
                        createdAt: productData[DbKeyConstant.createdAt],
                        updatedAt: productData[DbKeyConstant.updatedAt]);

                    return Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: GestureDetector(
                        onTap: () {
                          Get.to(() => DetailsScreen(
                                productModel: productModel,
                              ));
                        },
                        child: Container(
                          height: Get.height / 5,
                          width: Get.width / 2.3,
                          padding: const EdgeInsets.all(1.0),
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: ColorConstant.pinkColor),
                              color: ColorConstant.yellowColor,
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: CachedNetworkImage(
                                    height: Get.height / 6.4,
                                    width: Get.width / 2.0,
                                    fit: BoxFit.cover,
                                    imageUrl: productModel.productImgList[0],
                                  )),
                              const SizedBox(
                                height: 2.0,
                              ),
                              SizedBox(
                                  width: Get.width,
                                  child: Text(
                                    productModel.productName,
                                    style: TextStyleConstant.bold14Style,
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                  )),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text("Rs." + productModel.fullPrice),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  });
            }

            return Container();
          }),
    );
  }

  Widget allProductShimmer() {
    return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 5,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 15,
          mainAxisSpacing: 10,
          childAspectRatio: .9,
        ),
        itemBuilder: (context, index) {
          return const ProductShimmer();
        });
  }
}
