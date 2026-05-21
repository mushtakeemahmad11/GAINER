import 'package:flutter/material.dart';

class InfoSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const InfoSection({super.key, required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('  $title',
            style: const TextStyle(
                fontSize: 12, color: Colors.grey, letterSpacing: 1)),
        // const SizedBox(height: 2),
        Card(
          margin: EdgeInsets.all(2),
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Column(children: children),
        )
      ],
    );
  }
}
