import 'package:flutter/material.dart';
import 'package:gainer/gainer_app/core/widgets/gainer_expansion_tile.dart';
import 'package:gainer/gainer_app/modules/action_as_buyer/order_placed_view/widgets/expansion_tile_header.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import '../../../../core/constants/gainer_color.dart';
import '../../../../core/utils/check_time.dart';
import '../models/grouped_seller_model.dart';
import '../order_placed_controller.dart';
import 'details_card.dart';

class SellerGroupTile extends StatelessWidget {
  final GroupedSellerModel group;
  const SellerGroupTile({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<OrderPlacedController>();
    bool is48Complete = group.items
        .any((item) => CheckTime.is48HoursCompleted(item.requestDate ?? ""));
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: GainerColors.border),
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: GainerExpansionTile(
            is48Complete: is48Complete,
            titleWidget: ExpansionTileHeader(
              title1: group.sellerName,
              title2: group.location,
              title3: group.totalQty.toString(),
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
                  return DetailsCard(
                    isPart: true,
                    order: item,
                    onRemove: () => c.deletePart(
                        item.partNumber, item.bigId.toString(), context),
                  );
                },
              ),
            ]),
        // child: ExpansionTile(
        //   tilePadding: const EdgeInsets.symmetric(horizontal: 10),
        //   backgroundColor: GainerColors.lightWhite,
        //   // collapsedBackgroundColor: GainerColors.lightWhite,
        //   collapsedBackgroundColor:
        //       is48Complete ? GainerColors.lightPink : GainerColors.lightWhite,
        //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        //   collapsedShape:
        //       RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        //   title: ExpansionTileHeader(
        //     title1: group.sellerName,
        //     title2: group.location,
        //     title3: group.totalQty.toString(),
        //   ),
        //   children: [
        //     ListView.separated(
        //       shrinkWrap: true,
        //       physics: const NeverScrollableScrollPhysics(),
        //       itemCount: group.items.length,
        //       separatorBuilder: (_, __) =>
        //           const Divider(height: 1, color: Colors.black38),
        //       itemBuilder: (_, index) {
        //         final item = group.items[index];
        //         return DetailsCard(
        //           isPart: true,
        //           order: item,
        //           onRemove: () => c.deletePart(
        //               item.partNumber, item.bigId.toString(), context),
        //         );
        //       },
        //     ),
        //   ],
        // ),
      ),
    );
  }
}
