import 'package:flutter/material.dart';
import './part_receipt_controller.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../core/widgets/error_text.dart';
import '../../../core/widgets/expansion_tile_skeleton.dart';
import '../../../core/widgets/gainer_app_bar.dart';
import 'widget/part_receipt_part_tile.dart';
import 'widget/part_receipt_seller_tile.dart';
import 'widget/search_bar.dart';
import 'widget/sort_filter/pr_sort_filter_row.dart';

class PartReceiptView extends GetView<PartReceiptController> {
  const PartReceiptView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: GainerColors.background,
      appBar: GainerAppBar(title: 'Part Receipt'),
      bottomNavigationBar: Obx(() => controller.partReceiptList.isNotEmpty
          ? SafeArea(child: const PrSortFilterRow())
          : const SizedBox.shrink()),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
        child: Column(
          children: [
            Obx(() => controller.partReceiptList.isNotEmpty
                ? const PartReceiptSearchBar()
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

                  if (controller.groupType.value == PRGroupType.part) {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.partGroups.length,
                      itemBuilder: (_, index) {
                        return PartReceiptPartTile(
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
                      return PartReceiptSellerTile(
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
