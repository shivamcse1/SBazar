import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:s_bazar/controllers/home_controller.dart';
import 'package:s_bazar/core/constant/app_const.dart';
import 'package:s_bazar/core/constant/database_key_const.dart';
import 'package:s_bazar/core/constant/image_const.dart';
import 'package:s_bazar/presentation/widget/custom_app_bar.dart';
import 'package:s_bazar/presentation/widget/custom_image.dart';

import 'category_screen_view.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  int selcectedIndex = 0;
  final HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        appBarColor: AppConstant.appPrimaryColor,
        title: "Category",
        isTitleCentered: true,
        titleStyle: const TextStyle(color: Colors.white),
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            child: IntrinsicHeight(
              child: NavigationRail(
                elevation: 5,
                backgroundColor: Colors.pink.shade50,
                selectedIndex: selcectedIndex,
                onDestinationSelected: (int index) {
                  setState(() {
                    selcectedIndex = index;
                  });
                },
                labelType: NavigationRailLabelType.all,
                destinations: List.generate(
                  homeController.categoryList.length + 1,
                  (index) => NavigationRailDestination(
                      icon: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomImage(
                            height: 50,
                            image: index == 0
                                ? "assets/images/shopping_bag_img.png"
                                : homeController.categoryList[index - 1]
                                    [DbKeyConstant.categoryImg],
                            imageFit: BoxFit.cover,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            index == 0
                                ? "All"
                                : homeController.categoryList[index - 1]
                                    [DbKeyConstant.categoryName],
                            style: TextStyle(
                                fontSize: index == selcectedIndex ? 14 : 13,
                                color: index == selcectedIndex
                                    ? Colors.redAccent
                                    : Colors.grey),
                          )
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 0),
                      selectedIcon: Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                        ),
                        padding: const EdgeInsets.only(
                            left: 20, right: 20, top: 10, bottom: 5),
                        child: Column(
                          children: [
                            CustomImage(
                              height: 60,
                              image: index == 0
                                  ? "assets/images/shopping_bag_img.png"
                                  : homeController.categoryList[index - 1]
                                      [DbKeyConstant.categoryImg],
                              backgroundColor: Colors.pink.shade200,
                              imageFit: BoxFit.cover,
                              shape: BoxShape.circle,
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            Text(
                                index == 0
                                    ? "All"
                                    : homeController.categoryList[index - 1]
                                        [DbKeyConstant.categoryName],
                                style: TextStyle(
                                  fontSize: index == selcectedIndex ? 14 : 13,
                                  color: index == selcectedIndex
                                      ? Colors.redAccent
                                      : Colors.grey,
                                  fontWeight: index == selcectedIndex
                                      ? FontWeight.w500
                                      : FontWeight.normal,
                                )),
                          ],
                        ),
                      ),
                      label: const SizedBox()),
                ),
              ),
            ),
          ),
          Expanded(
              child: CategoryScreenView(
            categoryId: selcectedIndex == 0
                ? null
                : homeController.categoryList[selcectedIndex - 1]
                    [DbKeyConstant.categoryId],
          ))
        ],
      ),
    );
  }
}
