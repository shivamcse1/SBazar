import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:s_bazar/controllers/wishlist_controller.dart';
import 'package:s_bazar/presentation/widget/custom_app_bar.dart';
import '../../../../core/constant/app_const.dart';
import '../../../../core/constant/color_const.dart';
import '../../../../core/constant/database_key_const.dart';
import '../../../../core/constant/textstyle_const.dart';
import '../../../../data/model/product_model.dart';
import '../../../widget/product_shimmer.dart';
import '../details/details_screen.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  WishlistController wishlistController = Get.put(WishlistController());

  @override
  void initState() {
    wishlistController.fetchWishlistProduct();
    super.initState();
  }

  @override
  void dispose() {
    WishlistController().dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        isBackBtnVisible: true,
        backIconColor: Colors.white,
        title: "Wishlist",
        titleStyle: TextStyle(color: ColorConstant.whiteColor),
        appBarColor: AppConstant.appPrimaryColor,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await wishlistController.fetchWishlistProduct();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Obx(() => wishlistController.productWishList.isNotEmpty
                  ? GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: wishlistController.productWishList.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 15,
                        mainAxisSpacing: 10,
                        childAspectRatio: 1,
                      ),
                      itemBuilder: (context, index) {
                        final productData =
                            wishlistController.productWishList[index];
                        ProductModel productModel = ProductModel(
                            productId: productData[DbKeyConstant.productId],
                            categoryId: productData[DbKeyConstant.categoryId],
                            productName: productData[DbKeyConstant.productName],
                            categoryName:
                                productData[DbKeyConstant.categoryName],
                            salePrice: productData[DbKeyConstant.salePrice],
                            fullPrice: productData[DbKeyConstant.fullPrice],
                            productImgList:
                                productData[DbKeyConstant.productImgList],
                            deliveryTime:
                                productData[DbKeyConstant.deliveryTime],
                            isSale: productData[DbKeyConstant.isSale],
                            isWishlist: productData[DbKeyConstant.isWishlist],
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
                                  border: Border.all(
                                      color: ColorConstant.pinkColor),
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
                                        imageUrl:
                                            productModel.productImgList[0],
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
                      },
                    )
                  : wishlistProductShimmer()),
            ),
          ),
        ),
      ),
    );
  }

  Widget wishlistProductShimmer() {
    return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 8,
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
