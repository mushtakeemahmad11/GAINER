import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/notification_controller.dart';
import '../utility/format_custom_date_time.dart';
import 'colors.dart';

class NotificationScreen extends StatefulWidget {
  final String selectedLocationID;

  const NotificationScreen({super.key, required this.selectedLocationID});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final NotificationController controller = Get.put(NotificationController());

  @override
  void initState() {
    super.initState();
    controller.fetchNotifications(widget.selectedLocationID);
  }

  Future<void> _onWillPop() async {
    // ✅ Mark all as read when user goes back
    await controller.markAllNotificationsAsSeen(widget.selectedLocationID);
  }

  @override
  Widget build(BuildContext context) {
    // controller.fetchNotifications(widget.selectedLocationID);
    return PopScope(
      canPop: true, // you still must allow pop
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) _onWillPop();
      },
      child: Scaffold(
        appBar: AppBar(title: Text("Notifications")),
        body: RefreshIndicator(
          onRefresh: () async {
            await controller.fetchNotifications(widget.selectedLocationID);
          },
          child: Obx(() {
            if (controller.notifications.isEmpty) {
              return Center(child: Text("No notifications"));
            }

            return ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 8),
              itemCount: controller.notifications.length,
              itemBuilder: (context, index) {
                // controller.markAllNotificationsAsSeen(selectedLocationID);
                final notif = controller.notifications[index];
                String dateTime = FormatDateTime.formatCustomDateTime(
                    inputDateTimeStr: notif.sendAt);
                return Card(
                  // color: AppColor.primaryShade,
                  color: notif.isSeen ? AppColor.primaryShade : Colors.red[100],
                  child: ListTile(
                    title: Text(notif.title),
                    subtitle: Text(notif.body),
                    trailing: Text(dateTime),
                    // trailing: notif.isSeen
                    //     ? Icon(Icons.done, color: Colors.green)
                    //     : Icon(Icons.notifications_active, color: Colors.red),
                    // trailing: notif.isSeen ? null : Icon(Icons.fiber_new_outlined, color: Colors.red),
                    onTap: () {
                      controller.markAsSeen(
                          widget.selectedLocationID, notif.id);

                      // await copyNotificationsWithSubcollectionOnly(oldId: '18', newId: '42630');
                    },
                  ),
                );
              },
            );
          }),
        ),
      ),
    );
  }

  Future<void> copyNotificationsWithSubcollectionOnly({
    required String oldId,
    required String newId,
  }) async {
    final firestore = FirebaseFirestore.instance;

    final oldDocRef = firestore.collection('notifications').doc(oldId);
    final newDocRef = firestore.collection('notifications').doc(newId);

    try {
      // Try copying the main document (if it exists)
      final oldDocSnapshot = await oldDocRef.get();

      if (oldDocSnapshot.exists) {
        // print("✅ Old document exists. Copying data...");
        final data = oldDocSnapshot.data();
        if (data != null) {
          await newDocRef.set(data);
        }
      } else {
        // print("⚠️ Old document does not exist, skipping document data copy...");
        // Still create an empty parent document if you want
        await newDocRef.set({});
      }

      // ✅ Always copy the subcollection
      final subSnapshot = await oldDocRef.collection('userNotifications').get();

      for (var doc in subSnapshot.docs) {
        await newDocRef
            .collection('userNotifications')
            .doc(doc.id)
            .set(doc.data());
      }

      // print("✅ Successfully copied subcollection to new ID: $newId");
    } catch (e) {
      // print("🔥 Error: $e");
    }
  }
}
