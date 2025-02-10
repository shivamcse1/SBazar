import 'package:flutter/material.dart';

import 'custom_button.dart';

class CustomItemCard extends StatelessWidget {
  final String image;
  final String? itemName;
  final String? price;
  final int index;
  final String? discountPrice;
  final VoidCallback? onButtonTap;
  const CustomItemCard({
    super.key, 
    required this.image, 
     this.itemName, 
     this.price, 
     this.discountPrice, 
     this.onButtonTap, 
     this.index = 0,
    });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 302,
      width: 168,
      child: Column(
        children: [

          Container(
            padding: const EdgeInsets.all(23),
            height: 168,
            width: 168,
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(20)
            ),
            child: Image.asset(image,fit: BoxFit.contain,) ,
          ),

          const SizedBox(height: 8,),

          SizedBox(
            height: 118,
            width: 152,
            child: Column(
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                
                    Text("\$4.98",style: TextStyle(fontSize: 16)),
                    SizedBox(width: 4,),
                    Text("\$5.98",style:TextStyle(fontSize: 12,decoration: TextDecoration.lineThrough))
                  ],
                ),
                const SizedBox(height: 4,),

                const SizedBox(
                  height: 51,
                  width: 152,
                  child: Text("Finish Classic- 60ct - Dishwasher Detergent - Powerball - Dishwashing Tablets - Dish Tabs",
                  style: TextStyle(fontSize: 14),
                  softWrap: true,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 7,),

                index == 0 ? const CustomQuantityButton()
                : CustomElevatedButton(
                  isLoading: false,
                  radius: 8,
                  width: 152,
                  height: 33,
                  buttonColor: Colors.redAccent,
                  buttonText: "Add to cart", 
                  buttonTextStyle: const TextStyle(fontSize: 12),
                  onTap:onButtonTap ?? (){},
                  ),

                  
            
              ],
            ),
          )
        ],
      ),
    );
  }
}