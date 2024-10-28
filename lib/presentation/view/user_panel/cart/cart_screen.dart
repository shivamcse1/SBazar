// ignore_for_file: prefer_interpolation_to_compose_strings, avoid_print
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/controllers/cart_controller.dart';
import 'package:e_commerce/core/constant/database_key_const.dart';
import 'package:e_commerce/core/constant/image_const.dart';
import 'package:e_commerce/core/constant/textstyle_const.dart';
import 'package:e_commerce/data/model/cart_model.dart';
import 'package:e_commerce/presentation/view/user_panel/checkout/checkout_screen.dart';
import 'package:e_commerce/presentation/widget/custom_qunatity_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';

import '../../../../core/constant/app_const.dart';
import '../../../../core/constant/color_const.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  
  User? user  =  FirebaseAuth.instance.currentUser;
  double h = Get.height;
  double w = Get.width;
  final CartController cartController = Get.put(CartController());
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
          iconTheme: IconThemeData(color: ColorConstant.whiteColor),
          backgroundColor: AppConstant.appPrimaryColor,
          title: Text("Cart", style: TextStyle(color: AppConstant.whiteColor),),
        ),
        body: 
           Container(
          color: Colors.blue.withOpacity(.2),
          child: Column(
            children: [
               const SizedBox(height: 5.0,),
              Expanded(
                child: StreamBuilder(
                stream: FirebaseFirestore.instance
                        .collection(DbKeyConstant.cartCollection)
                        .doc(user!.uid)
                        .collection(DbKeyConstant.cartProductCollection)
                        .snapshots(),
                builder: (context , snapshot) {

                  cartController.calculateTotalProductPrice(user: user);

                  if(snapshot.connectionState == ConnectionState.waiting){
                    EasyLoading.show(status: "Please wait..");
                    return SizedBox(
                          height: Get.height / 5,
                          child: const Center(
                            child: CupertinoActivityIndicator(),
                          ),
                        ) ;
                  }

                  if(snapshot.hasError){
                    EasyLoading.dismiss();
                    return const Center(child: Text("Something went wrong")) ;
                  }

                  if(snapshot.hasData){
                    EasyLoading.dismiss();
                       
                    if(snapshot.data!.docs.isNotEmpty){
                      final docData = snapshot.data!.docs;
                       
                       print(docData.length);
                        return ListView.builder(
                        itemCount: docData.length,
                        itemBuilder: (context,index){
                              
                          CartModel cartModel = CartModel(
                            productId: docData[index][DbKeyConstant.productId], 
                            categoryId: docData[index][DbKeyConstant.categoryId], 
                            productName: docData[index][DbKeyConstant.productName], 
                            categoryName: docData[index][DbKeyConstant.categoryName],
                            salePrice: docData[index][DbKeyConstant.salePrice], 
                            fullPrice: docData[index][DbKeyConstant.fullPrice], 
                            productImgList: docData[index][DbKeyConstant.productImgList], 
                            deliveryTime: docData[index][DbKeyConstant.deliveryTime], 
                            isSale: docData[index][DbKeyConstant.isSale], 
                            productDescription: docData[index][DbKeyConstant.productDescription], 
                            createdAt: docData[index][DbKeyConstant.createdAt], 
                            updatedAt: docData[index][DbKeyConstant.updatedAt], 
                            productQuantity: docData[index][DbKeyConstant.productQuantity], 
                            productTotalPrice: docData[index][DbKeyConstant.productTotalPrice]
                            );    

                          return 
                            Slidable(
                            startActionPane:ActionPane(
                              extentRatio: .48,
                             motion:  const StretchMotion() , 
                             children: [

                               SlidableAction(
                                onPressed: (context){

                                },
                                icon: Icons.share,
                                backgroundColor: Colors.lightBlue,
                                foregroundColor: ColorConstant.whiteColor,
                                label: "Share",
                               ),

                              SlidableAction(
                                onPressed: (context) async{
                                  await cartController.deleteCartProduct(
                                    cartModel: cartModel, user: user
                                    );
                                },
                                icon: Icons.delete,
                                backgroundColor: ColorConstant.primaryColor,
                                foregroundColor: ColorConstant.whiteColor,
                                label: "Delete",
                               ),
                             
                             ]
                              
                              ),
                            child: Container(
                            margin: const EdgeInsets.symmetric(vertical:3.0,horizontal: 8.0),
                            height: 100,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: ColorConstant.whiteColor,
                              borderRadius: BorderRadius.circular(10)
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                
                                Container(
                                  height: h/10,
                                  width: w/5,
                                  padding: const EdgeInsets.all(1),
                                  decoration: BoxDecoration(
                                    color: ColorConstant.greyColor.withOpacity(.3),
                                    borderRadius: BorderRadius.circular(10)
                                  ),
                                  child:ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: CachedNetworkImage(
                                      fit: BoxFit.fill,
                                      imageUrl: cartModel.productImgList[0], 
                                      
                                      // it execute until image not load
                                      placeholder: (context,imgUrl){
                                        return const Center(
                                          child: CupertinoActivityIndicator(),
                                        );
                                      },
                                      
                                      // it execute when any error occured loaidng in image
                                    errorWidget: (context, url, error) {
                                          return Image.asset(ImageConstant.previewImg);
                                      },     
                                    ),
                                  )
                                ),
                                const SizedBox(width: 15,),

                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                  
                                      Text(cartModel.productName,style: TextStyleConstant.bold14Style,),
                                      Text(DbKeyConstant.rs +cartModel.productTotalPrice.toString(),style: TextStyleConstant.bold14Style,),
                                      Text("Qty : "+cartModel.productQuantity.toString(),style: TextStyleConstant.bold14Style,),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 5,),
                                
                                CustomQuantityButton(
                                  value: cartModel.productQuantity,
                                  plusOntap: () async{
                                    
                                     await cartController.incrementCartProductQuantity(
                                      cartModel: cartModel, 
                                      user: user
                                      );
                                  },

                                minusOntap: () async{
                                   await cartController.decrementCartProductQuantity(
                                      cartModel: cartModel, 
                                      user: user
                                      );
                                },  
                                )
                              
                              ],
                            ),
                          )
                          );
                        }
                        ) ;
                      }
                     else{
                     EasyLoading.dismiss();

                     return const Center(child: Text("No data Found")) ;
                     }
                  }else{
                    EasyLoading.dismiss();

                   return const Center(child: Text("No data Found")) ;
                  }
                }
              ),
           ),

            Container(
                height: 60,
                color: Colors.blue.shade100,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    children: [
                            
                      Padding(
                        padding: const EdgeInsets.only(top:8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Total amount",style: TextStyleConstant.bold14Style,),
                            
                            Obx(() => Text(DbKeyConstant.rs+"${cartController.totalProductPrice}",style: TextStyleConstant.bold14Style,),)
                          ],
                        ),
                      ),      
                       
                       const Spacer(),
                       ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorConstant.primaryColor,
                          fixedSize: Size(w/2, h/18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)
                          )
                        ),
                        onPressed: (){
                  
                         Get.to(()=> const CheckOutScreen());
                        }, 
                        child: Text("Checkout",style: TextStyleConstant.bold16Style.copyWith(
                          color: ColorConstant.whiteColor
                        ),))
                    ],
                  ),
                ),
              )
          
           ]
          ),
         ));
      }
  }