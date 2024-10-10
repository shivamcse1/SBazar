import 'package:e_commerce/firebase_options.dart';
import 'package:e_commerce/presentation/view/auth_ui/sign_in_screen.dart';
import 'package:e_commerce/presentation/view/auth_ui/splash_screen.dart';
import 'package:e_commerce/presentation/view/auth_ui/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import 'presentation/view/auth_ui/sign_up_screen.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();

    await Firebase.initializeApp(
    options:DefaultFirebaseOptions.currentPlatform );
    runApp(const MyApp());
 
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // home: const SignUpScreen(),
      initialRoute: '/',
      builder: EasyLoading.init(),
      getPages: [
        GetPage(
          name: '/', 
          page: ()=> const SplashScreen()
          ),

        GetPage(
           name: '/welcomeScreen',
           page: ()=> const WelcomeScreen()
          ),

        GetPage(
          name: '/signUpScreen', 
          page: ()=> const SignUpScreen()
          ),

        GetPage(
          name: '/signInScreen', 
          page: ()=> const SignInScreen()
          ),
        

      ],
    );
  }
}

