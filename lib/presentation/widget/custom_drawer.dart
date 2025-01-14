// ignore_for_file: avoid_unnecessary_containers

import 'package:e_commerce/core/constant/color_const.dart';
import 'package:e_commerce/core/constant/image_const.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../core/constant/textstyle_const.dart';
import '../../utils/Uihelper/custom_snakbar.dart';
import '../view/auth_ui/welcome_screen.dart';

class CustomDrawer extends StatelessWidget {

  final String userEmail ;
  final String userName ; 
  final String userImg ; 
  const CustomDrawer({
    super.key,
    this.userEmail = 'user@gmail.com',
    this.userName = '@Shivam Kumar',
    this.userImg = ImageConstant.profileAvatarImg
    });
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40.0),
       child: Drawer(
        backgroundColor: ColorConstant.primaryColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.0),
            topRight:Radius.circular(10.0),
            bottomRight:Radius.circular(10.0)  
            )
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          
              const SizedBox(height: 30,),

              Stack(
                children: [
                     
                Container(
                  margin:const EdgeInsets.symmetric( horizontal: 10.0,vertical: 10.0),
                  width: 80.0, 
                  height: 80.0, 
                  decoration:  BoxDecoration(
                
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage(userImg),
                      )
                    ),
                  ),

                Positioned(
                  right: 2,
                  bottom: 1,
                  child: GestureDetector(
                    onTap: (){

                    },
                    child: Container(
                      margin:const EdgeInsets.symmetric( horizontal: 10.0,vertical: 10.0),
                      width: 25.0, 
                      height: 25.0, 
                      decoration: BoxDecoration(
                      color: ColorConstant.secondaryColor,
                      shape: BoxShape.circle,
                      ), 
                      child:const Icon(Icons.photo_camera,color: Colors.white,
                      size: 15,
                      ),
                      ),
                  ),
                ),

          
                ],
              ),
             
                Text(userName,style: TextStyle(
                  color: ColorConstant.whiteColor,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold
                ),),
          
                Text(userEmail,style: TextStyle(
                  color: ColorConstant.whiteColor,
                  fontSize: 16.0,
                  
                ),),
               const SizedBox(height: 10,),
               const  Divider(),

              ListTile(
                onTap: (){
                  
                },
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.home,color:ColorConstant.whiteColor,),
                title:  Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Text("Home",style:TextStyleConstant.normal14WhiteStyle.copyWith(
                    color: ColorConstant.whiteColor 
                  ) ,),
                ),
                trailing: Icon(Icons.arrow_forward_rounded,color:ColorConstant.whiteColor,)),
               

              ListTile(
                onTap: (){
                  
                },
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.store,color:ColorConstant.whiteColor,),
                title:  Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Text("Order",style:TextStyleConstant.normal14WhiteStyle.copyWith(
                    color: ColorConstant.whiteColor 
                  ) ,),
                ),
                trailing: Icon(Icons.arrow_forward_rounded,color:ColorConstant.whiteColor,)),
               

              ListTile(
                onTap: (){
                  
                },
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.account_circle,color:ColorConstant.whiteColor,),
                title:  Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Text("Edit Profile",style:TextStyleConstant.normal14WhiteStyle.copyWith(
                    color: ColorConstant.whiteColor 
                  ) ,),
                ),
                trailing: Icon(Icons.arrow_forward_rounded,color:ColorConstant.whiteColor,)),
               
              ListTile(
                onTap: (){
                  
                },
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.add_location_alt,color:ColorConstant.whiteColor,),
                title:  Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Text("Saved Addresses",style:TextStyleConstant.normal14WhiteStyle.copyWith(
                    color: ColorConstant.whiteColor 
                  ) ,),
                ),
                trailing: Icon(Icons.arrow_forward_rounded,color:ColorConstant.whiteColor,)),
              

              ListTile(
                onTap: (){
                  
                },
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.share,color:ColorConstant.whiteColor,),
                title:  Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Text("Share to Friends",style:TextStyleConstant.normal14WhiteStyle.copyWith(
                    color: ColorConstant.whiteColor 
                  ) ,),
                ),
                trailing: Icon(Icons.arrow_forward_rounded,color:ColorConstant.whiteColor,)),
              

              ListTile(
                onTap: (){

                },
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.library_books,color:ColorConstant.whiteColor,),
                title:  Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Text("Terms and Condition",style:TextStyleConstant.normal14WhiteStyle.copyWith(
                    color: ColorConstant.whiteColor 
                  ),),
                ),
                trailing: Icon(Icons.arrow_forward_rounded,color:ColorConstant.whiteColor,
                )),


              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.android,color:ColorConstant.whiteColor,),
                title:  Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Text("App Version",style:TextStyleConstant.normal14WhiteStyle.copyWith(
                    color: ColorConstant.whiteColor 
                  ) ,),
                ),
                subtitle:  Text("1.0.0",style:TextStyleConstant.normal14WhiteStyle.copyWith(
                    color: ColorConstant.whiteColor 
                  ),),
              ),

            const SizedBox(height: 20.0,),

            ElevatedButton(
              
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 40),
                backgroundColor: ColorConstant.secondaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10-.0)
                )
              ),
              onPressed: () async{
                // only signout from firebase not email
                await FirebaseAuth.instance.signOut();
                
                // signout from email so that next time you need to select email again 
                await GoogleSignIn().signOut();
                
                Get.offAll(() => const WelcomeScreen() );
                SnackbarHelper.customSnackbar(titleMsg: "Logout", msg: "User Logout Successfull");

              }, 
              child:Text('Log Out',style:TextStyleConstant.bold14WhiteStyle.copyWith(
                    color: ColorConstant.whiteColor 
                  )))
               
              ],
            ),
        ),
      
      ));
  }
}