// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:s_bazar/core/constant/app_const.dart';
import 'package:s_bazar/data/services/get_server_key_service.dart';
import "package:http/http.dart" as http;

class SendNotificationService {
  static Future<void> sendNotification(
      {required String deviceToken,
      required String body,
      required String title,
      required Map<String, dynamic> data}) async {
    try {
      String serverKeyToken = await GetServerKeyService.getServerKeyToken();

      print(deviceToken);
      Map<String, String> headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer $serverKeyToken",
      };

      Map<String, dynamic> message = {
        "message": {
          "token": deviceToken,
          "notification": {"body": body, "title": title},
          "data": data
        }
      };

      var response = await http.post(Uri.parse(AppConstant.notificationUrl),
          headers: headers, body: jsonEncode(message));

      if (response.statusCode == 200) {
        print("Notification send sucessfully");
      } else {
        print("Notification send failed ${response.body}");
      }
    } catch (ex) {
      throw Exception(ex);
    }
  }
}
