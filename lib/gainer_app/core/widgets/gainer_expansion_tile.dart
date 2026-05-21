import 'package:flutter/material.dart';
import '../constants/gainer_color.dart';

class GainerExpansionTile extends StatelessWidget {
  final Widget titleWidget;
  final List<Widget> bodyChildren;
  final bool is48Complete;
  const GainerExpansionTile({
    super.key,
    required this.titleWidget,
    required this.bodyChildren,
    required this.is48Complete,
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      dense: true,
      tilePadding: const EdgeInsets.symmetric(horizontal: 10),
      backgroundColor: GainerColors.lightWhite,
      collapsedBackgroundColor:
          is48Complete ? GainerColors.lightPink : GainerColors.lightWhite,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      collapsedShape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      title: titleWidget,
      children: bodyChildren,
    );
  }
}


