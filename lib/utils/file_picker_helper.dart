// ignore_for_file: avoid_print


import 'package:image_picker/image_picker.dart';
import 'package:s_bazar/utils/Uihelper/ui_helper.dart';

class FilePickerHelper {
  static ImagePicker imagePicker = ImagePicker();

  static Future<XFile?> pickSingleImage({
    ImageSource imageSource = ImageSource.camera,
  }) async {
    try {
      final XFile? pickedFile =
          await imagePicker.pickImage(source: imageSource);
      // if image picked by user then pickedFile can not be null
      if (pickedFile != null) {
        return pickedFile;
      } else {
        UiHelper.customToast(msg: "You Have Not Picked Any Image");
        return null;
      }
    } catch (ex) {
      print(ex);
      return null;
    }
  }
  
  
   

}
