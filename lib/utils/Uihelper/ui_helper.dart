import 'package:flutter/cupertino.dart';

import '../../core/constant/image_const.dart';

class UiHelper{

  static Widget noProductFound (){
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          
          Image.asset(ImageConstant.noProductFound2Img,
          height: 150,
          ),
      
          const Text("No Product Found",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
      
          const Text("It seems like there is not any product in this category so please go to another category products!",
           style: TextStyle(fontSize: 14,),
           textAlign: TextAlign.center,
          )
        ],
      ),
    );
  
  }

  
}