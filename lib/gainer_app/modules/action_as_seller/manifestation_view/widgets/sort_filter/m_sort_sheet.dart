import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/widgets/gainer_sort_tile.dart';
import '../../controllers/manifestation_controller.dart';

class MSortSheet extends GetView<ManifestationController> {
  const MSortSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
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
          Obx(
            () => Column(
              children: [
                SortTile(
                  title: "Part wise",
                  selected: controller.groupType.value == MGroupType.part,
                  onTap: () {
                    controller.updateGrouping(MGroupType.part);
                    Get.back();
                  },
                ),
                SortTile(
                  title: "Buyer wise",
                  selected: controller.groupType.value == MGroupType.seller,
                  onTap: () {
                    controller.updateGrouping(MGroupType.seller);
                    Get.back();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
