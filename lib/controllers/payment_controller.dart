// ignore_for_file: unused_element, unnecessary_overrides, avoid_print

import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:s_bazar/controllers/order_controller.dart';
import 'package:s_bazar/core/constant/database_key_const.dart';
import 'package:s_bazar/data/model/product_model.dart';
import 'package:s_bazar/presentation/view/user_panel/order/order_success_screen.dart';
import 'package:s_bazar/utils/Uihelper/ui_helper.dart';

class PaymentController extends GetxController {
  final Razorpay _razorPay = Razorpay();
  Map<String, dynamic> userInfo = {};
  ProductModel? productModel;

  final OrderController orderController = Get.put(OrderController());
  @override
  void onInit() {
    super.onInit();
    _razorPay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    _razorPay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorPay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
  }

  @override
  void onClose() {
    _razorPay.clear();
    super.onClose();
  }

  Future<void> getPayment(
      {Map<String, dynamic>? paymentData, ProductModel? model}) async {
    try {
      userInfo = paymentData!;
      productModel = model;

      var options = {
        'key': DbKeyConstant.razorpayKey,
        'amount': paymentData[DbKeyConstant.productTotalPrice],
        'name': 'SBazar',
        'currency': 'INR',
        'description': "",
        'prefill': {
          'contact': paymentData[DbKeyConstant.userPhone],
        },
        'external': {
          'wallets': ['paytm', 'phonepe', 'amazonpay'],
        }
      };
      _razorPay.open(options);
    } catch (ex) {
      UiHelper.customSnackbar(
        titleMsg: "Error Occured",
        msg: ex.toString(),
      );
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    try {
      if (productModel != null) {
        orderController.placeOrder(
            userName: userInfo[DbKeyConstant.userName],
            userPhone: userInfo[DbKeyConstant.userPhone],
            userAddress: userInfo[DbKeyConstant.userAddress],
            productModel: productModel);
      } else {
        orderController.placeOrder(
          userName: userInfo[DbKeyConstant.userName],
          userPhone: userInfo[DbKeyConstant.userPhone],
          userAddress: userInfo[DbKeyConstant.userAddress],
        );
      }

      UiHelper.customToast(
        msg: "Order Placed Successfully",
      );
      Get.offAll(() => OrderSuccessScreen(
            paymentMode: "Online",
            totalAmount:
                ((userInfo[DbKeyConstant.productTotalPrice]) / 100).toString(),
          ));
    } catch (ex) {
      UiHelper.customSnackbar(
        titleMsg: "Payment Successfull",
        msg: "Order Place Failed!",
      );
      print(ex);
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    UiHelper.customSnackbar(
      titleMsg: "Payment Failed",
      msg: "Order Place Failed Try Again",
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    UiHelper.customSnackbar(
      titleMsg: "External Wallet",
      msg: "Order Placed With ${response.walletName} Wallet",
    );
    // Get.offAll(() => const UserHomeScreen());
  }
}
