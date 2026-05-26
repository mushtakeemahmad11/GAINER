import 'package:flutter/material.dart';
import '../../../main.dart';
import '../constants/gainer_color.dart';
import '../constants/gainer_image.dart';

class GainerBottomSheet {
  /// This method shows a bottom sheet to select a profile picture.
  static void show({
    required BuildContext context,
    required VoidCallback onPressedCamera,
    required VoidCallback onPressedGallery,
    bool isGainer = true,
  }) {
    showModalBottomSheet(
      backgroundColor:
          isGainer ? GainerColors.primary : GainerColors.primaryOld,
      context: context,
      builder: (_) {
        return SafeArea(
          child: ListView(
            padding: EdgeInsets.symmetric(vertical: mq.height * 0.03),
            shrinkWrap: true,
            children: [
              // Header Text
              const Center(
                child: Text(
                  'Select image from',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              // Space
              SizedBox(height: mq.height * .02),

              // Icon Buttons Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Camera Icon Button
                  _imageTextColumn(
                    text: 'Camera',
                    imageUrl: GainerImages.cameraIcon,
                    onPressed: onPressedCamera,
                    isGainer: isGainer,
                  ),

                  // Gallery Icon Button
                  _imageTextColumn(
                    text: 'Gallery',
                    imageUrl: GainerImages.galleryIcon,
                    onPressed: onPressedGallery,
                    isGainer: isGainer,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  /// Helper widget for image button with text below it.
  static Widget _imageTextColumn({
    required String text,
    required String imageUrl,
    required VoidCallback onPressed,
    required bool isGainer,
  }) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            fixedSize: Size.square(mq.height * 0.13),
            // backgroundColor: Colors.white24,
            backgroundColor: isGainer ? Colors.white12 : Colors.white24,
          ),
          child: Image.asset(imageUrl),
        ),
        SizedBox(
          height: mq.height * .01,
        ),
        Text(
          text,
          style: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white70),
        ),
      ],
    );
  }

  /// SnackBar show from bottom
  static void showSnackBar(String message,
      {bool isAction = false, String label = '', VoidCallback? onPressed}) {
    final messenger = scaffoldMessengerKey.currentState;
    if (messenger == null) return;

    messenger
      ..removeCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 3),
          action: isAction
              ? SnackBarAction(
                  label: label,
                  onPressed: onPressed ?? () {},
                  textColor: GainerColors.primary,
                )
              : null,
          persist: false,
          behavior: isAction ? SnackBarBehavior.floating : null,
          shape: isAction
              ? RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                )
              : null,
        ),
      );

    // ScaffoldMessenger.of(context).removeCurrentSnackBar(); // Remove previous
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(
    //     content: Text(message),
    //     duration: const Duration(seconds: 3),
    //   ),
    // );
  }

  static void showError(String message,
      {bool isError = false, bool longDuration = false}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // if (Get.isSnackbarOpen) {
      //   Get.closeCurrentSnackbar();
      // }

      final messenger = scaffoldMessengerKey.currentState;
      if (messenger == null) return;

      messenger
        ..removeCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Center(
              child: Text(message, style: TextStyle(color: Colors.white)),
            ),
            backgroundColor: isError ? Color(0xFF303030) : Colors.green,
            duration: longDuration ? Duration(hours: 1) : Duration(seconds: 3),
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          ),
        );

      // Get.rawSnackbar(
      //   messageText: Center(
      //     child: Text(message, style: TextStyle(color: Colors.white)),
      //   ),
      //   backgroundColor: isError ? Color(0xFF303030) : Colors.green,
      //   duration: longDuration ? Duration(hours: 1) : Duration(seconds: 3),
      //   isDismissible: !longDuration,
      //   padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      // );
    });
  }
}
