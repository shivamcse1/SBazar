import 'package:flutter/material.dart';

import 'package:s_bazar/core/constant/color_const.dart';

import 'package:s_bazar/presentation/view/user_panel/cart/cart_screen.dart';
import 'package:s_bazar/presentation/view/user_panel/home/user_home_screen.dart';
import 'package:s_bazar/presentation/widget/cart_icon_widget.dart';

import '../account/account_screen.dart';
import '../category/category_screen.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int currentIndex = 0;

  List<Widget> bodyList = [
    const UserHomeScreen(),
    const CategoryScreen(),
    const CartScreen(),
    const AccountScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: bodyList.isNotEmpty && currentIndex < bodyList.length
            ? bodyList[currentIndex]
            :  Center(child: const CircularProgressIndicator()),
        bottomNavigationBar: NavigationBar(
          backgroundColor: Colors.transparent,
          selectedIndex: currentIndex,
          onDestinationSelected: (value) {
            setState(() {
              currentIndex = value;
            });
          },
          height: 60,
          destinations: [
            NavigationDestination(
                icon: Icon(
                  Icons.home,
                  color: currentIndex == 0
                      ? ColorConstant.pinkColor
                      : Colors.black,
                ),
                label: "Home"),
            NavigationDestination(
                icon: Icon(
                  currentIndex == 1
                      ? Icons.dashboard_rounded
                      : Icons.dashboard_outlined,
                  color: currentIndex == 1
                      ? ColorConstant.pinkColor
                      : Colors.black,
                ),
                label: "Category"),
            NavigationDestination(
                icon: CartIconWidget(
                  index: currentIndex,
                  isbottomNavBar: true,
                ),
                label: "Cart"),
            NavigationDestination(
              icon: Icon(
                currentIndex == 3 ? Icons.person : Icons.person_2_outlined,
                color:
                    currentIndex == 3 ? ColorConstant.pinkColor : Colors.black,
              ),
              label: "Account",
            ),
          ],
        ));
  }
}
