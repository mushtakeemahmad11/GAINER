import 'package:flutter/material.dart';
import 'package:gainer/gainer_app/modules/action_as_buyer/order_placed_view/widgets/expansion_tile_header.dart';
import 'package:gainer/gainer_app/modules/action_as_buyer/order_placed_view/widgets/details_card.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import '../../../../core/constants/gainer_color.dart';
import '../../../../core/constants/gainer_image.dart';
import '../../../../core/widgets/gainer_bottom_sheet.dart';
import '../../../../core/widgets/gainer_dialog.dart';
import '../models/grouped_part_model.dart';
import '../order_placed_controller.dart';

class PartGroupTile extends StatelessWidget {
  final GroupedPartModel group;
  // final VoidCallback onRemove;
  const PartGroupTile({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<OrderPlacedController>();
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
          title: ExpansionTileHeader(
            title1: group.partNumber,
            title2: group.partDesc,
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
                print(item.partNumber);
                print(item.partDesc);

                return DetailsCard(
                  isPart: false,
                  order: item,
                  onRemove: () {
                    c.deletePart(item.bigId.toString());
                    if (c.odrDltResMsg.value != null) {
                      GainerDialog.midPopUp(GainerImages.deleteIcon,
                          c.odrDltResMsg.value ?? "Part Request Deleted");
                    } else {
                      GainerBottomSheet.showSnackBar(
                        context,
                        c.odrDltErrorMsg.value ?? "There is a problem......!",
                      );
                    }
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
}
