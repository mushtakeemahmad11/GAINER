import 'package:flutter/material.dart';

import '../../../core/constants/gainer_color.dart';
import '../../../core/widgets/scrollable_text_widget.dart';

class CardHeader extends StatelessWidget {
  final String title1;
  final String title2;
  final String title3;

  const CardHeader({
    super.key,
    required this.title1,
    required this.title2,
    required this.title3,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 10,
      children: [
        Expanded(child: ScrollableTextWidget(textWidget: _titleText(title1))),
        Expanded(
          flex: 2,
          child: ScrollableTextWidget(textWidget: _titleText(title2)),
        ),
        _titleText('Qty: $title3'),
      ],
    );
  }

  Widget _titleText(String text) {
    return Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.bold,
        color: GainerColors.textPrimary,
      ),
    );
  }
}
