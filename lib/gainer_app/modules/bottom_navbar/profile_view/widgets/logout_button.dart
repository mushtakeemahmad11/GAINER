import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

import '../../../../core/constants/gainer_color.dart';
import '../../home_view/home_controller.dart';

class LogoutButton extends GetView<HomeController> {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: OutlinedButton.icon(
        onPressed: controller.logout,
        icon: const Icon(Icons.logout, color: GainerColors.error),
        label:
            const Text("Log Out", style: TextStyle(color: GainerColors.error)),
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(double.infinity, 45),
          side: const BorderSide(color: GainerColors.error),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
