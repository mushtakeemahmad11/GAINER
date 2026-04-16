import 'package:flutter/material.dart';
import 'package:gainer/gainer_app/modules/splash/splash_controller.dart';
import 'package:get/get.dart';
import '../../core/constants/gainer_image.dart';

class SplashView extends GetView<AuthController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),

          /// App Logo
          Image.asset(GainerImages.scsCircle),
          // Image.asset(AppImages.appLogo),

          const SizedBox(height: 20),

          /// App Name
          const Text(
            'Tel-e-scope',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          /// Company
          const Text(
            'SpareCare Solution Pvt. Ltd.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),

          const Spacer(),

          const Padding(
            padding: EdgeInsets.only(bottom: 24),
            child: CircularProgressIndicator(),
          ),
        ],
      ),
    );
  }
}

// class SplashView extends GetView<AuthController> {
//   const SplashView({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(
//       body: Center(
//         child: CircularProgressIndicator(),
//       ),
//     );
//   }
// }
