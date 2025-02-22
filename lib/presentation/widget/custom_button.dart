import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onTap;
  final double? height;
  final double? width;
  final double? borderWidth;
  final double? radius;
  final Color? buttonColor;
  final Color? borderColor;
  final Color? loderColor;
  final TextStyle? buttonTextStyle;
  final bool? isTextFieldEmpty;
  final bool isLoading;
  final EdgeInsetsGeometry? margin;

  const CustomElevatedButton(
      {super.key,
      required this.buttonText,
      required this.onTap,
      this.height = 50,
      this.width = double.infinity,
      this.radius,
      this.buttonColor,
      this.loderColor = Colors.white,
      this.buttonTextStyle,
      this.isTextFieldEmpty = true,
      this.margin,
      this.isLoading = false,
      this.borderWidth,
      this.borderColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      height: height!,
      width: width!,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: isTextFieldEmpty == true
                  ? buttonColor ?? Colors.red
                  : Colors.red,
              shape: RoundedRectangleBorder(
                  side: BorderSide(
                      width: borderWidth ?? 1,
                      color: borderColor ?? Colors.red),
                  borderRadius: BorderRadius.circular(radius ?? 10))),
          onPressed: onTap,
          child: (isLoading == true)
              ? Visibility(
                  visible: isLoading,
                  child: Container(
                    width: height! / 1.5,
                    height: height! / 1.18,
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: CircularProgressIndicator(
                      color: loderColor,
                      // backgroundColor: Colors.whi,
                    ),
                  ))
              : Text(buttonText,
                  style: isTextFieldEmpty == true
                      ? buttonTextStyle ?? const TextStyle(fontSize: 16)
                      : const TextStyle(fontSize: 16))),
    );
  }
}

class CustomQuantityButton extends StatelessWidget {
  final VoidCallback? onPlusTap;
  final VoidCallback? onMinusTap;
  final String? quantity;
  final double? height;
  final double? width;
  final double? radius;
  final double? iconSize;
  final Color? buttonColor;
  final Color? iconColor;
  final TextStyle? quantityStyle;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;

  const CustomQuantityButton({
    super.key,
    this.height = 32,
    this.width = 152,
    this.radius,
    this.buttonColor,
    this.quantityStyle,
    this.margin,
    this.onPlusTap,
    this.onMinusTap,
    this.quantity = "1",
    this.padding,
    this.iconColor,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: margin,
        height: height!,
        width: width!,
        padding: padding ??
            const EdgeInsets.symmetric(
              horizontal: 8,
            ),
        decoration: BoxDecoration(
            color: buttonColor,
            border: Border.all(color: Colors.green),
            borderRadius: BorderRadius.circular(radius ?? 10)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
                onTap: onMinusTap,
                child: Icon(
                  Icons.remove,
                  color: iconColor ?? Colors.green,
                  size: iconSize,
                )),
            Text(
              quantity!,
              style: quantityStyle ?? const TextStyle(fontSize: 16),
            ),
            InkWell(
                onTap: onPlusTap,
                child: Icon(
                  Icons.add,
                  color: iconColor ?? Colors.red,
                  size: iconSize,
                ))
          ],
        ));
  }
}
