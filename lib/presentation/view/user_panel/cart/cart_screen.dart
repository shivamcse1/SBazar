// ignore_for_file: prefer_interpolation_to_compose_strings, avoid_print
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:s_bazar/controllers/cart_controller.dart';
import 'package:s_bazar/controllers/permission_handler_controller.dart';
import 'package:s_bazar/core/constant/database_key_const.dart';
import 'package:s_bazar/core/constant/image_const.dart';
import 'package:s_bazar/core/constant/textstyle_const.dart';
import 'package:s_bazar/data/model/cart_model.dart';
import 'package:s_bazar/presentation/view/user_panel/checkout/checkout_screen.dart';
import 'package:s_bazar/presentation/widget/custom_qunatity_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:s_bazar/presentation/widget/no_product_found_widget.dart';

import '../../../../core/constant/app_const.dart';
import '../../../../core/constant/color_const.dart';
import '../../../widget/custom_shimmer_container.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  double h = Get.height;
  double w = Get.width;
  final CartController cartController = Get.put(CartController());
  final PermissionHandlerController permissionController =
      Get.put(PermissionHandlerController());

  @override
  void initState() {
    cartController.calculateTotalProductPrice(user: user);
    permissionController.cameraPermissionHandler();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: ColorConstant.whiteColor),
          backgroundColor: AppConstant.appPrimaryColor,
          title: Text(
            "Cart",
            style: TextStyle(color: AppConstant.whiteColor),
          ),
        ),
        body: Container(
          color: Colors.blue.withOpacity(.2),
          child: Column(children: [
            const SizedBox(
              height: 5.0,
            ),
            Expanded(
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection(DbKeyConstant.cartCollection)
                      .doc(user!.uid)
                      .collection(DbKeyConstant.cartProductCollection)
                      .snapshots()
                      .asyncMap((event) async {
                    await Future.delayed(const Duration(milliseconds: 500));
                    return event;
                  }),
                  builder: (context, snapshot) {
                    cartController.calculateTotalProductPrice(user: user);

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return cartShimmer();
                    }

                    if (snapshot.hasError) {
                      EasyLoading.dismiss();
                      return const Center(child: Text("Something went wrong"));
                    }

                    if (snapshot.hasData) {
                      EasyLoading.dismiss();

                      if (snapshot.data!.docs.isNotEmpty) {
                        final docData = snapshot.data!.docs;

                        print(docData.length);
                        return ListView.builder(
                            itemCount: docData.length,
                            itemBuilder: (context, index) {
                              CartModel cartModel = CartModel(
                                  productId: docData[index]
                                      [DbKeyConstant.productId],
                                  categoryId: docData[index]
                                      [DbKeyConstant.categoryId],
                                  productName: docData[index]
                                      [DbKeyConstant.productName],
                                  categoryName: docData[index]
                                      [DbKeyConstant.categoryName],
                                  salePrice: docData[index]
                                      [DbKeyConstant.salePrice],
                                  fullPrice: docData[index]
                                      [DbKeyConstant.fullPrice],
                                  productImgList: docData[index]
                                      [DbKeyConstant.productImgList],
                                  deliveryTime: docData[index]
                                      [DbKeyConstant.deliveryTime],
                                  isSale: docData[index][DbKeyConstant.isSale],
                                  productDescription: docData[index]
                                      [DbKeyConstant.productDescription],
                                  createdAt: docData[index]
                                      [DbKeyConstant.createdAt],
                                  updatedAt: docData[index]
                                      [DbKeyConstant.updatedAt],
                                  productQuantity: docData[index]
                                      [DbKeyConstant.productQuantity],
                                  productTotalPrice: docData[index]
                                      [DbKeyConstant.productTotalPrice]);

                              return Slidable(
                                  startActionPane: ActionPane(
                                      extentRatio: .48,
                                      motion: const StretchMotion(),
                                      children: [
                                        SlidableAction(
                                          onPressed: (context) {},
                                          icon: Icons.share,
                                          backgroundColor: Colors.lightBlue,
                                          foregroundColor:
                                              ColorConstant.whiteColor,
                                          label: "Share",
                                        ),
                                        SlidableAction(
                                          onPressed: (context) async {
                                            await cartController
                                                .deleteCartProduct(
                                                    cartModel: cartModel,
                                                    user: user);
                                          },
                                          icon: Icons.delete,
                                          backgroundColor:
                                              ColorConstant.primaryColor,
                                          foregroundColor:
                                              ColorConstant.whiteColor,
                                          label: "Delete",
                                        ),
                                      ]),
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 3.0, horizontal: 8.0),
                                    height: 100,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    decoration: BoxDecoration(
                                        color: ColorConstant.whiteColor,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                            height: h / 10,
                                            width: w / 5,
                                            padding: const EdgeInsets.all(1),
                                            decoration: BoxDecoration(
                                                color: ColorConstant.greyColor
                                                    .withOpacity(.3),
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: CachedNetworkImage(
                                                fit: BoxFit.fill,
                                                imageUrl:
                                                    cartModel.productImgList[0],

                                                // it execute until image not load
                                                placeholder: (context, imgUrl) {
                                                  return const Center(
                                                    child:
                                                        CupertinoActivityIndicator(),
                                                  );
                                                },

                                                // it execute when any error occured loaidng in image
                                                errorWidget:
                                                    (context, url, error) {
                                                  return Image.asset(
                                                      ImageConstant.previewImg);
                                                },
                                              ),
                                            )),
                                        const SizedBox(
                                          width: 15,
                                        ),
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                cartModel.productName,
                                                style: TextStyleConstant
                                                    .bold14Style,
                                              ),
                                              Text(
                                                DbKeyConstant.rs +
                                                    cartModel.productTotalPrice
                                                        .toString(),
                                                style: TextStyleConstant
                                                    .bold14Style,
                                              ),
                                              Text(
                                                "Qty : " +
                                                    cartModel.productQuantity
                                                        .toString(),
                                                style: TextStyleConstant
                                                    .bold14Style,
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        CustomQuantityButton(
                                          value: cartModel.productQuantity,
                                          plusOntap: () async {
                                            await cartController
                                                .incrementCartProductQuantity(
                                                    cartModel: cartModel,
                                                    user: user);
                                          },
                                          minusOntap: () async {
                                            await cartController
                                                .decrementCartProductQuantity(
                                                    cartModel: cartModel,
                                                    user: user);
                                          },
                                        )
                                      ],
                                    ),
                                  ));
                            });
                      } else {
                        EasyLoading.dismiss();

                        return const Center(child: NoProductFoundWidget());
                      }
                    } else {
                      EasyLoading.dismiss();

                      return const Center(child: Text("No data Found"));
                    }
                  }),
            ),
            Obx(
              () => Container(
                height: cartController.totalProductPrice.value == 0.0 ? 0 : 60,
                color: Colors.blue.shade100,
                child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: cartController.totalProductPrice.value != 0.0
                        ? Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Total amount",
                                      style: TextStyleConstant.bold14Style,
                                    ),
                                    Text(
                                      DbKeyConstant.rs +
                                          "${cartController.totalProductPrice}",
                                      style: TextStyleConstant.bold14Style,
                                    ),
                                  ],
                                ),
                              ),
                              const Spacer(),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          ColorConstant.primaryColor,
                                      fixedSize: Size(w / 2, h / 18),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15))),
                                  onPressed: () {
                                    Get.to(() => const CheckOutScreen());
                                  },
                                  child: Text(
                                    "Checkout",
                                    style: TextStyleConstant.bold16Style
                                        .copyWith(
                                            color: ColorConstant.whiteColor),
                                  ))
                            ],
                          )
                        : cartController.totalProductPrice.value == 0.0
                            ? const SizedBox.shrink()
                            : bottomButtonShimmer()),
              ),
            ),
          ]),
        ));
  }

  Widget cartShimmer() {
    return ListView.builder(
        itemCount: 8,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return const Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomShimmerContainer(
                  height: 80,
                  width: 90,
                  radius: 12,
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CustomShimmerContainer(
                        height: 10,
                        width: 200,
                        radius: 12,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      CustomShimmerContainer(
                        height: 10,
                        width: 130,
                        radius: 12,
                      ),
                      SizedBox(height: 10),
                      CustomShimmerContainer(
                        height: 10,
                        width: 80,
                        radius: 12,
                      ),
                      SizedBox(height: 10),
                      CustomShimmerContainer(
                        height: 10,
                        width: 100,
                        radius: 12,
                      ),
                    ],
                  ),
                ),
                CustomShimmerContainer(
                  height: 30,
                  width: 70,
                ),
              ],
            ),
          );
        });
  }

  Widget bottomButtonShimmer() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
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
              width: 80,
            ),
          ],
        ),
        CustomShimmerContainer(
          height: 40,
          width: 150,
          radius: 15,
        ),
      ],
    );
  }
}
