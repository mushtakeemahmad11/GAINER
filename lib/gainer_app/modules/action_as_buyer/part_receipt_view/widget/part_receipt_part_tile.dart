import 'package:flutter/material.dart';
import 'package:gainer/gainer_app/core/widgets/gainer_expansion_tile.dart';
import '../../../../core/constants/gainer_color.dart';
import '../../../../core/utils/check_time.dart';
import '../models/part_receipt_part_model.dart';
import 'pr_details_card.dart';
import 'pr_expansion_tile_header.dart';

class PartReceiptPartTile extends StatelessWidget {
  final PartReceiptPartModel group;
  const PartReceiptPartTile({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    bool is48Complete = group.items
        .any((item) => CheckTime.is48HoursCompleted(item.dispatchdate));

    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: GainerColors.border),
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: GainerExpansionTile(
            is48Complete: is48Complete,
            titleWidget: PRExpansionTileHeader(
              title1: group.partNumber,
              title2: group.partDesc,
              title3: 'PO Qty: ${group.poQty}',
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
                  return PRDetailsCard(
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
