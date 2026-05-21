import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../core/widgets/error_text.dart';
import '../../../core/widgets/expansion_tile_skeleton.dart';
import '../../../core/widgets/gainer_app_bar.dart';
import 'dr_sent_controller.dart';
import 'widgets/dr_sent_part_tile.dart';
import 'widgets/dr_sent_seller_tile.dart';
import 'widgets/search_bar.dart';
import 'widgets/sort_filter/dr_sent_sort_filter_row.dart';

class DrSentView extends GetView<DrSentController> {
  const DrSentView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GainerAppBar(title: 'Direct Request Sent'),
      bottomNavigationBar: Obx(() => controller.drSentOrderList.isNotEmpty
          ? SafeArea(child: const DrSentSortFilterRow())
          : const SizedBox.shrink()),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
              child: Column(
                children: [
                  Obx(() => controller.drSentOrderList.isNotEmpty
                      ? DrSentSearchBar()
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
                            DrSentGroupType.part) {
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: controller.partGroups.length,
                            itemBuilder: (_, index) {
                              return DrSentPartTile(
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
                            return DrSentSellerTile(
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
