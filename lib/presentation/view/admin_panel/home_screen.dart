import 'package:e_commerce/presentation/view/auth_ui/welcome_screen.dart';
import 'package:e_commerce/utils/Uihelper/custom_snakbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../core/constant/app_const.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => AdminHomeScreenState();
}

class AdminHomeScreenState extends State<AdminHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar:AppBar(
        iconTheme: IconThemeData(color: AppConstant.whiteColor),
        backgroundColor: AppConstant.appPrimaryColor,
        title: Text('Admin',style: TextStyle(color: AppConstant.whiteColor),),
        centerTitle: true,

        actions:[

        IconButton(
        onPressed: () async{
           
          // only signout from firebase not email
          await FirebaseAuth.instance.signOut();
          
          // signout from email so that next time you need to select email again 
          await GoogleSignIn().signOut();
          
          Get.offAll(() => const WelcomeScreen() );
           SnackbarHelper.customSnackbar(titleMsg: "Logout", msg: "User Logout Successfull");
        }, 
        icon: const Icon(Icons.logout,color: Colors.white,)
        )
        ],
      )
    );
  }
}