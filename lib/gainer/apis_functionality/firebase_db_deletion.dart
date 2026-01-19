import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseDBDelete {
  Future<void> cleanUpOldReadNotifications(String locationID) async {
    try {
      final now = DateTime.now();
      final thresholdDate = now.subtract(Duration(days: 7));

      final snapshot = await FirebaseFirestore.instance
          .collection('notifications')
          .doc(locationID)
          .collection('userNotifications')
          .where('sendAt', isLessThan: Timestamp.fromDate(thresholdDate))
          // .where('isSeen', isEqualTo: true)
          .get();

      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }

      // print("✅ Deleted ${snapshot.docs.length} old read notifications.");
    } catch (e) {
      // print("❌ Error deleting old read notifications: $e");
    }
  }

  Future<void> cleanUpOldNotifications(String tCode) async {
    final now = DateTime.now();
    final thresholdDate = now.subtract(Duration(days: 7));

    final snapshot = await FirebaseFirestore.instance
        .collection('notifications')
        .doc(tCode)
        .collection('userNotifications')
        .where('sendAt', isLessThan: Timestamp.fromDate(thresholdDate))
        .get();

    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }

    // print("✅ Old notifications deleted");
  }
}
