import 'package:flutter/material.dart';
import 'package:gainer/gainer_app/core/widgets/expansion_tile_skeleton.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../core/widgets/error_text.dart';
import '../../../../core/widgets/gainer_app_bar.dart';
import '../order_received_controller.dart';
import '../widgets/or_part_tile.dart';
import '../widgets/or_seller_tile.dart';
import '../widgets/search_bar.dart';
import '../widgets/sort_filter/or_sort_filter_row.dart';

class OrderReceivedView extends GetView<OrderReceivedController> {
  const OrderReceivedView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: GainerColors.background,
      appBar: GainerAppBar(title: 'Order Received'),
      bottomNavigationBar: Obx(() => controller.orderReceivedList.isNotEmpty
          ? SafeArea(child: const ORSortFilterRow())
          : const SizedBox.shrink()),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
        child: Column(
          children: [
            Obx(() => controller.orderReceivedList.isNotEmpty
                ? const ORSearchBar()
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
                  if (controller.filteredList.isEmpty) {
                    return const Center(child: Text("No Orders Found"));
                  }

                  if (controller.groupType.value == ORGroupType.part) {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.partGroups.length,
                      itemBuilder: (_, index) {
                        return ORPartTile(
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
                      return ORSellerTile(
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
    );
  }
}
