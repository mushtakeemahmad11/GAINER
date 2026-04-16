
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'no_internet_controller.dart';

class NoInternetView extends GetView<NoInternetController> {
  const NoInternetView({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off, size: 80, color: Colors.red),
            SizedBox(height: size.height * .02),
            const Text("No Internet Connection 😔",
                style: TextStyle(fontSize: 20)),
            SizedBox(height: size.height * .02),
            OutlinedButton(
              onPressed: () => Navigator.of(Get.overlayContext!).pop(),
              child: const Text('Back'),
            ),
          ],
        ),
      ),
    );
  }
}