import 'package:flutter/material.dart';
import '../../../../core/constants/gainer_color.dart';
import '../../../../core/utils/check_time.dart';
import '../../../../core/widgets/gainer_expansion_tile.dart';
import '../models/dr_received_part_model.dart';
import 'dr_received_card.dart';
import 'dr_received_expansion_tile_header.dart';

class DrReceivedPartTile extends StatelessWidget {
  final DrReceivedPartModel group;
  const DrReceivedPartTile({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    bool is48Complete = group.items
        .any((item) => CheckTime.is48HoursCompleted(item.requestDate ?? ''));
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: GainerColors.border),
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: GainerExpansionTile(
            is48Complete: is48Complete,
            titleWidget: DrReceivedExpansionTileHeader(
              title1: group.partNumber,
              title2: group.partDesc,
              title3: 'Part: ${group.totalItem}',
            ),
            bodyChildren: [
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: group.items.length,
                separatorBuilder: (_, __) =>
                    const Divider(height: 1, color: Colors.black38),
                itemBuilder: (_, index) {
                  final item = group.items[index];
                  return DrReceivedDetailsCard(
                    isPart: false,
                    order: item,
                  );
                },
              ),
            ]),
      ),
    );
  }
}
