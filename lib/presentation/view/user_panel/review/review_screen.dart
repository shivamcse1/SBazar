import 'package:s_bazar/controllers/review_controller.dart';
import 'package:s_bazar/core/constant/textstyle_const.dart';
import 'package:s_bazar/data/model/order_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';

import '../../../../core/constant/app_const.dart';
import '../../../../core/constant/color_const.dart';

class ReviewScreen extends StatefulWidget {
  final OrderModel? orderModel;
  const ReviewScreen({super.key, this.orderModel});

  @override
  State<ReviewScreen> createState() {
    return ReviewScreenState();
  }
}

class ReviewScreenState extends State<ReviewScreen> {
  ReviewController reviewController = Get.put(ReviewController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: ColorConstant.whiteColor),
        backgroundColor: AppConstant.appPrimaryColor,
        title: Text(
          "Review",
          style: TextStyle(color: AppConstant.whiteColor),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: ListView(
          children: [
            const SizedBox(
              height: 10,
            ),
            Align(
                alignment: Alignment.center,
                child: Text(
                  "Add your rating and review",
                  style: TextStyleConstant.normal16Style,
                )),
            const SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.center,
              child: RatingBar.builder(
                  itemSize: 30,
                  itemCount: 5,
                  minRating: 1,
                  allowHalfRating: true,
                  glow: true,
                  glowColor: Colors.pink,
                  itemBuilder: (context, index) {
                    return const Icon(
                      Icons.star,
                      color: Colors.amber,
                    );
                  },
                  onRatingUpdate: (updateRating) {
                    reviewController.productRating = updateRating;
                    setState(() {});
                  }),
            ),
            const SizedBox(
              height: 10,
            ),
            Align(
                alignment: Alignment.center,
                child: Text(
                  "Feedback",
                  style: TextStyleConstant.normal16Style,
                )),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: reviewController.feedbackController,
              keyboardType: TextInputType.multiline,
              maxLines: 10,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Write your feedback here..",
                // label: Text("Feedback")
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorConstant.primaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () async {
                await reviewController.submitReview(
                    orderModel: widget.orderModel);
              },
              child: Text(
                "Submit Review",
                style: TextStyleConstant.bold16Style
                    .copyWith(color: ColorConstant.whiteColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
