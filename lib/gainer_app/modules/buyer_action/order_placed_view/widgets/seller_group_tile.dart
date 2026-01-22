import 'package:flutter/material.dart';
import 'package:gainer/gainer_app/modules/buyer_action/order_placed_view/widgets/expansion_tile_header.dart';
import '../../../../core/constants/gainer_color.dart';
import '../models/grouped_seller_model.dart';
import 'details_card.dart';

class SellerGroupTile extends StatelessWidget {
  final GroupedSellerModel group;
  const SellerGroupTile({super.key, required this.group});

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
          title: ExpansionTileHeader(
            title1: group.sellerName,
            title2: group.location,
            title3: group.totalQty.toString(),
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

                return DetailsCard(
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
}
