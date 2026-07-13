import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'firebase_options.dart';
import 'gainer_app/core/Services/auth_service.dart';
import 'gainer_app/core/constants/gainer_color.dart';
import 'gainer_app/core/services/fcm_service/firebase_notification_service.dart';
import 'gainer_app/modules/internet_connectivity/no_internet_controller.dart';
import 'gainer_app/modules/notification_view/notification_controller.dart';
import 'gainer_app/routes/app_pages.dart';
import 'gainer_app/routes/app_routes.dart';

@pragma('vm:entry-point')
Future<void> _firebaseBackgroundHandler(RemoteMessage message) async {
  // Required for background isolate
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

// /// for SSL certificate By-Pass
// class MyHttpOverrides extends HttpOverrides {
//   @override
//   HttpClient createHttpClient(SecurityContext? context) {
//     return super.createHttpClient(context)
//       ..badCertificateCallback =
//           (X509Certificate cert, String host, int port) => true;
//   }
// }

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // // Optional: Global override if needed (e.g., for self-signed certs)
  // HttpOverrides.global = MyHttpOverrides();
  /// Initialize Firebase only onc
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  /// Register background message handler
  FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundHandler);

  RemoteMessage? initialMessage =
      await FirebaseMessaging.instance.getInitialMessage();

  await NotificationServiceNEW.init();

  /// ✅ ONLY NotificationController global
  Get.put(NotificationController(), permanent: true);

  /// Lock orientation (do this BEFORE runApp)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  /// 🔹 GLOBAL CONTROLLERS (APP LIFETIME for GainerApp)
  Get.put<NoInternetController>(
    NoInternetController(),
    permanent: true,
  );

  final INITIAL =
      await AuthService.isLoggedIn() ? Routes.APPSWITCHER : Routes.LOGIN;

  runApp(MyApp(initialRoute: INITIAL, initialMessage: initialMessage));
}

// Global variable to store screen size
late Size mq;

class MyApp extends StatelessWidget {
  final dynamic initialRoute;
  final RemoteMessage? initialMessage;
  const MyApp({
    super.key,
    required this.initialRoute,
    this.initialMessage,
  });

  @override
  Widget build(BuildContext context) {
    // Initialize screen size
    mq = MediaQuery.of(context).size;

    return GetMaterialApp(
      scaffoldMessengerKey: scaffoldMessengerKey,
      debugShowCheckedModeBanner: false,
      title: 'Tel-e-scope',
      // Application theme
      theme: ThemeData(
        useMaterial3: true, // Enable Material 3 styling

        // AppBar theme
        appBarTheme: AppBarTheme(
          backgroundColor: GainerColors.primaryOld,
          // foregroundColor: GainerColors.whiteOld,
          foregroundColor: GainerColors.white,
        ),

        // Icon theme
        iconTheme: const IconThemeData(
          color: GainerColors.backgroundOld, // Set icon color
        ),

        // Color scheme
        colorScheme: ColorScheme.fromSeed(
          seedColor: GainerColors.primaryOld,
          primary: GainerColors.primaryOld,
        ),
      ),

      initialRoute: initialRoute,
      getPages: AppPages.routes,
    );
  }
}
