import 'package:flutter/material.dart';

import '../constants/gainer_color.dart';
import 'scrollable_text_widget.dart';

class ExpansionHeader3 extends StatelessWidget {
  final String title1;
  final String title2;
  final String title3;
  const ExpansionHeader3({
    super.key,
    required this.title1,
    required this.title2,
    required this.title3,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(child: ScrollableTextWidget(textWidget: _titleText(title1))),
        const SizedBox(width: 10),
        Expanded(
          child: Center(
            child: ScrollableTextWidget(
              textWidget: _titleText(title2),
            ),
          ),
        ),
        const SizedBox(width: 10),
        _titleText(title3),
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
