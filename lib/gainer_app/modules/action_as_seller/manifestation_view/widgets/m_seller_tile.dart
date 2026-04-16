import 'package:flutter/material.dart';
import '../../../../core/constants/gainer_color.dart';
import '../../../../core/utils/check_time.dart';
import '../models/manifestation_seller_model.dart';
import 'm_details_card.dart';
import 'm_expansion_tile_header.dart';

class MSellerTile extends StatelessWidget {
  final ManifestationSellerModel group;
  const MSellerTile({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    bool is48Complete = group.items.any(
        (item) => CheckTime.is48HoursCompleted(item.poConfirmationDate ?? ''));
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
          collapsedBackgroundColor:
              is48Complete ? GainerColors.lightPink : GainerColors.lightWhite,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          collapsedShape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          title: MExpansionTileHeader(
            title1: 'Pending Since',
            subTitle1: group.minimumDate,
            title2: group.sellerName,
            subTitle2: group.location,
            title3: 'Part: ${group.totalItem}',
            // subTitle3: '₹${group.totalPrice}',
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
                return MDetailsCard(
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
