// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:s_bazar/core/error/exception/firebase_exception_handler.dart';
import 'package:s_bazar/data/model/product_model.dart';

import '../core/constant/database_key_const.dart';
import '../data/model/order_model.dart';
import '../data/model/review_model.dart';

class ReviewController extends GetxController {
  final TextEditingController feedbackController = TextEditingController();
  double productRating = 0;
  User? user = FirebaseAuth.instance.currentUser;
  RxDouble totalAvgRating = 0.0.obs;
  RxInt totalPeople = 0.obs;

  Future<void> submitReview({
    OrderModel? orderModel,
  }) async {
    try {
      EasyLoading.show(status: "Please wait..");

      ReviewModel reviewModel = ReviewModel(
        userName: orderModel!.userName,
        userPhone: orderModel.userPhone,
        createdAt: DateTime.now().toString(),
        userRating: productRating.toString(),
        userReview: feedbackController.text.trim().toString(),
        userUid: user!.uid,
        userDeviceToken: orderModel.userDeviceToken,
      );

      if (productRating > 0) {
        await FirebaseFirestore.instance
            .collection(DbKeyConstant.productCollection)
            .doc(orderModel.productId)
            .collection(DbKeyConstant.reviewCollection)
            .doc(user!.uid)
            .set(reviewModel.toMap());
        EasyLoading.dismiss();
        Fluttertoast.showToast(msg: "Review Submitted Successfully");
        Get.back();
      } else {
        EasyLoading.dismiss();
        Fluttertoast.showToast(msg: "Please Rate Product");
      }
    } on FirebaseException catch (ex) {
      EasyLoading.dismiss();
      Fluttertoast.showToast(msg: "Review Submitted Failed");
      Get.back();
      FirebaseExceptionHelper.exceptionHandler(ex);
    }
  }

  Future<void> calculateRating({
    ProductModel? productModel,
  }) async {
    DocumentReference docref = FirebaseFirestore.instance
        .collection(DbKeyConstant.productCollection)
        .doc(productModel!.productId);

    QuerySnapshot querySnapshot =
        await docref.collection(DbKeyConstant.reviewCollection).get();
    totalPeople.value = querySnapshot.docs.length;

    if (querySnapshot.docs.isNotEmpty) {
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> docData = doc.data() as Map<String, dynamic>;

        print(docData[DbKeyConstant.userRating]);
        totalAvgRating.value += double.parse(docData[DbKeyConstant.userRating]);

        print("avg rating $totalAvgRating.value");
      }
      totalAvgRating.value = totalAvgRating.value / querySnapshot.docs.length;
    }

    double decimalValue = totalAvgRating.value - totalAvgRating.value.floor();
    if (decimalValue >= .01 && decimalValue <= .49) {
      totalAvgRating.value = totalAvgRating.value.floor() + .5;
    } else if (decimalValue >= .51 && decimalValue <= .99) {
      totalAvgRating.value = totalAvgRating.value.ceil() * 1.0;
    }
    print("avg rating ${totalAvgRating.value}");
  }

}
