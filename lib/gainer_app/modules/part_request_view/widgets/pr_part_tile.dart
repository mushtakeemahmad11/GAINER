import 'package:flutter/material.dart';
import 'package:gainer/gainer_app/core/widgets/scrollable_text_widget.dart';
import './pr_details_card.dart';
import '../../../core/constants/gainer_color.dart';
import '../model/part_request_part_model.dart';

class PRPartTile extends StatelessWidget {
  final PartRequestPartModel group;
  final int totalPartLen;
  const PRPartTile(
      {super.key, required this.group, required this.totalPartLen});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: GainerColors.border),
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: ExpansionTile(
          initiallyExpanded: totalPartLen < 3 ? true : false,
          // showTrailingIcon: false,
          tilePadding: const EdgeInsets.symmetric(horizontal: 10),
          backgroundColor: GainerColors.lightWhite,
          collapsedBackgroundColor: GainerColors.lightWhite,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          collapsedShape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 10,
            children: [
              _titleText(group.partNumber),
              Expanded(
                child: Center(
                  child: ScrollableTextWidget(
                    textWidget: _titleText(group.partDesc),
                  ),
                ),
              ),
              // Expanded(
              //   child: SingleChildScrollView(
              //     scrollDirection: Axis.horizontal,
              //     child: _titleText(group.partDesc),
              //   ),
              // ),
              _titleText('MRP: ₹${group.mrp}'),
            ],
          ),
          children: [
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: group.items.length,
              separatorBuilder: (_, __) =>
                  const Divider(height: 1, color: Colors.black38),
              itemBuilder: (_, index) {
                final item = group.items[index];
                return PRDetailsCard(order: item);
              },
            ),
          ],
        ),
      ),
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
