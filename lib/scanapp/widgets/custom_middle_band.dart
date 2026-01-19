import 'package:flutter/material.dart';
import '../../main.dart';
import '../core/themes/scanapp_colors.dart';

class CustomHomeIcon extends StatelessWidget {
  final IconData icon; // Icon to display inside the avatar
  final String bottomText; // Text to display below the avatar
  final VoidCallback onPressed;
  final Color bgColor;

  const CustomHomeIcon({
    super.key,
    required this.icon,
    required this.bottomText,
    required this.onPressed,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: mq.width * .05),
      child: Column(
        children: [
          ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(16),
              backgroundColor: bgColor, // Button color
              // foregroundColor: ScanappColors.cyan, // Splash color
            ),
            child: Icon(
              icon,
              color: ScanappColors.white,
              size: 30,
            ),
          ),
          Text(
            bottomText,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
