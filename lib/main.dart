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

/*@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // ✅ Required for background isolate
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await NotificationService.handleBackgroundMessage(message);
}

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
GlobalKey<ScaffoldMessengerState>();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// ✅ STEP 1: Initialize Firebase FIRST
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  /// ✅ STEP 2: Register background handler AFTER init
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  /// ✅ STEP 3: NOW safe to access FirebaseMessaging
  RemoteMessage? initialMessage =
      await FirebaseMessaging.instance.getInitialMessage();

  /// ✅ STEP 4: Init notification service
  await NotificationService.init();

  /// ✅ STEP 5: Lock orientation
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  /// ✅ STEP 6: Controllers
  Get.put<NoInternetController>(
    NoInternetController(),
    permanent: true,
  );

  /// (IMPORTANT) register required controllers
  Get.put<AppSwitcherController>(AppSwitcherController(), permanent: true);
  Get.put<GainerMainController>(GainerMainController(), permanent: true);
  Get.put<HomeController>(HomeController(), permanent: true);
  Get.put<HelpController>(HelpController(), permanent: true);

  /// ✅ STEP 7: Initial route
  final INITIAL =
      await AuthService.isLoggedIn() ? Routes.APPSWITCHER : Routes.LOGIN;

  /// ✅ STEP 8: Run app
  runApp(MyApp(
    initialRoute: INITIAL,
    initialMessage: initialMessage,
  ));
}

///TEMP COMMENT*/

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

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Initialize Firebase only once
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // final notificationCtrl = Get.put<NotificationController>(
  //   NotificationController(),
  //   permanent: true,
  // );

  /// Register background message handler
  FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundHandler);

  RemoteMessage? initialMessage =
      await FirebaseMessaging.instance.getInitialMessage();

  await NotificationServiceNEW.init();

  /// ✅ ONLY NotificationController global
  Get.put(NotificationController(), permanent: true);
  // if (initialMessage != null) {
  //   notificationCtrl.openFromNotification.value = true;
  //   notificationCtrl.notificationType.value = initialMessage.data['type'] ?? '';
  // }

  /// Lock orientation (do this BEFORE runApp)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  /// 🔹 GLOBAL CONTROLLERS (APP LIFETIME for GainerApp)
  Get.put<NoInternetController>(
    NoInternetController(),
    permanent: true,
  );

  // Get.put<LocationController>(
  //   LocationController(),
  //   permanent: true,
  // );

  // Get.put<NotificationController>(
  //   NotificationController(),
  //   permanent: true,
  // );

  ///-------------------------------------------
  // /// 🔹 GLOBAL CONTROLLERS (APP LIFETIME for DealerApp)
  // Get.put<ConnectivityController>(
  //   ConnectivityController(),
  //   permanent: true,
  // );
  ///-------------------------------------------

  // ///Temp use for dealer monitoring from gainer new
  // Get.put<AppSwitcherController>(
  //   AppSwitcherController(),
  //   permanent: true,
  // );

  // Register your GetX controller
  // Get.put(ConnectivityController());

  // Optional: Global override if needed (e.g., for self-signed certs)
  // HttpOverrides.global = MyHttpOverrides();

  //Get message if user come from notification
  // initialMessage = await FirebaseMessaging.instance.getInitialMessage();

  // final isLoggedIn = await getBoolData('isLogin') ?? false;
  // final INITIAL = isLoggedIn ? '/app-launching' : '/login';
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

    // if (initialMessage != null && initialRoute == Routes.APPSWITCHER) {
    //   final route = initialMessage!.data['route'];
    //   print("Roues from msg: $route");
    //   // final id = initialMessage!.data['id'];
    //
    //   // Delay until app builds
    //   Future.microtask(() {
    //     Get.offAllNamed(Routes.APPSWITCHER);
    //     Get.to(Routes.GAINERSPLASH);
    //     Future.delayed(const Duration(milliseconds: 300), () {
    //       Get.toNamed(route);
    //     });
    //   });
    // }

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

      // theme: ThemeData(
      //   useMaterial3: true, // Enable Material 3 styling
      //
      //   // AppBar theme
      //   appBarTheme: AppBarTheme(
      //     backgroundColor: AppColor.primary,
      //     foregroundColor: AppColor.white,
      //   ),
      //
      //   // Icon theme
      //   iconTheme: const IconThemeData(
      //     color: AppColor.background, // Set icon color
      //   ),
      //
      //   // Color scheme
      //   colorScheme: ColorScheme.fromSeed(
      //     seedColor: AppColor.primary,
      //     primary: AppColor.primary,
      //   ),
      // ),

      initialRoute: initialRoute,
      getPages: AppPages.routes,
    );

    // return GetMaterialApp(
    //   // showPerformanceOverlay: true,
    //   debugShowCheckedModeBanner: false,
    //   title: 'Gainer',
    //
    //   // Application theme
    //   theme: ThemeData(
    //     useMaterial3: true, // Enable Material 3 styling
    //
    //     // AppBar theme
    //     appBarTheme: AppBarTheme(
    //       backgroundColor: AppColor.primary,
    //       foregroundColor: AppColor.white,
    //     ),
    //
    //     // Icon theme
    //     iconTheme: const IconThemeData(
    //       color: AppColor.background, // Set icon color
    //     ),
    //
    //     // Color scheme
    //     colorScheme: ColorScheme.fromSeed(
    //       seedColor: AppColor.primary,
    //       primary: AppColor.primary,
    //     ),
    //   ),
    //
    //   getPages: [
    //     GetPage(
    //       name: '/app-switcher-view',
    //       page: () => AppLauncherScreen(),
    //       binding: AppLauncherBinding(),
    //     ),
    //     GetPage(
    //       name: '/login',
    //       page: () => LoginScreen(),
    //     ),
    //     GetPage(
    //       name: '/testing',
    //       page: () => Scaffold(
    //         appBar: AppBar(
    //           title: Text("Testing"),
    //         ),
    //         body: const Center(
    //           child: Text("Testing Routes"),
    //         ),
    //       ),
    //     ),
    //   ],
    //   initialRoute: initialRoute,
    //   // initialRoute: '/testing',
    //   unknownRoute: GetPage(
    //     name: '/not-found',
    //     page: () => const Scaffold(
    //       body: Center(child: Text('Route not found')),
    //     ),
    //   ),
    // );
  }
}
