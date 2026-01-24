import 'package:flutter/material.dart';
import 'package:gainer/gainer_app/core/widgets/scs_circle_icon.dart';

import '../constants/gainer_color.dart';

class GainerAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  const GainerAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: GainerColors.primary,
      title: Text(title),
      titleTextStyle: TextStyle(fontSize: 18),
      actions: [ScsCircleIcon()],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

}
