import 'package:flutter/material.dart';

class DmListTile extends StatelessWidget {
  final bool isScanappDrawer;
  final IconData? icon;
  final String? url;
  final String title;
  final VoidCallback onTap;

  const DmListTile({
    super.key,
    this.icon,
    this.url,
    this.isScanappDrawer = false,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget? leadingWidget;

    if (url != null && url!.isNotEmpty) {
      leadingWidget = Image.asset(
        url!,
        width: 30,
        height: 30,
        fit: BoxFit.contain,
        color: (title.startsWith("Substitution") || title.startsWith("PPNI"))
            ? Colors.white
            : null, // desired color
        colorBlendMode: BlendMode.srcIn, // keeps transparency
      );
    } else if (icon != null) {
      leadingWidget = Icon(
        icon,
        color: isScanappDrawer ? Colors.black : Colors.white,
      );
    }

    return ListTile(
      leading: leadingWidget,
      title: Text(
        title,
        style: TextStyle(
            color: isScanappDrawer ? Colors.black : Colors.white),
      ),
      onTap: onTap,
    );
  }
}
