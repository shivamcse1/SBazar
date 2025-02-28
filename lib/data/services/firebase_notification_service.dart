// ignore_for_file: avoid_print, unused_local_variable

import 'dart:io';
import 'dart:ui';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:s_bazar/presentation/view/user_panel/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:s_bazar/presentation/view/user_panel/cart/cart_screen.dart';
import 'package:s_bazar/utils/Uihelper/ui_helper.dart';

class FirebaseNotificationService {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<String> getDeviceToken() async {
    try {
      String? deviceToken = await FirebaseMessaging.instance.getToken();
      print("Token => $deviceToken");
      return deviceToken ?? "";
    } catch (ex) {
      throw Exception(ex);
    }
  }

  static Future<void> requestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      carPlay: true,
      sound: true,
      provisional: true,
      criticalAlert: true,
    );

    // only for android 12+ device explicitly request necessary
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      UiHelper.customToast(msg: "User Notification Permission Granted");
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      UiHelper.customToast(
          msg: "User Provisonal Notification Permission Granted");
    } else {
      UiHelper.customSnackbar(
        titleMsg: "Notification Permission Denied",
        msg: "Please Allow Notification To Recieve Updates",
      );

      Future.delayed(const Duration(seconds: 3), () {
        openAppSettings();
      });
    }
  }

  static Future<void> showNotification({required RemoteMessage message}) async {
    // for android 8+ if not describe then may be not show notification
    AndroidNotificationChannel channel = AndroidNotificationChannel(
      message.notification!.android!.channelId.toString(),
      message.notification!.android!.channelId.toString(),
      playSound: true,
      showBadge: true,
      importance: Importance.high,
    );

// for android notificaition appereance and customization
// default setting me show hogi only for 8 version se kam wale device me
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
            channel.id.toString(), channel.name.toString(),
            importance: Importance.high,
            enableVibration: true,
            playSound: true,
            priority: Priority.high,
            sound: channel.sound,
            largeIcon:
                const DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
            channelDescription: "Channel Description");

// for ios notification appreance and customization
// sirf ios 15 tak hi dikhegi aur deafult setting use karegi ios 15+ me nahi show hogi if not describe this.
    DarwinNotificationDetails iOSNotificationDetails =
        const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

// merging both ios and android
    NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails, iOS: iOSNotificationDetails);

// for showing notification
    flutterLocalNotificationsPlugin.show(
      0,
      message.notification!.title,
      message.notification!.body,
      notificationDetails,
    );
  }

  //!-----------for click event on notificaiton -------//
  //iske initialize ke bina hm show(),click on notification,schedule notification ye sab work nahi karega
  static Future<void> setupNotificationSetting(
      {required RemoteMessage message}) async {
    // for defualt icon setting in andorid
    AndroidInitializationSettings androidInitializationSettings =
        const AndroidInitializationSettings("@mipmap/ic_launcher");

    // for ios setting
    DarwinInitializationSettings ioSInitializationSettings =
        const DarwinInitializationSettings();

    // for merging both android and ios
    InitializationSettings initializationSettings = InitializationSettings(
        android: androidInitializationSettings, iOS: ioSInitializationSettings);

    // for initialize  both setting ios and android
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if (response.payload != null) {
          onNotificationTap(message);
        }
      },
    );
  }

  static Future<void> backgroundClickListner() async {
    //background state
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print("app background");
      onNotificationTap(message);
    });

    //terminated state
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null && message.data.isNotEmpty) {
        print("app terminated");
        onNotificationTap(message);
      }
    });
  }

  //!--------  notificaiton handler -------------//
  static void foregrounNotificationdHandler() async {
    FirebaseMessaging.onMessage.listen((message) async {
      RemoteNotification? notification = message.notification;
      AndroidNotification? androidNotificaiton = notification!.android;
      if (Platform.isIOS) {
        await iosForegroundNotificationHandler();
        onNotificationTap(message);
      }
      if (Platform.isAndroid) {
        setupNotificationSetting(message: message);

        showNotification(message: message);
      }
    });
  }

  //!----------mainly use for heavy processing in background or data fetching--------///
  static Future<void> backgroundNotificationHandler(
      RemoteMessage message) async {
    print("Background Notificaiton Data :${message.notification!.title}");
  }

  static Future<void> iosForegroundNotificationHandler() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  // only for navigation based on notification
  static Future<void> onNotificationTap(RemoteMessage message) async {
    Get.to(() => const CartScreen());
  }

  static Future<void> initializeNotification() async {
    //backgroundHandler
    FirebaseMessaging.onBackgroundMessage(backgroundNotificationHandler);

    //foregroundHandler
    foregrounNotificationdHandler();

    //backgroundclick listner
    backgroundClickListner();
  }
}
