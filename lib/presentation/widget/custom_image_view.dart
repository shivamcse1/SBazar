import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/constant/image_const.dart';

class CustomImageView extends StatelessWidget {
  final String imgString;
  final double? height;
  final double? width;
  const CustomImageView(
      {super.key, required this.imgString, this.height, this.width});

  @override
  Widget build(BuildContext context) {
    Uri uri = Uri.parse(imgString);
    return uri.hasScheme
        ? CachedNetworkImage(
            height: height,
            width: width,
            imageUrl: imgString,
            fit: BoxFit.cover,
            // Placeholder while the image is loading
            placeholder: (context, imgUrl) {
              return Container(
                color: Colors.white,
                child: const Center(
                  child: CupertinoActivityIndicator(),
                ),
              );
            },

            errorWidget: (context, url, error) {
              return Image.asset(ImageConstant.previewImg);
            },
          )
        : (imgString.endsWith(".jpg") ||
                imgString.endsWith(".png") ||
                imgString.endsWith(".jpeg") ||
                imgString.endsWith(".gif"))
            ? Image.asset(
                imgString,
                height: height,
                width: width,
                fit: BoxFit.contain,
              )
            : imgString.endsWith(".svg")
                ? SvgPicture.asset(
                    imgString,
                    height: height,
                    width: width,
                    fit: BoxFit.contain,
                  )
                : Image.asset(ImageConstant.previewImg);
  }
}
