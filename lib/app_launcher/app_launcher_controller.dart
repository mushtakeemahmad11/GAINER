import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import '../dealer_monitoring/screens/dm_splash_screen.dart';
import '../gainer/apis_functionality/api_service.dart';
import '../gainer/controllers/check_internet/connectivity_controller.dart';
import '../gainer/controllers/check_internet/no_internet_screen.dart';
import '../gainer/controllers/home_screen_controller.dart';
import '../gainer/screens/login_screen.dart';
import '../gainer/screens/splash_screen.dart';
import '../gainer/shared_preferences/shared_preferences_get_data.dart';
import '../gainer/shared_preferences/shared_preferences_remove_data.dart';
import '../gainer/shared_preferences/shared_preferences_set_data.dart';
import '../gainer/utility/check_session.dart';
import '../scanapp/screens/scanapp_splash_screen.dart';

class AppLauncherController extends GetxController with WidgetsBindingObserver {
  final LocationController locationController = Get.find();

  RxString oldVersion = '1.0.4'.obs;
  RxString newVersion = ''.obs;
  RxBool isAppUpdated = true.obs;
  RxString userName = ''.obs;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    init();
  }
  // void onReady() {
  //   super.onReady();
  //   WidgetsBinding.instance.addObserver(this);
  //   init();
  // }

  Future<void> init() async {
    String fName = await getStringData('firstName') ?? "";
    String lName = await getStringData('lastName') ?? "";
    userName.value = '$fName $lName';
    checkSession();
    fetchVersionFromFirestore();
    navigateOnLaunch();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      checkSession();
    }
  }

  Future<void> navigateOnLaunch() async {
    final isLoggedIn = await getBoolData('isLogin') ?? false;

    if (!isLoggedIn) {
      Get.offAll(() => const LoginScreen());
      return;
    }

    if (!Get.find<ConnectivityController>().isConnected.value) {
      Get.to(() => NoInternetScreen());
      return;
    }

    await locationController.getLocationUsingTCode();

    if (locationController.errorMsg.value != null) {
      Get.to(() => NoInternetScreen());
    }
  }

  Future<void> fetchVersionFromFirestore() async {
    print("You are in fetchVersionFromFirestore");
    try {
      final doc = await FirebaseFirestore.instance
          .collection('update')
          .doc('tel-e-scope')
          .get();
      if (doc.exists) {
        newVersion.value = doc['versionName'];
        isAppUpdated.value = oldVersion.value == newVersion.value;
      }
      print(
          "Is App Updated: ${isAppUpdated.value}, ${oldVersion.value}, ${newVersion.value}");
    } catch (e) {
      debugPrint('Version fetch error: $e');
    }
  }

  Future<void> gotoScreen(String name) async {
    if (!Get.find<ConnectivityController>().isConnected.value) {
      Get.to(() => NoInternetScreen());
      return;
    }

    switch (name) {
      case 'gainer':
        Get.to(
          () => SplashScreen(),
          transition: Transition.rightToLeft,
        );
        break;
      case 'sims':
        Get.to(
          () => DMSplashScreen(),
          transition: Transition.rightToLeft,
        );
        break;
      case 'scanapp':
        Get.to(() => ScanappSplashScreen());
        break;
    }
  }

  Future<void> checkSession() async {
    final isLoggedIn = await getBoolData('isLogin') ?? false;

    if (!isLoggedIn) return;

    if (await isSessionExpired()) {
      await ApiService().logoutContinue(
        empId: (await getIntData("tCode")).toString(),
        userId: (await getStringData('UserID')).toString(),
        deviceToken: (await getStringData("deviceToken")).toString(),
        logoutType: 'SessionExpired',
      );

      await setBoolData('isLogin', false);
      await removeData('tCode');
      await removeData('userProfile');

      Get.offAll(() => const LoginScreen());
    }
  }
}
