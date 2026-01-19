import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants/gainer_color.dart';

class AppErrorText extends StatelessWidget {
  final RxnString error;

  const AppErrorText({
    super.key,
    required this.error,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final message = error.value;
      if (message == null || message.isEmpty) {
        return const SizedBox.shrink();
      }

      return Padding(
        padding: const EdgeInsets.only(top: 6),
        child: Text(
          message,
          style: const TextStyle(
            color: GainerColors.error,
            fontSize: 14,
          ),
        ),
      );
    });
  }
}
