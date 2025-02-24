// ignore_for_file: unnecessary_null_comparison, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:s_bazar/core/constant/database_key_const.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:s_bazar/core/error/exception/firebase_exception_handler.dart';
import 'package:s_bazar/data/model/product_model.dart';

import '../data/model/cart_model.dart';

class CartController extends GetxController {
  RxDouble totalProductPrice = 0.0.obs;
  RxDouble totalAmount = 0.0.obs;
  RxInt totalCartItem = 0.obs;

  RxBool itemExistInCart = false.obs;
  RxList<Map<String, dynamic>> cartItemList = <Map<String, dynamic>>[].obs;
  User? user = FirebaseAuth.instance.currentUser;

  Future<void> incrementCartProductQuantity({
    required CartModel cartModel,
    required User? user,
  }) async {
    if (cartModel.productQuantity > 0) {
      await FirebaseFirestore.instance
          .collection(DbKeyConstant.cartCollection)
          .doc(user!.uid)
          .collection(DbKeyConstant.cartProductCollection)
          .doc(cartModel.productId)
          .update({
        "productQuantity": cartModel.productQuantity + 1,
        "productTotalPrice": cartModel.productTotalPrice +
            double.parse(
                (cartModel.isSale ? cartModel.salePrice : cartModel.fullPrice))
      });
    }
  }

  Future<void> decrementCartProductQuantity({
    required CartModel cartModel,
    required User? user,
  }) async {
    DocumentReference docref = FirebaseFirestore.instance
        .collection(DbKeyConstant.cartCollection)
        .doc(user!.uid)
        .collection(DbKeyConstant.cartProductCollection)
        .doc(cartModel.productId);

    // if product quantity is greater than 1 then decrease otherwise delete product
    if (cartModel.productQuantity > 1) {
      await docref.update({
        "productQuantity": cartModel.productQuantity - 1,
        "productTotalPrice": cartModel.productTotalPrice -
            double.parse(
                (cartModel.isSale ? cartModel.salePrice : cartModel.fullPrice))
      });
    } else {
      await docref.delete();

      // total number of item calc
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection(DbKeyConstant.cartCollection)
          .doc(user.uid)
          .collection(DbKeyConstant.cartProductCollection)
          .get();

      totalCartItem.value = querySnapshot.docs.length;
    }
  }

  Future<void> deleteCartProduct({
    required CartModel cartModel,
    required User? user,
  }) async {
    await FirebaseFirestore.instance
        .collection(DbKeyConstant.cartCollection)
        .doc(user!.uid)
        .collection(DbKeyConstant.cartProductCollection)
        .doc(cartModel.productId)
        .delete();

    // total number of item calc
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(DbKeyConstant.cartCollection)
        .doc(user.uid)
        .collection(DbKeyConstant.cartProductCollection)
        .get();

    totalCartItem.value = querySnapshot.docs.length;
  }

  Future<void> calculateTotalProductPrice({required User? user}) async {
    double sum = 0;
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(DbKeyConstant.cartCollection)
        .doc(user!.uid)
        .collection(DbKeyConstant.cartProductCollection)
        .get();

    for (DocumentSnapshot doc in querySnapshot.docs) {
      Map<String, dynamic> docData = doc.data() as Map<String, dynamic>;
      if (docData != null &&
          docData.containsKey(DbKeyConstant.productTotalPrice)) {
        sum = sum + docData[DbKeyConstant.productTotalPrice];
      }
    }
    Future.delayed(const Duration(milliseconds: 500), () {
      totalProductPrice.value = sum;
    });
  }

  Future<void> addToCart({
    required uId,
    int quantityIncrement = 1,
    required ProductModel productModel,
  }) async {
    try {
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection(DbKeyConstant.cartCollection)
          .doc(uId)
          .collection(DbKeyConstant.cartProductCollection)
          .doc(productModel.productId);

      // it is use for accessing subCollection
      FirebaseFirestore.instance
          .collection(DbKeyConstant.cartCollection)
          .doc(uId)
          .set({'uId': uId, 'createdAt': DateTime.now()});

      final data = productModel;
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
      Fluttertoast.showToast(msg: "Add to cart successfully");

      // for total cart product quantity calc
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection(DbKeyConstant.cartCollection)
          .doc(uId)
          .collection(DbKeyConstant.cartProductCollection)
          .get();
      totalCartItem.value = querySnapshot.docs.length;
    } on FirebaseException catch (ex) {
      FirebaseExceptionHelper.exceptionHandler(ex);
    }
  }

  Future<void> calculateTotalCartItem() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection(DbKeyConstant.cartCollection)
          .doc(user!.uid)
          .collection(DbKeyConstant.cartProductCollection)
          .get();
      totalCartItem.value = querySnapshot.docs.length;
    } on FirebaseException catch (ex) {
      FirebaseExceptionHelper.exceptionHandler(ex);
    }
  }

  Future<void> fetchCartItem({String? productId}) async {
    try {
      if (productId == null) {
        // for all cart item fetching
        QuerySnapshot snapshot = await FirebaseFirestore.instance
            .collection(DbKeyConstant.cartCollection)
            .doc(user!.uid)
            .collection(DbKeyConstant.cartProductCollection)
            .get();
        cartItemList.value = snapshot.docs.map((doc) {
          return doc.data() as Map<String, dynamic>;
        }).toList();
      } else {
        // for only one cart item existance checking
        QuerySnapshot snapshot = await FirebaseFirestore.instance
            .collection(DbKeyConstant.cartCollection)
            .doc(user!.uid)
            .collection(DbKeyConstant.cartProductCollection)
            .where(DbKeyConstant.productId, isEqualTo: productId)
            .get();
        if (snapshot.docs.isNotEmpty) {
          itemExistInCart.value = true;
        } else {
          itemExistInCart.value = false;
        }
      }
    } on FirebaseException catch (ex) {
      FirebaseExceptionHelper.exceptionHandler(ex);
    }
  }

  @override
  void onClose() {
    CartController().dispose();
    super.onClose();
  }
}
