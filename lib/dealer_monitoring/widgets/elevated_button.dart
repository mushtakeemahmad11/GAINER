import 'package:flutter/material.dart';
import '../../main.dart';
import '../core/theme/app_colors.dart';

class ReusableElevatedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const ReusableElevatedButton({super.key,required this.text,required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: mq.width,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(DMAppColors.secondary),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
        child: Text(text,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
