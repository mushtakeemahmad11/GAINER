import 'package:flutter/material.dart';
import 'package:gainer/gainer_app/core/widgets/expansion_tile_skeleton.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../core/constants/gainer_color.dart';
import '../../../../core/widgets/error_text.dart';
import '../../../../core/widgets/gainer_app_bar.dart';
import '../controllers/manifestation_controller.dart';
import '../widgets/m_part_tile.dart';
import '../widgets/m_seller_tile.dart';
import '../widgets/search_bar.dart';
import '../widgets/sort_filter/m_sort_filter_row.dart';

class ManifestationView extends GetView<ManifestationController> {
  const ManifestationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: GainerColors.background,
      appBar: GainerAppBar(title: 'Manifestation'),
      bottomNavigationBar: Obx(() => controller.manifestationList.isNotEmpty
          ? SafeArea(child: const MSortFilterRow())
          : const SizedBox.shrink()),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
        child: Column(
          children: [
            Obx(() => controller.manifestationList.isNotEmpty
                ? const MSearchBar()
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

                  if (controller.groupType.value == MGroupType.part) {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.partGroups.length,
                      itemBuilder: (_, index) {
                        return MPartTile(
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
                      return MSellerTile(
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
      floatingActionButton: Obx(() {
        final order = controller.selectedOrders;
        if (order.isNotEmpty) {
          return ActionChip(
            backgroundColor: GainerColors.primary,
            labelStyle: TextStyle(color: Colors.white),
            label: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Manifestation'),
                SizedBox(width: 5),
                Icon(
                  Icons.arrow_forward_ios_outlined,
                  size: 12,
                )
              ],
            ),
            onPressed: () => controller.proceedToManifestation(context),
          );
        }
        return SizedBox.shrink();
      }),
    );
  }
}
