import 'package:flutter/material.dart';
import '../../../../core/constants/gainer_color.dart';
import '../../../../core/widgets/scrollable_text_widget.dart';

class ExpansionTileHeader extends StatelessWidget {
  final String title1;
  final String title2;
  final String title3;

  const ExpansionTileHeader({
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
        _titleText(title1),
        Expanded(
          child: Center(
            child: ScrollableTextWidget(textWidget: _titleText(title2)),
          ),
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
