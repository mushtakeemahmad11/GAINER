import 'package:flutter/material.dart';
import 'package:gainer/gainer_app/core/widgets/gainer_app_bar.dart';
import 'package:gainer/gainer_app/modules/action_as_seller/dispatched_details_view/models/dd_model.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../core/widgets/error_text.dart';
import '../../../core/widgets/expansion_tile_skeleton.dart';
import 'dispatched_details_controller.dart';
import 'widgets/dd_expansion_tile.dart';
import 'widgets/search_bar.dart';

class DDView extends GetView<DDController> {
  const DDView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GainerAppBar(title: 'Dispatch Details'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
        child: Column(
          children: [
            Obx(() => controller.ddList.isNotEmpty
                ? const DDSearchBar()
                : const SizedBox.shrink()),
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
                  if (controller.groupedList.isEmpty) {
                    return const Center(child: Text("No Orders Found"));
                  }

                  final groupData = controller.groupedList;

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: groupData.length,
                    itemBuilder: (_, index) {
                      final data = groupData[index];
                      final order = data['data'] as DDModel;
                      final count = data['count'] as int;
                      controller.initImages(order, count);
                      return DDExpansionTile(order: order, count: count,index:index);
                    },
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:gainer/gainer_app/core/widgets/expansion_tile_skeleton.dart';
// import 'package:gainer/gainer_app/modules/action_as_seller/dispatched_details_view/widgets/dd_details_card.dart';
// import 'package:get/get.dart';
// import 'package:skeletonizer/skeletonizer.dart';
// import '../../../core/constants/gainer_color.dart';
// import '../../../core/widgets/error_text.dart';
// import '../../../core/widgets/gainer_app_bar.dart';
// import 'dispatched_details_controller.dart';
// import 'widgets/dd_part_tile.dart';
// import 'widgets/dd_expansion_tile.dart';
// import 'widgets/search_bar.dart';
// import 'widgets/sort_filter/dd_sort_filter_row.dart';
//
// class DDView extends GetView<DDController> {
//   const DDView({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: GainerAppBar(title: 'Manifestation'),
//       // bottomNavigationBar: Obx(() => controller.ddList.isNotEmpty
//       //     ? SafeArea(child: const DDSortFilterRow())
//       //     : const SizedBox.shrink()),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
//         child: Column(
//           children: [
//             Obx(() => controller.ddList.isNotEmpty
//                 ? const DDSearchBar()
//                 : const SizedBox.shrink()),
//             Expanded(
//               child: SingleChildScrollView(
//                 child: Obx(() {
//                   if (controller.isLoading.value) {
//                     return Skeletonizer(
//                       child: ListView.builder(
//                         shrinkWrap: true,
//                         physics: const NeverScrollableScrollPhysics(),
//                         itemCount: 5,
//                         itemBuilder: (_, index) {
//                           return ExpansionTileSkeleton();
//                         },
//                       ),
//                     );
//                   }
//                   final err = controller.errorMsg;
//                   if (err.value != null && err.value!.isNotEmpty) {
//                     return Center(child: AppErrorText(error: err));
//                   }
//                   if (controller.filteredList.isEmpty) {
//                     return const Center(child: Text("No Orders Found"));
//                   }
//
//
//                   // if (controller.groupType.value == DDGroupType.part) {
//                   //   return ListView.builder(
//                   //     shrinkWrap: true,
//                   //     physics: const NeverScrollableScrollPhysics(),
//                   //     itemCount: controller.partGroups.length,
//                   //     itemBuilder: (_, index) {
//                   //       return DDPartTile(
//                   //         group: controller.partGroups[index],
//                   //       );
//                   //     },
//                   //   );
//                   // }
//                   return ListView.builder(
//                     shrinkWrap: true,
//                     physics: const NeverScrollableScrollPhysics(),
//                     itemCount: controller.sellerGroups.length,
//                     itemBuilder: (_, index) {
//                       return DDSellerTile(
//                         group: controller.sellerGroups[index],
//                       );
//                     },
//                   );
//                 }),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
