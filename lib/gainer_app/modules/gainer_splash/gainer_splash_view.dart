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
            const Spacer(),

            /// App Logo
            Image.asset(
              GainerImages.scsBlackLogo,
              height: 100,
            ),
            const SizedBox(height: 40),
            Image.asset(GainerImages.partWithCar,
                height: size.height * .25), //gainerSplashBanner

            const SizedBox(height: 40),

            // /// App Name
            const Text(
              'Welcome to \nGainer Application',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Spacer(),

            // const Padding(
            //   padding: EdgeInsets.only(bottom: 24),
            //   child: CircularProgressIndicator(),
            // ),
          ],
        ),
      ),
    );
  }
}
