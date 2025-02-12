// ignore_for_file: prefer_const_declarations, deprecated_member_use

import 'package:s_bazar/data/model/product_model.dart';
import 'package:url_launcher/url_launcher.dart';

class ShareHelper {
  static Future<void> sendTextOnWhatsapp({
    required ProductModel productModel,
  }) async {
    final number = "+919696599965";
    final String message = "My name is shivam";
    // creating ws url
    final url = "https://wa.me/$number?text=${Uri.encodeComponent(message)}";

    if (await canLaunch(url)) {
      await launchUrl(Uri.parse(url));
    } else {
      throw "could not launch $url";
    }
  }
}
