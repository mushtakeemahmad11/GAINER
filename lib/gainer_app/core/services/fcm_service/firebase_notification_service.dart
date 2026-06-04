import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import '../../../modules/notification_view/notification_controller.dart';
import '../../Services/auth_service.dart';
import '../../widgets/notification_permission_bottom_sheet.dart';

class NotificationServiceNEW {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  /// INIT (call in main)
  static Future<void> init() async {
    await requestPermission();
    await _initLocalNotification();
    _setupListeners();
  }

  /// PERMISSION
  static Future<void> requestPermission() async {
    // await _messaging.requestPermission();

    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    /// Foreground notification (iOS)
    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    ///check notification permission allowed or denied
    bool requestPermission =
        settings.authorizationStatus == AuthorizationStatus.denied;

    if (requestPermission) {
      Future.delayed(Duration.zero, () {
        if (Get.context != null) {
          NotificationPermission.showNotificationPermissionSheet();
        }
      });
    }
  }

  /// 🔑 TOKEN
  static Future<String?> getFirebaseMessagingToken() async {
    try {
      // final token = await _messaging.getToken();
      //
      // if (token != null) {
      //   AuthService.saveDeviceToken(token);
      // }
      //
      // return token;

      /// 🍎 iOS: wait for APNs token
      if (Platform.isIOS) {
        return 'PlatFormIos';
        String? apnsToken;
        int retry = 0;

        while (apnsToken == null && retry < 10) {
          await Future.delayed(const Duration(seconds: 1));
          apnsToken = await _messaging.getAPNSToken();
          retry++;
        }

        if (apnsToken == null) {
          print("❌ APNS token not available");
          return null;
        }

        // print("✅ APNS Token: $apnsToken");
        AuthService.saveDeviceToken(apnsToken);
        return apnsToken;
      }

      /// 🤖 Android: directly works
      String? fcmToken = await _messaging.getToken();

      print("✅ FCM Token: $fcmToken");

      if (fcmToken == null) return null;
      AuthService.saveDeviceToken(fcmToken);

      return fcmToken;
    } catch (e) {
      return null;
    }
  }

  /// LOCAL NOTIFICATION INIT
  static Future<void> _initLocalNotification() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings();

    const settings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    await _localNotifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (response) {
        if (response.payload != null) {
          final data = jsonDecode(response.payload!);
          NotificationController.to.handleData(data);
        }
      },
    );
  }

  /// LISTENERS
  static void _setupListeners() {
    /// FOREGROUND
    FirebaseMessaging.onMessage.listen((message) {
      _showNotification(message);
    });

    /// BACKGROUND TAP
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      NotificationController.to.handleMessage(message);
    });
  }

  /// BACKGROUND HANDLER (main)
  static Future<void> backgroundHandler(RemoteMessage message) async {}

  /// SHOW LOCAL NOTIFICATION
  static Future<void> _showNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    const android = AndroidNotificationDetails(
      'channel_id',
      'Notifications',
      importance: Importance.high,
      priority: Priority.high,
    );

    const ios = DarwinNotificationDetails();

    const details = NotificationDetails(android: android, iOS: ios);

    await _localNotifications.show(
      notification.hashCode,
      notification.title,
      notification.body,
      details,
      payload: jsonEncode(message.data),
    );
  }
}

/*class NotificationServicesNEW {
  static final FirebaseMessaging fMessaging = FirebaseMessaging.instance;

  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// 🔥 INIT (call from main)
  static Future<void> init() async {
    await requestNotificationPermission();
    await _initLocalNotification();
    await _setupFirebaseListeners();
  }

  /// 🔐 PERMISSION
  static Future<void> requestNotificationPermission() async {
    final settings = await fMessaging.requestPermission();

    if (settings.authorizationStatus != AuthorizationStatus.authorized) {
      NotificationPermission.showNotificationPermissionSheet();
    }
  }

  /// 🔔 LOCAL NOTIFICATION INIT
  static Future<void> _initLocalNotification() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings();

    const settings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    await flutterLocalNotificationsPlugin.initialize(
      settings,
      onDidReceiveNotificationResponse: (response) {
        if (response.payload != null) {
          final data = jsonDecode(response.payload!);
          _handleNotificationData(data);
        }
      },
    );
  }

  /// 📡 FIREBASE LISTENERS
  static Future<void> _setupFirebaseListeners() async {
    /// 🔹 FOREGROUND
    FirebaseMessaging.onMessage.listen((message) {
      _showNotification(message);
    });

    /// 🔹 BACKGROUND TAP
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      handleNotificationTap(message);
    });
  }

  /// 🌙 BACKGROUND HANDLER (main.dart)
  static Future<void> handleBackgroundMessage(RemoteMessage message) async {
    print("Background Message: ${message.data}");
  }

  /// 👉 NOTIFICATION TAP ENTRY
  static Future<void> handleNotificationTap(RemoteMessage message) async {
    print("Notification Tap: ${message.data}");
    _handleNotificationData(message.data);
  }

  /// 🔥 COMMON HANDLER
  static Future<void> _handleNotificationData(Map data) async {
    print("Notification Data: $data");

    await handleGainerFlow(data);
  }

  /// 🚀 MAIN GAINER FLOW (CLEAN & SAFE)
  static Future<void> handleGainerFlow(Map data) async {
    String dataRoute = data['route'] ?? "";
    String locationId = data['notifyTo'] ?? "";

    final appController = Get.find<AppController>();
    final switcherController = Get.find<AppSwitcherController>();
    final homeController = Get.find<HomeController>();

    /// 1️⃣ Switch to Gainer Mode
    appController.switchToGainer();

    /// 2️⃣ Reset navigation stack
    Get.offAllNamed(Routes.APPSWITCHER);

    await Future.delayed(const Duration(milliseconds: 300));

    Get.offAllNamed(Routes.GAINERMAINVIEW);

    /// 3️⃣ Load Locations
    await switcherController.getLocation();

    final locationDetails = switcherController.locationDataList.firstWhere(
      (e) => e.locationId.toString() == locationId,
      orElse: () => switcherController.locationDataList.first,
    );

    /// 4️⃣ Load Data
    await homeController.getBuyerDetails(
      locationDetails.locationId.toString(),
      locationDetails.location,
    );

    /// 5️⃣ Navigate to final screen
    Get.toNamed(dataRoute, arguments: data);
  }

  /// 🔔 SHOW LOCAL NOTIFICATION
  static Future<void> _showNotification(RemoteMessage message) async {
    final notification = message.notification;

    if (notification == null) return;

    const androidDetails = AndroidNotificationDetails(
      'gainer_channel',
      'Gainer Notifications',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
      playSound: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      details,
      payload: jsonEncode(message.data),
    );
  }

  /// 🔑 TOKEN
  static Future<String?> getFirebaseMessagingToken() async {
    try {
      final token = await fMessaging.getToken();

      if (token != null) {
        AuthService.saveDeviceToken(token);
      }

      return token;
    } catch (e) {
      return null;
    }
  }
}*/

/*

class NotificationServicesOLD {
  static final FirebaseMessaging fMessaging = FirebaseMessaging.instance;

  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// initialize notification service
  static Future<void> init() async {
    await requestNotificationPermission();
    await _initLocalNotification();
    await _setupFirebaseListeners();
  }

  /// request notification permission
  static Future<void> requestNotificationPermission() async {
    final settings = await fMessaging.requestPermission();

    if (settings.authorizationStatus != AuthorizationStatus.authorized) {
      NotificationPermission.showNotificationPermissionSheet();
    }
  }

  /// initialize local notification only once
  static Future<void> _initLocalNotification() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');

    const iosInit = DarwinInitializationSettings();

    const settings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    await flutterLocalNotificationsPlugin.initialize(
      settings,
      onDidReceiveNotificationResponse: (response) {
        _handleNavigation(response.payload);
      },
    );
  }

  /// setup firebase listeners
  static Future<void> _setupFirebaseListeners() async {
    /// Foreground
    FirebaseMessaging.onMessage.listen((message) {
      if (kDebugMode) {
        print("Foreground notification");
        print("Title: ${message.notification?.title}");
        print("Body: ${message.notification?.body}");
        print("Data: ${message.data}");
        print("Notification: ${message.notification}");
        print("From: ${message.from}");
        print("message: $message");
        print("FULL MESSAGE: ${message.toMap()}");
      }

      _showNotification(message);
    });

    /// Background click
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      // final notificationCtrl = Get.find<HomeController>();
      // notificationCtrl.setNotification(message.data);
      navigateFromNotification();
    });

    /// App killed
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      // final notificationCtrl = Get.find<HomeController>();
      // notificationCtrl.setNotification(initialMessage.data);
      Future.delayed(const Duration(milliseconds: 500), () {
        navigateFromNotification();
      });
    }
  }

  /// show local notification
  static Future<void> _showNotification(RemoteMessage message) async {
    final notification = message.notification;

    if (notification == null) return;

    const androidDetails = AndroidNotificationDetails(
      'gainer_channel',
      'Gainer Notifications',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
      playSound: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      details,
      payload: message.data['moduleRoute'],
    );
  }

  /// handle navigation from notification
  static void _handleNavigation(String? route) {
    navigateFromNotification();
  }

  /// central navigation handler
  static void navigateFromNotification() {
    String route = Get.currentRoute;
    print("You are in navigateFromNotification, CurrentRoute: $route");
    if (route == Routes.NOTIFICATIONVIEW) {
    } else if (route == Routes.GAINERMAINVIEW) {
      /// Already on main
      Get.toNamed(Routes.NOTIFICATIONVIEW);
    } else if (route == Routes.APPSWITCHER) {
      /// From app switcher
      Get.toNamed(Routes.GAINERMAINVIEW);
      Future.delayed(const Duration(milliseconds: 200), () {
        Get.toNamed(Routes.NOTIFICATIONVIEW);
      });
    } else {
      /// Other module
      Get.offAllNamed(Routes.APPSWITCHER);

      Future.delayed(const Duration(milliseconds: 300), () {
        Get.toNamed(Routes.GAINERMAINVIEW);

        Future.delayed(const Duration(milliseconds: 200), () {
          Get.toNamed(Routes.NOTIFICATIONVIEW);
        });
      });
    }
  }

  // static void navigateFromNotification() {
  //   final currentRoute = Get.currentRoute;
  //
  //   /// If already on main screen
  //   if (currentRoute == Routes.GAINERMAINVIEW) {
  //     Get.toNamed(Routes.NOTIFICATIONVIEW);
  //     return;
  //   }
  //
  //   /// If on AppSwitcher
  //   if (currentRoute == Routes.APPSWITCHER) {
  //     Get.toNamed(Routes.GAINERMAINVIEW);
  //
  //     Future.delayed(const Duration(milliseconds: 200), () {
  //       Get.toNamed(Routes.NOTIFICATIONVIEW);
  //     });
  //
  //     return;
  //   }
  //
  //   /// If in other module
  //   Get.offAllNamed(Routes.APPSWITCHER);
  //
  //   Future.delayed(const Duration(milliseconds: 300), () {
  //     Get.toNamed(Routes.GAINERMAINVIEW);
  //
  //     Future.delayed(const Duration(milliseconds: 200), () {
  //       Get.toNamed(Routes.NOTIFICATIONVIEW);
  //     });
  //   });
  // }

  /// get firebase token
  static Future<String?> getFirebaseMessagingToken() async {
    try {
      final token = await fMessaging.getToken();

      if (token != null) {
        AuthService.saveDeviceToken(token);
      }

      return token;
    } catch (_) {
      return null;
    }
  }
}*/

// import 'dart:io';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:get/get.dart';
// import '../../../../gainer/controllers/notification_controller.dart';
// import '../../../modules/bottom_navbar/home_view/home_controller.dart';
// import '../../widgets/notification_permission_bottom_sheet.dart';
// import '../../../routes/app_routes.dart';
// import '../../Services/auth_service.dart';
//
// class NotificationServices {
//   // for accessing firebase message notification (push notification)
//   static FirebaseMessaging fMessaging = FirebaseMessaging.instance;
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();
//   static final ctrl = Get.find<HomeController>();
//
//   ///for getting firebase messaging token
//   static Future<String?> getFirebaseMessagingToken() async {
//     try {
//       String? token = await fMessaging.getToken();
//       if (token != null) {
//         // setStringData('deviceToken', token);
//         AuthService.saveDeviceToken(token);
//         // log('Device Token: $token');
//         return token;
//       }
//       // log('Device Token can not find');
//       return null;
//     } catch (e) {
//       // log('FCM Token error: $e');
//       return null;
//     }
//   }
//
//   ///Get permission from user for notification---
//   static Future<void> requestNotificationPermission() async {
//     NotificationSettings settings = await fMessaging.requestPermission();
//
//     if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//       debugPrint('Notification Allow');
//     } else {
//       NotificationPermission.showNotificationPermissionSheet();
//       // Get.snackbar(
//       //   "Notification Permission Denied",
//       //   "Notifications are disabled. Enable them via setting to receive important updates.",
//       //   backgroundColor: AppColor.primary,
//       //   snackPosition: SnackPosition.BOTTOM,
//       // );
//     }
//   }
//
//   ///initialize Local Notification Plugins
//   Future<void> initLocalNotification(RemoteMessage message) async {
//     var androidInitSetting =
//         const AndroidInitializationSettings('@mipmap/ic_launcher');
//     var iosInitSettings = const DarwinInitializationSettings();
//
//     var initializationSetting = InitializationSettings(
//       android: androidInitSetting,
//       iOS: iosInitSettings,
//     );
//
//     await flutterLocalNotificationsPlugin.initialize(initializationSetting,
//         onDidReceiveNotificationResponse: (payroll) {
//       print("initLocalNotification");
//       //When app is in use
//       handleMessage(message);
//       if (payroll.payload != null) {
//         print(
//             "flutterLocalNotificationsPlugin.initialize(initializationSetting ");
//       }
//     });
//   }
//
//   /// firebase initialization (When app is in running state)
//   Future<void> firebaseInit() async {
//     FirebaseMessaging.onMessage.listen((message) {
//       RemoteNotification? notification = message.notification;
//       // AndroidNotification? android = message.notification!.android;
//       if (kDebugMode) {
//         print('Title: ${notification!.title}');
//         print('Body: ${notification.body}');
//       }
//
//       if (Platform.isAndroid) {
//         initLocalNotification(message);
//         showNotification(message);
//         // handleMessage(context, message);
//       } else if (Platform.isIOS) {
//         iosForegroundMessage();
//       }
//     });
//
//     // /// App killed
//     // RemoteMessage? message =
//     //     await FirebaseMessaging.instance.getInitialMessage();
//     //
//     // if (message != null) {
//     //   ctrl.setNotification(message.data);
//     // }
//     //
//     // /// App in background
//     // FirebaseMessaging.onMessageOpenedApp.listen((message) {
//     //   ctrl.setNotification(message.data);
//     //   _navigate();
//     // });
//     //
//     // /// App in foreground
//     // FirebaseMessaging.onMessage.listen((message) {
//     //   ctrl.setNotification(message.data);
//     //   _navigate();
//     // });
//   }
//
//   static void _navigate() {
//     Get.offAllNamed(Routes.APPSWITCHER);
//
//     Future.delayed(const Duration(milliseconds: 300), () {
//       Get.toNamed(Routes.GAINERMAINVIEW);
//
//       Future.delayed(const Duration(milliseconds: 200), () {
//         Get.toNamed(Routes.NOTIFICATIONVIEW);
//       });
//     });
//   }
//
//   ///function to show notification
//   Future<void> showNotification(RemoteMessage message) async {
//     //channel settings
//     AndroidNotificationChannel channel = AndroidNotificationChannel(
//       message.notification!.android!.channelId.toString(),
//       message.notification!.android!.channelId.toString(),
//       description: 'Demo channel Description',
//       importance: Importance.high,
//       showBadge: true,
//       playSound: true,
//       enableVibration: true,
//     );
//
//     //android settings
//     AndroidNotificationDetails androidNotificationDetails =
//         AndroidNotificationDetails(
//       channel.id,
//       channel.name,
//       channelDescription: channel.description,
//       playSound: channel.playSound,
//       importance: channel.importance,
//       priority: Priority.high,
//       sound: channel.sound,
//       icon: '@mipmap/ic_launcher',
//       // styleInformation: BigTextStyleInformation(''),
//       //for show all text not ...
//       styleInformation: BigTextStyleInformation(
//         message.notification!.body ?? "",
//         contentTitle: message.notification!.title,
//         // htmlFormatBigText: true,
//         htmlFormatBigText: false,
//       ),
//     );
//
//     //ios settings
//     DarwinNotificationDetails darwinNotificationDetails =
//         const DarwinNotificationDetails(
//       presentAlert: true,
//       presentBadge: true,
//       presentSound: true,
//     );
//
//     //merging both setting
//     NotificationDetails notificationDetails = NotificationDetails(
//         android: androidNotificationDetails, iOS: darwinNotificationDetails);
//
//     //show Notification
//     Future.delayed(Duration.zero, () {
//       flutterLocalNotificationsPlugin.show(
//         0,
//         message.notification!.title.toString(),
//         message.notification!.body.toString(),
//         notificationDetails,
//         // payload: "This is my notification data",
//         payload: message.data['route'],
//       );
//     });
//   }
//
//   ///when app is in background and terminate state
//   Future<void> setUpInteractMessage(BuildContext context) async {
//     //Terminate State
//     FirebaseMessaging.onMessageOpenedApp.listen(
//       (message) {
//         print("setUpInteractMessage ");
//         handleMessage(message);
//       },
//     );
//
//     // // get initial message from State
//     // FirebaseMessaging.instance.getInitialMessage().then(
//     //   (RemoteMessage? message) {
//     //     if (message != null && message.data.isNotEmpty) {
//     //       // handleMessage(message);
//     //     }
//     //   },
//     // );
//
//     // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//     //   final notificationCtrl = Get.find<NotificationController>();
//     //
//     //   notificationCtrl.openFromNotification.value = true;
//     //   notificationCtrl.notificationType.value = message.data['type'] ?? '';
//     //
//     //   Get.toNamed(Routes.NOTIFICATIONVIEW);
//     // });
//   }
//
//   ///handler for handle message
//   static Future<void> handleMessage(RemoteMessage message) async {
//     print("App: ${message.data}");
//     Get.toNamed(Routes.NOTIFICATIONVIEW);
//     // if (message.data['app'] == 'gainer') {
//     //   Get.offAllNamed(
//     //     '/app-launching',
//     //     arguments: {'app': message.data['app']},
//     //   );
//     //   // Get.to(() => SplashScreen());
//     // } else {}
//     // if (message.data['Screen'] == 'OrderReceivedScreen') {
//     //   Get.to(() => OrderReceivedScreen());
//     // } else {
//     //   Get.offAll(() => SplashScreen());
//     // }
//
//     /// can go to notification screen with message and show the notification data on that screen
//   }
//
//   // for ios message
//   static Future<void> iosForegroundMessage() async {
//     await FirebaseMessaging.instance
//         .setForegroundNotificationPresentationOptions(
//       alert: true,
//       badge: true,
//       sound: true,
//     );
//   }
//
//   ///getDeviceTokensByDealerOrLocation
//   // Future<List<String>> getDeviceTokensByDealerOrLocation({
//   //   String? dealerId,
//   //   String? locationId,
//   // }) async {
//   //   Query query = FirebaseFirestore.instance.collection('users');
//   //
//   //   if (dealerId != null) {
//   //     query = query.where('dealerid', isEqualTo: dealerId);
//   //   } else if (locationId != null) {
//   //     query = query.where('locationids', arrayContains: locationId);
//   //   }
//   //
//   //   final snapshot = await query.get();
//   //   final tokens = <String>{};
//   //
//   //   for (var doc in snapshot.docs) {
//   //     final docTokens = List<String>.from(doc['tokens'] ?? []);
//   //     tokens.addAll(docTokens);
//   //   }
//   //
//   //   return tokens.toList();
//   // }
//
//   Future<String?> getDeviceTokenFromFirebase({
//     String? dealerId,
//     String? locationId,
//   }) async {
//     Query query = FirebaseFirestore.instance.collection('users');
//
//     if (dealerId != null) {
//       query = query.where('dealerid', isEqualTo: dealerId);
//     } else if (locationId != null) {
//       query = query.where('locationids', arrayContains: locationId);
//     }
//
//     final snapshot = await query.get();
//     String? token;
//
//     for (var doc in snapshot.docs) {
//       token = doc['token'];
//       if (token != null && token.isNotEmpty) {
//         return token;
//       }
//     }
//     return null;
//   }
//
//   Future<List<String>> getAllDeviceTokensFromFirebase({
//     String? dealerId,
//     String? locationId,
//   }) async {
//     Query query = FirebaseFirestore.instance.collection('users');
//
//     if (dealerId != null) {
//       query = query.where('dealerid', isEqualTo: dealerId);
//     } else if (locationId != null) {
//       query = query.where('locationids', arrayContains: locationId);
//     }
//
//     final snapshot = await query.get();
//
//     List<String> tokens = [];
//
//     for (var doc in snapshot.docs) {
//       final token = doc['token'];
//       if (token != null && token.toString().isNotEmpty) {
//         tokens.add(token);
//       }
//     }
//
//     return tokens;
//   }
//
//   Future<List<Map<String, dynamic>>> fetchNotifications(String tCode) async {
//     final snapshot = await FirebaseFirestore.instance
//         .collection('notifications')
//         .doc(tCode)
//         .collection('userNotifications')
//         .orderBy('sendAt', descending: true)
//         .get();
//
//     return snapshot.docs.map((doc) {
//       return {
//         'id': doc.id,
//         ...doc.data(),
//       };
//     }).toList();
//   }
// }
