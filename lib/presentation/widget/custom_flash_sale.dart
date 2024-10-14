// ignore_for_file: sized_box_for_whitespace, prefer_interpolation_to_compose_strings

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/core/constant/color_const.dart';
import 'package:e_commerce/core/constant/database_key_const.dart';
import 'package:e_commerce/core/constant/textstyle_const.dart';
import 'package:e_commerce/data/model/product_model.dart';
import 'package:flutter/cupertino.dart';

import 'package:get/get.dart';

class CustomFlashSale extends StatelessWidget {
  const CustomFlashSale({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
            future: FirebaseFirestore
                    .instance
                    .collection(DbKeyConstant.productCollection)
                    .where('isSale',isEqualTo: true)
                    .get(), 
      builder: (context , snapshot){

        if(snapshot.connectionState == ConnectionState.waiting){
          return Container(
            height: Get.height / 5,
            child: const Center(
              child: CupertinoActivityIndicator(),
            ),
          ) ;
        } 
        
       if(snapshot.hasError){
          return const Center(
            child: Text("Error Ocurred"),
          ) ;
       }

       if(snapshot.data!.docs.isEmpty){
         return const Center(
          child: Text("No Flash Sale Product found"),
         );
       }

       if(snapshot.data != null){
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            alignment: Alignment.centerLeft,
            height: Get.height/5.4,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context,index){
                  
                final productData =  snapshot.data!.docs[index];
                ProductModel productModel = ProductModel(

                  productId: productData[DbKeyConstant.productId], 
                  categoryId: productData[DbKeyConstant.categoryId], 
                  productName: productData[DbKeyConstant.productName], 
                  categoryName: productData[DbKeyConstant.categoryName], 
                  salePrice : productData[DbKeyConstant.salePrice],
                  fullPrice : productData[DbKeyConstant.fullPrice],
                  productImgList : productData[DbKeyConstant.productImgList],
                  deliveryTime : productData[DbKeyConstant.deliveryTime],
                  isSale : productData[DbKeyConstant.isSale],
                  productDescription : productData[DbKeyConstant.productDescription],
                  createdAt : productData[DbKeyConstant.createdAt],
                  updatedAt : productData[DbKeyConstant.updatedAt]

                  );

              return Row(
             
                children: [

                  Container(
                    margin:const EdgeInsets.only(right: 10.0),
                    padding: const EdgeInsets.all(1.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: ColorConstant.pinkColor
                      ),
                      color: ColorConstant.yellowColor,
                      borderRadius: BorderRadius.circular(10)
                    ),
                    width: Get.width/4,
                   
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                       

                        ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: CachedNetworkImage(
                            height: 100,
                            fit: BoxFit.cover,
                            imageUrl: productModel.productImgList[0],
                            )
                      
                        ),
                        
                        const SizedBox(height: 2.0,),
                        Container(
                          width: Get.width,
                          child: Text(productModel.productName,
                          style: TextStyleConstant.bold14WhiteStyle,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          )),
                    
                           Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text("Rs."+productModel.salePrice),
                              Text(productModel.fullPrice,
                              style: TextStyle(
                                color:ColorConstant.secondaryColor.withOpacity(.7),
                                decoration: TextDecoration.lineThrough
                                
                                ),),
                    
                            ],
                          )
                        ],
                      ),
                
                
                    ),
                  ],
                ); }
              ),
          );}

      return Container();
    });
  }
}