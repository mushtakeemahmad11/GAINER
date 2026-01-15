import 'package:flutter/material.dart';

class CustomCircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const CustomCircleButton(
      {super.key, required this.icon, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,
        shape: const CircleBorder(side: BorderSide(color: Colors.teal)),
      ),
      onPressed: onTap,
      child: Icon(icon, color: Colors.teal),
    );
    // return IconButton(
    //     onPressed: onTap,
    //     icon: Icon(
    //       icon,
    //       size: 35,
    //       color: ScanappColors.secondary,
    //     ));
  }
}
