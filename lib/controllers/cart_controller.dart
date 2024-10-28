
// ignore_for_file: unnecessary_null_comparison

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/core/constant/database_key_const.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../data/model/cart_model.dart';



class CartController extends GetxController{

  RxDouble totalProductPrice = 0.0.obs;

  Future<void> incrementCartProductQuantity(
    {
      required CartModel cartModel,
      required User? user,
    }
    ) async{

      if(cartModel.productQuantity > 0){

        await FirebaseFirestore.instance
        .collection(DbKeyConstant.cartCollection)
        .doc(user!.uid)
        .collection(DbKeyConstant.cartProductCollection)
        .doc(cartModel.productId)
        .update({
          "productQuantity" : cartModel.productQuantity + 1,
          "productTotalPrice" : cartModel.productTotalPrice + double.parse((cartModel.isSale ? cartModel.salePrice : cartModel.fullPrice))
          }) ;
       }
     
    }
        
  
  Future<void> decrementCartProductQuantity( 
    {
      required CartModel cartModel,
      required User? user,
    }) async{

      DocumentReference docref = FirebaseFirestore.instance
                                  .collection(DbKeyConstant.cartCollection)
                                  .doc(user!.uid)
                                  .collection(DbKeyConstant.cartProductCollection)
                                  .doc(cartModel.productId);
           
           // if product quantity is greater than 1 then decrease otherwise delete product
        if(cartModel.productQuantity > 1){
          await docref.update({
              "productQuantity" : cartModel.productQuantity - 1,
              "productTotalPrice" : cartModel.productTotalPrice - double.parse((cartModel.isSale ? cartModel.salePrice : cartModel.fullPrice))
              }) ;
        } else{
          
         await docref.delete();
        }                         
            
    }

  
  Future<void> deleteCartProduct( 
    {
      required CartModel cartModel,
      required User? user,
    }) async{

      await FirebaseFirestore.instance
            .collection(DbKeyConstant.cartCollection)
            .doc(user!.uid)
            .collection(DbKeyConstant.cartProductCollection)
            .doc(cartModel.productId)
            .delete();
    }


  Future<void> calculateTotalProductPrice( {required User? user} ) async{
   double sum = 0;
   QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                                      .collection(DbKeyConstant.cartCollection)
                                      .doc(user!.uid)
                                      .collection(DbKeyConstant.cartProductCollection)
                                      .get();       

      for(DocumentSnapshot doc in querySnapshot.docs ){
           Map<String,dynamic> docData = doc.data() as Map<String ,dynamic>;
           if(docData != null && docData.containsKey(DbKeyConstant.productTotalPrice)){
              sum = sum +  docData[DbKeyConstant.productTotalPrice];
           }
          
      }
     totalProductPrice.value = sum ;
  }

  @override
  void onInit() {
    calculateTotalProductPrice(user: FirebaseAuth.instance.currentUser);
    super.onInit();
  }
}