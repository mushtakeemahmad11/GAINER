import 'package:flutter/material.dart';
import 'package:gainer/dealer_monitoring/core/theme/app_colors.dart';

class TitleIconRow extends StatelessWidget {
  final String title;
  final VoidCallback onCloseTap;
  const TitleIconRow({
    super.key,
    required this.title,
    required this.onCloseTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: DMAppColors.primary,
      margin: const EdgeInsets.only(bottom: 5),
      padding: const EdgeInsets.only(left: 5),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          IconButton(
            onPressed: onCloseTap,
            icon: const Icon(
              Icons.close,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
