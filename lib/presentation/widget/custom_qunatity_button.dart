import 'package:flutter/material.dart';

import '../../core/constant/color_const.dart';
import '../../core/constant/textstyle_const.dart';

class CustomQuantityButton extends StatefulWidget {
  final double? height ;
  final int?  value ;
  final VoidCallback? plusOntap ;
  final VoidCallback? minusOntap ;

    const CustomQuantityButton({
    super.key, 
    this.height = 30, 
    this.value = 0, 
    this.plusOntap, 
    this.minusOntap
    });

  @override
  State<CustomQuantityButton> createState() => _CustomQuantityButtonState();
}

class _CustomQuantityButtonState extends State<CustomQuantityButton> {
  @override
  Widget build(BuildContext context) {
    return   Container(
        height: widget.height,
        padding: const EdgeInsets.symmetric(horizontal: 3.0),
        decoration: BoxDecoration(
          color: ColorConstant.primaryColor,
          borderRadius: BorderRadius.circular(5)
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            
            GestureDetector(
              onTap:widget.minusOntap,
              child: Icon(Icons.remove,color: ColorConstant.whiteColor,)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2.0),
              child: Text(widget.value.toString(),style: TextStyleConstant.bold14Style.copyWith(
                color: ColorConstant.whiteColor,
              ),),
            ),
            
            GestureDetector(
              onTap:widget.plusOntap,
              child: Icon(Icons.add,color: ColorConstant.whiteColor)),

          ],
        ),
        );
  }
}