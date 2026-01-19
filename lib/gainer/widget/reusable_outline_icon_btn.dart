import 'package:flutter/material.dart';

class CustomIconBtn extends StatelessWidget {
  final VoidCallback onTap;
  final IconData icon;
  const CustomIconBtn({super.key, required this.onTap, required this.icon});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: ButtonStyle(
          shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      )),
      onPressed: onTap,
      child: Icon(
        icon,
        size: 25,
      ),
    );
  }
}
