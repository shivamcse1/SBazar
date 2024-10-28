// ignore_for_file: avoid_unnecessary_containers

import 'package:e_commerce/controllers/email_sign_up_controller.dart';
import 'package:e_commerce/core/constant/color_const.dart';
import 'package:e_commerce/presentation/view/auth_ui/sign_in_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';

import '../../../core/constant/app_const.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  final EmailSignUpController emailSignUpController = Get.put(EmailSignUpController());
  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(
      builder: (context,isKeyboardvisible){
       return Scaffold(
         appBar: AppBar(
          iconTheme: IconThemeData(color: ColorConstant.whiteColor),
          backgroundColor: AppConstant.appSecondaryColor,
          title: Text("Sign Up",
          style: TextStyle(color: AppConstant.whiteColor),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          physics:const  BouncingScrollPhysics(),
          child: Container(
            child: Column(
              children: [

                SizedBox(height: Get.height/25,),

                Container(
                  alignment: Alignment.center,
                  child: Text("Welcome to My App",
                   style: TextStyle(color: AppConstant.appSecondaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0
                    ),
                  ),
                ),
                SizedBox(height: Get.height/25,), 

                Container(
                  margin: const EdgeInsets.only(left: 10,right: 10),
                  padding: const EdgeInsets.symmetric(horizontal:10,vertical: 10 ),
                  child: TextFormField(
                    controller: emailSignUpController.emailController,
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
                  child: TextFormField(
                    controller:  emailSignUpController.userNameController,
                    cursorColor: AppConstant.appSecondaryColor,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      prefixIcon:const Icon(Icons.person),
                      hintText: "UserName",
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
                  child: TextFormField(
                    controller:  emailSignUpController.phoneController,
                    cursorColor: AppConstant.appSecondaryColor,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      prefixIcon:const Icon(Icons.phone),
                      hintText: "Phone",
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
                  child: TextFormField(
                    controller:  emailSignUpController.cityController,
                    cursorColor: AppConstant.appSecondaryColor,
                    keyboardType: TextInputType.streetAddress,
                    decoration: InputDecoration(
                      prefixIcon:const Icon(Icons.location_pin),
                      hintText: "City",
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
                  child: 
                  Obx(() => TextFormField(
                    obscureText:  emailSignUpController.isPasswordVisible.value,
                    controller:  emailSignUpController.passwordController,
                    cursorColor: AppConstant.appSecondaryColor,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      prefixIcon:const Icon(Icons.password),
                      suffixIcon: IconButton(
                        onPressed: (){
                         emailSignUpController.isPasswordVisible.toggle();

                      },
                      icon: Icon(
                        emailSignUpController.isPasswordVisible.value 
                        ? Icons.visibility_off
                        :  Icons.visibility
                        
                        ),
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
             
                SizedBox(height: Get.height/20,), 
                Container(
                  height: Get.height/18,
                  width: Get.width/1.8,
                  decoration: BoxDecoration(
                    color: AppConstant.appPrimaryColor,
                    borderRadius: BorderRadius.circular(20.0)
                  ),
                  child: TextButton(
                    onPressed: () async{

                      String userName = emailSignUpController.userNameController.text.trim();
                      String userPhone = emailSignUpController.phoneController.text.trim();
                      String userEmail = emailSignUpController.emailController.text.trim();
                      String userPassword = emailSignUpController.passwordController.text.trim();
                      String userCity = emailSignUpController.cityController.text.trim();
                      String userDeviceToken = '';

                      if(
                        userName == '' ||
                        userEmail == '' ||
                        userPassword == '' ||
                        userCity == '' ||
                        userPhone == '' 
                        )
                      {
                        Get.snackbar(
                        "Error Occured", 
                        'Please Enter All Details!',
                        backgroundColor: AppConstant.appSecondaryColor,
                        colorText: AppConstant.whiteColor,
                        snackPosition: SnackPosition.BOTTOM
                        );
                      }
                      else{
                         
                       UserCredential? userCredential = await emailSignUpController.emailSignUpUser(
                       userName: userName, 
                       userEmail: userEmail, 
                       userPhone: userPhone, 
                       userPassword: userPassword, 
                       userCity: userCity, 
                       userDeviceToken:userDeviceToken);
            
                       
                       if(userCredential !=null){
                        Get.snackbar(
                        "Verification Email Sent On $userEmail", 
                        'Please Verify Email Before Login!',
                        backgroundColor: AppConstant.appSecondaryColor,
                        colorText: AppConstant.whiteColor,
                        snackPosition: SnackPosition.BOTTOM
                        );

                        Get.offAll( () => const SignInScreen());

                       }
                      }
                    },
                  child: Text("SIGN UP",
                  style: TextStyle(color: AppConstant.whiteColor),
                  ),
                  ),
                ),  
           
                SizedBox(height: Get.height/30,), 
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account? ",
                    style: TextStyle(color: AppConstant.appSecondaryColor,
                  
                    ),
                    ),

                    GestureDetector(
                      onTap: (){
                        Get.offAll(()=>const SignInScreen());
                      },
                      child: Text("Sign In",
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