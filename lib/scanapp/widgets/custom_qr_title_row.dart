import 'package:flutter/material.dart';
import '../../main.dart';
import '../core/themes/scanapp_colors.dart';

class CustomQrTitleRow extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  const CustomQrTitleRow({super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
            onPressed: onTap,
            icon: const Icon(
              Icons.qr_code_scanner,
              size: 35,
              color: ScanappColors.black,
            )),
        SizedBox(width: mq.width * .02),
        Text(title),
      ],
    );
  }
}
