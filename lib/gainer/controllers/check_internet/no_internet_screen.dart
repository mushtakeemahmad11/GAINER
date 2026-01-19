import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../main.dart';

class NoInternetScreen extends StatelessWidget {
  const NoInternetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off, size: 80, color: Colors.red),
            SizedBox(height: mq.height * .02),
            const Text("No Internet Connection 😔",
                style: TextStyle(fontSize: 20)),
            SizedBox(height: mq.height * .02),
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

internetNotAvl() {
  return Get.defaultDialog(
    title: 'You are offline',
    titlePadding: const EdgeInsets.all(14),
    content: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.wifi_off, size: 80, color: Colors.red),
          SizedBox(height: mq.height * .02),
          const Text("No Internet Connection 😔",
              style: TextStyle(fontSize: 20)),
          SizedBox(height: mq.height * .02),
          OutlinedButton(
            onPressed: () => Navigator.of(Get.overlayContext!).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    ),
  );
}
