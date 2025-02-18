import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBackBtn;
  final List<Widget>? actions;
  final TextStyle? titleStyle;
  final double? appBarheight;
  final Color? appBarColor;
  final Color? backIconColor;
  final bool isTitleCentered;
  final bool appBarcolorTransparency;
  final bool isBackBtnVisible;
  final Widget? leading;
  final Widget? titleWidget;
  final EdgeInsetsGeometry? leadingPadding;

  const CustomAppBar({
    super.key,
    this.title = '',
    this.actions,
    this.appBarcolorTransparency = false,
    this.titleStyle,
    this.appBarheight,
    this.appBarColor,
    this.backIconColor,
    this.isTitleCentered = false,
    this.onBackBtn,
    this.leading,
    this.titleWidget,
    this.isBackBtnVisible = false,
    this.leadingPadding,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
        forceMaterialTransparency: appBarcolorTransparency,
        toolbarHeight: appBarheight,
        leading: isBackBtnVisible == true
            ? GestureDetector(
                onTap: onBackBtn ??
                    () {
                      Navigator.pop(context);
                    },
                child: Align(
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.arrow_back,
                      color: backIconColor ?? Colors.black,
                    )))
            : leading ?? const SizedBox(),
        centerTitle: isTitleCentered,
        title: titleWidget ??
            Text(
              title,
              style: titleStyle,
            ),
        backgroundColor: appBarColor,
        actions: actions);
  }

  @override
  Size get preferredSize => Size(double.maxFinite, appBarheight ?? 56);
}
