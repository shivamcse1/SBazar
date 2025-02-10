import 'package:s_bazar/presentation/view/user_panel/category/all_category_screen.dart';
import 'package:s_bazar/presentation/view/user_panel/all_flash_sale/all_flash_sale_product_screen.dart';
import 'package:s_bazar/presentation/view/user_panel/all_product/all_product_screen.dart';
import 'package:s_bazar/presentation/view/user_panel/cart/cart_screen.dart';
import 'package:s_bazar/presentation/widget/custom_drawer.dart';
import 'package:s_bazar/presentation/widget/custom_heading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constant/app_const.dart';
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
        actions: [
          Stack(
            children: [
              IconButton(
                  onPressed: () {
                    Get.to(() => const CartScreen());
                  },
                  icon: const Icon(
                    Icons.shopping_cart,
                    color: Colors.white,
                  )),
            ],
          )
        ],
      ),
      drawer: const CustomDrawer(),
      body: SingleChildScrollView(
        // physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            CustomSlider(),
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
