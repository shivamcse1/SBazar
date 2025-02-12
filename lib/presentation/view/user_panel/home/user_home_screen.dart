// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:s_bazar/controllers/cart_controller.dart';
import 'package:s_bazar/controllers/get_user_data_controller.dart';
import 'package:s_bazar/presentation/view/user_panel/category/all_category_screen.dart';
import 'package:s_bazar/presentation/view/user_panel/all_flash_sale/all_flash_sale_product_screen.dart';
import 'package:s_bazar/presentation/view/user_panel/all_product/all_product_screen.dart';
import 'package:s_bazar/presentation/widget/custom_drawer.dart';
import 'package:s_bazar/presentation/widget/custom_heading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constant/app_const.dart';
import '../../../widget/cart_icon_widget.dart';
import '../../../widget/custom_all_product.dart';
import '../../../widget/custom_category_item.dart';
import '../../../widget/custom_flash_sale.dart';
import '../../../widget/custom_slider.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({super.key});

  @override
  State<UserHomeScreen> createState() => UserHomeScreenState();
}

class UserHomeScreenState extends State<UserHomeScreen> {
  GetUserDataController getUserDataController =
      Get.put(GetUserDataController());
  var userData;
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
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
      drawer: const CustomDrawer(),
      body: SingleChildScrollView(
        // physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const CustomSlider(
              imgList: [],
              autoScroll: true,
            ),
            CustomHeading(
              onTap: () {
                Get.to(() => const AllCategoryScreen());
              },
              categoryTitle: "Categories",
              categorySubTitle: "According to your budget",
            ),
            const CustomCategoryItem(),
            CustomHeading(
              onTap: () {
                Get.to(() => const AllFlashSaleProductScreen());
              },
              categoryTitle: "Flash Sale",
              categorySubTitle: "According to your budget",
            ),
            const CustomFlashSale(),
            CustomHeading(
              onTap: () {
                Get.to(() => const AllProductScreen());
              },
              categoryTitle: "All Product",
              categorySubTitle: "According to your budget",
            ),
            const CustomAllProduct(),
            const SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }
}
