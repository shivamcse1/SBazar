import 'package:flutter/widgets.dart';

import '../../core/constant/image_const.dart';

class NoProductFoundWidget extends StatelessWidget {
  final String heading;
  final String subHeading;
  final String image;
  const NoProductFoundWidget({
    super.key,
    this.heading = "No Product Found",
    this.subHeading =
        "It seems like there is not any product in this category so please go to another category products!",
    this.image = ImageConstant.noProductFound2Img,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            image,
            height: 150,
          ),
          Text(
            heading,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            subHeading,
            style: const TextStyle(
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
