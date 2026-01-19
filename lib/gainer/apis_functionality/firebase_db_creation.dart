import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../shared_preferences/shared_preferences_get_data.dart';

class FirebaseDB {
  // for accessing cloud firestore database
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  //for accessing cloud firestore database
  static FirebaseStorage storage = FirebaseStorage.instance;

  // //fro creating a new user if not exists
  // static Future<void> createNotificationDB(
  //   String dealerID,
  //   String title,
  //   String body,
  // ) async {
  //   int tCode = await getIntData("tCode");
  //   final time = DateTime.now().millisecondsSinceEpoch.toString();
  //
  //   await firestore
  //       .collection('notification')
  //       .doc(tCode.toString())
  //       // .collection('notifications')
  //       // .doc()
  //       .set(
  //     {
  //       "title": title,
  //       "body": body,
  //       "isSeen": false,
  //       "sendAt": time,
  //       "userId": tCode,
  //       "dealerID": dealerID,
  //     },
  //   );
  //
  //   // await SendNotification.sendPushNotification(
  //   //     token:
  //   //     "cdUGWbtmTlSprBnaKolH0l:APA91bHfc3ow_9Fq9T20PowxgK_sbwGOOuRkyRySVfSc-WUSJ-muZMpo3QM4zODB5uSVqvi_UNaCd2P2Cew6Tv4QANML0X7y2hWas2b30R_aeb8KqO2QiEw",
  //   //     title: "Gainer Firebase Testing",
  //   //     body: "This is demo notification using function in firebaseDB",
  //   //     data: {
  //   //       "Screen": "OrderReceivedScreen",
  //   //       "key2": "value2",
  //   //     });
  // } //comment

  static Future<void> createNotificationDB({
    required String locationID,
    required String title,
    required String body,
  }) async {
    // final time = DateTime.now();
    int tCode = await getIntData("tCode");
    // final time = DateTime.now().millisecondsSinceEpoch.toString();
    final docRef = FirebaseFirestore.instance
        .collection('notifications')
        // .doc(tCode.toString())
        .doc(locationID)
        .collection('userNotifications')
        .doc(); // auto-generated

    await docRef.set({
      "title": title,
      "body": body,
      "isSeen": false,
      // "sendAt": time,
      'sendAt': FieldValue.serverTimestamp(),
      "userId": tCode,
      "locationID": locationID,
    });
  }

  Future<void> storeDeviceToken({
    required String userId,
    required String userCode,
    required String dealerId,
    required List<String> locationIds,
  }) async {
    final token = await FirebaseMessaging.instance.getToken();
    if (token == null) return;

    // final currentTime = getCurrentTimeAsString();
    final docRef = FirebaseFirestore.instance.collection('users').doc(userId);

    await docRef.set({
      'usercode': userCode,
      'dealerid': dealerId,
      'locationids': locationIds,
      // 'createAt': currentTime,
      'createAt': FieldValue.serverTimestamp(),
      'token': token,
    }, SetOptions(merge: true));

    // // Remove old tokens and keep only current one
    // await docRef.update({
    //   'tokens': FieldValue.arrayUnion([token])
    // });
  }

  void setupTokenRefreshListener() {
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
      // Update Firestore with the new token here
      await storeDeviceToken(
        userId: 'USER_ID',
        userCode: 'USER_CODE',
        dealerId: 'DEALER_ID',
        locationIds: ['LOC_ID_1'],
      );
    });
  }

  void fetchAndSortUsers() async {
    final snapshot = await FirebaseFirestore.instance.collection('users').get();

    final users = snapshot.docs
        .map((doc) {
          final data = doc.data();
          final name = doc.id;
          final rawCreateAt = data['createAt'];

          // Handle both types of timestamp
          DateTime? createAt;
          if (rawCreateAt is Timestamp) {
            createAt = rawCreateAt.toDate();
          } else if (rawCreateAt is String) {
            createAt = DateTime.tryParse(rawCreateAt);
          }

          return {
            'name': name,
            'createAt': createAt,
          };
        })
        .where((e) => e['createAt'] != null)
        .toList();

    // Sort descending (newest first)
    users.sort((a, b) =>
        (b['createAt'] as DateTime).compareTo(a['createAt'] as DateTime));

    // Print result
    // for (var user in users) {
    //   print('${user['name']} => ${user['createAt']}');
    // }
  }
}
