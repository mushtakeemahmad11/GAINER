import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

import '../../gainer_app/core/Services/auth_service.dart';
import '../screens/colors.dart';
import '../screens/home_sellers_stage/order_received/order_received_screen.dart';
import '../screens/splash_screen.dart';
import '../shared_preferences/shared_preferences_set_data.dart';
class NotificationServices {
  // for accessing firebase message notification (push notification)
  static FirebaseMessaging fMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  ///for getting firebase messaging token
  Future<String?> getFirebaseMessagingToken() async {
    try {
      String? token = await fMessaging.getToken();
      if (token != null) {
        setStringData('deviceToken', token);
        AuthService.saveDeviceToken(token);
        log('Device Token: $token');
        return token;
      }
      log('Device Token can not find');
      return null;
    } catch (e) {
      log('FCM Token error: $e');
      return null;
    }
  }

  ///Get permission from user for notification
  Future<void> requestNotificationPermission() async {
    NotificationSettings settings = await fMessaging.requestPermission();

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('Notification Allow');
    } else {
      Get.snackbar("Notification Permission Denied",
          "Please allow notification from app setting for notification",
          backgroundColor: AppColor.primary,
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  ///initialize Local Notification Plugins
  void initLocalNotification(
      BuildContext context, RemoteMessage message) async {
    var androidInitSetting =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosInitSettings = const DarwinInitializationSettings();

    var initializationSetting = InitializationSettings(
        android: androidInitSetting, iOS: iosInitSettings);

    await flutterLocalNotificationsPlugin.initialize(initializationSetting,
        onDidReceiveNotificationResponse: (payroll) {
      handleMessage(context, message);
    });
  }

  /// firebase initialization (When app is in running state)
  void firebaseInit(BuildContext context) {
    FirebaseMessaging.onMessage.listen((message) {
      RemoteNotification? notification = message.notification;
      // AndroidNotification? android = message.notification!.android;
      if (kDebugMode) {
        print('Title: ${notification!.title}');
        print('Body: ${notification.body}');
      }

      if (Platform.isAndroid) {
        initLocalNotification(context, message);
        showNotification(message);
        // handleMessage(context, message);
      } else if (Platform.isIOS) {
        iosForegroundMessage();
      }
    });
  }

  ///function to show notification
  Future<void> showNotification(RemoteMessage message) async {
    //channel settings
    AndroidNotificationChannel channel = AndroidNotificationChannel(
      message.notification!.android!.channelId.toString(),
      message.notification!.android!.channelId.toString(),
      description: 'Demo channel Description',
      importance: Importance.high,
      showBadge: true,
      playSound: true,
      enableVibration: true,
    );

    //android settings
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      channel.id,
      channel.name,
      channelDescription: channel.description,
      playSound: channel.playSound,
      importance: channel.importance,
      priority: Priority.high,
      sound: channel.sound,
      icon: '@mipmap/ic_launcher',
      // styleInformation: BigTextStyleInformation(''),
          //for show all text not ...
      styleInformation: BigTextStyleInformation(
        message.notification!.body ?? "",
        contentTitle: message.notification!.title,
        // htmlFormatBigText: true,
        htmlFormatBigText: false,
      ),
    );

    //ios settings
    DarwinNotificationDetails darwinNotificationDetails =
        const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    //merging both setting
    NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails, iOS: darwinNotificationDetails);

    //show Notification
    Future.delayed(Duration.zero, () {
      flutterLocalNotificationsPlugin.show(
        0,
        message.notification!.title.toString(),
        message.notification!.body.toString(),
        notificationDetails,
        payload: "This is my notification data",
      );
    });
  }

  ///when app is in background and terminate state
  Future<void> setUpInteractMessage(BuildContext context) async {
    //backGround State
    FirebaseMessaging.onMessageOpenedApp.listen(
      (message) {
        handleMessage(context, message);
      },
    );

    //terminate State
    FirebaseMessaging.instance.getInitialMessage().then(
      (RemoteMessage? message) {
        if (message != null && message.data.isNotEmpty) {
          handleMessage(context, message);
        }
      },
    );
  }

  ///handler for handle message
  Future<void> handleMessage(
      BuildContext context, RemoteMessage message) async {
    if (message.data['Screen'] == 'OrderReceivedScreen') {
      Get.to(() => OrderReceivedScreen());
    } else {
      Get.offAll(() => SplashScreen());
    }

    /// can go to notification screen with message and show the notification data on that screen
  }

  // for ios message
  Future iosForegroundMessage() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  ///getDeviceTokensByDealerOrLocation
  // Future<List<String>> getDeviceTokensByDealerOrLocation({
  //   String? dealerId,
  //   String? locationId,
  // }) async {
  //   Query query = FirebaseFirestore.instance.collection('users');
  //
  //   if (dealerId != null) {
  //     query = query.where('dealerid', isEqualTo: dealerId);
  //   } else if (locationId != null) {
  //     query = query.where('locationids', arrayContains: locationId);
  //   }
  //
  //   final snapshot = await query.get();
  //   final tokens = <String>{};
  //
  //   for (var doc in snapshot.docs) {
  //     final docTokens = List<String>.from(doc['tokens'] ?? []);
  //     tokens.addAll(docTokens);
  //   }
  //
  //   return tokens.toList();
  // }

  Future<String?> getDeviceTokenFromFirebase({
    String? dealerId,
    String? locationId,
  }) async {
    Query query = FirebaseFirestore.instance.collection('users');

    if (dealerId != null) {
      query = query.where('dealerid', isEqualTo: dealerId);
    } else if (locationId != null) {
      query = query.where('locationids', arrayContains: locationId);
    }

    final snapshot = await query.get();
    String? token;

    for (var doc in snapshot.docs) {
      token = doc['token'];
      if (token != null && token.isNotEmpty) {
        return token;
      }
    }
    return null;
  }

  Future<List<String>> getAllDeviceTokensFromFirebase({
    String? dealerId,
    String? locationId,
  }) async {
    Query query = FirebaseFirestore.instance.collection('users');

    if (dealerId != null) {
      query = query.where('dealerid', isEqualTo: dealerId);
    } else if (locationId != null) {
      query = query.where('locationids', arrayContains: locationId);
    }

    final snapshot = await query.get();

    List<String> tokens = [];

    for (var doc in snapshot.docs) {
      final token = doc['token'];
      if (token != null && token.toString().isNotEmpty) {
        tokens.add(token);
      }
    }

    return tokens;
  }

  Future<List<Map<String, dynamic>>> fetchNotifications(String tCode) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('notifications')
        .doc(tCode)
        .collection('userNotifications')
        .orderBy('sendAt', descending: true)
        .get();

    return snapshot.docs.map((doc) {
      return {
        'id': doc.id,
        ...doc.data(),
      };
    }).toList();
  }
}
