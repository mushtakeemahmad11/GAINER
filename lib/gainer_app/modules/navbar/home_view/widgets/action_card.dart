import 'package:flutter/material.dart';

import '../../../../core/constants/gainer_color.dart';

class ActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String status;
  final Color color;

  const ActionCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.status,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: GainerColors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: color)),
          const SizedBox(height: 4),
          Text(subtitle),
          const SizedBox(height: 6),
          Text(
            status,
            style: const TextStyle(
                fontSize: 12, color: GainerColors.error),
          ),
        ],
      ),
    );
  }
}
