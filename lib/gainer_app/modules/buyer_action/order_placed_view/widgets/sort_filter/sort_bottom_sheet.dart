import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../order_placed_controller.dart';

void showSortBottomSheet(BuildContext context) {
  final controller = Get.find<OrderPlacedController>();

  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (_) {
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
                  _SortTile(
                    title: "Part wise",
                    selected: controller.groupType.value == GroupType.part,
                    onTap: () {
                      controller.updateGrouping(GroupType.part);
                      Get.back();
                    },
                  ),
                  _SortTile(
                    title: "Seller wise",
                    selected: controller.groupType.value == GroupType.seller,
                    onTap: () {
                      controller.updateGrouping(GroupType.seller);
                      Get.back();
                    },
                  ),
                ],
              )),
        ],
      );
    },
  );
}

class _SortTile extends StatelessWidget {
  final String title;
  final bool selected;
  final VoidCallback onTap;

  const _SortTile({
    required this.title,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        selected ? Icons.check : null,
        color: Colors.green,
      ),
      title: Text(title),
      onTap: onTap,
    );
  }
}
