import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../controllers/cart_controller.dart';
import '../view/user_panel/cart/cart_screen.dart';

class CartIconWidget extends StatefulWidget {
  const CartIconWidget({super.key});

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
          IconButton(
            onPressed: () {
              Get.to(
                () => const CartScreen(),
              );
            },
            icon: const Icon(
              Icons.shopping_cart,
              color: Colors.white,
            ),
          ),
          cartController.totalCartItem.value > 0
              ? Positioned(
                  top: 7,
                  right: 7,
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
