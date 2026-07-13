import 'package:flutter/material.dart';
import '../constants/gainer_color.dart';
import 'gainer_app_loader.dart';

class GainerPrimaryButton extends StatelessWidget {
  final String? title;
  final VoidCallback? onPressed;
  final bool isLoading;
  final double height;
  final double width;
  final double borderRadius;
  final IconData? icon;
  final Color bgColor;

  const GainerPrimaryButton({
    super.key,
    this.title,
    required this.onPressed,
    this.isLoading = false,
    this.height = 40,
    this.width = double.infinity,
    this.borderRadius = 10,
    this.icon,
    this.bgColor = GainerColors.primary,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        onPressed: onPressed,
        child: isLoading
            ? GainerCircularLoader(color: GainerColors.secondary)
            : icon != null
                ? Icon(icon, color: GainerColors.white)
                : Text(
                    title!,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
      ),
    );
  }
}
