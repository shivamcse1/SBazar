import 'package:flutter/material.dart';

import '../../core/constant/image_const.dart';

class CustomItem extends StatelessWidget {
  final String? itemName;
  final String? itemImage;
  final TextStyle? itemNameStyle;
  final Color? backGroundColor;
  final double? height;
  final double? width;
  final double? radius;
  final EdgeInsetsGeometry? namePadding;
  final EdgeInsetsGeometry? itemMargin;

  const CustomItem(
      {super.key,
      this.itemName,
      this.itemImage,
      this.itemNameStyle,
      this.backGroundColor,
      this.height = 94,
      this.width = 134,
      this.radius,
      this.namePadding,
      this.itemMargin});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        margin: itemMargin ?? const EdgeInsets.only(right: 5),
        height: height!,
        width: width!,
        padding: namePadding ?? const EdgeInsets.only(left: 8, top: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius ?? 12),
          color: backGroundColor ?? Colors.red.shade400,
        ),
        child: Text(itemName ?? '',
            style: itemNameStyle ?? const TextStyle(fontSize: 14)),
      ),
      Positioned(
          right: 5,
          top: 10,
          child: itemImage == null
              ? Image.asset(
                  ImageConstant.previewIc,
                )
              : Image.asset(itemImage!))
    ]);
  }
}
