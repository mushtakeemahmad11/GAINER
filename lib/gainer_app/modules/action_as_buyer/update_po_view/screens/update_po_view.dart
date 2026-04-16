import 'package:flutter/material.dart';
import 'package:gainer/gainer_app/core/widgets/expansion_tile_skeleton.dart';
import 'package:gainer/gainer_app/modules/action_as_buyer/update_po_view/update_po_controller.dart';
import 'package:gainer/gainer_app/modules/action_as_buyer/update_po_view/widgets/po_part_tile.dart';
import 'package:gainer/gainer_app/modules/action_as_buyer/update_po_view/widgets/po_seller_tile.dart';
import 'package:gainer/gainer_app/modules/action_as_buyer/update_po_view/widgets/sort_filter/po_sort_filter_row.dart';
import 'package:gainer/gainer_app/modules/action_as_buyer/update_po_view/widgets/search_bar.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../core/constants/gainer_color.dart';
import '../../../../core/widgets/error_text.dart';
import '../../../../core/widgets/gainer_app_bar.dart';

class UpdatePoView extends GetView<UpdatePoController> {
  const UpdatePoView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: GainerColors.background,
      appBar: GainerAppBar(title: 'Update PO Details'),
      bottomNavigationBar: Obx(() => controller.updatePoList.isNotEmpty
          ? SafeArea(child: const PoSortFilterRow())
          : const SizedBox.shrink()),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
        child: Column(
          children: [
            Obx(() => controller.updatePoList.isNotEmpty
                ? const PoSearchBar()
                : const SizedBox.shrink()),
            // if (controller.updatePoList.isNotEmpty) const PoSearchBar(),
            Expanded(
              child: SingleChildScrollView(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return Skeletonizer(
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: 5,
                        itemBuilder: (_, index) {
                          return ExpansionTileSkeleton();
                        },
                      ),
                    );
                  }
                  final err = controller.errorMsg;
                  if (err.value != null && err.value!.isNotEmpty) {
                    return Center(child: AppErrorText(error: err));
                  }
                  if (controller.filteredList.isEmpty) {
                    return const Center(child: Text("No Orders Found"));
                  }

                  if (controller.groupType.value == POGroupType.part) {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.partGroups.length,
                      itemBuilder: (_, index) {
                        return PoPartTile(
                          group: controller.partGroups[index],
                        );
                      },
                    );
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.sellerGroups.length,
                    itemBuilder: (_, index) {
                      return PoSellerTile(
                        group: controller.sellerGroups[index],
                      );
                    },
                  );
                }),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Obx(() {
        if (controller.acceptedOrders.isNotEmpty) {
          return ActionChip(
            backgroundColor: GainerColors.primary,
            labelStyle: TextStyle(color: Colors.white),
            label: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Create PO'),
                SizedBox(width: 5),
                Icon(
                  Icons.arrow_forward_ios_outlined,
                  size: 12,
                )
              ],
            ),
            onPressed: () => controller.createPoScreen(context),
          );
        }
        return SizedBox.shrink();
      }),
    );
  }
}
