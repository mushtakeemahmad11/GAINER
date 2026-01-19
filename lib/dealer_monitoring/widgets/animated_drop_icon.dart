import 'package:flutter/material.dart';

class AnimatedDropIcon extends StatelessWidget {
  final bool isTrue;
  final bool? isWhite;
  final double iconSize;
  const AnimatedDropIcon(
      {super.key,
      required this.isTrue,
      this.iconSize = 30,
      this.isWhite = false});
  @override
  Widget build(BuildContext context) {
    return AnimatedRotation(
      turns: isTrue ? 0.5 : 0.0, // 0.5 = 180 degrees
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: Icon(
        Icons.arrow_drop_down,
        // size: 30,
        size: iconSize,
        color: isWhite == true ? Colors.white : Colors.black,
      ),
    );
  }
}
