import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../main.dart';
import '../controllers/home_screen_controller.dart';
import '../shared_preferences/shared_preferences_get_data.dart';
import 'login_screen.dart';
import 'constant_image_path.dart';
import 'main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final LocationController locationController = Get.put(LocationController());

  bool _hasNavigated = false;
  Timer? _timer;
  @override
  void initState() {
    super.initState();
    _subscribeTopic();
    _timer = Timer(const Duration(seconds: 2), () {
      if (mounted && !_hasNavigated) {
        _hasNavigated = true;
        _navigateToNextScreen();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // stop the 2s timer if user presses back
    super.dispose();
  }

  /// Handles navigation logic based on user login status.
  Future<void> _navigateToNextScreen() async {
    bool isLoggedIn = await getBoolData('isLogin') ?? false;

    if (isLoggedIn) {
      await locationController.getLocationUsingTCode();
      Get.off(() => MainScreen(),
          transition: Transition.rightToLeft); //only for Gainer
      // if (locationController.errorMsg.value != null) {
      //   Get.to(() => NoInternetScreen());
      //   internetNotAvl();
      //   CustomBottomSheet.showSnackBar(
      //       context, locationController.errorMsg.value!);
      // } else {
      //   Get.off(() => MainScreen()); //only for Gainer
      //   // Get.offAll(() => const AppLauncherScreen());
      // }
    } else {
      Get.offAll(() => const LoginScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[50],
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                AppImages.profile,
                height: 250,
              ),
              SizedBox(height: mq.height * 0.05),
              const Text(
                'Welcome to\nGainer Application',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: mq.height * 0.15),
            ],
          ),
        ),
      ),
    );
  }

  void _subscribeTopic() {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    messaging.subscribeToTopic("all");
    // print("subscribe topic All");
  }
}
