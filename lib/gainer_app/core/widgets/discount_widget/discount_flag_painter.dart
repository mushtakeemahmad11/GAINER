import 'package:flutter/material.dart';

class DiscountFlagPainter extends CustomPainter {
  final Color color;

  DiscountFlagPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    const double notchDepth = 20;
    const double radius = 6;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();

    // Start top-left (with radius)
    path.moveTo(radius, 0);

    // Top edge
    path.lineTo(size.width, 0);

    // Right notch (inside cut)
    path.lineTo(size.width - notchDepth, size.height / 2);
    path.lineTo(size.width, size.height);

    // Bottom edge
    path.lineTo(radius, size.height);

    // Bottom-left rounded corner
    path.quadraticBezierTo(
      0,
      size.height,
      0,
      size.height - radius,
    );

    // Left edge
    path.lineTo(0, radius);

    // Top-left rounded corner
    path.quadraticBezierTo(
      0,
      0,
      radius,
      0,
    );

    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
