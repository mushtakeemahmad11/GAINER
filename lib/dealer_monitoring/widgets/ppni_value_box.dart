import 'package:flutter/material.dart';
import '../core/utils/transform_value_ind.dart';

class PpniValueBox extends StatelessWidget {
  final double value;

  const PpniValueBox({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    String number = TransformValue().formatIndianNumber(value.toInt());
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.deepOrange[300],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              // 'PPNI Value   ${value.toStringAsFixed(2)}',
              // 'PPNI Value   ${value.toInt()}',
              // 'PPNI Value   $number',
              'PPNI Value       $number',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
