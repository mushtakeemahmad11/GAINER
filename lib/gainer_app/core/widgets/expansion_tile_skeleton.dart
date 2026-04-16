import 'package:flutter/material.dart';

import '../constants/gainer_color.dart';

class ExpansionTileSkeleton extends StatelessWidget {
  const ExpansionTileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: ExpansionTile(
        collapsedBackgroundColor: GainerColors.white,
        collapsedShape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("6396219187"),
            Expanded(
              child: Text(
                "Mushtakeem",
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text("908"),
          ],
        ),
      ),
    );
  }
}
