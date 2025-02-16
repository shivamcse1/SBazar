import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:s_bazar/core/constant/app_const.dart';
import 'package:s_bazar/core/constant/color_const.dart';
import 'package:s_bazar/core/constant/image_const.dart';
import 'package:s_bazar/presentation/view/user_panel/home/user_home_screen.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: UserHomeScreen(),
        bottomNavigationBar: NavigationBar(
          backgroundColor: Colors.transparent,
          selectedIndex: currentIndex,
          onDestinationSelected: (value) {
            setState(() {
              currentIndex = value;
            });
          },
          height: 65,
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
                icon: Icon(
                  currentIndex == 2
                      ? Icons.shopping_cart
                      : Icons.shopping_cart_outlined,
                  color: currentIndex == 2
                      ? ColorConstant.pinkColor
                      : Colors.black,
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
