import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:gainer/gainer_app/core/widgets/error_text.dart';
import 'package:gainer/gainer_app/core/widgets/expansion_tile_skeleton.dart';
import 'package:gainer/gainer_app/core/widgets/gainer_app_loader.dart';
import 'package:gainer/gainer_app/core/widgets/gainer_text_form_field.dart';
import 'package:gainer/gainer_app/modules/buyer_action/order_placed_view/widgets/part_group_tile.dart';
import 'package:gainer/gainer_app/modules/buyer_action/order_placed_view/widgets/seller_group_tile.dart';
import 'package:gainer/gainer_app/modules/buyer_action/order_placed_view/widgets/sort_filter/bottom_sort_filter_bar.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../gainer/utility/controller_utils.dart';
import '../../../core/constants/gainer_color.dart';
import '../../../core/widgets/scs_circle_icon.dart';
import 'order_placed_controller.dart';

class OrderPlacedView extends GetView<OrderPlacedController> {
  const OrderPlacedView({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: GainerColors.background,
      appBar: AppBar(
        backgroundColor: GainerColors.primary,
        title: Text('Order Placed'),
        titleTextStyle: TextStyle(fontSize: 16),
        actions: [ScsCircleIcon()],
      ),
      bottomNavigationBar: BottomSortFilterBar(),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6.0),
                      child: GainerTextFormField(
                        hint: 'Search by part number',
                        controller: controller.searchController,
                        onChanged: (value) {
                          // String filteredValue = await ControllerUtils.partNumberValidation(value);
                          String filteredValue = value
                              .replaceAll(RegExp(r'[^a-zA-Z0-9-/]'), '')
                              .toUpperCase();
                          controller.searchController.text = filteredValue;
                          controller.onSearch(filteredValue);
                        },
                        suffixIcon: IconButton(
                            onPressed: () {}, icon: Icon(Icons.search)),
                      ),
                    ),
                    Obx(() {
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
                      if (controller.orderPlacedList.isNotEmpty) {
                        if (controller.groupType.value == GroupType.part) {
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: controller.partGroups.length,
                            itemBuilder: (_, index) {
                              return PartGroupTile(
                                group: controller.partGroups[index],
                                // onRemove: () {
                                //   controller.odrDltResMsg.value =
                                //       'from error delete mesg';
                                //   if (controller.odrDltResMsg.value != null) {
                                //     GainerDialog.midPopUp(
                                //         GainerImages.deleteIcon,
                                //         controller.odrDltResMsg.value ??
                                //             "Part Request Deleted");
                                //   } else {
                                //     GainerBottomSheet.showSnackBar(
                                //         context,
                                //         controller.odrDltErrorMsg.value ??
                                //             "There is a problem......!");
                                //   }
                                // },
                              );
                            },
                          );
                        } else {
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
                        }
                      } else {
                        return Text("There is some problem");
                      }
                    }),
                  ],
                ),
              ),
            ),
            GainerAppLoader(isLoading: controller.dltIsLoading),
          ],
        ),
      ),
    );
  }
}
