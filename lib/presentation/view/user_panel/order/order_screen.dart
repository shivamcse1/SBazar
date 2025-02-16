// ignore_for_file: prefer_interpolation_to_compose_strings, avoid_print
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:s_bazar/controllers/cart_controller.dart';
import 'package:s_bazar/core/constant/database_key_const.dart';
import 'package:s_bazar/core/constant/textstyle_const.dart';
import 'package:s_bazar/presentation/view/user_panel/review/review_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:s_bazar/presentation/widget/custom_shimmer_container.dart';

import '../../../../core/constant/app_const.dart';
import '../../../../core/constant/color_const.dart';
import '../../../../core/constant/image_const.dart';
import '../../../../data/model/order_model.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  double h = Get.height;
  double w = Get.width;
  double rating = 0;
  final CartController cartController = Get.put(CartController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: ColorConstant.whiteColor),
          backgroundColor: AppConstant.appPrimaryColor,
          title: Text(
            "Order",
            style: TextStyle(color: AppConstant.whiteColor),
          ),
        ),
        body: Container(
          color: Colors.blue.withOpacity(.1),
          child: Column(children: [
            const SizedBox(
              height: 5.0,
            ),
            Expanded(
              child: FutureBuilder(
                  future: Future.delayed(
                    const Duration(seconds: 2),
                    () => FirebaseFirestore.instance
                        .collection(DbKeyConstant.orderCollection)
                        .doc(user!.uid)
                        .collection(DbKeyConstant.confirmedOrderCollection)
                        .get(),
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return orderShimmer();
                    }

                    if (snapshot.hasError) {
                      EasyLoading.dismiss();
                      return const Center(child: Text("Something went wrong"));
                    }

                    if (snapshot.hasData) {
                      EasyLoading.dismiss();

                      if (snapshot.data!.docs.isNotEmpty) {
                        return ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              final docData = snapshot.data!.docs[index];
                              OrderModel orderModel = OrderModel(
                                productId: docData[DbKeyConstant.productId],
                                categoryId: docData[DbKeyConstant.categoryId],
                                productName: docData[DbKeyConstant.productName],
                                categoryName:
                                    docData[DbKeyConstant.categoryName],
                                salePrice: docData[DbKeyConstant.salePrice],
                                fullPrice: docData[DbKeyConstant.fullPrice],
                                productImgList:
                                    docData[DbKeyConstant.productImgList],
                                deliveryTime:
                                    docData[DbKeyConstant.deliveryTime],
                                isSale: docData[DbKeyConstant.isSale],
                                productDescription:
                                    docData[DbKeyConstant.productDescription],
                                createdAt: docData[DbKeyConstant.createdAt],
                                updatedAt: docData[DbKeyConstant.updatedAt],
                                productQuantity:
                                    docData[DbKeyConstant.productQuantity],
                                productTotalPrice:
                                    docData[DbKeyConstant.productTotalPrice],
                                userName: docData[DbKeyConstant.userName],
                                userPhone: docData[DbKeyConstant.userPhone],
                                userUid: docData[DbKeyConstant.userUid],
                                userAddress: docData[DbKeyConstant.userAddress],
                                userDeviceToken:
                                    docData[DbKeyConstant.userDeviceToken],
                                orderStatus: docData[DbKeyConstant.orderStatus],
                              );

                              return Container(
                                margin: const EdgeInsets.symmetric(
                                    vertical: 3.0, horizontal: 8.0),
                                // height: 120,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                    color: ColorConstant.whiteColor,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      child: Text("ODI1234567890",
                                          style: TextStyleConstant.normal12Style
                                              .copyWith(
                                                  fontSize: 10,
                                                  color: Colors.grey)),
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                                imageUrl: orderModel
                                                    .productImgList[0],

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
                                                orderModel.productName,
                                                style: TextStyleConstant
                                                    .normal14Style,
                                              ),
                                              Text(
                                                DbKeyConstant.rs +
                                                    orderModel.fullPrice,
                                                style: TextStyleConstant
                                                    .normal14Style,
                                              ),
                                              Text(
                                                "Qty :${orderModel.productQuantity} ",
                                                style: TextStyleConstant
                                                    .normal14Style,
                                              ),
                                              const SizedBox(
                                                height: 5.0,
                                              ),
                                              orderModel.orderStatus
                                                  ? Text(
                                                      "Delivered",
                                                      style: TextStyleConstant
                                                          .normal14Style
                                                          .copyWith(
                                                              color: ColorConstant
                                                                  .primaryColor),
                                                    )
                                                  : Text(
                                                      "Pending",
                                                      style: TextStyleConstant
                                                          .normal14Style
                                                          .copyWith(
                                                              color:
                                                                  Colors.green),
                                                    ),
                                            ],
                                          ),
                                        ),
                                        orderModel.orderStatus == true
                                            ? InkWell(
                                                splashColor:
                                                    Colors.amberAccent.shade100,
                                                onTap: () {
                                                  Get.to(() => ReviewScreen(
                                                        orderModel: orderModel,
                                                      ));
                                                },
                                                child: Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      vertical: 5.0,
                                                      horizontal: 10),
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey.shade200,
                                                    shape: BoxShape.rectangle,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  child: const Text("Review"),
                                                ),
                                              )
                                            : const SizedBox()
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
                              );
                            });
                      } else {
                        EasyLoading.dismiss();

                        return const Center(child: Text("No data Found"));
                      }
                    } else {
                      EasyLoading.dismiss();

                      return const Center(child: Text("No data Found"));
                    }
                  }),
            ),
          ]),
        ));
  }

  Widget orderShimmer() {
    return ListView.builder(
        itemCount: 8,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return const Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                CustomShimmerContainer(
                  height: 8,
                  width: 80,
                  radius: 12,
                ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomShimmerContainer(
                      height: 90,
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
                    )
                  ],
                )
              ],
            ),
          );
        });
  }


}
