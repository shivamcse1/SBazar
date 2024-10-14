// ignore_for_file: avoid_unnecessary_containers
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:e_commerce/core/constant/image_const.dart';
import 'package:e_commerce/presentation/view/admin_panel/home_screen.dart';
import 'package:e_commerce/presentation/view/auth_ui/welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../contollers/check_user_data_controller.dart';
import '../../../core/constant/app_const.dart';
import '../user_panel/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  late StreamSubscription <List<ConnectivityResult>> subscription ;
  bool isConnected = false;
 User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 3),(){
       getUserInfo();
    });
  }

  Future<void> getUserInfo() async{
   final CheckUserDataController checkUserDataController = Get.put(CheckUserDataController());
      if(user!=null){
         var userData = await checkUserDataController.getUserData(user!.uid);
          if(userData[0]['isAdmin']== true){

             Get.offAll(() => const AdminHomeScreen());
          }
          else{
            Get.offAll(() => const UserHomeScreen());
          }
      }
      else
      {
       Get.off(()=>const WelcomeScreen());
      }
  }

  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor:AppConstant.appPrimaryColor,
      appBar: AppBar(
        backgroundColor: AppConstant.appPrimaryColor,
      ),
      
      body: Container(
        child: Column(
        children: [

           Expanded(
             child: Container(
              alignment:Alignment.center,
              width: Get.width,
              child: Lottie.asset(ImageConstant.loginImg,
              width: 300,
              height: 300
              ),
              ),
           ),
            Container(
              margin: const EdgeInsets.only(bottom: 20.0),
              width: Get.width,
              alignment:Alignment.center,
              child: Text(AppConstant.appPoweredBy,
               style: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.bold,
                color: AppConstant.whiteColor
               ),
              ),

            )

        ],
        ),
        ),
    );
  }
}