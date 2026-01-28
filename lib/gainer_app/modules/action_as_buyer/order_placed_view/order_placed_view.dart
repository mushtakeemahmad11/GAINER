import 'package:flutter/material.dart';
import 'package:gainer/gainer_app/core/utils/input_formatters.dart';
import 'package:gainer/gainer_app/core/widgets/error_text.dart';
import 'package:gainer/gainer_app/core/widgets/expansion_tile_skeleton.dart';
import 'package:gainer/gainer_app/core/widgets/gainer_app_bar.dart';
import 'package:gainer/gainer_app/core/widgets/gainer_app_loader.dart';
import 'package:gainer/gainer_app/core/widgets/gainer_text_form_field.dart';
import 'package:gainer/gainer_app/modules/action_as_buyer/order_placed_view/widgets/part_group_tile.dart';
import 'package:gainer/gainer_app/modules/action_as_buyer/order_placed_view/widgets/seller_group_tile.dart';
import 'package:gainer/gainer_app/modules/action_as_buyer/order_placed_view/widgets/sort_filter/bottom_sort_filter_bar.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../core/constants/gainer_color.dart';
import 'order_placed_controller.dart';

class OrderPlacedView extends GetView<OrderPlacedController> {
  const OrderPlacedView({super.key});

  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: GainerColors.background,
      // appBar: AppBar(
      //   backgroundColor: GainerColors.primary,
      //   title: Text('Order Placed'),
      //   titleTextStyle: TextStyle(fontSize: 16),
      //   actions: [ScsCircleIcon()],
      // ),
      appBar: GainerAppBar(title: 'Order Placed'),
      bottomNavigationBar: BottomSortFilterBar(),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
              child: Column(
                children: [
                  _searchBar(),
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
                          return AppErrorText(error: err);
                        }
                        if (controller.filteredList.isEmpty) {
                          return const Center(child: Text("No Orders Found"));
                        }
                        if (controller.groupType.value == GroupType.part) {
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
        hint: 'Search by part number\\Dealer name',
        controller: controller.searchController,
        inputFormatters: [GainerInputFormatters.alphaNumericWithSpace],
        onChanged: (value) => controller.onSearch(value),
        suffixIcon: IconButton(
            onPressed: controller.clearSearchBar, icon: Icon(Icons.clear)),
      ),
    );
  }
}
