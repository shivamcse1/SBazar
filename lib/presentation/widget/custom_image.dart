import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/constant/image_const.dart';

class CustomImage extends StatelessWidget {
  final String image;
  final String? errorImage;
  final double height;
  final double width;
  final Color? backgroundColor;
  final BoxFit imageFit;
  final BoxShape shape;
  final BorderRadiusGeometry borderRadius;

  const CustomImage({
    super.key,
    required this.image,
    this.height = 50,
    this.width = 50,
    this.imageFit = BoxFit.cover,
    this.shape = BoxShape.rectangle,
    this.backgroundColor,
    this.errorImage,
    this.borderRadius = BorderRadius.zero,
  });

  @override
  Widget build(BuildContext context) {
    Uri uri = Uri.parse(image);
    return uri.hasScheme
        ? shape == BoxShape.circle
            ? ClipOval(
                child: CachedNetworkImage(
                  height: height,
                  width: height,
                  imageUrl: image,
                  fit: imageFit,
                  // Placeholder while the image is loading
                  placeholder: (context, imgUrl) {
                    return Container(
                      color: Colors.white,
                      child: const Center(
                        child: CupertinoActivityIndicator(),
                      ),
                    );
                  },
                  //when any error occur
                  errorWidget: (context, url, error) {
                    return Container(
                        decoration: BoxDecoration(
                      borderRadius:
                          shape != BoxShape.circle ? borderRadius : null,
                      color: backgroundColor ?? Colors.grey.shade300,
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage(
                          errorImage ?? ImageConstant.previewIc,
                        ),
                      ),
                    ));
                  },
                ),
              )
            : ClipRRect(
                borderRadius: borderRadius,
                child: CachedNetworkImage(
                  height: height,
                  width: width,
                  imageUrl: image,
                  fit: imageFit,
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
                    return ClipRRect(
                      borderRadius: borderRadius,
                      child: Image.asset(
                        errorImage ?? ImageConstant.previewIc,
                      ),
                    );
                  },
                ),
              )
        : (image.endsWith(".jpg") ||
                image.endsWith(".png") ||
                image.endsWith(".jpeg") ||
                image.endsWith(".gif"))
            ? Container(
                height: height,
                width: shape == BoxShape.circle ? height : width,
                decoration: BoxDecoration(
                  color: backgroundColor ??
                      (shape == BoxShape.circle
                          ? Colors.grey.shade300
                          : Colors.transparent),
                  borderRadius: shape != BoxShape.circle ? borderRadius : null,
                  shape: shape,
                  image: DecorationImage(
                    fit: imageFit,
                    image: AssetImage(
                      image,
                    ),
                  ),
                ))
            : image.endsWith(".svg")
                ? Container(
                    height: height,
                    width: shape == BoxShape.circle ? height : width,
                    decoration: BoxDecoration(
                      shape: shape,
                      borderRadius:
                          shape != BoxShape.circle ? borderRadius : null,
                      color: backgroundColor ??
                          (shape == BoxShape.circle
                              ? Colors.grey.shade300
                              : Colors.transparent),
                    ),
                    child: SvgPicture.asset(
                      image,
                      fit: imageFit,
                      placeholderBuilder: (context) {
                        return Container(
                          color: Colors.white,
                          child: const Center(
                            child: CupertinoActivityIndicator(),
                          ),
                        );
                      },
                    ),
                  )
                : Container(
                    height: height,
                    width: shape == BoxShape.circle ? height : width,
                    decoration: BoxDecoration(
                      borderRadius:
                          shape != BoxShape.circle ? borderRadius : null,
                      shape: shape,
                      color: backgroundColor ??
                          (shape == BoxShape.circle
                              ? Colors.grey.shade300
                              : Colors.transparent),
                      image: DecorationImage(
                        fit: imageFit,
                        image: const AssetImage(ImageConstant.previewIc),
                      ),
                    ),
                  );
  }
}
