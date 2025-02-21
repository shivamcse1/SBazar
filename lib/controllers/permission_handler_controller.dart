import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:s_bazar/utils/Uihelper/ui_helper.dart';

class PermissionHandlerController extends GetxController {
  void cameraPermissionHandler() async {
    PermissionStatus cameraStatus = await Permission.camera.status;

    if (cameraStatus.isGranted) {
      UiHelper.customToast(msg: "Camera Permission Granted");
      return;
    } else if (cameraStatus.isDenied) {
      cameraStatus = await Permission.camera.request();
    }
  }
}
