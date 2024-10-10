import 'package:e_commerce/presentation/view/auth_ui/sign_in_screen.dart';
import 'package:e_commerce/presentation/view/auth_ui/sign_up_screen.dart';
import 'package:e_commerce/presentation/view/auth_ui/splash_screen.dart';
import 'package:e_commerce/presentation/view/auth_ui/welcome_screen.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

class AppRoutes{

  static String splashScreen = '/';
  static String welcomeScreen = '/welcomeScreen';
  static String signInScreen = '/signInScreen';
  static String signupScreen = '/signupScreen';



  static List<GetPage<dynamic>>? pages = [
    
    GetPage(
      name: splashScreen, 
      page: () => const SplashScreen()
      ),

      GetPage(
      name: welcomeScreen, 
      page: () => const WelcomeScreen() 
      ),

      GetPage(
      name: signInScreen, 
      page: () => const SignInScreen()
      ),

      GetPage(
      name: signupScreen, 
      page: () => const SignUpScreen()
      ),


  ];


}