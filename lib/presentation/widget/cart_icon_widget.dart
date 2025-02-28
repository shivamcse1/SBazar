import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../controllers/cart_controller.dart';
import '../../core/constant/color_const.dart';
import '../view/user_panel/cart/cart_screen.dart';

class CartIconWidget extends StatefulWidget {
  final int index;
  final bool isbottomNavBar;
  const CartIconWidget(
      {super.key, this.index = -1, this.isbottomNavBar = false});

  @override
  State<CartIconWidget> createState() => CartIconWidgetState();
}

class CartIconWidgetState extends State<CartIconWidget> {
  CartController cartController = Get.put(CartController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Stack(
        children: [
          GestureDetector(
              onTap: widget.isbottomNavBar != true
                  ? () {
                      Get.to(
                        () => const CartScreen(),
                      );
                    }
                  : null,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Icon(
                  widget.isbottomNavBar != true
                      ? Icons.shopping_cart
                      : widget.index == 2
                          ? Icons.shopping_cart
                          : Icons.shopping_cart_outlined,
                  color: widget.isbottomNavBar != true
                      ? Colors.white
                      : widget.index == 2
                          ? ColorConstant.pinkColor
                          : Colors.black,
                ),
              )),
          cartController.totalCartItem.value > 0
              ?
               Positioned(
                  top: 1,
                  right: 5,
                  child: Container(
                    height: 15,
                    width: 15,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.pink,
                    ),
                    child: Center(
                      child: Text(
                        cartController.totalCartItem.value.toString(),
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                )
            
            
              : const SizedBox()
        ],
      ),
    );
  }
}
