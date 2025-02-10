import 'package:flutter/cupertino.dart';

import '../../core/constant/image_const.dart';

class UiHelper{

  static Widget noProductFound ({
    String heading="No Product Found", 
    String subHeading ="It seems like there is not any product in this category so please go to another category products!", 
    String image = ImageConstant.noProductFound2Img,
    
    }){
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          
          Image.asset(image,
          height: 150,
          ),
      
          Text(heading,style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
      
           Text(subHeading,
           style: const TextStyle(fontSize: 14,),
           textAlign: TextAlign.center,
          )
        ],
      ),
    );
  
  }

  
}