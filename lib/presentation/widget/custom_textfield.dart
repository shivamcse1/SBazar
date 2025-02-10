import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class CustomTextField extends StatelessWidget {
  final bool? focus;
  final bool? readOnly;
  final TextAlign? contentAlign;
  final double? height;
  final double? width;
  final String? labelText;
  final String? hintText;
  final Widget? prefix;
  final Widget? suffix;
  final double? radius;
  final Color? enableBorderColor;
  final Color? backGroundColor;
  final Color? focusBorderColor;
  final TextStyle? labelStyle;
  final TextStyle? hintStyle;
  final TextStyle? contentStyle;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  // final EdgeInsetsGeometry? contentPadding;
  final int? maxDigitLength;
  final Function(String)? onChanged;

  const CustomTextField(
      {super.key,
      this.height = 56,
      this.width = 343,
      this.labelText,
      this.prefix,
      this.suffix,
      this.radius,
      this.enableBorderColor,
      this.focusBorderColor,
      this.labelStyle,
      this.controller,
      this.keyboardType,
      this.margin,
      this.padding,
      this.focus,
      this.maxDigitLength,
      this.onChanged,
      this.contentStyle,
      // this.contentPadding,
      this.readOnly,
      this.contentAlign,
      this.backGroundColor,
      this.hintText,
      this.hintStyle});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      height: height!,
      width: width!,
      child: TextField(
        textAlignVertical: TextAlignVertical.center,
        textAlign: contentAlign ?? TextAlign.start,
        readOnly: readOnly ?? false,
        style: contentStyle ?? const TextStyle(fontSize: 16),
        onChanged: onChanged,
        inputFormatters: [LengthLimitingTextInputFormatter(maxDigitLength)],
        autofocus: focus ?? false,
        keyboardType: keyboardType,
        controller: controller,
        decoration: InputDecoration(
          hintStyle: hintStyle,
          hintText: hintText,
          contentPadding:
              EdgeInsets.symmetric(vertical: height! / 4, horizontal: 10),
          filled: true,
          fillColor: backGroundColor ?? Colors.white,
          suffixIcon: suffix,
          prefixIcon: prefix,
          labelText: labelText,
          labelStyle:
              labelStyle ?? const TextStyle(fontSize: 12),
          isDense: false,
          enabledBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: enableBorderColor ?? Colors.transparent),
              borderRadius: BorderRadius.circular(radius ?? 16)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(radius ?? 16),
              borderSide:
                  BorderSide(color: focusBorderColor ?? Colors.transparent)),
        ),
      ),
    );
  }
}
