import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/widgets/gainer_sort_tile.dart';
import '../../order_received_controller.dart';

class ORSortSheet extends GetView<OrderReceivedController> {
  const ORSortSheet({super.key});

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
                    selected: controller.groupType.value == ORGroupType.part,
                    onTap: () {
                      controller.updateGrouping(ORGroupType.part);
                      Get.back();
                    },
                  ),
                  SortTile(
                    title: "Buyer wise",
                    selected: controller.groupType.value == ORGroupType.seller,
                    onTap: () {
                      controller.updateGrouping(ORGroupType.seller);
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
//
// void showSortBottomSheet(BuildContext context) {
//   final c = Get.find<OrderReceivedController>();
//
//   showModalBottomSheet(
//     context: context,
//     shape: const RoundedRectangleBorder(
//       borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
//     ),
//     builder: (_) {
//       return SafeArea(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             /// Header
//             Padding(
//               padding: const EdgeInsets.all(16),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   const Text(
//                     "SORT BY",
//                     style: TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                   GestureDetector(
//                     onTap: () => Get.back(),
//                     child: const Text("Close"),
//                   )
//                 ],
//               ),
//             ),
//
//             const Divider(),
//
//             /// Options
//             Obx(() => Column(
//                   children: [
//                     SortTile(
//                       title: "Part wise",
//                       selected: c.groupType.value == ORGroupType.part,
//                       onTap: () {
//                         c.updateGrouping(ORGroupType.part);
//                         Get.back();
//                       },
//                     ),
//                     SortTile(
//                       title: "Seller wise",
//                       selected: c.groupType.value == ORGroupType.seller,
//                       onTap: () {
//                         c.updateGrouping(ORGroupType.seller);
//                         Get.back();
//                       },
//                     ),
//                   ],
//                 )),
//           ],
//         ),
//       );
//     },
//   );
//
// }
