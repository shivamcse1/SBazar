// ignore_for_file: must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/core/constant/color_const.dart';
import 'package:e_commerce/data/model/product_model.dart';
import 'package:e_commerce/utils/Uihelper/ui_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constant/app_const.dart';
import '../../../../core/constant/database_key_const.dart';
import '../../../../core/constant/textstyle_const.dart';
import '../details_page/details_screen.dart';

class AllCategoryProductScreen extends StatefulWidget {
  String categoryId ;

  AllCategoryProductScreen({
    super.key,
    required this.categoryId
    
    });

  @override
  State<AllCategoryProductScreen> createState() => AllCategoryProductScreenState();
}

class AllCategoryProductScreenState extends State<AllCategoryProductScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: ColorConstant.whiteColor),
          backgroundColor: AppConstant.appPrimaryColor,
          title: Text("Product", style: TextStyle(color: AppConstant.whiteColor),),
        ),

        body:  Padding(
          padding: const EdgeInsets.only(left: 10.0,right: 10.0),
          child: FutureBuilder(
            
              future: FirebaseFirestore
                      .instance
                      .collection(DbKeyConstant.productCollection)
                      .where('categoryId' , isEqualTo : widget.categoryId)
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
                  return UiHelper.noProductFound();
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
                 
                 final productData = snapshot.data!.docs;
                 ProductModel productModel = ProductModel(
                  productId: productData[index]['productId'], 
                  categoryId: productData[index]['categoryId'],
                  productName: productData[index]['productName'], 
                  categoryName: productData[index]['categoryName'], 
                  salePrice: productData[index]['salePrice'], 
                  fullPrice: productData[index]['fullPrice'], 
                  productImgList: productData[index]['productImgList'], 
                  deliveryTime: productData[index]['deliveryTime'], 
                  isSale: productData[index]['isSale'], 
                  productDescription: productData[index]['productDescription']
                  );

               return Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: InkWell(
                    onTap: (){
                      Get.to(()=> DetailsScreen(productModel: productModel,));
                    
                    },
                    child: Container(
                      // padding: const EdgeInsets.all(1.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: ColorConstant.pinkColor
                        ),
                        color: Colors.pink,
                        borderRadius: BorderRadius.circular(10)
                      ),
                      height: Get.height/5,
                      width: Get.width/2.3,
                      child: Column(
                        
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                    
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: Image.network(productModel.productImgList[0],
                            height: Get.height/6,
                            width: Get.width/2.0,
                            fit: BoxFit.cover,
                            ),
                          ),
                          
                          const SizedBox(height: 8.0,),
                          SizedBox(
                            width: Get.width,
                            
                            child: Text(productModel.productName,
                            style: TextStyleConstant.bold14Style.copyWith(
                              color: ColorConstant.whiteColor
                            ),
                            
                            textAlign: TextAlign.center,
                            ))
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