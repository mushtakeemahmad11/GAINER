import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../gainer/screens/constant_image_path.dart';
import '../../main.dart';
import 'dm_main_screen.dart';

class DMSplashScreen extends StatefulWidget {
  const DMSplashScreen({super.key});

  @override
  State<DMSplashScreen> createState() => _DMSplashScreenState();
}

class _DMSplashScreenState extends State<DMSplashScreen> {
  bool _hasNavigated = false;
  Timer? _timer;
  @override
  void initState() {
    super.initState();
    // Future.delayed(Duration(seconds: 2), () {
    //   if (!_hasNavigated) {
    //     _hasNavigated = true;
    //     Get.off(() => DMMainScreen());
    //   }
    // });
    _timer = Timer(Duration(seconds: 2), () {
      if (mounted && !_hasNavigated) {
        _hasNavigated = true;
        Get.off(() => DMMainScreen(), transition: Transition.rightToLeft);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // stop the 2s timer if user presses back
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFD4E7E7), // Light blue background
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: mq.height * .2),
              // Logo
              Image.asset(
                AppImages.scsBlack,
                height: 100,
              ),
              SizedBox(height: mq.height * .1),
              // Image below logo
              // Image.asset(
              //   Constants.openingScreenImg,
              //   height: 200,
              // ),
              ClipRRect(
                borderRadius: BorderRadius.circular(
                    16), // you can change 16 to whatever you like
                child: Image.asset(
                  AppImages.openingScreenImg,
                  height: 200,
                  // width: 300,
                  fit: BoxFit.cover, // makes sure the image fits nicely
                ),
              ),
              SizedBox(height: 30),
              // Text
              Text(
                'Empowering Dealers,\nSimplifying Monitoring',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
