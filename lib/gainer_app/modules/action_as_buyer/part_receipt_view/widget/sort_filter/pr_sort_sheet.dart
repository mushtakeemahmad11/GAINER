import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

import '../../../../../core/widgets/gainer_sort_tile.dart';
import '../../part_receipt_controller.dart';

class PRSortSheet extends GetView<PartReceiptController> {
  const PRSortSheet({super.key});

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
          Obx(() => Column(
                children: [
                  SortTile(
                    title: "Part wise",
                    selected: controller.groupType.value == PRGroupType.part,
                    onTap: () {
                      controller.updateGrouping(PRGroupType.part);
                      Get.back();
                    },
                  ),
                  SortTile(
                    title: "Seller wise",
                    selected: controller.groupType.value == PRGroupType.seller,
                    onTap: () {
                      controller.updateGrouping(PRGroupType.seller);
                      Get.back();
                    },
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
