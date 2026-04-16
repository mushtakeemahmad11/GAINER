import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NoInternetDialog {
  static void show() {
    if (Get.isDialogOpen == true) return;

    final size = MediaQuery.of(Get.context!).size;

    Get.defaultDialog(
      title: 'You are offline',
      titlePadding: const EdgeInsets.all(14),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.wifi_off, size: 80, color: Colors.red),
          SizedBox(height: size.height * .02),
          const Text(
            "No Internet Connection 😔",
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: size.height * .02),
          OutlinedButton(
            onPressed: Get.back,
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}