// ignore_for_file: prefer_typing_uninitialized_variables, invalid_use_of_protected_member

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

import 'package:s_bazar/controllers/cart_controller.dart';
import 'package:s_bazar/controllers/get_user_data_controller.dart';
import 'package:s_bazar/controllers/home_controller.dart';
import 'package:s_bazar/presentation/view/user_panel/category/all_category_screen.dart';
import 'package:s_bazar/presentation/view/user_panel/flash_sale/all_flash_sale_product_screen.dart';
import 'package:s_bazar/presentation/widget/custom_heading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../controllers/internet_controller.dart';
import '../../../../core/constant/app_const.dart';
import '../../../widget/cart_icon_widget.dart';
import '../../../widget/custom_all_product.dart';
import '../../../widget/custom_category_item.dart';
import '../../../widget/custom_flash_sale.dart';
import '../../../widget/custom_slider.dart';
import '../product/all_product_screen.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({super.key});

  @override
  State<UserHomeScreen> createState() => UserHomeScreenState();
}

class UserHomeScreenState extends State<UserHomeScreen> {
  final GetUserDataController getUserDataController =
      Get.put(GetUserDataController());
  final HomeController homeController = Get.put(HomeController());
  final CartController cartController = Get.put(CartController());
  final InternetController internetController =
      Get.put(InternetController(), permanent: true);

  var userData;
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    cartController.calculateTotalCartItem();
    homeController.fetchBannerImage();
    homeController.fetchCategory();
    homeController.fetchFlashSaleProduct();
    homeController.fetchAllProduct();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppConstant.whiteColor),
        backgroundColor: AppConstant.appPrimaryColor,
        title: Text(
          AppConstant.appMainName,
          style: TextStyle(color: AppConstant.whiteColor),
        ),
        centerTitle: true,
        actions: const [
          CartIconWidget(),
        ],
      ),
      body: SingleChildScrollView(
        // physics: const BouncingScrollPhysics(),
        child: Obx(
          () => Column(
            children: [
              CustomSlider(
                imgList: homeController.bannerImgList,
                autoScroll: true,
              ),
              CustomHeading(
                onTap: () {
                  Get.to(() => const AllCategoryScreen());
                },
                categoryTitle: "Categories",
                categorySubTitle: "According to your budget",
              ),
              CustomCategoryItem(
                categoryList: homeController.categoryList.value,
              ),
              CustomHeading(
                onTap: () {
                  Get.to(() => const AllFlashSaleProductScreen());
                },
                categoryTitle: "Flash Sale",
                categorySubTitle: "According to your budget",
              ),
              CustomFlashSale(
                flashSaleProductList: homeController.flashSaleList.value,
              ),
              CustomHeading(
                onTap: () {
                  Get.to(() => const AllProductScreen());
                },
                categoryTitle: "All Product",
                categorySubTitle: "According to your budget",
              ),
              CustomAllProduct(
                allProductList: homeController.allProductList.value,
              ),
              const SizedBox(
                height: 10,
              )
            ],
          ),
        ),
      ),
    );
  }
}
