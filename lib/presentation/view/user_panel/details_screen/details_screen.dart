// ignore_for_file: must_be_immutable, prefer_interpolation_to_compose_strings, avoid_print, avoid_unnecessary_containers

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:s_bazar/controllers/banner_contoller.dart';
import 'package:s_bazar/core/constant/app_const.dart';
import 'package:s_bazar/core/constant/database_key_const.dart';
import 'package:s_bazar/core/constant/image_const.dart';
import 'package:s_bazar/core/constant/textstyle_const.dart';
import 'package:s_bazar/data/model/cart_model.dart';
import 'package:s_bazar/data/model/product_model.dart';
import 'package:s_bazar/data/model/review_model.dart';
import 'package:s_bazar/utils/review_helper.dart';
import 'package:s_bazar/utils/share_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../../../controllers/cart_controller.dart';
import '../../../../controllers/review_controller.dart';
import '../../../../core/constant/color_const.dart';
import '../../../widget/cart_icon_widget.dart';

class DetailsScreen extends StatefulWidget {
  ProductModel? productModel;
  DetailsScreen({super.key, this.productModel});

  @override
  State<DetailsScreen> createState() => DetailsScreenState();
}

class DetailsScreenState extends State<DetailsScreen> {
  final BannerController bannerController = Get.put(BannerController());
  final ReviewController reviewController = Get.put(ReviewController());

  double h = Get.height;
  double w = Get.width;
  double avgRating = 2;
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    reviewController.calculateRating(productModel: widget.productModel);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: ColorConstant.whiteColor),
        backgroundColor: AppConstant.appPrimaryColor,
        title: Text(
          "Details Screen",
          style: TextStyle(color: AppConstant.whiteColor),
        ),
        actions: const [
          CartIconWidget(),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: h / 4,
              child: PageView.builder(
                  onPageChanged: (value) {
                    bannerController.pageIndex.value = value;
                  },
                  itemCount: widget.productModel!.productImgList.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(
                          left: 5.0, top: 5.0, right: 10.0),
                      child: ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          child: CachedNetworkImage(
                            fit: BoxFit.fill,
                            imageUrl:
                                widget.productModel!.productImgList[index],

                            // it execute until image not load
                            placeholder: (context, imgUrl) {
                              return const Center(
                                child: CupertinoActivityIndicator(),
                              );
                            },
                            errorWidget: (context, url, error) {
                              return Image.asset(ImageConstant.previewImg);
                            },
                          )),
                    );
                  }),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                  widget.productModel!.productImgList.length, (index) {
                return Obx(() => AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height:
                          bannerController.pageIndex.value == index ? 10 : 10,
                      width:
                          bannerController.pageIndex.value == index ? 12 : 10,
                      margin: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                          shape: bannerController.pageIndex.value == index
                              ? BoxShape.rectangle
                              : BoxShape.circle,
                          color: bannerController.pageIndex.value == index
                              ? ColorConstant.primaryColor
                              : ColorConstant.greyColor),
                    ));
              }),
            ),
            const SizedBox(
              height: 10,
            ),
            Card(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(
                      () => Row(
                        children: [
                          RatingBar.builder(
                              itemSize: 20,
                              allowHalfRating: true,
                              ignoreGestures: true,
                              initialRating:
                                  reviewController.totalAvgRating.value,
                              itemBuilder: (context, index) {
                                return const Icon(
                                  Icons.star,
                                  color: Colors.yellow,
                                  size: 5,
                                );
                              },
                              onRatingUpdate: (updateRating) {}),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            "${reviewController.totalAvgRating.value}",
                            style: TextStyleConstant.bold14Style
                                .copyWith(color: Colors.green),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(" ${reviewController.totalPeople.value} ratings",
                              style: TextStyleConstant.bold14Style.copyWith(
                                  color:
                                      const Color.fromARGB(255, 25, 81, 210)))
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.productModel!.productName,
                          style: TextStyleConstant.bold16Style,
                        ),
                        Icon(
                          Icons.favorite,
                          color: ColorConstant.greyColor,
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Text(
                          "Price : " +
                              DbKeyConstant.rs +
                              widget.productModel!.salePrice,
                          style: TextStyleConstant.bold16Style,
                        ),
                        SizedBox(
                            width:
                                widget.productModel!.salePrice.isEmpty ? 0 : 5),
                        Text(
                          widget.productModel!.fullPrice,
                          style: TextStyleConstant.bold14Style.copyWith(
                              decoration: widget.productModel!.salePrice.isEmpty
                                  ? TextDecoration.none
                                  : TextDecoration.lineThrough,
                              color: widget.productModel!.salePrice.isEmpty
                                  ? Colors.black
                                  : ColorConstant.secondaryColor
                                      .withOpacity(.6)),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      "Category : " + widget.productModel!.categoryName,
                      style: TextStyleConstant.bold16Style,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      "Description : " +
                          widget.productModel!.productDescription,
                      style: TextStyleConstant.bold16Style,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: ColorConstant.primaryColor,
                                minimumSize: const Size(150, 40)),
                            onPressed: () async {
                              await ShareHelper.sendTextOnWhatsapp(
                                  productModel: widget.productModel!);
                            },
                            child: Text(
                              "Whatsapp",
                              style: TextStyleConstant.bold14Style
                                  .copyWith(color: ColorConstant.whiteColor),
                            )),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: ColorConstant.primaryColor,
                                minimumSize: const Size(150, 40)),
                            onPressed: () async {
                              await checkProductExistence(uId: user!.uid);

                              Fluttertoast.showToast(
                                  msg: "Add to cart successfully");
                            },
                            child: Text("Add to cart",
                                style: TextStyleConstant.bold14Style.copyWith(
                                    color: ColorConstant.whiteColor))),
                      ],
                    ),
                    const Divider(),
                    ratingWidget()
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> checkProductExistence(
      {required uId, int quantityIncrement = 1}) async {
    CartController cartController = Get.put(CartController());

    // it is use so we can not write again again code
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection(DbKeyConstant.cartCollection)
        .doc(uId)
        .collection(DbKeyConstant.cartProductCollection)
        .doc(widget.productModel!.productId);

    DocumentSnapshot docSnapshot = await documentReference.get();

    if (docSnapshot.exists) {
      // find out quantity and price
      int currentQuantity = docSnapshot[DbKeyConstant.productQuantity];
      int updatedQuantity = currentQuantity + quantityIncrement;
      double totalPrice = double.parse(widget.productModel!.isSale
              ? widget.productModel!.salePrice
              : widget.productModel!.fullPrice) *
          updatedQuantity;

      //product exist so only update qunatity and price
      await documentReference.update({
        "productQuantity": updatedQuantity,
        "productTotalPrice": totalPrice
      });

      print("Already added");
    } else {
      // it is use for accessing subCollection
      FirebaseFirestore.instance
          .collection(DbKeyConstant.cartCollection)
          .doc(uId)
          .set({'uId': uId, 'createdAt': DateTime.now()});

      final data = widget.productModel!;
      CartModel cartmodel = CartModel(
          productId: data.productId,
          categoryId: data.categoryId,
          productName: data.productName,
          categoryName: data.categoryName,
          salePrice: data.salePrice,
          fullPrice: data.fullPrice,
          productImgList: data.productImgList,
          deliveryTime: data.deliveryTime,
          isSale: data.isSale,
          productDescription: data.productDescription,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          productQuantity: quantityIncrement,
          productTotalPrice: double.parse(data.fullPrice));

      await documentReference.set(cartmodel.toMap());
      print("first time added");
    }

    // for total cart product quantity calc
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(DbKeyConstant.cartCollection)
        .doc(uId)
        .collection(DbKeyConstant.cartProductCollection)
        .get();

    cartController.totalCartItem.value = querySnapshot.docs.length;
  }

  Widget ratingWidget() {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  "Ratings & Reviews",
                  style: TextStyleConstant.bold18Style,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.center,
                child: Obx(
                  () => Text(
                    ReviewHelper.getReviewCategory(
                        reviewController.totalAvgRating.value),
                    style: TextStyleConstant.bold16Style,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Obx(
                  () => RatingBar.builder(
                      itemSize: 35,
                      itemCount: 5,
                      allowHalfRating: true,
                      initialRating: reviewController.totalAvgRating.value,
                      ignoreGestures: true,
                      itemBuilder: (context, index) {
                        return const Icon(
                          Icons.star,
                          color: Colors.yellow,
                          size: 5,
                        );
                      },
                      onRatingUpdate: (updateRating) {}),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Obx(
                    () => Text(
                      "${reviewController.totalPeople.value} ratings & reviews",
                      style: TextStyleConstant.normal14Style
                          .copyWith(color: Colors.grey),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const Divider(
          thickness: .5,
        ),
        FutureBuilder(
            future: FirebaseFirestore.instance
                .collection(DbKeyConstant.productCollection)
                .doc(widget.productModel!.productId)
                .collection(DbKeyConstant.reviewCollection)
                .get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SizedBox(
                  height: Get.height / 5,
                  child: const Center(
                    child: CupertinoActivityIndicator(),
                  ),
                );
              }

              if (snapshot.hasError) {
                return const Center(
                  child: Text("Error Ocurred"),
                );
              }

              if (snapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text("No Rating found"),
                );
              }

              // if (snapshot.data != null) {
              //   return GridView.builder(
              //       shrinkWrap: true,
              //       physics: const BouncingScrollPhysics(),
              //       itemCount: snapshot.data!.docs.length,
              //       gridDelegate:
              //           const SliverGridDelegateWithFixedCrossAxisCount(
              //         crossAxisCount: 2,
              //         crossAxisSpacing: 15,
              //         mainAxisSpacing: 10,
              //         childAspectRatio: 1,
              //       ),
              //       itemBuilder: (context, index) {
              //         var docData = snapshot.data!.docs[index];
              //         // ReviewModel reviewModel = ReviewModel(
              //         //     userName: docData[DbKeyConstant.userName],
              //         //     userPhone: docData[DbKeyConstant.userPhone],
              //         //     createdAt: docData[DbKeyConstant.createdAt],
              //         //     userRating: docData[DbKeyConstant.userRating],
              //         //     userReview: docData[DbKeyConstant.userReview],
              //         //     userUid: docData[DbKeyConstant.userUid],
              //         //     userDeviceToken:
              //         //         docData[DbKeyConstant.userDeviceToken]);

              //         return Padding(
              //           padding: const EdgeInsets.only(top: 5.0),
              //           child: InkWell(
              //             onTap: () {},
              //             child: Container(
              //               // padding: const EdgeInsets.all(1.0),
              //               decoration: BoxDecoration(
              //                   border:
              //                       Border.all(color: ColorConstant.pinkColor),
              //                   color: Colors.pink,
              //                   borderRadius: BorderRadius.circular(10)),
              //               height: Get.height / 5,
              //               width: Get.width / 2.3,
              //               child: Column(
              //                 mainAxisAlignment: MainAxisAlignment.start,
              //                 children: [
              //                   // ClipRRect(
              //                   //   borderRadius: BorderRadius.circular(10.0),
              //                   //   child: Image.network(categoryModel.categoryImg,
              //                   //   height: Get.height/6,
              //                   //   width: Get.width/2.0,
              //                   //   fit: BoxFit.cover,
              //                   //   ),
              //                   // ),

              //                   const SizedBox(
              //                     height: 8.0,
              //                   ),
              //                   SizedBox(
              //                       width: Get.width,
              //                       child: Text(
              //                         'RAM',
              //                         style: TextStyleConstant.bold14Style
              //                             .copyWith(
              //                                 color: ColorConstant.whiteColor),
              //                         textAlign: TextAlign.center,
              //                       ))
              //                 ],
              //               ),
              //             ),
              //           ),
              //         );
              //       });
              // }

              if (snapshot.data != null) {
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    var data = snapshot.data!.docs[index];
                    return Container(
                      // height: 50,
                      padding: const EdgeInsets.only(top: 5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              RatingBar.builder(
                                  itemSize: 25,
                                  allowHalfRating: true,
                                  ignoreGestures: true,
                                  initialRating: double.parse(
                                      data[DbKeyConstant.userRating]),
                                  itemBuilder: (context, index) {
                                    return const Icon(
                                      Icons.star,
                                      color: Colors.yellow,
                                      size: 5,
                                    );
                                  },
                                  onRatingUpdate: (updateRating) {}),
                              Padding(
                                padding: const EdgeInsets.only(top: 2),
                                child: Text(
                                  data[DbKeyConstant.userRating],
                                  style: TextStyleConstant.bold18Style
                                      .copyWith(color: Colors.green),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                ReviewHelper.getReviewCategory(double.parse(
                                    data[DbKeyConstant.userRating])),
                                style: TextStyleConstant.bold16Style,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            data[DbKeyConstant.userReview],
                            maxLines: 10,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: [
                              Text(
                                data[DbKeyConstant.userName],
                                style: TextStyleConstant.bold14Style,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              const Text("Aug 2022"),
                            ],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          const Divider(
                            thickness: .5,
                          ),
                        ],
                      ),
                    );
                  },
                );
              }
              return Container();
            }),
      ],
    );
  }
}
