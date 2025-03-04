import 'package:flutter/widgets.dart';

import '../../core/constant/image_const.dart';

class NoProductFoundWidget extends StatelessWidget {
  final String heading;
  final String subHeading;
  final double imageHeight;
  final TextStyle? headingStyle;
  final TextStyle? subheadingStyle;
  final String image;
  const NoProductFoundWidget({
    super.key,
    this.heading = "No Product Found",
    this.subHeading =
        "It seems like there is not any product in this category so please go to another category products!",
    this.image = ImageConstant.noProductFound2Img,
    this.headingStyle,
    this.subheadingStyle,
    this.imageHeight = 150,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              image,
              height: imageHeight,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              heading,
              style: headingStyle ??
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              subHeading,
              style: subheadingStyle ??
                  const TextStyle(
                    fontSize: 14,
                  ),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
