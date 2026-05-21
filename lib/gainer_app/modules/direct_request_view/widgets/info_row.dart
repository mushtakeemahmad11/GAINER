import 'package:flutter/material.dart';

class InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const InfoRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Expanded(
        //   child: Text(label,
        //       style: const TextStyle(
        //           fontWeight: FontWeight.w600, color: Colors.black54)),
        // ),
        SizedBox(
          width: 150,
          child: Text(label,
              style: const TextStyle(
                  fontWeight: FontWeight.w600, color: Colors.black54)),
        ),
        Expanded(child: Text(value)),
      ],
    );
  }
}
