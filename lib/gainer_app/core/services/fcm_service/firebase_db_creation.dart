import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../Services/auth_service.dart';
import 'firebase_notification_service.dart';

class FirebaseDbCreation {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> saveNotification({
    required String title,
    required String body,
    required String receiverLocationId,
    String type = 'buyer/seller',
    Map<String, dynamic>? data,
  }) async {
    final tCode = await AuthService.getTCode();
    final userId = await AuthService.getUserId();
    final sourceLocationId = await AuthService.getLocationId();
    await _firestore.collection('gainer-notifications').add({
      'sourceLocationId': sourceLocationId,
      'userId': userId,
      'tCode': tCode,
      'locationId': receiverLocationId,
      'title': title,
      'body': body,
      'type': type,
      'data': data ?? {},
      'read': false,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  static Future<void> markRead(String id) async {
    await _firestore
        .collection('gainer-notifications')
        .doc(id)
        .update({'read': true});
  }

  // static Future<void> storeDeviceToken({
  //   required String tCode,
  //   required String userId,
  //   required String dealerId,
  //   required List<String> locationIds,
  // }) async {
  //   // final token = await FirebaseMessaging.instance.getToken();
  //   final token = await NotificationServiceNEW.getFirebaseMessagingToken();
  //   if (token == null) return;
  //
  //   // final currentTime = getCurrentTimeAsString();
  //   final docRef =
  //       FirebaseFirestore.instance.collection('user-details').doc(tCode);
  //
  //   await docRef.set({
  //     'userId': userId,
  //     'dealerid': dealerId,
  //     'locationids': locationIds,
  //     'createAt': FieldValue.serverTimestamp(),
  //     'token': token,
  //   }, SetOptions(merge: true));
  // }

  // static Future<List<String>> getAllToken({
  //   String? dealerId,
  //   String? locationId,
  // }) async {
  //   Query query = FirebaseFirestore.instance.collection('user-details');
  //
  //   if (dealerId != null) {
  //     query = query.where('dealerid', isEqualTo: dealerId);
  //   } else if (locationId != null) {
  //     query = query.where('locationids', arrayContains: locationId);
  //   }
  //
  //   final snapshot = await query.get();
  //
  //   List<String> tokens = [];
  //
  //   for (var doc in snapshot.docs) {
  //     final token = doc['token'];
  //     if (token != null && token.toString().isNotEmpty) {
  //       tokens.add(token);
  //     }
  //   }
  //
  //   return tokens;
  // }

  static Future<void> storeUserDetails({
    required String role,
    required String dealerId,
    required List locationIds,
    // required Map<String, String> locationIds,
    required String appVersion,
  }) async {
    String? userName = await AuthService.getUserId();
    String? tCode = await AuthService.getTCode();
    if (tCode.isEmpty || tCode == "NULL") return;

    final token = await NotificationServiceNEW.getFirebaseMessagingToken();
    if (token == null) return;

    final ref =
        FirebaseFirestore.instance.collection('users-details').doc(tCode);

    final snap = await ref.get();

    final Map<String, dynamic> updateData = {
      'role': role.toLowerCase(),
      'dealerId': dealerId,
      'locationIds': locationIds, // ✅ List<String>
      'deviceToken': token,
      'appVersion': appVersion,
      'deviceType': Platform.isIOS ? 'ios' : 'android',
      'lastUsedAt': FieldValue.serverTimestamp(),
    };

    /// First time only
    if (!snap.exists) {
      updateData.addAll({
        'uid': tCode,
        'userName': userName,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
    await ref.set(updateData, SetOptions(merge: true));

    // final ref =
    //     FirebaseFirestore.instance.collection('users-details').doc(tCode);
    //
    // final snap = await ref.get();
    // final token = await NotificationServiceNEW.getFirebaseMessagingToken();
    // if (token == null) return;
    //
    // /// Always-updated fields
    // final updateData = {
    //   'role': role,
    //   'locationIds': locationIds.toList(),
    //   'deviceToken': token,
    //   'lastUsedAt': FieldValue.serverTimestamp(),
    //   'appVersion': appVersion,
    //   'deviceType': Platform.isIOS ? 'IOS' : 'android',
    // };
    //
    // /// First-time-only fields
    // if (!snap.exists) {
    //   updateData.addAll({
    //     'uid': tCode,
    //     'userName': userName,
    //     'dealerId': dealerId,
    //     'createdAt': FieldValue.serverTimestamp(),
    //   });
    // }
    // print('Store User Details: $updateData');
    // await ref.set(updateData, SetOptions(merge: true));
  }

  static Future<List<String>> getDeviceTokens({
    String? dealerId,
    String? locationId,
  }) async {
    assert(
      dealerId != null || locationId != null,
      'Either dealerId or locationId must be provided',
    );

    Query query = FirebaseFirestore.instance
        .collection('users-details')
        .where('deviceToken', isNotEqualTo: null);

    // Dealer-based notification
    if (dealerId != null) {
      query = query.where('dealerId', isEqualTo: dealerId);
    }

    // Location-based notification
    if (locationId != null) {
      query = query.where('locationIds', arrayContains: locationId);
    }

    final snapshot = await query.get();

    return snapshot.docs
        .map((doc) => doc['deviceToken'] as String)
        .where((token) => token.isNotEmpty)
        .toList();
  }

  static Future<bool> needNotificationSend() async {
    final doc = await FirebaseFirestore.instance
        .collection('notification-function')
        .doc('sN0cGDacb68lZDhhZwk3')
        .get();

    if (doc.exists) {
      bool isSend = doc.data()?['isSend'] ?? false;
      return isSend;
    }
    return false;
  }

  static Future<bool> versionCheckFB() async {
    final doc = await FirebaseFirestore.instance
        .collection('notification-function')
        .doc('sN0cGDacb68lZDhhZwk3')
        .get();

    if (doc.exists) {
      bool isFB = doc.data()?['versionCheck'] ?? false;
      return isFB;
    }
    return false;
  }

  static Future<String> getServerKey() async {
    final doc = await FirebaseFirestore.instance
        .collection('notification-function')
        .doc('sN0cGDacb68lZDhhZwk3')
        .get();

    if (doc.exists) {
      // final Map<String, dynamic> key = doc.data()?['serverKey'] ?? {};
      final String key = doc.data()?['fcmServerKey'] ?? {};
      return key;
    }
    return '';
  }

  // async {
  //   assert(
  //     dealerId != null || locationId != null,
  //     'Either dealerId or locationId must be provided',
  //   );
  //
  //   Query query = FirebaseFirestore.instance.collection('users-details');
  //
  //   // Case 1: Dealer-based notification
  //   if (dealerId != null) {
  //     query = query.where('dealerId', isEqualTo: dealerId);
  //   }
  //
  //   // Case 2: Location-based notification
  //   if (locationId != null) {
  //     query = query.where(
  //       'locationIds.${locationId.toString()}',
  //       isNull: false,
  //     );
  //   }
  //
  //   final snapshot = await query.get();
  //   print(snapshot.docs);
  //   List<String> tokens = snapshot.docs
  //       .map((doc) => doc['deviceToken'] as String?)
  //       .where((token) => token != null && token.isNotEmpty)
  //       .cast<String>()
  //       .toList();
  //
  //   return tokens;
  // }
}

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:gainer/gainer_app/core/Services/auth_service.dart';
// class FirebaseDB {
//   // for accessing cloud firestore database
//   static FirebaseFirestore firestore = FirebaseFirestore.instance;
//
//   //for accessing cloud firestore database
//   static FirebaseStorage storage = FirebaseStorage.instance;
//
//   // //fro creating a new user if not exists
//   // static Future<void> createNotificationDB(
//   //   String dealerID,
//   //   String title,
//   //   String body,
//   // ) async {
//   //   int tCode = await getIntData("tCode");
//   //   final time = DateTime.now().millisecondsSinceEpoch.toString();
//   //
//   //   await firestore
//   //       .collection('notification')
//   //       .doc(tCode.toString())
//   //       // .collection('notifications')
//   //       // .doc()
//   //       .set(
//   //     {
//   //       "title": title,
//   //       "body": body,
//   //       "isSeen": false,
//   //       "sendAt": time,
//   //       "userId": tCode,
//   //       "dealerID": dealerID,
//   //     },
//   //   );
//   //
//   //   // await SendNotification.sendPushNotification(
//   //   //     token:
//   //   //     "cdUGWbtmTlSprBnaKolH0l:APA91bHfc3ow_9Fq9T20PowxgK_sbwGOOuRkyRySVfSc-WUSJ-muZMpo3QM4zODB5uSVqvi_UNaCd2P2Cew6Tv4QANML0X7y2hWas2b30R_aeb8KqO2QiEw",
//   //   //     title: "Gainer Firebase Testing",
//   //   //     body: "This is demo notification using function in firebaseDB",
//   //   //     data: {
//   //   //       "Screen": "OrderReceivedScreen",
//   //   //       "key2": "value2",
//   //   //     });
//   // } //comment
//
//   static Future<void> createNotificationDB({
//     required String locationID,
//     required String title,
//     required String body,
//   }) async {
//     // final time = DateTime.now();
//     // int tCode = await getIntData("tCode");
//     String tCode = await AuthService.getTCode();
//     // final time = DateTime.now().millisecondsSinceEpoch.toString();
//     final docRef = FirebaseFirestore.instance
//         .collection('notifications')
//         // .doc(tCode.toString())
//         .doc(locationID)
//         .collection('userNotifications')
//         .doc(); // auto-generated
//
//     await docRef.set({
//       "title": title,
//       "body": body,
//       "isSeen": false,
//       // "sendAt": time,
//       'sendAt': FieldValue.serverTimestamp(),
//       "userId": tCode,
//       "locationID": locationID,
//     });
//   }
//
//   Future<void> storeDeviceToken({
//     required String userId,
//     required String userCode,
//     required String dealerId,
//     required List<String> locationIds,
//   }) async {
//     final token = await FirebaseMessaging.instance.getToken();
//     if (token == null) return;
//
//     // final currentTime = getCurrentTimeAsString();
//     final docRef = FirebaseFirestore.instance.collection('users').doc(userId);
//
//     await docRef.set({
//       'usercode': userCode,
//       'dealerid': dealerId,
//       'locationids': locationIds,
//       // 'createAt': currentTime,
//       'createAt': FieldValue.serverTimestamp(),
//       'token': token,
//     }, SetOptions(merge: true));
//
//     // // Remove old tokens and keep only current one
//     // await docRef.update({
//     //   'tokens': FieldValue.arrayUnion([token])
//     // });
//   }
//
//   void setupTokenRefreshListener() {
//     FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
//       // Update Firestore with the new token here
//       await storeDeviceToken(
//         userId: 'USER_ID',
//         userCode: 'USER_CODE',
//         dealerId: 'DEALER_ID',
//         locationIds: ['LOC_ID_1'],
//       );
//     });
//   }
//
//   void fetchAndSortUsers() async {
//     final snapshot = await FirebaseFirestore.instance.collection('users').get();
//
//     final users = snapshot.docs
//         .map((doc) {
//           final data = doc.data();
//           final name = doc.id;
//           final rawCreateAt = data['createAt'];
//
//           // Handle both types of timestamp
//           DateTime? createAt;
//           if (rawCreateAt is Timestamp) {
//             createAt = rawCreateAt.toDate();
//           } else if (rawCreateAt is String) {
//             createAt = DateTime.tryParse(rawCreateAt);
//           }
//
//           return {
//             'name': name,
//             'createAt': createAt,
//           };
//         })
//         .where((e) => e['createAt'] != null)
//         .toList();
//
//     // Sort descending (newest first)
//     users.sort((a, b) =>
//         (b['createAt'] as DateTime).compareTo(a['createAt'] as DateTime));
//
//     // Print result
//     // for (var user in users) {
//     //   print('${user['name']} => ${user['createAt']}');
//     // }
//   }
// }
