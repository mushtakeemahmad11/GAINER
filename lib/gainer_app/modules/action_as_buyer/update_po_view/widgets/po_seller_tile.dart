import 'package:flutter/material.dart';
import 'package:gainer/gainer_app/core/widgets/gainer_expansion_tile.dart';
import 'package:gainer/gainer_app/modules/action_as_buyer/update_po_view/models/update_po_seller_model.dart';
import 'package:gainer/gainer_app/modules/action_as_buyer/update_po_view/widgets/po_details_card.dart';
import 'package:gainer/gainer_app/modules/action_as_buyer/update_po_view/widgets/po_expansion_tile_header.dart';
import '../../../../core/constants/gainer_color.dart';
import '../../../../core/utils/check_time.dart';

class PoSellerTile extends StatelessWidget {
  final UpdatePoSellerModel group;
  const PoSellerTile({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    bool is48Complete = group.items.any(
        (item) => CheckTime.is48HoursCompleted(item.sellerResponseDate ?? ''));
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: GainerColors.border),
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: GainerExpansionTile(
            is48Complete: is48Complete,
            titleWidget: PoExpansionTileHeader(
              title1: 'Pending Since',
              subTitle1: group.highestDate,
              title2: group.sellerName,
              subTitle2: group.location,
              title3: 'Total Price',
              subTitle3: '₹${group.totalPrice}',
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

                  return PoDetailsCard(
                    isPart: true,
                    order: item,
                  );
                },
              ),
            ]),
        // child: ExpansionTile(
        //   tilePadding: const EdgeInsets.symmetric(horizontal: 10),
        //   backgroundColor: GainerColors.lightWhite,
        //   collapsedBackgroundColor: is48Complete?GainerColors.lightPink:GainerColors.lightWhite,
        //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        //   collapsedShape:
        //       RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        //
        //   title: PoExpansionTileHeader(
        //     title1: 'Pending Since',
        //     subTitle1: group.highestDate,
        //     title2: group.sellerName,
        //     subTitle2: group.location,
        //     title3: 'Total Price',
        //     subTitle3: '₹${group.totalPrice}',
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
        //
        //         return PoDetailsCard(
        //           isPart: true,
        //           order: item,
        //         );
        //       },
        //     ),
        //   ],
        //   // children: group.items
        //   //     .map(
        //   //       (order) => DetailsCard(
        //   //         isPart: true,
        //   //         order: order,
        //   //         onRemove: () {
        //   //           print(order.bigId);
        //   //         },
        //   //       ),
        //   //     )
        //   //     .toList(),
        // ),
      ),
    );
  }

  /*Widget _strikeText(String text, bool isStrike) => Text(
        text,
        style: TextStyle(
          fontSize: isStrike ? 12 : 14,
          color: isStrike ? Colors.black : GainerColors.textPrimary,
          decoration:
              isStrike ? TextDecoration.lineThrough : TextDecoration.none,
          fontWeight: FontWeight.bold,
        ),
      );*/

/*  //format Date
  String _formatDate(String input) {
    try {
      String cleanedDate = input.replaceAll(RegExp(r'\s+'), ' ').trim();
      final parsed = DateFormat("MMM d yyyy h:mma").parse(cleanedDate);

      return DateFormat("MMM d yyyy").format(parsed);
    } catch (e) {
      return 'MMM d yyyy';
    }
  }*/
}
