// ignore_for_file: prefer_interpolation_to_compose_strings, prefer_adjacent_string_concatenation, unnecessary_brace_in_string_interps, avoid_print

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:s_bazar/core/error/exception/firebase_exception_handler.dart';

import '../core/constant/database_key_const.dart';
import '../data/model/order_model.dart';
import '../utils/Uihelper/ui_helper.dart';

class OrderController extends GetxController {
  // placeing order method
  Future<void> placeOrder({
    required BuildContext context,
    required String userName,
    required String userPhone,
    required String userAddress,
    required String userDeviceToken,
  }) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        QuerySnapshot snapshot = await FirebaseFirestore.instance
            .collection(DbKeyConstant.cartCollection)
            .doc(user.uid)
            .collection(DbKeyConstant.cartProductCollection)
            .get();

        List<QueryDocumentSnapshot> documentList = snapshot.docs;

        for (var singleDoc in documentList) {
          Map<String, dynamic> docData =
              singleDoc.data() as Map<String, dynamic>;
          String orderId = generateOrderId();

          print("Ram${documentList.length}");
          OrderModel orderModel = OrderModel(
            productId: docData[DbKeyConstant.productId],
            categoryId: docData[DbKeyConstant.categoryId],
            productName: docData[DbKeyConstant.productName],
            categoryName: docData[DbKeyConstant.categoryName],
            salePrice: docData[DbKeyConstant.salePrice],
            fullPrice: docData[DbKeyConstant.fullPrice],
            productImgList: docData[DbKeyConstant.productImgList],
            deliveryTime: docData[DbKeyConstant.deliveryTime],
            isSale: docData[DbKeyConstant.isSale],
            productDescription: docData[DbKeyConstant.productDescription],
            createdAt: DateTime.now(),
            updatedAt: docData[DbKeyConstant.updatedAt],
            productQuantity: docData[DbKeyConstant.productQuantity],
            productTotalPrice: docData[DbKeyConstant.productTotalPrice],
            userUid: user.uid,
            orderStatus: false,
            userName: userName,
            userPhone: userPhone,
            userAddress: userAddress,
            userDeviceToken: userDeviceToken,
            orderId: orderId,
          );
          await FirebaseFirestore.instance
              .collection(DbKeyConstant.orderCollection)
              .doc(user.uid)
              .set({
            "userUid": user.uid,
            "userName": userName,
            "userPhone": userPhone,
            "userAddress": userAddress,
            "userDeviceToken": userDeviceToken,
            "orderStatus": false,
            "createdAt": DateTime.now()
          });

          // set All order details
          await FirebaseFirestore.instance
              .collection(DbKeyConstant.orderCollection)
              .doc(user.uid)
              .collection(DbKeyConstant.confirmedOrderCollection)
              .doc(orderId)
              .set(orderModel.toMap());

          // delete cart product after successfull order
          await FirebaseFirestore.instance
              .collection(DbKeyConstant.cartCollection)
              .doc(user.uid)
              .collection(DbKeyConstant.cartProductCollection)
              .doc(orderModel.productId)
              .delete()
              .then((value) {
            print("delete cart product :${orderModel.productId}");
          });
        }

        // UiHelper.customSnackbar(
        //     titleMsg: "Order Confirmed!",
        //     msg: "Thank you for shopping! Have a nice day");
     
        // Get.offAll(() => const UserHomeScreen());
      } on FirebaseException catch (ex) {
        
        FirebaseExceptionHelper.exceptionHandler(ex);
        print("error Ocurred:$ex");
      }
    }
 
  }

  // generate order id
  String generateOrderId() {
    DateTime now = DateTime.now();
    int randomNumber = Random().nextInt(10000);
    String orderId = "OD" + "${now.millisecondsSinceEpoch}" + "${randomNumber}";
    return orderId;
  }

}
