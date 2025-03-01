// ignore_for_file: avoid_unnecessary_containers, avoid_print
import 'package:s_bazar/controllers/auth_controller.dart';
import 'package:s_bazar/controllers/get_user_data_controller.dart';
import 'package:s_bazar/core/constant/app_const.dart';
import 'package:s_bazar/core/constant/color_const.dart';
import 'package:s_bazar/core/constant/database_key_const.dart';
import 'package:s_bazar/core/constant/image_const.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:s_bazar/data/model/user_model.dart';
import 'package:s_bazar/main.dart';
import 'package:s_bazar/presentation/widget/custom_button.dart';
import 'package:s_bazar/presentation/widget/custom_image_view.dart';
import '../../../../core/constant/textstyle_const.dart';
import '../../../../utils/Uihelper/ui_helper.dart';
import '../../auth_ui/welcome_screen.dart';
import '../address/address_screen.dart';
import '../order/order_screen.dart';
import '../wishlist/wishlist_screen.dart';
import 'update_profile_screen.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({
    super.key,
  });

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final GetUserDataController getUserDataController =
      Get.put(GetUserDataController());
  final AuthController authController = Get.put(AuthController());
  User? user = FirebaseAuth.instance.currentUser;
  String name = '';
  String email = '';

  void getUserData() {
    name =
        localDataBaseHelper.sharedPref.getString(DbKeyConstant.userName) ?? '';
    email =
        localDataBaseHelper.sharedPref.getString(DbKeyConstant.userEmail) ?? '';
    String phone =
        localDataBaseHelper.sharedPref.getString(DbKeyConstant.userPhone) ?? '';
    String state =
        localDataBaseHelper.sharedPref.getString(DbKeyConstant.userState) ?? '';
    String city =
        localDataBaseHelper.sharedPref.getString(DbKeyConstant.userCity) ?? '';
    String street =
        localDataBaseHelper.sharedPref.getString(DbKeyConstant.userStreet) ??
            '';

    authController.assignDataToController(
        userCity: city,
        userEmail: email,
        userName: name,
        userPhone: phone,
        userState: state,
        userStreet: street);
  }

  @override
  Widget build(BuildContext context) {
    getUserData();
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: const Color.fromRGBO(250, 250, 250, 1),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 50,
                ),
                Container(
                  height: 80,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.amberAccent.withOpacity(.1),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          width: 1, color: Colors.amber.withOpacity(.5))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        email,
                        style: const TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Divider(),
                ListTile(
                    onTap: () {
                      Get.to(() => const OrderScreen());
                    },
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(
                      Icons.store,
                    ),
                    title: Text("My Order",
                        style: TextStyleConstant.normal14Style),
                    trailing: const Icon(
                      Icons.arrow_forward_rounded,
                    )),
                ListTile(
                    onTap: () {
                      Get.to(() => const WishlistScreen());
                    },
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(
                      Icons.favorite_border,
                    ),
                    title: Text("Wishlist",
                        style: TextStyleConstant.normal14Style),
                    trailing: const Icon(
                      Icons.arrow_forward_rounded,
                    )),
                ListTile(
                    onTap: () {
                      Get.to(() => const UpdateProfileScreen());
                    },
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(
                      Icons.account_circle,
                    ),
                    title: Text("Update Profile",
                        style: TextStyleConstant.normal14Style),
                    trailing: const Icon(
                      Icons.arrow_forward_rounded,
                    )),
                ListTile(
                    onTap: () {
                      Get.to(() => const AddressScreen());
                    },
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(
                      Icons.add_location_alt,
                    ),
                    title: Text("My Addresses",
                        style: TextStyleConstant.normal14Style),
                    trailing: const Icon(
                      Icons.arrow_forward_rounded,
                    )),
                ListTile(
                    onTap: () {},
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(
                      Icons.share,
                    ),
                    title: Text("Share to Friends",
                        style: TextStyleConstant.normal14Style),
                    trailing: const Icon(
                      Icons.arrow_forward_rounded,
                    )),
                ListTile(
                    onTap: () {},
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(
                      Icons.library_books,
                    ),
                    title: Text("Terms and Condition",
                        style: TextStyleConstant.normal14Style),
                    trailing: const Icon(
                      Icons.arrow_forward_rounded,
                    )),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(
                    Icons.android,
                  ),
                  title: Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Text("App Version",
                        style: TextStyleConstant.normal14Style),
                  ),
                  subtitle:
                      Text("1.0.0", style: TextStyleConstant.normal14Style),
                ),
                const SizedBox(
                  height: 15.0,
                ),
                TextButton(
                    style: TextButton.styleFrom(
                        minimumSize: const Size(double.infinity, 40),
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            side: const BorderSide(width: .2),
                            borderRadius: BorderRadius.circular(10))),
                    onPressed: () async {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              titlePadding:
                                  const EdgeInsets.symmetric(vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              contentPadding: EdgeInsets.zero,
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Image.asset(
                                    height: 55,
                                    ImageConstant.warningIc,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Text(
                                    "Are you sure you want to logout?",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                ],
                              ),
                              actions: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CustomElevatedButton(
                                      width: 110,
                                      height: 40,
                                      buttonColor: Colors.red,
                                      buttonText: "Yes",
                                      buttonTextStyle: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      onTap: () async {
                                        await GoogleSignIn().signOut();

                                        // only signout from firebase not email
                                        await FirebaseAuth.instance.signOut();

                                        Get.offAll(() => const WelcomeScreen());
                                        UiHelper.customSnackbar(
                                            titleMsg: "Logout",
                                            msg: "User Logout Successfull");
                                      },
                                    ),
                                    CustomElevatedButton(
                                      width: 110,
                                      height: 40,
                                      borderColor: Colors.transparent,
                                      buttonColor: Colors.blueAccent,
                                      buttonTextStyle: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      buttonText: "Cancel",
                                      onTap: () {
                                        Get.back();
                                      },
                                    ),
                                  ],
                                )
                              ],
                            );
                          });
                    },
                    child: Text('Log Out',
                        style: TextStyleConstant.bold16Style.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppConstant.appPrimaryColor)))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
