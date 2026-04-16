// import 'package:gainer/gainer_app/modules/notification_view/test_notification_model.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:get/get_instance/src/extension_instance.dart';
// import 'package:get/get_navigation/src/extension_navigation.dart';
//
// import '../../../app_switcher_view/app_switcher_controller.dart';
// import '../../core/Services/auth_service.dart';
// import '../../routes/app_routes.dart';
// import '../bottom_navbar/home_view/home_controller.dart';
//
// class NotificationHandler {
//   static Future<void> handle(Map<String, dynamic> data) async {
//     final notification = NotificationModel.fromMap(data);
//
//     print("Handling Notification: ${notification.route}");
//
//     /// 1. Check Login
//     bool isLoggedIn = await AuthService.isLoggedIn();
//     if (!isLoggedIn) {
//       // Storage.savePendingNotification(data);
//       Get.offAllNamed(Routes.LOGIN);
//       return;
//     }
//
//     /// 2. Check Module
//     if (notification.module == "gainer") {
//       await _handleGainer(notification);
//     }
//   }
//
//   ///HANDLE NOTIFICATION FOR GAINER
//   static Future<void> _handleGainer(NotificationModel notification) async {
//     /// Step 1: Go to AppSwitcher if not there
//     if (Get.currentRoute != Routes.APPSWITCHER) {
//       Get.offAllNamed(Routes.APPSWITCHER);
//       await Future.delayed(Duration(milliseconds: 200));
//     }
//
//     /// Step 2: Open Gainer
//     Get.toNamed(Routes.GAINERMAINVIEW);
//
//     /// Step 3: Wait for controller ready
//     // final controller = Get.find<GainerMainController>();
//     final controller = Get.put(AppSwitcherController());
//
//     /// Step 4: Fetch locations (if not already)
//     await controller.appSwitcherInitWork();
//     // final tCode = await AuthService.getTCode();
//     // await controller.getLocationUsingTCode(tCode);
//
//     /// Step 5: Match location
//     // final location = controller.locations.firstWhere(
//     //       (e) => e.id == notification.locationId,
//     //   orElse: () => controller.locations.first,
//     // );
//
//     final locationDetails = controller.locationDataList.firstWhere(
//       (e) => e.locationId.toString() == notification.locationId,
//       orElse: () => controller.locationDataList.first,
//     );
//     final homeCtrl = Get.find<HomeController>();
//     homeCtrl.onChangeLocation(locationDetails.location);
//
//     // homeCtrl.onChangeLocation(locationDetails.location);
//
//     /// Step 6: Set location
//     // await controller.setLocation(location);
//
//     /// Step 7: Refresh data
//     // await controller.fetchDashboardData();
//
//     /// Step 8: Navigate to screen
//     Get.toNamed(notification.route);
//   }
// }
