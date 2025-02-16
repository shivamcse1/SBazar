import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final bool? focus;
  final bool? readOnly;
  final TextAlign? contentAlign;
  // final double? height;
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
  final String? Function(String?)? validator;

  const CustomTextField(
      {super.key,
      // this.height = 63,
      this.width = double.infinity,
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
      this.validator,
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
      height: 63,
      width: width,
      child: TextFormField(
        validator: validator,
        autovalidateMode: AutovalidateMode.onUserInteraction,
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
          errorStyle: const TextStyle(height: .1),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          filled: true,
          fillColor: backGroundColor ?? Colors.white,
          suffixIcon: suffix,
          prefixIcon: prefix,
          labelText: labelText,
          labelStyle: labelStyle ?? const TextStyle(fontSize: 14),
          isDense: false,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: enableBorderColor ?? Colors.grey),
              borderRadius: BorderRadius.circular(radius ?? 10.0)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(radius ?? 10.0),
              borderSide: BorderSide(color: focusBorderColor ?? Colors.grey)),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius ?? 10.0),
            borderSide: const BorderSide(color: Colors.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius ?? 10.0),
            borderSide: const BorderSide(color: Colors.red),
          ),
        ),
      ),
    );
  }
}
