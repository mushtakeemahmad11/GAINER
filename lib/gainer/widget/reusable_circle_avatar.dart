import 'package:flutter/material.dart';

import '../screens/colors.dart';

class CustomCircleAvatar extends StatelessWidget {
  const CustomCircleAvatar(
      {super.key, required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: AppColor.primary,
      // radius: 20,
      child: IconButton(
        onPressed: onTap,
        icon: Icon(
          icon,
          color: AppColor.primaryShade,
          // size: 20,
        ),
      ),
    );
  }
}
