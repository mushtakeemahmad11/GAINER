import 'package:flutter/material.dart';

import '../../../../core/constants/gainer_color.dart';
import '../../../../core/widgets/scrollable_text_widget.dart';

class DrReceivedExpansionTileHeader extends StatelessWidget {
  final String title1;
  final String title2;
  final String title3;

  const DrReceivedExpansionTileHeader({
    super.key,
    required this.title1,
    required this.title2,
    required this.title3,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxFirstWidth = constraints.maxWidth * 0.3; // 2 / (2+3)

        return Row(
          children: [
            /// 1️⃣ First child: content width, capped
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: maxFirstWidth,
              ),
              child: ScrollableTextWidget(
                textWidget: _titleText(title1),
              ),
            ),

            const SizedBox(width: 10),

            /// 2️⃣ Second child: remaining width
            Expanded(
              child: Center(
                child: ScrollableTextWidget(
                  textWidget: _titleText(title2),
                ),
              ),
            ),

            const SizedBox(width: 10),

            /// 3️⃣ Third child: content width
            _titleText(title3),
          ],
        );
      },
    );
    // return Row(
    //   children: [
    //     Expanded(
    //       flex: 2,
    //       child: ScrollableTextWidget(
    //         textWidget: _titleText(title1),
    //       ),
    //     ),
    //     const SizedBox(width: 10),
    //     Expanded(
    //       flex: 3,
    //       child: Center(
    //         child: ScrollableTextWidget(
    //           textWidget: _titleText(title2),
    //         ),
    //       ),
    //     ),
    //     const SizedBox(width: 10),
    //     _titleText(title3),
    //   ],
    // );
  }

  Widget _titleText(String text) {
    return Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.bold,
        color: GainerColors.textPrimary,
      ),
    );
  }
}
