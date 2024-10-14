import 'package:e_commerce/presentation/view/user_panel/all_category_screen.dart';
import 'package:e_commerce/presentation/widget/custom_drawer.dart';
import 'package:e_commerce/presentation/widget/custom_heading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constant/app_const.dart';
import '../../widget/custom_category_item.dart';
import '../../widget/custom_flash_sale.dart';
import '../../widget/custom_slider.dart';

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
                  onPressed: () async {
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
      body:SingleChildScrollView(
        child: Column(
          children: [
            
          CustomSlider(), 
          CustomHeading(
            onTap: (){
               Get.to( ()=> const AllCategoryScreen());
            },
            categoryTitle: "Categories",
            categorySubTitle: "According to your budget",
            ),
           const CustomCategoryItem(),
        
           CustomHeading(
            onTap: (){
        
            },
            categoryTitle: "Flash Sale",
            categorySubTitle: "According to your budget",
            ),
        
            const CustomFlashSale()
        
        
        
          ],
        ),
      ),
    );
  }
}
