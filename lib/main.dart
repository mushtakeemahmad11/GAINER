import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gainer/app_navigate.dart';
import 'package:get/get.dart';
import 'firebase_options.dart';
import 'gainer/controllers/check_internet/connectivity_controller.dart';
import 'gainer/controllers/home_screen_controller.dart';
import 'gainer/controllers/notification_controller.dart';
import 'gainer/screens/colors.dart';
import 'gainer_app/core/Services/auth_service.dart';
import 'gainer_app/modules/internet_connectivity/no_internet_controller.dart';
import 'gainer_app/routes/app_pages.dart';
import 'gainer_app/routes/app_routes.dart';

@pragma('vm:entry-point')
Future<void> _firebaseBackgroundHandler(RemoteMessage message) async {
  // Required for background isolate
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

/// for SSL certificate By-Pass
// class MyHttpOverrides extends HttpOverrides {
//   @override
//   HttpClient createHttpClient(SecurityContext? context) {
//     return super.createHttpClient(context)
//       ..badCertificateCallback =
//           (X509Certificate cert, String host, int port) => true;
//   }
// }

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Initialize Firebase only once
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  /// Register background message handler
  FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundHandler);

  /// Lock orientation (do this BEFORE runApp)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  /// 🔹 GLOBAL CONTROLLERS (APP LIFETIME)
  Get.put<ConnectivityController>(
    ConnectivityController(),
    permanent: true,
  );

  /// 🔹 GLOBAL CONTROLLERS (APP LIFETIME)
  Get.put<NoInternetController>(
    NoInternetController(),
    permanent: true,
  );

  Get.put<LocationController>(
    LocationController(),
    permanent: true,
  );

  Get.put<AppLauncherController>(
    AppLauncherController(),
    permanent: true,
  );

  Get.put<NotificationController>(
    NotificationController(),
    permanent: true,
  );
  // Register your GetX controller
  // Get.put(ConnectivityController());

  // Optional: Global override if needed (e.g., for self-signed certs)
  // HttpOverrides.global = MyHttpOverrides();

  // final bool isLoggedIn = await AuthService.isLoggedIn();
  final INITIAL =
      await AuthService.isLoggedIn() ? Routes.APPSWITCHER : Routes.LOGIN;
  print("initial: $INITIAL");
  runApp(MyApp(
    initialRoute: INITIAL,
  ));
}

// Global variable to store screen size
late Size mq;

class MyApp extends StatelessWidget {
  final dynamic initialRoute;

  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    // Initialize screen size
    mq = MediaQuery.of(context).size;

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tel-e-scope',
      // Application theme
      theme: ThemeData(
        useMaterial3: true, // Enable Material 3 styling

        // AppBar theme
        appBarTheme: AppBarTheme(
          backgroundColor: AppColor.primary,
          foregroundColor: AppColor.white,
        ),

        // Icon theme
        iconTheme: const IconThemeData(
          color: AppColor.background, // Set icon color
        ),

        // Color scheme
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColor.primary,
          primary: AppColor.primary,
        ),
      ),

      // Initial screen (Splash Screen)
      // home: const SplashScreen(), // only for Gainer

      // initialRoute: AppPages.INITIAL,
      // initialRoute: '/splash',
      initialRoute: initialRoute,
      getPages: AppPages.routes,
    );

    return GetMaterialApp(
      // showPerformanceOverlay: true,
      debugShowCheckedModeBanner: false,
      title: 'Gainer',

      // Application theme
      theme: ThemeData(
        useMaterial3: true, // Enable Material 3 styling

        // AppBar theme
        appBarTheme: AppBarTheme(
          backgroundColor: AppColor.primary,
          foregroundColor: AppColor.white,
        ),

        // Icon theme
        iconTheme: const IconThemeData(
          color: AppColor.background, // Set icon color
        ),

        // Color scheme
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColor.primary,
          primary: AppColor.primary,
        ),
      ),

      // Initial screen (Splash Screen)
      // home: const SplashScreen(), // only for Gainer
      home: AppLauncherScreen(),
    );
  }
}

/*
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gainer/app_navigate.dart';
import 'package:get/get.dart';
import 'firebase_options.dart';
import 'gainer/controllers/check_internet/connectivity_controller.dart';
import 'gainer/controllers/home_screen_controller.dart';
import 'gainer/screens/colors.dart';
import 'gainer_app/routes/app_pages.dart';

@pragma('vm:entry-point')
Future<void> _firebaseBackgroundHandler(RemoteMessage message) async {
  // Required for background isolate
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

/// for SSL certificate By-Pass
// class MyHttpOverrides extends HttpOverrides {
//   @override
//   HttpClient createHttpClient(SecurityContext? context) {
//     return super.createHttpClient(context)
//       ..badCertificateCallback =
//           (X509Certificate cert, String host, int port) => true;
//   }
// }

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Initialize Firebase only once
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  /// Register background message handler
  FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundHandler);

  /// Lock orientation (do this BEFORE runApp)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  /// 🔹 GLOBAL CONTROLLERS (APP LIFETIME)
  Get.put<ConnectivityController>(
    ConnectivityController(),
    permanent: true,
  );

  Get.put<LocationController>(
    LocationController(),
    permanent: true,
  );

  Get.put<AppLauncherController>(
    AppLauncherController(),
    permanent: true,
  );
  // Register your GetX controller
  // Get.put(ConnectivityController());

  // Optional: Global override if needed (e.g., for self-signed certs)
  // HttpOverrides.global = MyHttpOverrides();
}

// Global variable to store screen size
late Size mq;

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    // Initialize screen size
    mq = MediaQuery.of(context).size;

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tel-e-scope',
      // Application theme
      theme: ThemeData(
        useMaterial3: true, // Enable Material 3 styling

        // AppBar theme
        appBarTheme: AppBarTheme(
          backgroundColor: AppColor.primary,
          foregroundColor: AppColor.white,
        ),

        // Icon theme
        iconTheme: const IconThemeData(
          color: AppColor.background, // Set icon color
        ),

        // Color scheme
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColor.primary,
          primary: AppColor.primary,
        ),
      ),

      // Initial screen (Splash Screen)

      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    );

    return GetMaterialApp(
      // showPerformanceOverlay: true,
      debugShowCheckedModeBanner: false,
      title: 'Gainer',

      // Application theme
      theme: ThemeData(
        useMaterial3: true, // Enable Material 3 styling

        // AppBar theme
        appBarTheme: AppBarTheme(
          backgroundColor: AppColor.primary,
          foregroundColor: AppColor.white,
        ),

        // Icon theme
        iconTheme: const IconThemeData(
          color: AppColor.background, // Set icon color
        ),

        // Color scheme
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColor.primary,
          primary: AppColor.primary,
        ),
      ),

      // Initial screen (Splash Screen)
      home: AppLauncherScreen(),
    );
  }
}
*/
