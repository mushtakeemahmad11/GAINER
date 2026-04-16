import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';


class DealerSnackbar {
  static void showAccessDenied(String message) {
    ScaffoldMessenger.of(Get.context!)
      ..removeCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message)),
      );

    //   // if (Get.isSnackbarOpen) Get.closeAllSnackbars();
    //   if (Get.isSnackbarOpen) {
    //     Get.closeCurrentSnackbar();
    //   }
    //   Get.snackbar(
    //     'Access Denied',
    //     message,
    //     backgroundColor: DMAppColors.primaryShade,
    //     colorText: Colors.black,
    //   );
  }
}
