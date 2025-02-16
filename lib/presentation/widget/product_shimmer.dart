import 'package:flutter/material.dart';
import 'custom_shimmer_container.dart';

class ProductShimmer extends StatelessWidget {
  final double height;
  final double width;
  const ProductShimmer({
    super.key,
    this.height = 205,
    this.width = 190,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: 5,
          ),
          CustomShimmerContainer(
            height: height - 40,
            width: width,
          ),
          const SizedBox(
            height: 8.0,
          ),
          CustomShimmerContainer(
            height: 20,
            width: width,
          ),
        ],
      ),
    );
  }
}
