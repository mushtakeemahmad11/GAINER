import 'package:flutter/material.dart';

class SortTile extends StatelessWidget {
  final String title;
  final bool selected;
  final VoidCallback onTap;

  const SortTile({
    super.key,
    required this.title,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        selected ? Icons.check : null,
        color: Colors.green,
      ),
      title: Text(title),
      onTap: onTap,
    );
  }
}
