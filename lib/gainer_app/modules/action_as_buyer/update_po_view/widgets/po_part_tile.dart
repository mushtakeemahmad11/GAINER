import 'package:flutter/material.dart';
import 'package:gainer/gainer_app/modules/action_as_buyer/update_po_view/update_po_controller.dart';
import 'package:gainer/gainer_app/modules/action_as_buyer/update_po_view/widgets/po_details_card.dart';
import 'package:gainer/gainer_app/modules/action_as_buyer/update_po_view/widgets/po_expansion_tile_header.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/gainer_color.dart';
import '../models/grouped_part_model.dart';

class PoPartTile extends StatelessWidget {
  final UpdatePoPartModel group;
  const PoPartTile({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<UpdatePoController>();
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: ExpansionTile(
          // showTrailingIcon: false,
          tilePadding: const EdgeInsets.symmetric(horizontal: 10),
          backgroundColor: GainerColors.lightWhite,
          collapsedBackgroundColor: GainerColors.lightWhite,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          collapsedShape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          title: PoExpansionTileHeader(
            title1: 'Pending Since',
            title2: group.items[0].dealerName,
            title3: 'Total Price',
          ),
          // subtitle: PoExpansionTileHeader(
          //   // title1: group.items[0].requestDate
          //   //     .replaceAll(RegExp(r'\s+'), ' ')
          //   //     .trim(),
          //   title1: _formatDate(group.items[0].requestDate),
          //   title2: group.items[0].sellerLocation,
          //   title3:
          //       group.items[0].price.toInt().toString(), // need to total pay
          // ),
          children: [
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: group.items.length,
              separatorBuilder: (_, __) =>
                  const Divider(height: 1, color: Colors.black38),
              itemBuilder: (_, index) {
                final item = group.items[index];

                return PoDetailsCard(
                  isPart: false,
                  order: item,
                  onRemove: () {
                    // c.deletePart(item.bigId.toString());
                    // if (c.odrDltResMsg.value != null) {
                    //   GainerDialog.midPopUp(GainerImages.deleteIcon,
                    //       c.odrDltResMsg.value ?? "Part Request Deleted");
                    // } else {
                    //   GainerBottomSheet.showSnackBar(
                    //     context,
                    //     c.odrDltErrorMsg.value ?? "There is a problem......!",
                    //   );
                    // }
                  },
                  // onRemove: () {
                  // if (odrDltResMsg.value != null) {
                  //   AppDialog.midPopUp(AppImages.delete,
                  //       odrDltResMsg.value ?? "Part Request Deleted");
                  // } else {
                  //   CustomBottomSheet.showSnackBar(context,
                  //       odrDltErrorMsg.value ?? "There is some Problem");
                  // }
                  // },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

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
