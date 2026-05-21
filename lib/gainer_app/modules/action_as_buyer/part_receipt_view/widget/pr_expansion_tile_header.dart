import 'package:flutter/material.dart';
import '../../../../core/constants/gainer_color.dart';
import '../../../../core/widgets/scrollable_text_widget.dart';

class PRExpansionTileHeader extends StatelessWidget {
  final String title1;
  final String title2;
  final String title3;

  const PRExpansionTileHeader({
    super.key,
    required this.title1,
    required this.title2,
    required this.title3,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _titleText(title1),
        const SizedBox(width: 10),
        Expanded(
          // child:  _titleText(title2),
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
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.bold,
        color: GainerColors.textPrimary,
      ),
    );
  }
}