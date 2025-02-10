import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBackBtn;
  final List<Widget>? actions;
  final TextStyle? titleStyle;
  final double? appBarheight;
  final Color? appBarColor;
  final bool isTitleCentered;
  final bool isBackBtnVisible;
  final Widget? leading;
  final Widget? titleWidget;
  final EdgeInsetsGeometry? leadingPadding;

  const CustomAppBar({
    super.key,
    this.title = '',
    this.actions,
    this.titleStyle,
    this.appBarheight,
    this.appBarColor,
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
        forceMaterialTransparency: true,
        toolbarHeight: appBarheight,
        leading: isBackBtnVisible
            ? GestureDetector(
                onTap: onBackBtn,
                child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      margin: leadingPadding ?? EdgeInsets.zero,
                      padding: EdgeInsets.zero,
                      height: 30.3,
                      width: 30.3,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.red,
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.red,
                        size: 16.0, // Icon size fits the container
                      ),
                    )))
            : leading,
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
  Size get preferredSize => Size(double.maxFinite, appBarheight ?? 40);
}
