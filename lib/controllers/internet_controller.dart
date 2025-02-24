// ignore_for_file: unused_catch_clause

import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:s_bazar/presentation/widget/no_internet_connection_widget.dart';
import 'package:s_bazar/utils/Uihelper/ui_helper.dart';

class InternetController extends GetxController {
  RxBool internetStatus = true.obs;
  RxBool isLoading = false.obs;
  final Connectivity connecivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> subscription;

  @override
  void onInit() {
    super.onInit();
    checkConnection();
    listenConnectivity();
  }

  //!----using connectvity plus pakcgae (it use OS of device not use multiple call)----------------//

  // 1. for checking current time connectivity of device when it call
  Future<void> checkConnection() async {
    await Future.delayed(const Duration(seconds: 1));
    List<ConnectivityResult> result = await connecivity.checkConnectivity();
    if (result.contains(ConnectivityResult.mobile)) {
    } else if (result.contains(ConnectivityResult.wifi)) {
    } else if (result.contains(ConnectivityResult.ethernet)) {
    } else if (result.isEmpty || result.contains(ConnectivityResult.none)) {
      UiHelper.customToast(
          msg: "No Internet Connection", toastGravity: ToastGravity.BOTTOM);
      Get.to(() => const NoInternetConnectionWidget());
    }
  }

  // 2. for checking real time connectivity if device

  void listenConnectivity() {
    subscription = connecivity.onConnectivityChanged
        .listen((List<ConnectivityResult> result) {
      if (result.contains(ConnectivityResult.mobile)) {
        internetStatus.value = true;
        UiHelper.customToast(
          msg: "Connected to Mobile Data",
          toastGravity: ToastGravity.BOTTOM,
        );
      } else if (result.contains(ConnectivityResult.wifi)) {
        internetStatus.value = true;
        UiHelper.customToast(
          msg: "Connected to WiFi",
          toastGravity: ToastGravity.BOTTOM,
        );
      } else if (result.contains(ConnectivityResult.ethernet)) {
        internetStatus.value = true;
        UiHelper.customToast(
          msg: "Connected Via Ethernet",
          toastGravity: ToastGravity.BOTTOM,
        );
      } else if (result.isEmpty || result.contains(ConnectivityResult.none)) {
        internetStatus.value = false;
        isLoading.value = false;
        UiHelper.customToast(
          msg: "No Internet Connection",
          toastGravity: ToastGravity.BOTTOM,
        );
        Get.to(() => const NoInternetConnectionWidget());
      }
    });
  }
  //!---------  without using external pakcgae ----------------//

  //1. continue listen using periodic function
  void listenInternetConnection() {
    try {
      Timer.periodic(const Duration(seconds: 5), (timer) async {
        internetStatus.value = await fetchInternetStatus();
        if (internetStatus.value == false) {
          Get.to(
            () => const NoInternetConnectionWidget(),
            transition: Transition.fade,
          );
        }
      });
    } catch (ex) {
      UiHelper.customToast(msg: "Something Went Wrong");
    }
  }

  //2. DNS Resolution it may use cache DNS record
  Future<bool> getInternetStatus() async {
    try {
      var ipAddress = await InternetAddress.lookup("google.com");
      if (ipAddress.isNotEmpty && ipAddress[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (ex) {
      UiHelper.customToast(msg: "No Internet Connection Available");
      return false;
    }
    return false;
  }

  // ye direct uske DNS server se connect karta hai agr nahi connect hua to
  //3. internet nahi hai jo error throw karega
  Future<bool> fetchInternetStatus() async {
    try {
      // ye google ka "8.8.8.8" public DNS Ip hai aur 53 DNS service Port Ka number hai
      final socket = await Socket.connect("8.8.8.8", 53,
          timeout: const Duration(seconds: 4));
      socket.destroy();
      return true;
    } catch (ex) {
      return false;
    }
  }
}
