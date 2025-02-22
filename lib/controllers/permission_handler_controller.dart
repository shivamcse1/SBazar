import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:s_bazar/utils/Uihelper/ui_helper.dart';

class PermissionHandlerController extends GetxController {

  void permisionStatusHandler(
      {required PermissionStatus status, required String permissonType}) {
    switch (status) {
      case PermissionStatus.granted:
        UiHelper.customToast(
            msg:
                "${permissonType[0].toUpperCase() + permissonType.substring(1)} Permission Granted");
        break;

      case PermissionStatus.denied:
        UiHelper.customToast(
            msg:
                "${permissonType[0].toUpperCase() + permissonType.substring(1)} Permission Denied");
        break;

      case PermissionStatus.permanentlyDenied:
        UiHelper.customToast(
            msg:
                "${permissonType[0].toUpperCase() + permissonType.substring(1)} Permission Permanently Denied");
        openAppSettings(); // User ko settings me bhej do
        break;

      case PermissionStatus.restricted:
        UiHelper.customToast(
            msg:
                "${permissonType[0].toUpperCase() + permissonType.substring(1)} Permission Restricted by System");
        break;

      case PermissionStatus.limited:
        UiHelper.customToast(
            msg:
                "${permissonType[0].toUpperCase() + permissonType.substring(1)} Limited Permission on IOS");
        break;
      default:
        UiHelper.customToast(
            msg:
                "${permissonType[0].toUpperCase() + permissonType.substring(1)} Permisson Not Granted");
        break;
    }
  }
}
