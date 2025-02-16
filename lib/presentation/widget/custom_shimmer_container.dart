import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CustomShimmerContainer extends StatelessWidget {
  final double height;
  final double width;
  final double radius;
  final bool shimmerEnable;
  final EdgeInsetsGeometry? margin;
  final BoxShape? shape;
  final ShimmerDirection? shimerDirection;
  const CustomShimmerContainer({
    super.key,
    this.height = 120,
    this.width = 150,
    this.shape,
    this.radius = 8,
    this.shimerDirection,
    this.shimmerEnable = true,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Shimmer.fromColors(
        enabled: shimmerEnable,
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        direction: shimerDirection ?? ShimmerDirection.ltr,
        child: Container(
          margin: margin,
          height: height,
          width: width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            color: Colors.white,
            shape: shape ?? BoxShape.rectangle,
          ),
        ),
      ),
    );
  }
}
