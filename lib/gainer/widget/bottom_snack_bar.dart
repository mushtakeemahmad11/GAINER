import 'package:get/get.dart';
import 'package:flutter/material.dart';

class SnackBarService {
  static void showError(String message,
      {bool isError = false, bool longDuration = false}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.isSnackbarOpen) {
        Get.closeCurrentSnackbar();
      }

      Get.rawSnackbar(
        messageText: Center(
          child: Text(message, style: TextStyle(color: Colors.white)),
        ),
        backgroundColor: isError ? Color(0xFF303030) : Colors.green,
        duration: longDuration ? Duration(hours: 1) : Duration(seconds: 3),
        isDismissible: !longDuration,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      );
    });
    // Get.snackbar(
    //   title,
    //   message,
    //   backgroundColor: Colors.red.shade100,
    //   colorText: Colors.black,
    // );
  }
}
