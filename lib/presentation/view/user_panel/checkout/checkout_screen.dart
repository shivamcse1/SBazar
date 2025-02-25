// ignore_for_file: prefer_interpolation_to_compose_strings, avoid_print, prefer_typing_uninitialized_variables
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:s_bazar/controllers/address_controller.dart';
import 'package:s_bazar/controllers/auth_controller.dart';
import 'package:s_bazar/controllers/cart_controller.dart';
import 'package:s_bazar/controllers/order_controller.dart';
import 'package:s_bazar/controllers/payment_controller.dart';
import 'package:s_bazar/core/constant/database_key_const.dart';
import 'package:s_bazar/core/constant/image_const.dart';
import 'package:s_bazar/core/constant/textstyle_const.dart';
import 'package:s_bazar/data/model/cart_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:s_bazar/presentation/view/user_panel/address/address_screen.dart';
import 'package:s_bazar/presentation/view/user_panel/order/order_success_screen.dart';
import 'package:s_bazar/utils/Uihelper/ui_helper.dart';

import '../../../../core/constant/app_const.dart';
import '../../../../core/constant/color_const.dart';
import '../../../../data/model/product_model.dart';
import '../address/add_new_address_screen.dart';

class CheckOutScreen extends StatefulWidget {
  final ProductModel? productModel;
  const CheckOutScreen({super.key, this.productModel});

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  double h = Get.height;
  double w = Get.width;
  String paymentType = '';
  int taxesPercent = 2;
  dynamic userData;
  String fullAddress = "";
  double deliveryCharge = 40.0;
  final CartController cartController = Get.put(CartController());
  final AddressController addressController = Get.put(AddressController());
  final PaymentController paymentController = Get.put(PaymentController());
  final OrderController orderController = Get.put(OrderController());

  @override
  void initState() {
    super.initState();

    cartController.totalAmount.value = widget.productModel != null
        ? widget.productModel!.isSale == true
            ? ((double.parse(widget.productModel!.salePrice) * taxesPercent) /
                    100) +
                deliveryCharge +
                double.parse(widget.productModel!.salePrice)
            : ((double.parse(widget.productModel!.fullPrice) * taxesPercent) /
                    100) +
                deliveryCharge +
                double.parse(widget.productModel!.fullPrice)
        : ((cartController.totalProductPrice.value * taxesPercent) / 100) +
            deliveryCharge +
            cartController.totalProductPrice.value;

    addressController.fetchUserAddresses(
        addressId: addressController.groupValue.isEmpty
            ? null
            : addressController.groupValue);
    cartController.fetchCartItem();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: ColorConstant.whiteColor),
        backgroundColor: AppConstant.appPrimaryColor,
        title: Text(
          "Checkout",
          style: TextStyle(color: AppConstant.whiteColor),
        ),
      ),
      body: Container(
        color: Colors.blue.withOpacity(.1),
        child: SingleChildScrollView(
          child: Column(children: [
            const SizedBox(
              height: 5.0,
            ),
            widget.productModel == null
                ? Obx(
                    () => ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: widget.productModel == null
                            ? cartController.cartItemList.length
                            : 1,
                        itemBuilder: (context, index) {
                          var docData = cartController.cartItemList;

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

                          return Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 3.0, horizontal: 10.0),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            decoration: BoxDecoration(
                                color: ColorConstant.whiteColor,
                                borderRadius: BorderRadius.circular(10)),
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
                                      borderRadius: BorderRadius.circular(10),
                                      child: CachedNetworkImage(
                                        fit: BoxFit.fill,
                                        imageUrl: widget.productModel != null
                                            ? widget
                                                .productModel!.productImgList[0]
                                            : cartModel.productImgList[0],

                                        // it execute until image not load
                                        placeholder: (context, imgUrl) {
                                          return const Center(
                                            child: CupertinoActivityIndicator(),
                                          );
                                        },

                                        // it execute when any error occured loaidng in image
                                        errorWidget: (context, url, error) {
                                          return Image.asset(
                                              ImageConstant.previewIc);
                                        },
                                      ),
                                    )),
                                const SizedBox(
                                  width: 15,
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.productModel != null
                                            ? widget.productModel!.productName
                                            : cartModel.productName,
                                        style: TextStyleConstant.bold14Style,
                                      ),
                                      Text(
                                        widget.productModel != null
                                            ? DbKeyConstant.rs +
                                                widget.productModel!.fullPrice
                                            : DbKeyConstant.rs +
                                                cartModel.productTotalPrice
                                                    .toString(),
                                        style: TextStyleConstant.bold14Style,
                                      ),
                                      Text(
                                        widget.productModel != null
                                            ? "Qty : 1"
                                            : "Qty : " +
                                                cartModel.productQuantity
                                                    .toString(),
                                        style: TextStyleConstant.bold14Style,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                              ],
                            ),
                          );
                        }),
                  )
                : Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 3.0, horizontal: 10.0),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                        color: ColorConstant.whiteColor,
                        borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                            height: h / 10,
                            width: w / 5,
                            padding: const EdgeInsets.all(1),
                            decoration: BoxDecoration(
                                color: ColorConstant.greyColor.withOpacity(.3),
                                borderRadius: BorderRadius.circular(10)),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: CachedNetworkImage(
                                fit: BoxFit.fill,
                                imageUrl:
                                    widget.productModel!.productImgList[0],

                                // it execute until image not load
                                placeholder: (context, imgUrl) {
                                  return const Center(
                                    child: CupertinoActivityIndicator(),
                                  );
                                },

                                // it execute when any error occured loaidng in image
                                errorWidget: (context, url, error) {
                                  return Image.asset(ImageConstant.previewIc);
                                },
                              ),
                            )),
                        const SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.productModel!.productName,
                                style: TextStyleConstant.bold14Style,
                              ),
                              Text(
                                widget.productModel!.isSale == true
                                    ? DbKeyConstant.rs +
                                        widget.productModel!.salePrice
                                    : DbKeyConstant.rs +
                                        widget.productModel!.fullPrice,
                                style: TextStyleConstant.bold14Style,
                              ),
                              Text(
                                "Qty : 1",
                                style: TextStyleConstant.bold14Style,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                      ],
                    ),
                  ),
            const SizedBox(
              height: 20,
            ),
            GetBuilder<AddressController>(builder: (context) {
              if (addressController.userAddressList.isNotEmpty) {
                userData = addressController.userAddressList[0];

                fullAddress =
                    "${userData[DbKeyConstant.userStreet]}${userData[DbKeyConstant.userNearbyShop].isEmpty ? "" : ", Near by ${userData[DbKeyConstant.userNearbyShop]}"}, ${userData[DbKeyConstant.userCity]}, ${userData[DbKeyConstant.userState]} - ${userData[DbKeyConstant.userPincode]}";
              }

              return addressController.userAddressList.isNotEmpty
                  ? Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 15.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(width: .01),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Delivery Address",
                                style: TextStyleConstant.bold16Style,
                              ),
                              InkWell(
                                onTap: () {
                                  Get.to(() => const AddressScreen(
                                        isCheckoutPage: true,
                                      ));
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 6),
                                  decoration: BoxDecoration(
                                      border: Border.all(width: .05),
                                      borderRadius: BorderRadius.circular(5)),
                                  child: const Text(
                                    "Change",
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            userData[DbKeyConstant.userName][0].toUpperCase() +
                                userData[DbKeyConstant.userName].substring(1),
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            fullAddress,
                            style: const TextStyle(
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Ph: ${userData[DbKeyConstant.userPhone]}",
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    )
                  : InkWell(
                      onTap: () {
                        Get.to(() => const AddNewAddressScreen());
                      },
                      child: Container(
                          alignment: Alignment.centerLeft,
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          // height: 70,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(width: .01)),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "+  Add a new address",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward,
                                color: Colors.green,
                              )
                            ],
                          )),
                    );
            }),
            const SizedBox(
              height: 20,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(width: .01),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Price Details",
                    style: TextStyleConstant.bold16Style,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Items Total",
                        style: TextStyleConstant.normal14Style,
                      ),
                      Text(
                        widget.productModel != null
                            ? widget.productModel!.isSale == true
                                ? DbKeyConstant.ruppeeSign +
                                    widget.productModel!.salePrice
                                : DbKeyConstant.ruppeeSign +
                                    widget.productModel!.fullPrice
                            : DbKeyConstant.ruppeeSign +
                                cartController.totalProductPrice.toString(),
                        style: TextStyleConstant.normal14Style,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Delivery Charge",
                        style: TextStyleConstant.normal14Style,
                      ),
                      Text(
                        DbKeyConstant.ruppeeSign + deliveryCharge.toString(),
                        style: TextStyleConstant.normal14Style,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Taxes",
                        style: TextStyleConstant.normal14Style,
                      ),
                      Text(
                        widget.productModel != null
                            ? widget.productModel!.isSale == true
                                ? DbKeyConstant.ruppeeSign +
                                    ((double.parse(widget
                                                    .productModel!.salePrice) *
                                                taxesPercent) /
                                            100)
                                        .toString()
                                : DbKeyConstant.ruppeeSign +
                                    ((double.parse(widget
                                                    .productModel!.fullPrice) *
                                                taxesPercent) /
                                            100)
                                        .toString()
                            : DbKeyConstant.ruppeeSign +
                                ((cartController.totalProductPrice.value *
                                            taxesPercent) /
                                        100)
                                    .toString(),
                        style: TextStyleConstant.normal14Style,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total Amount",
                        style: TextStyleConstant.bold16Style,
                      ),
                      Obx(
                        () => Text(
                          DbKeyConstant.ruppeeSign +
                              "${cartController.totalAmount}",
                          style: TextStyleConstant.bold16Style,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(width: .01),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Payment Method",
                    style: TextStyleConstant.bold16Style,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Cash On Delivery",
                        style: TextStyleConstant.normal16Style.copyWith(
                          color: paymentType == "Cash"
                              ? Colors.green
                              : Colors.black,
                          fontWeight: paymentType == "Cash"
                              ? FontWeight.bold
                              : FontWeight.w500,
                        ),
                      ),
                      Radio(
                          activeColor: Colors.green,
                          value: "Cash",
                          groupValue: paymentType,
                          onChanged: (value) {
                            setState(() {
                              paymentType = value!;
                            });
                          }),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Online Pay",
                        style: TextStyleConstant.bold16Style.copyWith(
                          color: paymentType == "Online"
                              ? Colors.green
                              : Colors.black,
                          fontWeight: paymentType == "Online"
                              ? FontWeight.bold
                              : FontWeight.w500,
                        ),
                      ),
                      Radio(
                          activeColor: Colors.green,
                          value: "Online",
                          groupValue: paymentType,
                          onChanged: (value) {
                            setState(() {
                              paymentType = value!;
                            });
                          }),
                    ],
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
      bottomNavigationBar: GetBuilder<AddressController>(builder: (context) {
        return Container(
          height: 60,
          decoration: BoxDecoration(
              color: Colors.blue.shade100.withOpacity(.5),
              borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(10), topLeft: Radius.circular(10))),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
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
                      Obx(
                        () => Text(
                          DbKeyConstant.rs +
                              "${cartController.totalAmount.value}",
                          style: TextStyleConstant.bold14Style,
                        ),
                      )
                    ],
                  ),
                ),
                const Spacer(),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: ColorConstant.primaryColor,
                        fixedSize: Size(w / 2, h / 18),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15))),
                    onPressed: () async {
                      if (paymentType.isNotEmpty &&
                          addressController.userAddressList.isNotEmpty) {
                        // online payment method
                        if (paymentType == "Online") {
                          if (widget.productModel != null) {
                            await paymentController.getPayment(
                                model: widget.productModel,
                                paymentData: {
                                  DbKeyConstant.productTotalPrice:
                                      ((cartController.totalAmount.value) * 100)
                                          .toInt(),
                                  DbKeyConstant.userName:
                                      addressController.userAddressList[0]
                                          [DbKeyConstant.userName],
                                  DbKeyConstant.userPhone:
                                      addressController.userAddressList[0]
                                          [DbKeyConstant.userPhone],
                                  DbKeyConstant.userAddress: fullAddress,
                                });
                          } else {
                            await paymentController.getPayment(paymentData: {
                              DbKeyConstant.productTotalPrice:
                                  ((cartController.totalAmount.value) * 100)
                                      .toInt(),
                              DbKeyConstant.userName: addressController
                                  .userAddressList[0][DbKeyConstant.userName],
                              DbKeyConstant.userPhone: addressController
                                  .userAddressList[0][DbKeyConstant.userPhone],
                              DbKeyConstant.userAddress: fullAddress,
                            });
                          }
                        } else {
                          try {
                            EasyLoading.show(
                                status: "Please Wait..",
                                maskType: EasyLoadingMaskType.black);

                            if (widget.productModel != null) {
                              await orderController.placeOrder(
                                  userName: addressController.userAddressList[0]
                                      [DbKeyConstant.userName],
                                  userPhone:
                                      addressController.userAddressList[0]
                                          [DbKeyConstant.userPhone],
                                  userAddress: fullAddress,
                                  productModel: widget.productModel);
                            } else {
                              await orderController.placeOrder(
                                userName: addressController.userAddressList[0]
                                    [DbKeyConstant.userName],
                                userPhone: addressController.userAddressList[0]
                                    [DbKeyConstant.userPhone],
                                userAddress: fullAddress,
                              );
                            }

                            EasyLoading.dismiss();
                            Get.offAll(() => OrderSuccessScreen(
                                  paymentMode: "Cash",
                                  totalAmount: cartController.totalAmount.value
                                      .toString(),
                                ));
                          } catch (ex) {
                            EasyLoading.dismiss();
                            UiHelper.customSnackbar(
                                titleMsg: "Error Occured",
                                msg: "Order Placed Failed!");
                          }
                        }
                      } else {
                        UiHelper.customToast(
                            msg: "Address or Payment Not Selected");
                      }
                    },
                    child: Text(
                      "Place Order",
                      style: TextStyleConstant.bold16Style
                          .copyWith(color: ColorConstant.whiteColor),
                    ))
              ],
            ),
          ),
        );
      }),
    );
  }
}
