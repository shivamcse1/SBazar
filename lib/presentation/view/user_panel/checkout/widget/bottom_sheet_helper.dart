// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:s_bazar/controllers/order_controller.dart';
import 'package:s_bazar/core/constant/color_const.dart';
import 'package:s_bazar/core/constant/textstyle_const.dart';
import 'package:s_bazar/utils/Uihelper/custom_snakbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../controllers/device_token_contoller.dart';

class BottomSheetHelper {
  static Future addressBottomSheet(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController phoneController = TextEditingController();
    final TextEditingController addressController = TextEditingController();
    final DeviceTokenContoller deviceTokenContoller =
        Get.put(DeviceTokenContoller());
    final OrderController orderController = Get.put(OrderController());

    return showModalBottomSheet(
        isDismissible: false,
        backgroundColor: Colors.transparent,
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return DraggableScrollableSheet(
            initialChildSize: .6,
            maxChildSize: .9,
            minChildSize: .3,
            builder: (context, scrollController) {
              return Column(
                children: [
                  IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: CircleAvatar(
                          backgroundColor: Colors.black.withOpacity(.1),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 30,
                          ))),
                  Expanded(
                      child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15))),
                    child: ListView(
                      controller: scrollController,
                      // physics: const NeverScrollableScrollPhysics(),
                      children: [
                        TextFormField(
                          controller: nameController,
                          keyboardType: TextInputType.name,
                          decoration: const InputDecoration(
                            label: Text("Name"),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.phone,
                          controller: phoneController,
                          decoration: const InputDecoration(
                            label: Text("Phone"),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.streetAddress,
                          controller: addressController,
                          decoration: const InputDecoration(
                            label: Text("Address"),
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                backgroundColor: ColorConstant.primaryColor),
                            onPressed: () async {
                              if (nameController.text.isNotEmpty &&
                                  phoneController.text.isNotEmpty &&
                                  addressController.text.isNotEmpty) {
                                String name =
                                    nameController.text.toString().trim();
                                String phone =
                                    phoneController.text.toString().trim();
                                String address =
                                    addressController.text.toString().trim();
                                String deviceToken = await deviceTokenContoller
                                    .getCustomerDeviceToken();
                                print("token $deviceToken");

                                orderController.placeOrder(
                                    context: context,
                                    userName: name,
                                    userPhone: phone,
                                    userAddress: address,
                                    userDeviceToken: deviceToken);
                              } else {
                                SnackbarHelper.customSnackbar(
                                    titleMsg: "Please Fill Details",
                                    msg:
                                        "Provide all details before further proceed");
                              }
                            },
                            child: Text(
                              "Place Order",
                              style: TextStyleConstant.bold16Style
                                  .copyWith(color: ColorConstant.whiteColor),
                            ))
                      ],
                    ),
                  ))
                ],
              );
            },
          );
        });
  }
}
