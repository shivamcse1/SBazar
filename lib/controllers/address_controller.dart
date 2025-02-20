import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:s_bazar/core/constant/database_key_const.dart';
import 'package:s_bazar/core/error/exception/firebase_exception_handler.dart';
import 'package:s_bazar/data/model/address_model.dart';
import 'package:s_bazar/utils/Uihelper/ui_helper.dart';

class AddressController extends GetxController {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController nearbyShopController = TextEditingController();
  TextEditingController streetController = TextEditingController();

  User? user = FirebaseAuth.instance.currentUser;
  List<Map<String, dynamic>> userAddressList = [];
  RxInt totalAddress = 0.obs;
  String groupValue = '';

  Future<void> addNewAddress() async {
    try {
      EasyLoading.show(
          status: "Please Wait", maskType: EasyLoadingMaskType.black);

      String addressId = UiHelper.generateUniqueId(idType: "AD");
      AddressModel addressModel = AddressModel(
          createdAt: DateTime.now().toString(),
          userUid: user!.uid,
          addressId: addressId,
          userCity: cityController.text.trim(),
          userPhone: phoneController.text.trim(),
          userName: nameController.text.trim(),
          userPincode: pincodeController.text.trim(),
          userState: stateController.text.trim(),
          userStreet: streetController.text.trim(),
          userNearbyShop: nearbyShopController.text.trim());
      await FirebaseFirestore.instance
          .collection(DbKeyConstant.addressCollection)
          .doc(user!.uid)
          .collection(DbKeyConstant.savedAddressCollection)
          .doc(addressId)
          .set(addressModel.toMap());

      Future.delayed(const Duration(seconds: 2), () {
        EasyLoading.dismiss();
        UiHelper.customToast(
          toastGravity: ToastGravity.BOTTOM,
          msg: "Address Added Sucessfully",
        );
        Get.back();
      }).then((value) {
        fetchUserAddresses();
      });
    } on FirebaseException catch (ex) {
      EasyLoading.dismiss();
      FirebaseExceptionHelper.exceptionHandler(ex);
    }
  }

  Future<void> fetchUserAddresses({String? addressId}) async {
    try {
      EasyLoading.show(
          status: "Please Wait", maskType: EasyLoadingMaskType.black);

      if (addressId == null) {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection(DbKeyConstant.addressCollection)
            .doc(user!.uid)
            .collection(DbKeyConstant.savedAddressCollection)
            .orderBy("createdAt", descending: true)
            .get();

        Future.delayed(const Duration(seconds: 1), () {
          userAddressList = querySnapshot.docs.map((doc) {
            return doc.data() as Map<String, dynamic>;
          }).toList();
          EasyLoading.dismiss();
          update();
          totalAddress.value = userAddressList.length;
        });
      } else {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection(DbKeyConstant.addressCollection)
            .doc(user!.uid)
            .collection(DbKeyConstant.savedAddressCollection)
            .where(DbKeyConstant.addressId, isEqualTo: addressId)
            .get();

        Future.delayed(const Duration(seconds: 1), () {
          userAddressList = querySnapshot.docs.map((doc) {
            return doc.data() as Map<String, dynamic>;
          }).toList();
          EasyLoading.dismiss();
          update();
          totalAddress.value = userAddressList.length;
        });
      }
    } on FirebaseException catch (ex) {
      EasyLoading.dismiss();
      update();
      FirebaseExceptionHelper.exceptionHandler(ex);
    }
  }

  Future<void> removeUserAddress({AddressModel? addressModel}) async {
    try {
      EasyLoading.show(status: "Please Wait");
      await FirebaseFirestore.instance
          .collection(DbKeyConstant.addressCollection)
          .doc(user!.uid)
          .collection(DbKeyConstant.savedAddressCollection)
          .doc(addressModel!.addressId)
          .delete();

      update();
      EasyLoading.dismiss();
    } on FirebaseException catch (ex) {
      EasyLoading.dismiss();
      update();
      FirebaseExceptionHelper.exceptionHandler(ex);
    }
  }

  Future<void> editUserAddress({AddressModel? editAddressModel}) async {
    try {
      EasyLoading.show(
          status: "Please Wait", maskType: EasyLoadingMaskType.black);

      AddressModel addressModel = AddressModel(
          createdAt: DateTime.now().toString(),
          userUid: user!.uid,
          addressId: editAddressModel!.addressId,
          userCity: cityController.text.trim(),
          userPhone: phoneController.text.trim(),
          userName: nameController.text.trim(),
          userPincode: pincodeController.text.trim(),
          userState: stateController.text.trim(),
          userStreet: streetController.text.trim(),
          userNearbyShop: nearbyShopController.text.trim());

      await FirebaseFirestore.instance
          .collection(DbKeyConstant.addressCollection)
          .doc(user!.uid)
          .collection(DbKeyConstant.savedAddressCollection)
          .doc(editAddressModel.addressId)
          .update(addressModel.toMap());

      update();
      Get.back();
      EasyLoading.dismiss();
    } on FirebaseException catch (ex) {
      EasyLoading.dismiss();
      update();
      FirebaseExceptionHelper.exceptionHandler(ex);
    }
  }

  void assignControllerValue({
    required AddressModel addressModel,
  }) {
    try {
      nameController.text = addressModel.userName;
      phoneController.text = addressModel.userPhone;
      cityController.text = addressModel.userCity;
      pincodeController.text = addressModel.userPincode;
      stateController.text = addressModel.userState;
      nearbyShopController.text = addressModel.userNearbyShop;
      streetController.text = addressModel.userStreet;

      update();
    } catch (ex) {
      update();
      UiHelper.customToast(msg: "Error Occured");
    }
  }

  void selectAddress({required String currentIndexValue}) {
    groupValue = currentIndexValue;
    update();
  }

  @override
  void onClose() {
    AddressController().dispose();
    super.onClose();
  }
}
