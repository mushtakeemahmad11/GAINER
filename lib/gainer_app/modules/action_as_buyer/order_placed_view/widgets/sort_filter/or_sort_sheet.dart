import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/widgets/gainer_sort_tile.dart';
import '../../order_placed_controller.dart';

class OPSortSheet extends GetView<OrderPlacedController> {
  const OPSortSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        /// Header
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "SORT BY",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                onTap: () => Get.back(),
                child: const Text("Close"),
              )
            ],
          ),
        ),

        const Divider(),

        /// Options
        Obx(() => Column(
              children: [
                SortTile(
                  title: "Part wise",
                  selected: controller.groupType.value == OPGroupType.part,
                  onTap: () {
                    controller.updateGrouping(OPGroupType.part);
                    Get.back();
                  },
                ),
                SortTile(
                  title: "Seller wise",
                  selected: controller.groupType.value == OPGroupType.seller,
                  onTap: () {
                    controller.updateGrouping(OPGroupType.seller);
                    Get.back();
                  },
                ),
              ],
            )),
      ],
    );
  }
}
