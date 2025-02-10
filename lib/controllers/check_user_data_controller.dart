import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:s_bazar/core/constant/database_key_const.dart';
import 'package:get/get.dart';

class CheckUserDataController extends GetxController {
  Future<List<QueryDocumentSnapshot<Object?>>> getUserData(String uId) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(DbKeyConstant.userCollection)
        .where(DbKeyConstant.userUid, isEqualTo:uId)
        .get();

    return querySnapshot.docs;
  }
}
