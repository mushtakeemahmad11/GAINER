import 'package:flutter/material.dart';
import '../../main.dart';
import '../screens/colors.dart';
import '../screens/constant_image_path.dart';


class CustomBottomSheet {
  /// This method shows a bottom sheet to select a profile picture.
  static void show({
    required BuildContext context,
    required VoidCallback onPressedCamera,
    required VoidCallback onPressedGallery,
  }) {
    showModalBottomSheet(
      backgroundColor: AppColor.primary,
      context: context,
      builder: (_) {
        return ListView(
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
                  imageUrl: AppImages.camera,
                  onPressed: onPressedCamera,
                ),

                // Gallery Icon Button
                _imageTextColumn(
                  text: 'Gallery',
                  imageUrl: AppImages.gallery,
                  onPressed: onPressedGallery,
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  /// Helper widget for image button with text below it.
  static Widget _imageTextColumn({
    required String text,
    required String imageUrl,
    required VoidCallback onPressed,
  }) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            fixedSize: Size.square(mq.height * 0.13),
            backgroundColor: Colors.white24,
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
  static void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar(); // Remove previous
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}