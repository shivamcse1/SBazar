import 'package:get/get.dart';

import '../../core/constant/app_const.dart';

class SnackbarHelper{


  static void customSnackbar({required String titleMsg , required String msg}){
    
    Get.snackbar(
     titleMsg, 
     msg,
     backgroundColor: AppConstant.appSecondaryColor,
     colorText: AppConstant.whiteColor,
     snackPosition: SnackPosition.BOTTOM
    );
  }
}