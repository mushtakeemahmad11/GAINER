import 'package:flutter/material.dart';

class CustomErrorMsg extends StatelessWidget {
  final String text;
  const CustomErrorMsg({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(text,style: const TextStyle(color: Colors.red),);
  }
}
