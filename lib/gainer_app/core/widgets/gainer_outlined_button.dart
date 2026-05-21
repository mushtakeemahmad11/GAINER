import 'package:flutter/material.dart';

import '../constants/gainer_color.dart';

class GainerOutlinedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;
  const GainerOutlinedButton({
    super.key,
    required this.onPressed,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
        style: OutlinedButton.styleFrom(
          foregroundColor: GainerColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          side: BorderSide(
            color: GainerColors.primary,
            width: 2,
          ),
        ),
        onPressed: onPressed,
        child: Text(title));
  }
}
