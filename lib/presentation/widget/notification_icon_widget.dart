import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:s_bazar/core/constant/database_key_const.dart';

import '../view/user_panel/notification/notification_screen.dart';

class NotificationIconWidget extends StatefulWidget {
  const NotificationIconWidget({super.key});

  @override
  State<NotificationIconWidget> createState() => _NotificationIconWidgetState();
}

class _NotificationIconWidgetState extends State<NotificationIconWidget> {
  final User? user = FirebaseAuth.instance.currentUser;
  int totalUnseenNotification = 0;

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore.instance
        .collection(DbKeyConstant.notificationsCollection)
        .doc(user!.uid)
        .collection(DbKeyConstant.savedNotificationsCollection)
        .where(DbKeyConstant.isSeen, isEqualTo: false)
        .snapshots()
        .listen((snapshots) {
      totalUnseenNotification = snapshots.docs.length;
      setState(() {});
    });

    return InkWell(
      onTap: () {
        Get.to(() => const NotificationScreen());
      },
      child: Stack(children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          child: Icon(
            Icons.notifications,
            size: 27,
          ),
        ),
        totalUnseenNotification != 0
            ? Positioned(
                top: 3,
                right: 1,
                child: Container(
                  height: 15,
                  width: 15,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.pink,
                  ),
                  child: Center(
                      child: Text(
                    totalUnseenNotification.toString(),
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  )),
                ),
              )
            : const SizedBox()
      ]),
    );
  }
}
