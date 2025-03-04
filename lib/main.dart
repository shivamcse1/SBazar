// ignore_for_file: avoid_print

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:s_bazar/data/local_database/local_database_helper.dart';
import 'package:s_bazar/data/services/firebase_notification_service.dart';

import 'core/routes/app_routes.dart';

final RouteObserver<ModalRoute> routeObserver = RouteObserver<ModalRoute>();
final LocalDataBaseHelper localDataBaseHelper = LocalDataBaseHelper();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await localDataBaseHelper.sharedPrefInit();
  try {
    await Firebase.initializeApp();
  } catch (e) {
    print("Firebase Error: $e");
  }

  await FirebaseNotificationService.initializeNotification();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      navigatorObservers: [routeObserver],
      theme: ThemeData(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      builder: EasyLoading.init(),
      getPages: AppRoutes.pages,
    );
  }
}
