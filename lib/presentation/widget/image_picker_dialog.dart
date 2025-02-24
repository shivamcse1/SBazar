import 'package:flutter/material.dart';

import '../../core/constant/image_const.dart';
import '../../core/constant/textstyle_const.dart';
import 'custom_image.dart';

class ImagePickerDialog extends StatelessWidget {
  final VoidCallback? cameraOnTap; 
  final VoidCallback? galleryOnTap; 
  const ImagePickerDialog({
    super.key, 
    this.cameraOnTap, 
    this.galleryOnTap
    });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.symmetric(vertical: 15),
      iconPadding: const EdgeInsets.only(left: 10, top: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      icon: Text(
        "Select",
        style: TextStyleConstant.normal16Style
            .copyWith(fontWeight: FontWeight.w500),
      ),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: galleryOnTap,
                child: const CustomImage(
                    height: 55, width: 55, image: ImageConstant.appleGalleryIc),
              ),
              const SizedBox(
                height: 8,
              ),
              const Text(
                "Gallery",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap:cameraOnTap,
                child: const CustomImage(
                    height: 55, width: 55, image: ImageConstant.appleCameraIc),
              ),
              const SizedBox(
                height: 8,
              ),
              const Text(
                "Camera",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
