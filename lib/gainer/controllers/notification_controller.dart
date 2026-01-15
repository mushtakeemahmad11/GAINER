import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../model/user_notification_model.dart';

class NotificationController extends GetxController {

  String? lastVisitedLocationId; // Store current ID
  @override
  void onClose() {
    // Mark all as seen when user leaves the screen
    if (lastVisitedLocationId != null) {
      // markAllNotificationsAsSeen(lastVisitedLocationId!);
    }
    super.onClose();
  }

  final RxList<UserNotification> notifications = <UserNotification>[].obs;

  Future<void> fetchNotifications(String selectedLocationID) async {
    lastVisitedLocationId = selectedLocationID;
    // final snapshot = await FirebaseFirestore.instance
    //     .collection('notifications')
    //     .doc(tCode)
    //     .collection('userNotifications')
    //     .orderBy('sendAt', descending: true)
    //     .get();

    final snapshot = await FirebaseFirestore.instance
        .collection('notifications')
        .doc(selectedLocationID)
        .collection('userNotifications')
        .where('sendAt', isNotEqualTo: null)
        .orderBy('sendAt', descending: true)
        .get();

    final fetched = snapshot.docs.map((doc) {
      return UserNotification.fromMap(doc.id, doc.data());
    }).toList();

    notifications.assignAll(fetched);
  }

  Future<void> markAsSeen(String selectedLocationID, String notificationId) async {
    await FirebaseFirestore.instance
        .collection('notifications')
        .doc(selectedLocationID)
        .collection('userNotifications')
        .doc(notificationId)
        .update({'isSeen': true});

    // Refresh after update
    await fetchNotifications(selectedLocationID);
    // Get.off(()=>OrderReceivedScreen());

  }

  Future<void> markAllNotificationsAsSeen(String selectedLocationID) async {
    final collectionRef = FirebaseFirestore.instance
        .collection('notifications')
        .doc(selectedLocationID)
        .collection('userNotifications');

    final snapshot = await collectionRef.get();

    final batch = FirebaseFirestore.instance.batch();

    for (var doc in snapshot.docs) {
      batch.update(doc.reference, {'isSeen': true});
    }

    await batch.commit();

    // Refresh after update
    await fetchNotifications(selectedLocationID);
  }
}
