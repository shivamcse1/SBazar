// ignore_for_file: prefer_interpolation_to_compose_strings, prefer_adjacent_string_concatenation, unnecessary_brace_in_string_interps, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:s_bazar/controllers/auth_controller.dart';
import 'package:s_bazar/core/error/exception/firebase_exception_handler.dart';
import 'package:s_bazar/data/model/product_model.dart';
import 'package:s_bazar/data/services/firebase_notification_service.dart';
import 'package:s_bazar/data/services/send_notification_service.dart';

import '../core/constant/database_key_const.dart';
import '../data/model/order_model.dart';
import '../utils/Uihelper/ui_helper.dart';

class OrderController extends GetxController {
  final AuthController authController = Get.put(AuthController());
  // placeing order method

  Future<void> placeOrder(
      {required String userName,
      required String userPhone,
      required String userAddress,
      ProductModel? productModel}) async {
    User? user = FirebaseAuth.instance.currentUser;
    String userDeviceToken = await FirebaseNotificationService.getDeviceToken();
    String? adminDeviceToken = await getAdminDeviceToken();
    if (user != null) {
      try {
        if (productModel != null) {
          String orderId = UiHelper.generateUniqueId();

          OrderModel orderModel = OrderModel(
            productId: productModel.productId,
            categoryId: productModel.categoryId,
            productName: productModel.productName,
            categoryName: productModel.categoryName,
            salePrice: productModel.salePrice,
            fullPrice: productModel.fullPrice,
            productImgList: productModel.productImgList,
            deliveryTime: productModel.deliveryTime,
            isSale: productModel.isSale,
            productDescription: productModel.productDescription,
            createdAt: DateTime.now(),
            updatedAt: productModel.updatedAt,
            productQuantity: 1,
            productTotalPrice: double.parse(productModel.fullPrice),
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

          // save notification
          FirebaseFirestore.instance
              .collection(DbKeyConstant.notificationsCollection)
              .doc(user.uid)
              .collection(DbKeyConstant.savedNotificationsCollection)
              .doc()
              .set({
            DbKeyConstant.notificationTitle:
                "${orderModel.productName} Successfully Placed ",
            DbKeyConstant.notificationBody: orderModel.productDescription,
            DbKeyConstant.notificationImg: orderModel.productImgList,
            DbKeyConstant.isSale: orderModel.isSale,
            DbKeyConstant.isSeen: false,
            DbKeyConstant.productId: orderModel.productId,
            DbKeyConstant.createdAt: DateTime.now(),
            DbKeyConstant.salePrice: orderModel.salePrice,
            DbKeyConstant.fullPrice: orderModel.fullPrice,
          });
        } else {
          QuerySnapshot snapshot = await FirebaseFirestore.instance
              .collection(DbKeyConstant.cartCollection)
              .doc(user.uid)
              .collection(DbKeyConstant.cartProductCollection)
              .get();

          List<QueryDocumentSnapshot> documentList = snapshot.docs;

          for (var singleDoc in documentList) {
            Map<String, dynamic> docData =
                singleDoc.data() as Map<String, dynamic>;
            String orderId = UiHelper.generateUniqueId();

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

            // save notification
            FirebaseFirestore.instance
                .collection(DbKeyConstant.notificationsCollection)
                .doc(user.uid)
                .collection(DbKeyConstant.savedNotificationsCollection)
                .doc()
                .set({
              DbKeyConstant.notificationTitle:
                  "${orderModel.productName} Successfully Placed ",
              DbKeyConstant.notificationBody: orderModel.productDescription,
              DbKeyConstant.notificationImg: orderModel.productImgList,
              DbKeyConstant.isSale: orderModel.isSale,
              DbKeyConstant.isSeen: false,
              DbKeyConstant.productId: orderModel.productId,
              DbKeyConstant.createdAt: DateTime.now(),
              DbKeyConstant.salePrice: orderModel.salePrice,
              DbKeyConstant.fullPrice: orderModel.fullPrice,
            });
          }
        }

        // send notification to admin
        await SendNotificationService.sendNotification(
            deviceToken: adminDeviceToken ?? '',
            body: "Order Placed Sucessfully",
            title: "Order Sucessfully Placed By $userName",
            data: {DbKeyConstant.screen: "notification"});

        //send user notification
        Future.delayed(const Duration(seconds: 5), () async {
          await SendNotificationService.sendNotification(
              deviceToken: userDeviceToken,
              body: "Thank you for shopping in SBazar, Have a nice day!",
              title: "Order Successfully Placed",
              data: {DbKeyConstant.screen: "notification"});
        });
      } on FirebaseException catch (ex) {
        FirebaseExceptionHelper.exceptionHandler(ex);
        print("error Ocurred:$ex");
      }
    }
  }

  Future<String?> getAdminDeviceToken() async {
    try {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection(DbKeyConstant.userCollection)
          .where(DbKeyConstant.isAdmin, isEqualTo: true)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first[DbKeyConstant.userDeviceToken]
            as String;
      } else {
        return null;
      }
    } catch (ex) {
      print("Error in fetching admin token :$ex");
      return null;
    }
  }
}
