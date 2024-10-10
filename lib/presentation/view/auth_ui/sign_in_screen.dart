// ignore_for_file: avoid_unnecessary_containers, unnecessary_null_comparison, unused_local_variable

import 'package:e_commerce/contollers/sign_in_controller.dart';
import 'package:e_commerce/core/constant/image_const.dart';
import 'package:e_commerce/presentation/view/admin_panel/home_screen.dart';
import 'package:e_commerce/presentation/view/auth_ui/forgot_password_screen.dart';
import 'package:e_commerce/presentation/view/auth_ui/sign_up_screen.dart';
import 'package:e_commerce/presentation/view/user_panel/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../contollers/check_user_data_controller.dart';
import '../../../core/constant/app_const.dart';
import '../../../utils/Uihelper/custom_snakbar.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => SignInScreenState();
}

class SignInScreenState extends State<SignInScreen> {
 final SignInController signInController = Get.put(SignInController());
 final CheckUserDataController checkUserDataController = Get.put(CheckUserDataController());

  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(
      builder: (context,isKeyboardvisible){
       return Scaffold(
         appBar: AppBar(
          backgroundColor: AppConstant.appSecondaryColor,
          title: Text("Sign In",
          style: TextStyle(color: AppConstant.whiteColor),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          physics:const  BouncingScrollPhysics(),
          child: Container(
            child: Column(
              children: [
                Column(
                  children: [
                     Container(
                      color: AppConstant.appSecondaryColor,
                      height: Get.height/2.5,
                      width: Get.width,
                      child: Lottie.asset(ImageConstant.loginImg),
                    ),
                  ],
                ),
                SizedBox(height: Get.height/20,),
                Container(
                  margin: const EdgeInsets.only(left: 10,right: 10),
                  padding: const EdgeInsets.symmetric(horizontal:10,vertical: 10 ),
                  child: TextFormField(
                    controller: signInController.emailController,
                    cursorColor: AppConstant.appSecondaryColor,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      prefixIcon:const Icon(Icons.email),
                      hintText: "Email",
                      contentPadding:const EdgeInsets.only(top: 2.0,left: 8.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0)
                      )
                    ),
                  ),
                ),
                
                  Container(
                  margin: const EdgeInsets.only(left: 10,right: 10),
                  padding: const EdgeInsets.symmetric(horizontal:10,vertical: 10 ),
                  child: Obx(() =>  TextFormField(
                    controller: signInController.passwordController,
                    obscureText:  signInController.isPasswordVisible.value,
                    cursorColor: AppConstant.appSecondaryColor,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: InputDecoration(
                      prefixIcon:const Icon(Icons.password),
                      suffixIcon: IconButton(onPressed: (){
                         signInController.isPasswordVisible.toggle();
                      },
                      icon: Icon(
                        signInController.isPasswordVisible.value 
                        ? Icons.visibility_off
                        : Icons.visibility ),
                      ),
                      hintText: "Password",
                      contentPadding:const EdgeInsets.only(top: 2.0,left: 8.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0)
                      )
                    ),
                  ),
               )
                  
                  
                ),

                GestureDetector(
                  onTap: (){

                    Get.to( () => const ForgotPasswordScreen() );
                  },
                  child: Container(
                    margin:const EdgeInsets.only(right: 20),
                    alignment: Alignment.centerRight,
                    child: Text("Forgot Password",
                    style: TextStyle(
                      color: AppConstant.appSecondaryColor,
                      fontWeight: FontWeight.bold),),),
                ),
             
            SizedBox(height: Get.height/25,), 
            Container(
              height: Get.height/18,
              width: Get.width/1.8,
              decoration: BoxDecoration(
                color: AppConstant.appPrimaryColor,
                borderRadius: BorderRadius.circular(20.0)
              ),
              child: TextButton(
                onPressed: () async{
                    
                    String email = signInController.emailController.value.text.trim();
                    String password = signInController.passwordController.value.text.trim();

                    if(email.isEmpty || password.isEmpty){

                      SnackbarHelper.customSnackbar(
                      titleMsg: "Error occured", msg: "Please Enter All Details"
                      );
                    }
                    else{
                       UserCredential? userCredential = await signInController.signInUser(
                       userEmail : email, 
                       userPassword: password
                       );

                      final userData = await checkUserDataController.getUserData(userCredential!.user!.uid);
                       if(userCredential != null){
                          
                          if(userCredential.user!.emailVerified){
                             
                             if(userData[0]["isAdmin"]== true){

                              Get.offAll(()=> const AdminHomeScreen());
                              SnackbarHelper.customSnackbar(
                              titleMsg: "Congratulations! Admin", msg: "Sign In Successfull!"
                              );

                             } else{

                              Get.offAll( () =>const UserHomeScreen());
                              SnackbarHelper.customSnackbar(
                              titleMsg: "Congratulations! User", msg: "Sign In Successfull!"
                              );

                             }
                            }else{
                              SnackbarHelper.customSnackbar(
                              titleMsg: "Error occured", msg: "Please Verify Email Before Sign In"
                              );

                          }
                       } 
                    }
                },
               child: Text("SIGN IN",
               style: TextStyle(color: AppConstant.whiteColor),
               ),
              ),
            ),  
           
            SizedBox(height: Get.height/30,), 
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Don't have an account? ",
                style: TextStyle(color: AppConstant.appSecondaryColor,
               
                ),
                ),

                GestureDetector(
                  onTap: (){
                    Get.offAll(()=> const SignUpScreen());
                  },
                  child: Text("Sign Up",
                  style: TextStyle(color: AppConstant.appSecondaryColor,
                  fontWeight: FontWeight.bold
                  ),
                  ),
                )
              ],
            ) 
          
              ],
            ),
          ),
        )
          
        
      );
      },
      
    );
  }
}