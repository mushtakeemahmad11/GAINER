import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:gainer/gainer_app/core/services/auth_service.dart';
import 'package:get/get.dart';
import '../../../app_switcher_view/app_switcher_controller.dart';
import '../../routes/app_routes.dart';
import '../bottom_navbar/home_view/home_controller.dart';

class NotificationController extends GetxController {
  static NotificationController get to => Get.find();

  /// INIT
  @override
  void onInit() {
    super.onInit();
    _handleKillState();
  }

  /// 🔥 HANDLE KILL STATE
  Future<void> _handleKillState() async {
    RemoteMessage? message =
        await FirebaseMessaging.instance.getInitialMessage();

    if (message != null) {
      await Future.delayed(const Duration(seconds: 1));
      handleMessage(message);
    }
  }

  /// 🔥 ENTRY (FROM SERVICE)
  Future<void> handleMessage(RemoteMessage message) async {
    handleData(message.data);
  }

  /// 🔥 COMMON HANDLER
  Future<void> handleData(Map data) async {
    // await _handleGainerFlow(data);
    // print("Data of Notification handleData: $data");
    // final String route = data['route'];  //when own
    final String route = data['moduleRoute'];
    final String notifyId = data['LocationId'];
    await checkAndNavigate(route, notifyId);
  }

  /// 🚀 CLEAN FLOW (NO CONFLICT / NO DUPLICATE)
  // Future<void> _handleGainerFlow(Map data) async {
  //   final String route = data['moduleRoute'] ?? "";
  //   final String locationId = data['notifyTo'] ?? "";
  //
  //   /// ✅ Lazy init (ONLY when needed)
  //   // final appController = Get.isRegistered<AppController>()
  //   //     ? Get.find<AppController>()
  //   //     : Get.put(AppController());
  //   /// 1️⃣ Switch App Switcher
  //   Get.offAllNamed(Routes.APPSWITCHER);
  //   // await Future.delayed(const Duration(milliseconds: 300));
  //
  //   final switcherController = Get.find<AppSwitcherController>();
  //
  //   final homeController = Get.isRegistered<HomeController>()
  //       ? Get.find<HomeController>()
  //       : Get.put(HomeController());
  //
  //   /// 2️⃣ Navigation Gainer
  //   Get.toNamed(Routes.GAINERMAINVIEW);
  //
  //   /// 3️⃣ Load locations
  //   await switcherController.getLocation();
  //
  //   final locationDetails = switcherController.locationDataList.firstWhere(
  //     (e) => e.locationId.toString() == locationId,
  //     orElse: () => switcherController.locationDataList.first,
  //   );
  //   switcherController.selectedLocation.value = locationDetails.location;
  //   switcherController.selectedLocationId.value =
  //       locationDetails.locationId.toString();
  //
  //   /// 4️⃣ Load data
  //   await homeController.getBuyerDetails(
  //     locationDetails.locationId.toString(),
  //     locationDetails.location,
  //   );
  //
  //   /// 5️⃣ Navigate
  //   Get.toNamed(route, arguments: data);
  // }

  Future<void> checkAndNavigate(String screen, String locationId) async {
    final route = Get.currentRoute;

    final switcherController = Get.isRegistered<AppSwitcherController>()
        ? Get.find<AppSwitcherController>()
        : Get.put(AppSwitcherController());

    final homeController = Get.isRegistered<HomeController>()
        ? Get.find<HomeController>()
        : Get.put(HomeController());

    final localLocationId = await AuthService.getLocationId();

    /// 🔹 Common function (REUSABLE)
    Future<void> updateLocationAndFetch() async {
      if (localLocationId == locationId) return;

      final locationDetails = switcherController.locationDataList.firstWhere(
        (e) => e.locationId.toString() == locationId,
        orElse: () => switcherController.locationDataList.first,
      );

      switcherController.selectedLocation.value = locationDetails.location;
      switcherController.selectedLocationId.value =
          locationDetails.locationId.toString();

      await homeController.getBuyerDetails(
        locationDetails.locationId.toString(),
        locationDetails.location,
      );
    }

    /// 🔹 CASE 1: Notification Screen
    if (route == Routes.NOTIFICATIONVIEW) {
      Get.back();
      await updateLocationAndFetch();
      Get.toNamed(screen);
      return;
    }

    /// 🔹 CASE 2: Already on Main
    if (route == Routes.GAINERMAINVIEW) {
      await updateLocationAndFetch();
      Get.toNamed(screen);
      return;
    }

    /// 🔹 CASE 3: Not on AppSwitcher → Reset flow
    if (route != Routes.APPSWITCHER) {
      Get.offAllNamed(Routes.APPSWITCHER);
      await Future.delayed(const Duration(milliseconds: 300));
    }

    /// 🔹 Load locations if needed
    if (switcherController.locationDataList.isEmpty) {
      await switcherController.getLocation();
    }

    /// 🔹 Select location (ALWAYS needed here)
    final locationDetails = switcherController.locationDataList.firstWhere(
      (e) => e.locationId.toString() == locationId,
      orElse: () => switcherController.locationDataList.first,
    );

    switcherController.selectedLocation.value = locationDetails.location;
    switcherController.selectedLocationId.value =
        locationDetails.locationId.toString();

    /// 🔹 Navigate to Main
    if (Get.currentRoute != Routes.GAINERMAINVIEW) {
      Get.toNamed(Routes.GAINERMAINVIEW);
    }

    /// 🔹 Fetch data
    await homeController.getBuyerDetails(
      locationDetails.locationId.toString(),
      locationDetails.location,
    );

    /// 🔹 Final Navigation
    Get.toNamed(screen);
  }

  // Future<void> checkNavigate(String screen, String locationId) async {
  //   String route = Get.currentRoute;
  //   if (route == Routes.NOTIFICATIONVIEW) {
  //   } else if (route == Routes.GAINERMAINVIEW) {
  //     /// Already on main
  //     // Get.toNamed(Routes.NOTIFICATIONVIEW);
  //     Get.toNamed(screen);
  //   } else if (route == Routes.APPSWITCHER) {
  //     /// 2️⃣ Navigation Gainer
  //     Get.toNamed(Routes.GAINERMAINVIEW);
  //     final switcherController = Get.find<AppSwitcherController>();
  //     final homeController = Get.isRegistered<HomeController>()
  //         ? Get.find<HomeController>()
  //         : Get.put(HomeController());
  //
  //     final locationDetails = switcherController.locationDataList.firstWhere(
  //       (e) => e.locationId.toString() == locationId,
  //       orElse: () => switcherController.locationDataList.first,
  //     );
  //     switcherController.selectedLocation.value = locationDetails.location;
  //     switcherController.selectedLocationId.value =
  //         locationDetails.locationId.toString();
  //
  //     /// 4️⃣ Load data
  //     await homeController.getBuyerDetails(
  //       locationDetails.locationId.toString(),
  //       locationDetails.location,
  //     );
  //
  //     /// 5️⃣ Navigate
  //     Get.toNamed(screen);
  //   } else {
  //     Get.offAllNamed(Routes.APPSWITCHER);
  //     await Future.delayed(const Duration(milliseconds: 300));
  //
  //     final switcherController = Get.find<AppSwitcherController>();
  //
  //     final homeController = Get.isRegistered<HomeController>()
  //         ? Get.find<HomeController>()
  //         : Get.put(HomeController());
  //
  //     /// 2️⃣ Navigation Gainer
  //     Get.toNamed(Routes.GAINERMAINVIEW);
  //
  //     /// 3️⃣ Load locations
  //     await switcherController.getLocation();
  //
  //     final locationDetails = switcherController.locationDataList.firstWhere(
  //       (e) => e.locationId.toString() == locationId,
  //       orElse: () => switcherController.locationDataList.first,
  //     );
  //     switcherController.selectedLocation.value = locationDetails.location;
  //     switcherController.selectedLocationId.value =
  //         locationDetails.locationId.toString();
  //
  //     /// 4️⃣ Load data
  //     await homeController.getBuyerDetails(
  //       locationDetails.locationId.toString(),
  //       locationDetails.location,
  //     );
  //
  //     /// 5️⃣ Navigate
  //     Get.toNamed(screen);
  //   }
  // }
}
