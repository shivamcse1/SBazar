import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:s_bazar/core/constant/app_const.dart';
import 'package:s_bazar/core/constant/database_key_const.dart';
import 'package:s_bazar/presentation/widget/custom_app_bar.dart';
import 'package:s_bazar/presentation/widget/no_product_found_widget.dart';
import 'package:s_bazar/utils/date_time_converter.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Notification",
        appBarColor: AppConstant.appPrimaryColor,
        backIconColor: Colors.white,
        titleStyle: const TextStyle(color: Colors.white),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection(DbKeyConstant.notificationsCollection)
            .doc(user!.uid)
            .collection(DbKeyConstant.savedNotificationsCollection)
            .orderBy(DbKeyConstant.isSeen, descending: false)
            .snapshots(),
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: AppConstant.appPrimaryColor,
              ),
            );
          } else if (snapshot.hasData) {
            if (snapshot.data!.docs.isNotEmpty) {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final docData = snapshot.data!.docs[index];
                  final docId = docData.id;
                  final Timestamp date = docData[DbKeyConstant.createdAt];
                  return Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    child: Stack(children: [
                      ListTile(
                        onTap: () async {
                          await FirebaseFirestore.instance
                              .collection(DbKeyConstant.notificationsCollection)
                              .doc(user!.uid)
                              .collection(
                                  DbKeyConstant.savedNotificationsCollection)
                              .doc(docId)
                              .update({DbKeyConstant.isSeen: true});
                        },
                        tileColor: docData[DbKeyConstant.isSeen] == false
                            ? Colors.amber.shade100
                            : Colors.white,
                        leading: CircleAvatar(
                          child: Icon(
                              docData[DbKeyConstant.isSeen] == false
                                  ? Icons.notifications_active
                                  : Icons.notifications,
                              color: docData[DbKeyConstant.isSeen] == false
                                  ? Colors.red
                                  : Colors.green),
                        ),
                        title: Text(
                          docData[DbKeyConstant.notificationTitle],
                          softWrap: true,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: docData[DbKeyConstant.isSeen] == false
                                  ? AppConstant.appPrimaryColor
                                  : Colors.green),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(docData[DbKeyConstant.notificationBody]),
                            Text(
                                DateTimeConverter.getDayMonthYear(
                                    datetime: date.toDate(),
                                    isFullMonthName: false),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 12))
                          ],
                        ),
                      ),
                      docData[DbKeyConstant.isSeen] == false
                          ? const Positioned(
                              left: 15,
                              top: 10,
                              child: Text(
                                "New",
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ))
                          : const SizedBox()
                    ]),
                  );
                },
              );
            } else {
              return const NoProductFoundWidget(
                heading: "No Notificaiton Found",
                subHeading: "Notification data empty",
              );
            }
          } else if (snapshot.hasError) {
            return const Center(
              child: Text(
                "Somthing Went Wrong",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            );
          } else {
            return const NoProductFoundWidget(
              heading: "No Notificaiton Found",
              subHeading: "Notification data empty",
            );
          }
        }),
      ),
    );
  }
}
