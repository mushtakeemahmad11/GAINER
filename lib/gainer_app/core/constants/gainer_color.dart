import 'package:flutter/material.dart';

class GainerColors {
  static Color primaryOld = Colors.cyan.shade900;
  static Color primaryShadeOld = Colors.teal.shade50;
  static const Color backgroundOld = Color(0xFFF5F5F5);

  static const Color primary = Color(0xFF5A9FA3);
  static const Color secondary = Color(0xFFBBE4E1);
  static const Color background = Color(0xFFE6F5F4);

  static const Color textPrimary = Color(0xFF23675C);
  static const Color maroon = Color(0xFFAF0A1B);

  static const Color prStatusD = Color(0xFF096C74);
  static const Color prStatusN = Color(0x6E096C74);

  static const Color error = Colors.red;
  static const Color white = Colors.white;
  static const Color lightWhite = Colors.white70;

  static const Color border = Colors.black38;

  static const Color lightPink = Color(0x9BEFD0D4);
  static const Color filtered = Color(0x9BEF939F);

  static const BoxDecoration gradientDecoration = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment(0.94, 0.97),
      end: Alignment(2.94, -0.47),
      colors: [
        Color.fromRGBO(213, 221, 249, 0.5),
        Color.fromRGBO(223, 247, 246, 0.2),
      ],
    ),
  );
}
