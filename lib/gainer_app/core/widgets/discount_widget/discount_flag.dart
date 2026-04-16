import 'package:flutter/material.dart';
import 'package:gainer/gainer_app/core/constants/gainer_color.dart';
import 'discount_flag_painter.dart';

class DiscountFlag extends StatelessWidget {
  final String text;

  const DiscountFlag({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: DiscountFlagPainter(GainerColors.maroon),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 30),
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
