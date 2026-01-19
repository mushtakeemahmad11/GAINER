import 'dart:async';
import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';

class BlinkingButton extends StatefulWidget {
  final bool isBlink;
  final VoidCallback onPressed;
  final String text;

  const BlinkingButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.isBlink = false,
  });

  @override
  State<BlinkingButton> createState() => _BlinkingButtonState();
}

class _BlinkingButtonState extends State<BlinkingButton> {
  bool _visible = true;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    if (widget.isBlink) {
      _timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
        setState(() {
          _visible = !_visible;
        });
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: DMAppColors.secondary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        onPressed: widget.onPressed,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 500),
          opacity: widget.isBlink ? (_visible ? 1.0 : 0.0) : 1.0,
          child: Text(
            widget.text,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
