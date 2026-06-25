import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'firebase_db_creation.dart';
import 'get_server_key.dart';

class PushNotification {
  // for sending push notification
  static Future<void> sendNotification({
    required String? token, // FCM token of the recipient
    required String? title,
    required String? body,
    required Map<String, dynamic> data,
  }) async {
    log("title: $title, Body: $body");
    try {
      if (token == null) {
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

      // print("serverKey::: $serverKey");
      // print("messagePayload: $messagePayload");

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
        // print(
        //     '❌ Failed to send notification: ${response.statusCode}, ${response.body}');
      }
    } catch (e) {
      // print('🚨 Error sending push notification: $e');
    }
  }
  //comment

  static Future<void> notifyDealer({
    required String locationID,
    required String title,
    required String body,
    required Map<String, dynamic> data,
  }) async {
    if (locationID == "null" || locationID.isEmpty) return;
    List<String> tokens =
        await FirebaseDbCreation.getDeviceTokens(locationId: locationID);
    // await FirebaseDbCreation.getAllToken(locationId: locationID);

    // print("${tokens.length} Tokens Found");
    String? lastToken = "";
    for (String token in tokens) {
      if (lastToken != token) {
        lastToken = token;
        await PushNotification.sendNotification(
          token: token,
          title: title,
          body: body,
          data: data,
        );
      }
    }
    await FirebaseDbCreation.saveNotification(
      title: title,
      body: body,
      receiverLocationId: locationID,
      data: data,
    );
  }
}
