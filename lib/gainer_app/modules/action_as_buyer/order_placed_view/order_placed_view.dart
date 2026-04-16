import 'package:flutter/material.dart';
import 'package:gainer/gainer_app/core/utils/input_formatters.dart';
import 'package:gainer/gainer_app/core/widgets/error_text.dart';
import 'package:gainer/gainer_app/core/widgets/expansion_tile_skeleton.dart';
import 'package:gainer/gainer_app/core/widgets/gainer_app_bar.dart';
import 'package:gainer/gainer_app/core/widgets/gainer_app_loader.dart';
import 'package:gainer/gainer_app/core/widgets/gainer_text_form_field.dart';
import 'package:gainer/gainer_app/modules/action_as_buyer/order_placed_view/widgets/part_group_tile.dart';
import 'package:gainer/gainer_app/modules/action_as_buyer/order_placed_view/widgets/seller_group_tile.dart';
import 'package:gainer/gainer_app/modules/action_as_buyer/order_placed_view/widgets/sort_filter/or_sort_filter_row.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'order_placed_controller.dart';

class OrderPlacedView extends GetView<OrderPlacedController> {
  const OrderPlacedView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GainerAppBar(title: 'Order Placed'),
      bottomNavigationBar: Obx(() => controller.orderPlacedList.isNotEmpty
          ? SafeArea(child: const OPSortFilterRow())
          : const SizedBox.shrink()),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
              child: Column(
                children: [
                  Obx(() => controller.orderPlacedList.isNotEmpty
                      ? _searchBar()
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
                        if (controller.groupType.value == OPGroupType.part) {
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: controller.partGroups.length,
                            itemBuilder: (_, index) {
                              return PartGroupTile(
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
                            return SellerGroupTile(
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
            GainerAppLoader(isLoading: controller.dltIsLoading),
          ],
        ),
      ),
    );
  }

  Widget _searchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: GainerTextFormField(
        hint: 'Search by Part Number\\Dealer Name',
        controller: controller.searchController,
        inputFormatters: [GainerInputFormatters.alphaNumericWithSpace],
        onChanged: (value) => controller.onSearch(value),
        prefixIcon: Icon(Icons.search),
        suffixIcon: Obx(
          () => controller.searchText.value.isNotEmpty
              ? IconButton(
                  onPressed: controller.clearSearchBar, icon: Icon(Icons.clear))
              : SizedBox.shrink(),
        ),
      ),
    );
  }
}
