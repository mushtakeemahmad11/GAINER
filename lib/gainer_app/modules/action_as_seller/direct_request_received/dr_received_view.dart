import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../core/widgets/error_text.dart';
import '../../../core/widgets/expansion_tile_skeleton.dart';
import '../../../core/widgets/gainer_app_bar.dart';
import 'dr_received_controller.dart';
import 'widgets/dr_received_part_tile.dart';
import 'widgets/dr_received_seller_tile.dart';
import 'widgets/search_bar.dart';
import 'widgets/sort_filter/dr_received_sort_filter_row.dart';

class DrReceivedView extends GetView<DrReceivedController> {
  const DrReceivedView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GainerAppBar(title: 'Direct Request Received'),
      bottomNavigationBar: Obx(() => controller.drReceivedOrderList.isNotEmpty
          ? SafeArea(child: const DrReceivedSortFilterRow())
          : const SizedBox.shrink()),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
              child: Column(
                children: [
                  Obx(() => controller.drReceivedOrderList.isNotEmpty
                      ? DrReceivedSearchBar()
                      : const SizedBox.shrink()),
                  // _searchBar(),
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

                        if (controller.groupType.value ==
                            DrReceivedGroupType.part) {
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: controller.partGroups.length,
                            itemBuilder: (_, index) {
                              return DrReceivedPartTile(
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
                            return DrReceivedSellerTile(
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
          ],
        ),
      ),
    );
  }
}
