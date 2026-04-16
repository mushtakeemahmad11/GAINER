import 'package:flutter/material.dart';
import 'package:gainer/gainer_app/core/constants/gainer_image.dart';
import 'package:get/get.dart';
import '../../core/constants/gainer_color.dart';
import 'gainer_splash_controller.dart';

class GainerSplashView extends GetView<GainerSplashController> {
  const GainerSplashView({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: GainerColors.background,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ///space on Top
            const Spacer(),

            /// Sparecare Logo
            Image.asset(
              GainerImages.scsBlackLogo,
              height: 100,
            ),
            const SizedBox(height: 10),

            /// Welcoming With App Name
            const Text(
              'Welcome to \nGainer Application',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            ///Banner Image
            Image.asset(
              GainerImages.gainerSplashBanner,
              // height: 100,
              width: size.width - 20,
            ),
            const SizedBox(height: 20),

            ///Quotes Text
            const Text(
              'Unlocking Value \nEnabling Collaboration',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const Spacer(),
          ],
        ),
      ),
    );
  }
}
