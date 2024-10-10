import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/core/constant/database_key_const.dart';
import 'package:get/get.dart';

class CheckUserDataController extends GetxController{

Future <List<QueryDocumentSnapshot<Object?>>> getUserData(String uId) async{
    
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
    .collection(DatabaseKeyConstant.userCollection)
    .where('uId',isEqualTo:uId )
    .get();
   
     return querySnapshot.docs;

}

}