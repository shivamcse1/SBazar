import 'package:flutter/material.dart';

class CustomHeading extends StatelessWidget {
  final String headingText;
  final TextStyle? headingStyle;
  final EdgeInsetsGeometry? padding;
  final bool iconEnable;
  final Color? iconColor;  
  final Color? iconBGColor; 
  final double? iconSize;
  final IconData? icon; 

  const CustomHeading({
    super.key, 
    required this.headingText, 
    this.headingStyle, 
    this.padding, 
    this.iconEnable = true, 
    this.iconColor, 
    this.iconBGColor, 
    this.iconSize, 
    this.icon
    
    });

  @override
  Widget build(BuildContext context) {
   return Padding(
        padding: padding ?? const EdgeInsets.only(right: 10),
        child: Row(
          children: [
        
            Text(headingText,style: headingStyle ?? const TextStyle(fontSize: 14)),
            const Spacer(),
            
            iconEnable 
            ? Container(
              height: 30,
              width: 30,
              padding: const EdgeInsets.symmetric(vertical: 6,horizontal: 8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:  iconBGColor ?? Colors.red.shade400 ,
              ),
              child: Icon( icon ?? Icons.arrow_forward_ios,
                size: iconSize ?? 15,
                color: iconColor ??  Colors.red.shade400 ,
                ),
            )
            : const SizedBox.shrink()
          ],
        ),
      );
  }
}