import 'package:flutter/material.dart';
import '../../../../core/constants/gainer_color.dart';
import '../../../../core/utils/check_time.dart';
import '../models/part_receipt_seller_model.dart';
import 'pr_details_card.dart';
import 'pr_expansion_tile_header.dart';

class PartReceiptSellerTile extends StatelessWidget {
  final PartReceiptSellerModel group;
  const PartReceiptSellerTile({super.key, required this.group});

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
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 10),
          backgroundColor: GainerColors.lightWhite,
          collapsedBackgroundColor: is48Complete?GainerColors.lightPink:GainerColors.lightWhite,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          collapsedShape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          title: PRExpansionTileHeader(
            title1: group.sellerName,
            title2: group.location,
            title3: 'PO Qty: ${group.poQty}',
          ),
          // title: PoExpansionTileHeader(
          //   title1: 'Pending Since',
          //   subTitle1: group.highestDate,
          //   title2: group.sellerName,
          //   subTitle2: group.location,
          //   title3: 'Total Price',
          //   subTitle3: '₹${group.totalPrice}',
          // ),
          // title: Text('1234567890'),
          children: [
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: group.items.length,
              separatorBuilder: (_, __) =>
                  const Divider(height: 1, color: Colors.black38),
              itemBuilder: (_, index) {
                final item = group.items[index];

                return PRDetailsCard(
                  isPart: true,
                  order: item,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
