import 'package:s_bazar/presentation/view/auth_ui/forgot_password_screen.dart';
import 'package:s_bazar/presentation/view/auth_ui/sign_in_screen.dart';
import 'package:s_bazar/presentation/view/auth_ui/sign_up_screen.dart';
import 'package:s_bazar/presentation/view/auth_ui/splash_screen.dart';
import 'package:s_bazar/presentation/view/auth_ui/welcome_screen.dart';
import 'package:s_bazar/presentation/view/user_panel/cart/cart_screen.dart';
import 'package:s_bazar/presentation/view/user_panel/category/all_category_product_screen.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

import '../../presentation/view/admin_panel/admin_home_screen.dart';
import '../../presentation/view/user_panel/flash_sale/all_flash_sale_product_screen.dart';
import '../../presentation/view/user_panel/category/all_category_screen.dart';
import '../../presentation/view/user_panel/checkout/checkout_screen.dart';
import '../../presentation/view/user_panel/details/details_screen.dart';
import '../../presentation/view/user_panel/home/user_home_screen.dart';
import '../../presentation/view/user_panel/order/order_screen.dart';
import '../../presentation/view/user_panel/product/all_product_screen.dart';
import '../../presentation/view/user_panel/review/review_screen.dart';

class AppRoutes {
  static String splashScreen = '/';
  static String welcomeScreen = '/welcomeScreen';
  static String signInScreen = '/signInScreen';
  static String signupScreen = '/signupScreen';
  static String forgotPasswordScreen = '/forgotPasswordScreen';
  static String allProductScreen = '/allProductScreen';
  static String cartScreen = '/cartScreen';
  static String allCategoryProductScreen = '/allCategoryProductScreen';
  static String allCategoryScreen = '/allCategoryScreen';
  static String checkOutScreen = '/checkOutScreen';
  static String detailsScreen = '/detailsScreen';
  static String allFlashSaleProductScreen = '/allFlashSaleProductScreen';
  static String userHomeScreen = '/userHomeScreen';
  static String adminHomeScreen = '/adminHomeScreen';
  static String myOrderScreen = '/myOrderScreen';
  static String orderReviewScreen = '/orderReviewScreen';

  static List<GetPage<dynamic>>? pages = [
    GetPage(name: splashScreen, page: () => const SplashScreen()),
    GetPage(name: welcomeScreen, page: () => const WelcomeScreen()),
    GetPage(name: signInScreen, page: () => const SignInScreen()),
    GetPage(name: signupScreen, page: () => const SignUpScreen()),
    GetPage(
        name: forgotPasswordScreen, page: () => const ForgotPasswordScreen()),
    GetPage(name: allProductScreen, page: () => const AllProductScreen()),
    GetPage(name: cartScreen, page: () => const CartScreen()),
    GetPage(
        name: allCategoryProductScreen, page: () => AllCategoryProductScreen()),
    GetPage(name: allCategoryScreen, page: () => const AllCategoryScreen()),
    GetPage(name: checkOutScreen, page: () => const CheckOutScreen()),
    GetPage(name: detailsScreen, page: () => DetailsScreen()),
    GetPage(
        name: allFlashSaleProductScreen,
        page: () => const AllFlashSaleProductScreen()),
    GetPage(name: userHomeScreen, page: () => const UserHomeScreen()),
    GetPage(name: myOrderScreen, page: () => const OrderScreen()),
    GetPage(name: orderReviewScreen, page: () => const ReviewScreen()),
    GetPage(name: adminHomeScreen, page: () => const AdminHomeScreen()),
  ];
}
