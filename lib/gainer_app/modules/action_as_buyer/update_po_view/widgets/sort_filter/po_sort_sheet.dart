import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/widgets/gainer_sort_tile.dart';
import '../../update_po_controller.dart';

class POSortSheet extends GetView<UpdatePoController> {
  const POSortSheet({super.key});

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
                    selected: controller.groupType.value == POGroupType.part,
                    onTap: () {
                      controller.updateGrouping(POGroupType.part);
                      Get.back();
                    },
                  ),
                  SortTile(
                    title: "Seller wise",
                    selected: controller.groupType.value == POGroupType.seller,
                    onTap: () {
                      controller.updateGrouping(POGroupType.seller);
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

void showSortBottomSheet(BuildContext context) {
  final c = Get.find<UpdatePoController>();

  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (_) {
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
                      selected: c.groupType.value == POGroupType.part,
                      onTap: () {
                        c.updateGrouping(POGroupType.part);
                        Get.back();
                      },
                    ),
                    SortTile(
                      title: "Seller wise",
                      selected: c.groupType.value == POGroupType.seller,
                      onTap: () {
                        c.updateGrouping(POGroupType.seller);
                        Get.back();
                      },
                    ),
                  ],
                )),
          ],
        ),
      );
    },
  );

  // Get.bottomSheet(
  //   Container(
  //     color: Colors.white,
  //
  //     child: Column(
  //       mainAxisSize: MainAxisSize.min,
  //
  //       children: [
  //         ListTile(
  //           title: const Text("Part wise"),
  //           onTap: () {
  //             c.changeSort(SortType.part);
  //             Get.back();
  //           },
  //         ),
  //
  //         ListTile(
  //           title: const Text("Seller wise"),
  //           onTap: () {
  //             c.changeSort(SortType.seller);
  //             Get.back();
  //           },
  //         ),
  //       ],
  //     ),
  //   ),
  // );
}
