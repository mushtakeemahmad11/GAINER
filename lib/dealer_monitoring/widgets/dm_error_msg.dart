import 'package:flutter/material.dart';

class DmErrorMsg extends StatelessWidget {
  final String text;
  const DmErrorMsg({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(text,style: const TextStyle(color: Colors.red),);
  }
}
