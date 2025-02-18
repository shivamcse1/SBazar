// ignore_for_file: unused_element, unnecessary_overrides

import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:s_bazar/controllers/order_controller.dart';
import 'package:s_bazar/core/constant/database_key_const.dart';
import 'package:s_bazar/presentation/view/user_panel/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:s_bazar/utils/Uihelper/ui_helper.dart';

class PaymentController extends GetxController {
  final Razorpay _razorPay = Razorpay();
  Map<String, dynamic> userInfo = {};

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

  Future<void> getPayment({Map<String, dynamic>? userData}) async {
    try {
      userInfo = userData!;
      var options = {
        'key': DbKeyConstant.razorpayKey,
        'amount': 10000,
        'name': 'SBazar',
        'currency': 'INR',
        'description': '',
        'prefill': {
          'contact': userData[DbKeyConstant.userPhone],
          'email': userData[DbKeyConstant.userEmail],
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
    orderController.placeOrder(
        context: userInfo[DbKeyConstant.context],
        userName: userInfo[DbKeyConstant.userName],
        userPhone: userInfo[DbKeyConstant.userPhone],
        userAddress: userInfo[DbKeyConstant.userAddress],
        userDeviceToken: userInfo[DbKeyConstant.userDeviceToken]);

    UiHelper.customSnackbar(
      titleMsg: "Payment Successful",
      msg: "Order Successful Placed",
    );
    Get.offAll(() => const BottomNavBar());
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
