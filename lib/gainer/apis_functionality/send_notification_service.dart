import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

import 'firebase_db_creation.dart';
import 'firebase_notification_service.dart';
import 'get_server_key.dart';

class SendNotification {
  // for sending push notification
  static Future<void> sendPushNotification({
    required String? token, // FCM token of the recipient
    required String? title,
    required String? body,
    required Map<String, dynamic> data,
  }) async {
    log("title: $title, Body: $body");
    try {
      if (token == null) {
        // print('Push token is null');
        return;
      }

      final serverKey = await GetServerKey().getServerKey(); //comment
      final uri = Uri.parse(
          'https://fcm.googleapis.com/v1/projects/gainer-app/messages:send');

      final messagePayload = {
        "message": {
          "token": token,
          "notification": {
            "title": title,
            "body": body,
          },
          "data": data,
        }
      };

      final response = await http.post(
        uri,
        headers: {
          "Authorization": "Bearer $serverKey",
          "Content-Type": "application/json",
        },
        body: jsonEncode(messagePayload),
      );

      if (response.statusCode == 200) {
        // print('✅ Push notification sent successfully');
        // print(response.body);
      } else {
        // print('❌ Failed to send notification: ${response.statusCode}');
      }
    } catch (e) {
      // print('🚨 Error sending push notification: $e');
    }
  }
  //comment

  static Future<void> notifyDealerUsers(String locationID, String title,
      String body, Map<String, dynamic> data) async {
    NotificationServices notificationServices = NotificationServices();

    //token from firebase and send notification at that token
    // String? token = await notificationServices.getDeviceTokenFromFirebase(
    //     dealerId: dealerID);
    List<String> tokens = await notificationServices
        .getAllDeviceTokensFromFirebase(locationId: locationID);

    String? lastToken = "";

    for (String token in tokens) {
      if (lastToken != token) {
        lastToken = token;
        await SendNotification.sendPushNotification(
          token: token,
          title: title,
          body: body,
          data: data,
        );
      }
    }
    await FirebaseDB.createNotificationDB(
      locationID: locationID,
      title: title,
      body: body,
    );
  }
}
