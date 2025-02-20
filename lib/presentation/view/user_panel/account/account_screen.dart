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
import 'package:s_bazar/presentation/widget/custom_image_view.dart';
import '../../../../core/constant/textstyle_const.dart';
import '../../../../utils/Uihelper/ui_helper.dart';
import '../../auth_ui/welcome_screen.dart';
import '../address/address_screen.dart';
import '../order/order_screen.dart';
import '../wishlist/wishlist_screen.dart';
import '../../../widget/custom_image.dart';
import 'update_profile_screen.dart';

class AccountScreen extends StatefulWidget {

  const AccountScreen(
      {
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



  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async{ 
    await getUserDataController.getUserData(user!.uid);
    var data = getUserDataController.userDataList[0];

      UserModel userModel = UserModel(
        userUid: data[DbKeyConstant.userUid],
        userName: data[DbKeyConstant.userName],
        userEmail: data[DbKeyConstant.userEmail],
        userPhone: data[DbKeyConstant.userPhone],
        userImg: data[DbKeyConstant.userImg],
        userDeviceToken: data[DbKeyConstant.userDeviceToken],
        userCountry: data[DbKeyConstant.userCountry],
        userStreet: data[DbKeyConstant.userStreet],
        isAdmin: data[DbKeyConstant.isAdmin],
        isActive: data[DbKeyConstant.isActive],
        createdAt: data[DbKeyConstant.createdAt],
        userCity: data[DbKeyConstant.userCity],
        userState: data[DbKeyConstant.userState],
      );

      authController.assignDataToController(userModel: userModel);

    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade50,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 50,
            ),
            Stack(
              children: [
                InkWell(
                  onTap: () {
                    Get.to(
                      () => const CustomImageView(
                          image:
                              "https://plus.unsplash.com/premium_photo-1664474619075-644dd191935f?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8aW1hZ2V8ZW58MHx8MHx8fDA%3D"),
                      duration: const Duration(milliseconds: 530),
                    );
                  },
                  child: const Hero(
                    tag: "profile",
                    child: CustomImage(
                      height: 130,
                      shape: BoxShape.circle,
                      imageFit: BoxFit.fill,
                      image:
                          "https://plus.unsplash.com/premium_photo-1664474619075-644dd191935f?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8aW1hZ2V8ZW58MHx8MHx8fDA%3D",
                    ),
                  ),
                ),
                Positioned(
                  right: -10,
                  bottom: -8,
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 10.0),
                      width: 30.0,
                      height: 30.0,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: ColorConstant.pinkColor,
                          width: .3,
                        ),
                        color: ColorConstant.whiteColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.photo_camera,
                        color: Colors.pink,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Obx(
              () => Text(
                getUserDataController.userDataList.isNotEmpty ?
                getUserDataController.userDataList[0][DbKeyConstant.userName]

                : "@User Name",
                style: const TextStyle(
                    fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
            ),
            Obx(
              () => Text(
                 getUserDataController.userDataList.isNotEmpty ?
                getUserDataController.userDataList[0][DbKeyConstant.userEmail] :
                "@User Email",
                style: const TextStyle(
                  fontSize: 16.0,
                ),
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
                title: Text("My Order", style: TextStyleConstant.normal14Style),
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
                title: Text("Wishlist", style: TextStyleConstant.normal14Style),
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
                child:
                    Text("App Version", style: TextStyleConstant.normal14Style),
              ),
              subtitle: Text("1.0.0", style: TextStyleConstant.normal14Style),
            ),
            const SizedBox(
              height: 20.0,
            ),
            TextButton(
                style: TextButton.styleFrom(
                    minimumSize: const Size(double.infinity, 40),
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        side: const BorderSide(width: .2),
                        borderRadius: BorderRadius.circular(10))),
                onPressed: () async {
                  // FirebaseFirestore.instance
                  //     .collection(DbKeyConstant.userCollection)
                  //     .doc(FirebaseAuth.instance.currentUser!.uid)
                  //     .update({
                  //   "isActive": false,
                  // });

                  // signout from email so that next time you need to select email again
                  await GoogleSignIn().signOut();

                  // only signout from firebase not email
                  await FirebaseAuth.instance.signOut();

                  Get.offAll(() => const WelcomeScreen());
                  UiHelper.customSnackbar(
                      titleMsg: "Logout", msg: "User Logout Successfull");
                },
                child: Text('Log Out',
                    style: TextStyleConstant.bold16Style.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppConstant.appPrimaryColor)))
          ],
        ),
      ),
    );
  }
}
