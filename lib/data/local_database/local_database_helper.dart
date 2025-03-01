// ignore_for_file: avoid_print

import 'package:s_bazar/core/constant/database_key_const.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalDataBaseHelper {
  // ye ek instance create kar dega , aur hamko need hai ki is class ke bahar se iska instance na bane
  // to hame class ke constructor ko private banana padta hai
  // kisi class ke constructor ko private bannae ke liye className._(); likhna padta hai agr named banana hait to name de do ._named();
  static final LocalDataBaseHelper _instance = LocalDataBaseHelper._internal();

  // ye wo constructor hai jisko call kiya hai wha
  LocalDataBaseHelper._internal();

  //it use for returning single instance evry time
  //bina iske hm bahar se is class ka instance nahi bana sakte hai
  factory LocalDataBaseHelper() {
    return _instance;
  }

  late SharedPreferences sharedPref;

  Future<void> sharedPrefInit() async {
    sharedPref = await SharedPreferences.getInstance();
  }

  Future<void> setUserData({
    required String name,
    required String phone,
    required String city,
    required String state,
    String? deviceToken,
    required String email,
    required String street,
  }) async {
    try {
      await sharedPref.setString(DbKeyConstant.userCity, city);
      await sharedPref.setString(DbKeyConstant.userName, name);
      await sharedPref.setString(DbKeyConstant.userPhone, phone);
      await sharedPref.setString(DbKeyConstant.userEmail, email);
      await sharedPref.setString(DbKeyConstant.userState, state);
      await sharedPref.setString(DbKeyConstant.userStreet, street);
      if (deviceToken != null) {
        await sharedPref.setString(DbKeyConstant.userDeviceToken, deviceToken);
      }
      await sharedPref.setBool(DbKeyConstant.isChecked, false);

      print("data Successful saved");
    } catch (ex) {
      throw Exception("Error Ocurred $ex");
    }
  }

  // remove data at Key
  void removeDataAtKey({required String keyValue}) {
    sharedPref.remove(keyValue);
  }

  //whole data deleted
  void removeWholeData() {
    sharedPref.clear();
  }
}
