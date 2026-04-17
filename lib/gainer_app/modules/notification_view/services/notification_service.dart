import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';

import '../../../../app_switcher_view/app_switcher_controller.dart';
import '../../bottom_navbar/home_view/home_controller.dart';
import 'navigation_service.dart';

class NotificationService {
  static Future<void> init() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    await messaging.requestPermission();

    // 🔹 Foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    });

    // 🔹 Background Tap
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      handleNotificationTap(message);
    });

    // 🔹 App Killed Tap
    RemoteMessage? initialMessage =
    await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      handleNotificationTap(initialMessage);
    }
  }

  static Future<void> handleBackgroundMessage(RemoteMessage message) async {

  }

  static Future<void> handleNotificationTap(RemoteMessage message) async {
    final data = message.data;

    String type = data['type'];
    String screen = data['screen'];
    // String locationId = data['location_id'];

    if (type == "gainer") {
      await handleGainerFlow(data);
    } else {
      NavigationService.navigateTo(screen);
    }
  }

  // 🔥 MAIN LOGIC
  static Future<void> handleGainerFlow(Map data) async {
    final controller = Get.put(AppSwitcherController());
    // final appController = Get.find<AppController>();

    // Step 1: Switch App
    // appController.switchToGainer();

    // Step 2: Fetch Locations
    await controller.getLocation();

    // Step 3: Match location
    String locationId = data['location_id'];

    final locationDetails = controller.locationDataList.firstWhere(
          (e) => e.locationId.toString() == locationId,
      orElse: () => controller.locationDataList.first,
    );
    final homeCtrl = Get.find<HomeController>();
    homeCtrl.onChangeLocation(locationDetails.location);

    // await controller.selectLocationById(locationId);

    // // Step 4: Load Data (IMPORTANT)
    // await controller.loadDataForLocation();

    // Step 5: Navigate
    NavigationService.navigateTo(data['screen'], arguments: data);
  }
}