import 'package:flutter/material.dart';
import '../../../../core/constants/gainer_color.dart';
import '../../../../core/widgets/scrollable_text_widget.dart';

class MExpansionTileHeader extends StatelessWidget {
  final String title1;
  final String subTitle1;
  final String title2;
  final String subTitle2;
  final String title3;
  // final String subTitle3;

  const MExpansionTileHeader({
    super.key,
    required this.title1,
    required this.subTitle1,
    required this.title2,
    required this.subTitle2,
    required this.title3,
    // required this.subTitle3,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _titleText(title1),
            _titleText(subTitle1),
          ],
        ),
        Expanded(
          child: Center(
            child: Column(
              children: [
                ScrollableTextWidget(textWidget: _titleText(title2)),
                ScrollableTextWidget(textWidget: _titleText(subTitle2)),
                // SingleChildScrollView(
                //   scrollDirection: Axis.horizontal,
                //   child: _titleText(title2),
                // ),
                // SingleChildScrollView(
                //   scrollDirection: Axis.horizontal,
                //   child: _titleText(subTitle2),
                // ),
              ],
            ),
          ),
        ),
        _titleText(title3),
        // Column(
        //   crossAxisAlignment: CrossAxisAlignment.end,
        //   // mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     _titleText(title3),
        //     // _titleText(subTitle3),
        //   ],
        // ),
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
