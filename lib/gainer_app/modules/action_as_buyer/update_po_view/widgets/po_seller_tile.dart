import 'package:flutter/material.dart';
import 'package:gainer/gainer_app/modules/action_as_buyer/order_placed_view/widgets/expansion_tile_header.dart';
import 'package:gainer/gainer_app/modules/action_as_buyer/update_po_view/models/update_po_part_model.dart';
import 'package:gainer/gainer_app/modules/action_as_buyer/update_po_view/widgets/po_details_card.dart';
import 'package:gainer/gainer_app/modules/action_as_buyer/update_po_view/widgets/po_expansion_tile_header.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/gainer_color.dart';

class PoSellerTile extends StatelessWidget {
  final UpdatePoSellerModel group;
  const PoSellerTile({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 10),
          backgroundColor: GainerColors.lightWhite,
          collapsedBackgroundColor: GainerColors.lightWhite,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          collapsedShape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          // title: ExpansionTileHeader(
          //   title1: group.sellerName,
          //   title2: group.location,
          //   title3: group.totalQty.toString(),
          // ),
          title: PoExpansionTileHeader(
            title1: 'Pending Since',
            title2: group.sellerName,
            title3: 'Total Price',
          ),
          subtitle: PoExpansionTileHeader(
            title1: _formatDate(group.items[0].requestDate),
            title2: group.location,
            priceWidget: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _strikeText('₹${group.totalMrp} ', true),
                _strikeText('₹${group.totalPrice}', false)
              ],
            ),
            // title3: '${group.totalMrp} ${group.totalPrice}',
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
                print(item.dealerName);
                print(item.sellerLocation);

                return PoDetailsCard(
                  isPart: true,
                  order: item,
                  onRemove: () => print(item.bigId),
                );
              },
            ),
          ],
          // children: group.items
          //     .map(
          //       (order) => DetailsCard(
          //         isPart: true,
          //         order: order,
          //         onRemove: () {
          //           print(order.bigId);
          //         },
          //       ),
          //     )
          //     .toList(),
        ),
      ),
    );
  }

  Widget _strikeText(String text, bool isStrike) => Text(
        text,
        style: TextStyle(
          fontSize: isStrike ? 12 : 14,
          color: isStrike ? Colors.black : GainerColors.textPrimary,
          decoration:
              isStrike ? TextDecoration.lineThrough : TextDecoration.none,
          fontWeight: FontWeight.bold,
        ),
      );

  //format Date
  String _formatDate(String input) {
    try {
      String cleanedDate = input.replaceAll(RegExp(r'\s+'), ' ').trim();
      final parsed = DateFormat("MMM d yyyy h:mma").parse(cleanedDate);

      return DateFormat("MMM d yyyy").format(parsed);
    } catch (e) {
      return 'MMM d yyyy';
    }
  }
}
