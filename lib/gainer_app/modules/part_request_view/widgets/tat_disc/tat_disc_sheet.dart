import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/widgets/gainer_sort_tile.dart';
import '../../part_request_controller.dart';

class TatDiscSheet extends GetView<PartRequestController> {
  const TatDiscSheet({super.key});

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
                  title: "Discount Wise",
                  // selected: controller.groupType.value == OPGroupType.part,
                  selected: controller.isSortDisc.value,
                  onTap: controller.toggleSort,
                ),
                SortTile(
                  title: "TAT wise",
                  // selected: controller.groupType.value == OPGroupType.seller,
                  selected: !controller.isSortDisc.value,
                  onTap: controller.toggleSort,
                ),
              ],
            )),
      ],
    );
  }
}
