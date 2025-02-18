// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:s_bazar/data/model/address_model.dart';
import 'package:s_bazar/presentation/widget/custom_button.dart';
import 'package:s_bazar/presentation/widget/custom_textfield.dart';
import 'package:s_bazar/utils/Uihelper/ui_helper.dart';

import '../../../../controllers/address_controller.dart';
import '../../../../core/constant/app_const.dart';
import '../../../../core/constant/color_const.dart';
import '../../../widget/custom_app_bar.dart';

class AddNewAddressScreen extends StatefulWidget {
  final AddressModel? addressModel;
  final bool? isEdit;
  const AddNewAddressScreen({super.key, this.addressModel, this.isEdit});

  @override
  State<AddNewAddressScreen> createState() => _AddNewAddressScreenState();
}

class _AddNewAddressScreenState extends State<AddNewAddressScreen> {
  final AddressController addressController = Get.put(AddressController());

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (widget.addressModel != null) {
        addressController.assignControllerValue(
            addressModel: widget.addressModel!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        isBackBtnVisible: true,
        backIconColor: Colors.white,
        onBackBtn: () {
          Get.back();
        },
        title: "Add New Address",
        titleStyle: TextStyle(color: ColorConstant.whiteColor),
        appBarColor: AppConstant.appPrimaryColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              CustomTextField(
                keyboardType: TextInputType.name,
                controller: addressController.nameController,
                prefix: const Icon(
                  Icons.person,
                ),
                hintText: "Full Name (Required)*",
                focusBorderColor: ColorConstant.greyColor,
                enableBorderColor: ColorConstant.greyColor,
              ),
              const SizedBox(
                height: 20,
              ),
              CustomTextField(
                keyboardType: TextInputType.phone,
                controller: addressController.phoneController,
                prefix: const Icon(
                  Icons.phone_android,
                ),
                hintText: "Phone Number (Required)*",
                focusBorderColor: ColorConstant.greyColor,
                enableBorderColor: ColorConstant.greyColor,
              ),
              const SizedBox(
                height: 20,
              ),
              CustomTextField(
                keyboardType: TextInputType.streetAddress,
                controller: addressController.streetController,
                prefix: const Icon(
                  Icons.home,
                ),
                hintText: "Area,Colony,Street (Required)*",
                focusBorderColor: ColorConstant.greyColor,
                enableBorderColor: ColorConstant.greyColor,
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      keyboardType: TextInputType.number,
                      controller: addressController.pincodeController,
                      prefix: const Icon(
                        Icons.location_searching,
                      ),
                      hintText: "Pincode (Required)*",
                      focusBorderColor: ColorConstant.greyColor,
                      enableBorderColor: ColorConstant.greyColor,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: CustomTextField(
                      keyboardType: TextInputType.name,
                      controller: addressController.stateController,
                      prefix: const Icon(
                        Icons.maps_home_work,
                      ),
                      hintText: "State (Required)*",
                      focusBorderColor: ColorConstant.greyColor,
                      enableBorderColor: ColorConstant.greyColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              CustomTextField(
                keyboardType: TextInputType.name,
                controller: addressController.cityController,
                prefix: const Icon(
                  Icons.location_city,
                ),
                hintText: "City (Required)*",
                focusBorderColor: ColorConstant.greyColor,
                enableBorderColor: ColorConstant.greyColor,
              ),
              const SizedBox(
                height: 20,
              ),
              CustomTextField(
                keyboardType: TextInputType.name,
                controller: addressController.nearbyShopController,
                prefix: const Icon(
                  Icons.store_mall_directory,
                ),
                hintText: "Nearby Famous Shop/LandMark (Optional)",
                focusBorderColor: ColorConstant.greyColor,
                enableBorderColor: ColorConstant.greyColor,
              ),
              const SizedBox(
                height: 50,
              ),
              CustomElevatedButton(
                buttonText: "Save Address",
                buttonTextStyle: TextStyle(
                    color: ColorConstant.whiteColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
                buttonColor: AppConstant.appPrimaryColor,
                onTap: () async {
                  String name = addressController.nameController.text.trim();
                  String phone = addressController.phoneController.text.trim();
                  String street =
                      addressController.streetController.text.trim();
                  String pincode =
                      addressController.pincodeController.text.trim();
                  String state = addressController.stateController.text.trim();
                  String city = addressController.cityController.text.trim();
                  String nearbyShop =
                      addressController.nearbyShopController.text.trim();
                  if (name.isNotEmpty &&
                      phone.isNotEmpty &&
                      street.isNotEmpty &&
                      pincode.isNotEmpty &&
                      state.isNotEmpty &&
                      city.isNotEmpty) {
                    if (widget.isEdit != null && widget.isEdit == true) {
                      await addressController.editUserAddress(
                          editAddressModel: widget.addressModel);
                      await addressController.fetchUserAddresses();
                    } else {
                      await addressController
                          .addNewAddress()
                          .then((value) async {
                        await addressController.fetchUserAddresses();
                      });
                    }
                  } else {
                    UiHelper.customToast(
                      msg: "Please Fill All Details",
                      toastGravity: ToastGravity.BOTTOM,
                      bgColor: AppConstant.appPrimaryColor,
                      textColor: AppConstant.whiteColor,
                    );
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
