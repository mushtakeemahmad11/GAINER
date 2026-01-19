import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gainer/scanapp/screens/scanapp_main_screen.dart';
import 'package:get/get.dart';
import '../../main.dart';
import '../core/themes/scanapp_colors.dart';
import '../core/utils/scanapp_constant_image.dart';

class ScanappSplashScreen extends StatefulWidget {
  const ScanappSplashScreen({super.key});

  @override
  ScanappSplashScreenState createState() => ScanappSplashScreenState();
}

class ScanappSplashScreenState extends State<ScanappSplashScreen> {
  Timer? _timer;

  @override
  initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    _timer = Timer(const Duration(seconds: 2), () async {
      Get.off(() => ScanappMainScreen());
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
      backgroundColor: ScanappColors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(ScanappConstantImage.splashLogo, height: 120),
            SizedBox(height: mq.height * .02),
            Image.asset(ScanappConstantImage.homeBack),
            SizedBox(height: mq.height * .05),
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: mq.height * .02, horizontal: mq.width * .02),
              // child: const Text(
              //   "Warehouse management system\nis online now",
              //   textAlign: TextAlign.center,
              //   style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              // ),
              child: Text(
                "Audit on your fingertips is live now",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Future<bool> whereToGo() async {
  //   String? token = await getStringData(LoginScreenState.LOGINTOKEN);
  //   // If token is null or empty, return false otherwise return true
  //   bool checkTokenExpiredFromJwt = true;
  //   bool checkValidFromServer = false;
  //   if (token != null) {
  //     print(token);
  //     // bool checkTokenExpiredFromJwt = JwtDecoder.isExpired(await getStringData(LoginScreenState.LOGINTOKEN));
  //     // print(checkTokenExpiredFromJwt);
  //     // print(JwtDecoder.isExpired(token));
  //     final response = await isTokenValidFromServer(token);
  //     checkValidFromServer = response['success'];
  //     print(await isTokenValidFromServer(token));
  //     print(checkValidFromServer);
  //
  //     // final userId = response["decoded"]["userId"];
  //     // setStringData('userId', userId);
  //   }
  //   return token != null &&
  //       token.isNotEmpty &&
  //       checkTokenExpiredFromJwt &&
  //       checkValidFromServer;
  // }
}
