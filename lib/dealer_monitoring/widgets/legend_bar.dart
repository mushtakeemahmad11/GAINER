import 'package:flutter/material.dart';
import 'package:gainer/dealer_monitoring/core/theme/app_colors.dart';

class LegendBar extends StatelessWidget {
  const LegendBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Wrap(
        spacing: 20, // Space between items horizontally
        runSpacing: 8, // Space between lines vertically
        children: [
          LegendItem(color: DMAppColors.stockable, label: 'Stockable'),
          LegendItem(color: DMAppColors.nonStockable, label: 'Non-Stockable'),
          LegendItem(color: DMAppColors.nonMoving, label: 'Non-Moving'),
        ],
      ),
    );
  }
}

class LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const LegendItem({super.key, required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min, // take minimum space only
      children: [
        Container(width: 16, height: 16, color: color),
        const SizedBox(width: 5),
        Text(label),
      ],
    );
  }
}
