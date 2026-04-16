import 'package:flutter/material.dart';
import '../constants/gainer_color.dart';
import '../constants/gainer_image.dart';

class GainerAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showIcon;
  const GainerAppBar({
    super.key,
    required this.title,
    this.showIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: GainerColors.primary,
      title: Text(title),
      titleTextStyle: TextStyle(fontSize: 18),
      actions: showIcon ? [_scsCircleIcon()] : null,
    );
  }

  Widget _scsCircleIcon() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Image.asset(GainerImages.scsCircle, height: 30),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
