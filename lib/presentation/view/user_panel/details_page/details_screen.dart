// ignore_for_file: must_be_immutable, prefer_interpolation_to_compose_strings, avoid_print

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/controllers/banner_contoller.dart';
import 'package:e_commerce/core/constant/app_const.dart';
import 'package:e_commerce/core/constant/database_key_const.dart';
import 'package:e_commerce/core/constant/image_const.dart';
import 'package:e_commerce/core/constant/textstyle_const.dart';
import 'package:e_commerce/data/model/cart_model.dart';
import 'package:e_commerce/data/model/product_model.dart';
import 'package:e_commerce/utils/Uihelper/share.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../../../core/constant/color_const.dart';
import '../cart/cart_screen.dart';

class DetailsScreen extends StatefulWidget {

  ProductModel productModel;
  DetailsScreen(
    {
      super.key,
      required this.productModel
    }
  );

  @override
  State<DetailsScreen> createState() => DetailsScreenState();
}

class DetailsScreenState extends State<DetailsScreen> {
  
  final BannerController bannerController = Get.put(BannerController());
  double h = Get.height;
  double w = Get.width;
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
          iconTheme: IconThemeData(color: ColorConstant.whiteColor),
          backgroundColor: AppConstant.appPrimaryColor,
          title: Text("Details Screen", style: TextStyle(color: AppConstant.whiteColor),),

          actions: [
          Stack(
            children: [
              IconButton(
                  onPressed: ()  {
                   Get.to(()=> const CartScreen());
                  },
                  icon: const Icon(
                    Icons.shopping_cart,
                    color: Colors.white,
                  )),
            ],
          )
        ],
        ),

        body: Column(
          children: [

              SizedBox(
                height: h/4,
                child: PageView.builder(
                  onPageChanged: (value) {
                    bannerController.pageIndex.value = value;
                  },
                  itemCount: widget.productModel.productImgList.length,
                  itemBuilder: (context,index){
                  return Padding(
                    padding: const EdgeInsets.only(left: 5.0,top: 5.0,right: 10.0),
                    child: ClipRRect(
                      borderRadius:const BorderRadius.all(Radius.circular(10)),
                      child: CachedNetworkImage(
                        fit: BoxFit.fill,
                        imageUrl: widget.productModel.productImgList[index], 
                        
                        // it execute until image not load
                        placeholder: (context,imgUrl){
                           return const Center(
                            child: CupertinoActivityIndicator(),
                           );
                         },
                       errorWidget: (context, url, error) {
                            return Image.asset(ImageConstant.previewImg);
                        },     
                      )
                    ),
                  );
                }),
              ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(widget.productModel.productImgList.length, (index) {
               
               return Obx(() => AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: bannerController.pageIndex.value == index ? 10 : 10,
                width: bannerController.pageIndex.value == index ? 10 : 10,
                margin: const EdgeInsets.all(2),
                decoration:  BoxDecoration(
                  shape:  bannerController.pageIndex.value == index  ?  BoxShape.rectangle : BoxShape.circle,
                  color: bannerController.pageIndex.value == index ? ColorConstant.primaryColor : ColorConstant.greyColor
                ),
               )
            );
              }),
            ),
            
            const SizedBox(height: 10,),

            Card(
            
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
              
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      Text(widget.productModel.productName,style: TextStyleConstant.bold16Style,),

                      Icon(Icons.favorite,color: ColorConstant.greyColor,)
                    ],
                  ),

                  const SizedBox(height: 15,),
                  Row(
                    children: [
                      Text("Price : "+DbKeyConstant.rs+widget.productModel.salePrice,
                      style: TextStyleConstant.bold16Style,),
                      
                      SizedBox(width: widget.productModel.salePrice.isEmpty ? 0 : 5  ),
                      Text(
                        widget.productModel.fullPrice,
                        style: TextStyleConstant.bold14Style.copyWith(
                        decoration: widget.productModel.salePrice.isEmpty ? TextDecoration.none : TextDecoration.lineThrough,
                        color: widget.productModel.salePrice.isEmpty ? Colors.black : ColorConstant.secondaryColor.withOpacity(.6)
                      ),
                      
                      ),


                    ],
                  ),

                  const SizedBox(height: 15,),
                  Text("Category : "+widget.productModel.categoryName,style: TextStyleConstant.bold16Style,),

                  const SizedBox(height: 15,),
                  Text("Description: "+widget.productModel.productDescription,
                    style: TextStyleConstant.bold16Style,
                  
                  ),

                 const SizedBox(height: 10,),
                 Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                   children: [
                     ElevatedButton(
                       style: ElevatedButton.styleFrom(
                        backgroundColor: ColorConstant.primaryColor,
                         minimumSize: const Size(150, 40)
                       ),
                       onPressed: ()async{
                         await ShareHelper.sendTextOnWhatsapp(productModel: widget.productModel) ;    
                     }, 
                     child: Text("Whatsapp",style: TextStyleConstant.bold14Style.copyWith(
                      color: ColorConstant.whiteColor
                     ),)),
                     ElevatedButton(
                       style: ElevatedButton.styleFrom(
                        backgroundColor: ColorConstant.primaryColor,
                         minimumSize: const Size(150, 40)
                       ),
                       onPressed: () async{
                          await checkProductExistence(uId: user!.uid);   

                          Fluttertoast.showToast(msg: "Add to cart successfully");       
                     }, 
                     child: Text("Add to cart",style: TextStyleConstant.bold14Style.copyWith(
                      color: ColorConstant.whiteColor
                     ))),
                   ],
                 )


                ],
              ),
            ),
            )
              
          ],
        ),

    );
  }

  Future<void> checkProductExistence({
    required uId,
    int quantityIncrement = 1
    
    }) async{
     
     // it is use so we can not write again again code 
     DocumentReference documentReference = FirebaseFirestore
                                            .instance
                                            .collection(DbKeyConstant.cartCollection)
                                            .doc(uId)
                                            .collection(DbKeyConstant.cartProductCollection)
                                            .doc(widget.productModel.productId);
     
     DocumentSnapshot docSnapshot = await documentReference.get();

     if(docSnapshot.exists){
      
      // find out quantity and price 
      int currentQuantity = docSnapshot[DbKeyConstant.productQuantity];
      int updatedQuantity = currentQuantity + quantityIncrement ;
      double totalPrice = double.parse(widget.productModel.isSale 
       ? widget.productModel.salePrice  
       : widget.productModel.fullPrice) 
       * updatedQuantity ;

       //product exist so only update qunatity and price
      await documentReference.update({
       "productQuantity" : updatedQuantity,
       "productTotalPrice" : totalPrice
      });

      print("Already added");
     }else{
       
        // it is use for accessing subCollection
        FirebaseFirestore.instance.collection(DbKeyConstant.cartCollection).doc(uId).set({
          'uId' : uId,
          'createdAt' : DateTime.now()
        });
        
        final data = widget.productModel ;
        CartModel cartmodel = CartModel(
          productId: data.productId, 
          categoryId: data.categoryId, 
          productName: data.productName, 
          categoryName: data.categoryName, 
          salePrice: data.salePrice, 
          fullPrice: data.fullPrice, 
          productImgList: data.productImgList,
          deliveryTime: data.deliveryTime, 
          isSale: data.isSale, 
          productDescription: data.productDescription, 
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          productQuantity: quantityIncrement, 
          productTotalPrice: double.parse(data.fullPrice)
          
          );

          await documentReference.set(cartmodel.toMap());
          print("first time added");

     }
  }
}