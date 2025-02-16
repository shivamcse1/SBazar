import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:s_bazar/core/constant/color_const.dart';
import 'package:s_bazar/presentation/view/user_panel/category/all_category_product_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../controllers/cart_controller.dart';
import '../../../../core/constant/app_const.dart';
import '../../../../core/constant/database_key_const.dart';
import '../../../../core/constant/textstyle_const.dart';
import '../../../../data/model/category_model.dart';
import '../../../widget/cart_icon_widget.dart';
import '../../../widget/product_shimmer.dart';

class AllCategoryScreen extends StatefulWidget {
  const AllCategoryScreen({super.key});

  @override
  State<AllCategoryScreen> createState() => AllCategoryScreenState();
}

class AllCategoryScreenState extends State<AllCategoryScreen> {
  CartController cartController = Get.put(CartController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: ColorConstant.whiteColor),
        backgroundColor: AppConstant.appPrimaryColor,
        title: Text(
          "All Category",
          style: TextStyle(color: AppConstant.whiteColor),
        ),
        actions: const [
          CartIconWidget(),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
        child: FutureBuilder(
            future: Future.delayed(
                const Duration(seconds: 2),
                () => FirebaseFirestore.instance
                    .collection(DbKeyConstant.categoryCollection)
                    .get()),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return allCategoryShimmer();
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
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 10,
                      childAspectRatio: 1,
                    ),
                    itemBuilder: (context, index) {
                      CategoryModel categoryModel = CategoryModel(
                        categoryId: snapshot.data!.docs[index]
                            [DbKeyConstant.categoryId],
                        categoryName: snapshot.data!.docs[index]
                            [DbKeyConstant.categoryName],
                        categoryImg: snapshot.data!.docs[index]
                            [DbKeyConstant.categoryImg],
                        categoryCreatedAt: snapshot.data!.docs[index]
                            [DbKeyConstant.createdAt],
                      );

                      return Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: InkWell(
                          onTap: () {
                            Get.to(AllCategoryProductScreen(
                              categoryId: categoryModel.categoryId,
                            ));
                          },
                          child: Container(
                            // padding: const EdgeInsets.all(1.0),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: ColorConstant.pinkColor),
                                color: Colors.pink,
                                borderRadius: BorderRadius.circular(10)),
                            height: Get.height / 5,
                            width: Get.width / 2.3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Image.network(
                                    categoryModel.categoryImg,
                                    height: Get.height / 6,
                                    width: Get.width / 2.0,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(
                                  height: 8.0,
                                ),
                                SizedBox(
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
                      );
                    });
              }

              return Container();
            }),
      ),
    );
  }

  Widget allCategoryShimmer() {
    return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 8,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 15,
          mainAxisSpacing: 12,
          childAspectRatio: .95,
        ),
        itemBuilder: (context, index) {
          return const ProductShimmer();
        });
  }
}
