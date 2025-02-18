import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:s_bazar/controllers/address_controller.dart';
import 'package:s_bazar/core/constant/database_key_const.dart';
import 'package:s_bazar/data/model/address_model.dart';
import 'package:s_bazar/presentation/widget/custom_app_bar.dart';
import 'package:s_bazar/utils/Uihelper/ui_helper.dart';

import '../../../../core/constant/app_const.dart';
import '../../../../core/constant/color_const.dart';
import 'add_new_address_screen.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;
  final AddressController addressController = Get.put(AddressController());

  @override
  void dispose() {
    EasyLoading.dismiss();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        isBackBtnVisible: true,
        backIconColor: Colors.white,
        onBackBtn: () {
          Get.back();
        },
        title: "My Address",
        titleStyle: TextStyle(color: ColorConstant.whiteColor),
        appBarColor: AppConstant.appPrimaryColor,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await addressController.fetchUserAddresses();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    EasyLoading.dismiss();
                    Get.to(() => const AddNewAddressScreen());
                  },
                  child: Material(
                    elevation: 2,
                    child: Container(
                        alignment: Alignment.centerLeft,
                        height: 70,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          "+  Add a new address",
                          style: TextStyle(
                            fontSize: 18,
                            color: AppConstant.appPrimaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Obx(
                    () => Text(
                      "${addressController.totalAddress.value} SAVED ADDRESSES",
                      style: TextStyle(
                        fontSize: 12,
                        color: ColorConstant.greyColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                GetBuilder<AddressController>(
                    initState: (_) => addressController.fetchUserAddresses(),
                    builder: (addressController) {
                      return ListView.builder(
                        itemCount: addressController.userAddressList.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          var userData =
                              addressController.userAddressList[index];

                          AddressModel addressModel = AddressModel(
                            createdAt: userData[DbKeyConstant.createdAt],
                            userUid: userData[DbKeyConstant.userUid],
                            userCity: userData[DbKeyConstant.userCity],
                            userPhone: userData[DbKeyConstant.userPhone],
                            userName: userData[DbKeyConstant.userName],
                            userPincode: userData[DbKeyConstant.userPincode],
                            userState: userData[DbKeyConstant.userState],
                            userStreet: userData[DbKeyConstant.userStreet],
                            userNearbyShop:
                                userData[DbKeyConstant.userNearbyShop],
                            addressId: userData[DbKeyConstant.addressId],
                          );

                          String fullAddress =
                              "${addressModel.userStreet}${addressModel.userNearbyShop.isEmpty ? "" : ", ${addressModel.userNearbyShop}"}, ${addressModel.userCity}, ${addressModel.userState} - ${addressModel.userPincode}";

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Material(
                              elevation: 2,
                              child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(width: .01)),
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 5, bottom: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 40,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              addressModel.userName[0]
                                                      .toUpperCase() +
                                                  addressModel.userName
                                                      .substring(1),
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                            PopupMenuButton<String>(
                                              padding: EdgeInsets.zero,
                                              constraints:
                                                  const BoxConstraints(),
                                              color: ColorConstant.whiteColor,
                                              shape:
                                                  const RoundedRectangleBorder(),
                                              onSelected:
                                                  (selectedValue) async {
                                                if (selectedValue == "Remove") {
                                                  await addressController
                                                      .removeUserAddress(
                                                    addressModel: addressModel,
                                                  );
                                                  await addressController
                                                      .fetchUserAddresses();
                                                } else if (selectedValue ==
                                                    "Edit") {
                                                  Get.to(
                                                      () => AddNewAddressScreen(
                                                            addressModel:
                                                                addressModel,
                                                            isEdit: true,
                                                          ));
                                                }
                                              },
                                              itemBuilder: (context) {
                                                return [
                                                  const PopupMenuItem(
                                                      value: "Edit",
                                                      child: Text("Edit")),
                                                  const PopupMenuItem(
                                                      value: "Remove",
                                                      child: Text("Remove"))
                                                ];
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: 330,
                                        child: Text(
                                          fullAddress,
                                          style: const TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Text(
                                        "Ph: ${addressModel.userPhone}",
                                        style: const TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  )),
                            ),
                          );
                        },
                      );
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
