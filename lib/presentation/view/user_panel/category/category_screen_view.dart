import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../../core/constant/color_const.dart';
import '../../../../core/constant/database_key_const.dart';
import '../../../../core/constant/textstyle_const.dart';
import '../../../../data/model/product_model.dart';
import '../../../../utils/Uihelper/ui_helper.dart';
import '../../../widget/custom_image.dart';
import '../../../widget/no_product_found_widget.dart';
import '../../../widget/product_shimmer.dart';
import '../details/details_screen.dart';

class CategoryScreenView extends StatefulWidget {
  final String? categoryId;
  const CategoryScreenView({
    super.key,
    this.categoryId,
  });

  @override
  State<CategoryScreenView> createState() => _CategoryScreenViewState();
}

class _CategoryScreenViewState extends State<CategoryScreenView> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.delayed(
          const Duration(seconds: 1),
          () => widget.categoryId == null
              ? FirebaseFirestore.instance
                  .collection(DbKeyConstant.productCollection)
                  .get()
              : FirebaseFirestore.instance
                  .collection(DbKeyConstant.productCollection)
                  .where('categoryId', isEqualTo: widget.categoryId)
                  .get(),
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return categoryScreenViewShimmer();
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text("idget.documentListError Ocurred"),
            );
          }

          if (snapshot.data!.docs.isEmpty) {
            return const NoProductFoundWidget();
          }

          if (snapshot.data != null) {
            return GridView.builder(
                controller: ScrollController(),
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemCount: snapshot.data!.docs.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 3,
                  mainAxisSpacing: 3,
                  childAspectRatio: .8,
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
                      productImgList: productData[DbKeyConstant.productImgList],
                      deliveryTime: productData[DbKeyConstant.deliveryTime],
                      isSale: productData[DbKeyConstant.isSale],
                      productDescription:
                          productData[DbKeyConstant.productDescription],
                      createdAt: productData[DbKeyConstant.createdAt],
                      updatedAt: productData[DbKeyConstant.updatedAt]);

                  return Padding(
                    padding: const EdgeInsets.all(5),
                    child: GestureDetector(
                      onTap: () {
                        Get.to(() => DetailsScreen(
                              productModel: productModel,
                            ));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: ColorConstant.pinkColor),
                            color: ColorConstant.yellowColor,
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            CustomImage(
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10)),
                              image: productModel.productImgList[0],
                              height: Get.height / 7.9,
                              width: Get.width / 2.0,
                              imageFit: BoxFit.cover,
                            ),
                            const SizedBox(
                              height: 5.0,
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              width: Get.width,
                              child: Text(
                                productModel.productName,
                                style: TextStyleConstant.bold14Style,
                                textAlign: TextAlign.start,
                                maxLines: 2,
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text("Rs." + productModel.fullPrice),
                            ),
                            const SizedBox(
                              height: 5,
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                });
          }

          return Container();
        });
  }

  Widget categoryScreenViewShimmer() {
    return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 8,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 3,
          mainAxisSpacing: 3,
          childAspectRatio: .75,
        ),
        itemBuilder: (context, index) {
          return const Padding(
            padding: EdgeInsets.all(3),
            child: ProductShimmer(),
          );
        });
  }
}
