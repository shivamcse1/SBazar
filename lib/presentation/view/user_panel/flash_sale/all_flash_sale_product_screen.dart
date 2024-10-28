// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/core/constant/color_const.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constant/app_const.dart';
import '../../../../core/constant/database_key_const.dart';
import '../../../../core/constant/textstyle_const.dart';
import '../../../../data/model/product_model.dart';
import '../details_page/details_screen.dart';

class AllFlashSaleProductScreen extends StatefulWidget {
  const AllFlashSaleProductScreen({super.key});

  @override
  State<AllFlashSaleProductScreen> createState() => AllFlashSaleProductScreenState();
}

class AllFlashSaleProductScreenState extends State<AllFlashSaleProductScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: ColorConstant.whiteColor),
          backgroundColor: AppConstant.appPrimaryColor,
          title: Text("Flash Sale Products", style: TextStyle(color: AppConstant.whiteColor),),
        ),

        body:  Padding(
          padding: const EdgeInsets.only(left: 10.0,right: 10.0),
          child: FutureBuilder(
            
              future: FirebaseFirestore
                      .instance
                      .collection(DbKeyConstant.productCollection)
                      .where('isSale',isEqualTo: true)
                      .get(), 
                builder: (context , snapshot){
                
                if(snapshot.connectionState == ConnectionState.waiting){
                  return SizedBox(
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
                    child: Text("No category found"),
                  );
                 }
          
              if(snapshot.data != null){
                return GridView.builder(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemCount: snapshot.data!.docs.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 10,
                childAspectRatio: 1,
                ), 
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

                return GestureDetector(
                   onTap: () {
                      Get.to(()=> DetailsScreen(productModel: productModel,));
                    },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child:  Container(
                      height: Get.height/5,
                      width: Get.width/2.3,
                      padding: const EdgeInsets.all(1.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: ColorConstant.pinkColor
                        ),
                        color: ColorConstant.yellowColor,
                        borderRadius: BorderRadius.circular(10)
                      ),
                     
                     
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                  
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: CachedNetworkImage(
                              height: Get.height/6.4,
                              width: Get.width/2.0,
                              fit: BoxFit.cover,
                              imageUrl: productModel.productImgList[0],
                              )
                        
                          ),
                          
                          const SizedBox(height: 2.0,),
                          SizedBox(
                            width: Get.width,
                            child: Text(productModel.productName,
                            style: TextStyleConstant.bold14Style,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            )),
                      
                             Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text("Rs."+productModel.salePrice),
                                ),
                                const SizedBox(width: 5.0,),
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
                  ),
                );
               }
              );
            
            }
  
        return Container();
        }),
        ),
    );
  }
}