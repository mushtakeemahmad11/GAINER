import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class FirebaseDbDeletion {
  Future<void> cleanUpOldReadNotifications(String locationID) async {
    try {
      final now = DateTime.now();

      // 7 days ago from now
      final thresholdDate = now.subtract(const Duration(days: 7));

      final snapshot = await FirebaseFirestore.instance
          .collection('gainer-notifications')
          .where(
            'createdAt',
            isLessThan: Timestamp.fromDate(thresholdDate),
          )
          .get();

      if (snapshot.docs.isEmpty) return;

      final batch = FirebaseFirestore.instance.batch();

      for (final doc in snapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
    } catch (e) {
      debugPrint('❌ Error deleting old notifications: $e');
    }
  }

  Future<void> cleanUpOldNotifications(String tCode) async {
    final now = DateTime.now();
    final thresholdDate = now.subtract(Duration(days: 7));

    final snapshot = await FirebaseFirestore.instance
        .collection('gainer-notifications')
        .doc(tCode)
        .collection('userNotifications')
        .where('sendAt', isLessThan: Timestamp.fromDate(thresholdDate))
        .get();

    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }

    // print("✅ Old notifications deleted");
  }

  Future<void> deleteInvalidToken(String docId) async {
    await FirebaseFirestore.instance
        .collection('users-details')
        .doc(docId)
        .update({'deviceToken': FieldValue.delete()});
  }
}