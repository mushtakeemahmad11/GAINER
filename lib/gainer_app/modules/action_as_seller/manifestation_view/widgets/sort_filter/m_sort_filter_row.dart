import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/constants/gainer_color.dart';
import '../../controllers/manifestation_controller.dart';

class MSortFilterRow extends GetView<ManifestationController> {
  const MSortFilterRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
        // border: Border.all(color: Colors.grey.shade300),
        color: GainerColors.lightWhite,
      ),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              // onTap: () => showSortBottomSheet(context),
              onTap: () => controller.openSortSheet(context),
              child: SizedBox.expand(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.swap_vert,
                      color: Colors.black,
                    ),
                    SizedBox(width: 6),
                    Text("SORT"),
                  ],
                ),
              ),
            ),
          ),
          VerticalDivider(width: 1),
          Expanded(
            child: InkWell(
              onTap: () => controller.onFilterTap(context),
              child: SizedBox.expand(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.filter_alt_outlined,
                      color: Colors.black,
                    ),
                    SizedBox(width: 6),
                    Text("FILTER"),
                    Obx(() {
                      if (controller.isFilterApplied.value) {
                        return Padding(
                          padding:
                              const EdgeInsets.only(bottom: 8.0, left: 8.0),
                              child: IconButton(
                              onPressed: () {
                                controller.cancelFilter();
                                controller.applyFilters();
                              },
                              icon: Icon(
                                Icons.cancel_outlined,
                                color: Colors.red,
                                size: 18,
                              ),
                            )
                            // Icon(Icons.circle, color: Colors.red, size: 10),, size: 10),
                        );
                      }
                      return const SizedBox.shrink();
                    }),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class UpdatePoFilterController extends GetxController {
  // /// Quick Filter
  // RxString selectedOrderType = 'All'.obs;
  //
  // /// Multi-select filters
  // RxSet<String> selectedDealers = <String>{}.obs;
  // RxSet<String> selectedLocations = <String>{}.obs;
  // RxSet<String> selectedPartNos = <String>{}.obs;
  //
  // /// Clear all filters
  // void clearAll() {
  //   selectedOrderType.value = 'All';
  //   selectedDealers.clear();
  //   selectedLocations.clear();
  //   selectedPartNos.clear();
  // }
  //
  // bool isSelected(Set<String> set, String value) {
  //   return set.contains(value);
  // }
  //
  // void toggle(Set<String> set, String value) {
  //   set.contains(value) ? set.remove(value) : set.add(value);
  // }
  //
  // List<UpdatePoModel> applyFilters(
  //     List<UpdatePoModel> allOrders, UpdatePoFilterController filterCtrl) {
  //   return allOrders.where((order) {
  //     /// Quick filter
  //     if (filterCtrl.selectedOrderType.value != 'All' &&
  //         order.orderFor != filterCtrl.selectedOrderType.value) {
  //       return false;
  //     }
  //
  //     if (filterCtrl.selectedDealers.isNotEmpty &&
  //         !filterCtrl.selectedDealers.contains(order.dealerName)) {
  //       return false;
  //     }
  //
  //     if (filterCtrl.selectedLocations.isNotEmpty &&
  //         !filterCtrl.selectedLocations.contains(order.sellerLocation)) {
  //       return false;
  //     }
  //
  //     if (filterCtrl.selectedPartNos.isNotEmpty &&
  //         !filterCtrl.selectedPartNos.contains(order.partNumber)) {
  //       return false;
  //     }
  //
  //     return true;
  //   }).toList();
  // }
  //
  // Future<bool?> openFilterSheet(BuildContext context) {
  //   return Get.bottomSheet<bool>(
  //     SafeArea(
  //       child: Container(
  //         height: MediaQuery.of(context).size.height * .75,
  //         decoration: const BoxDecoration(
  //           color: Colors.white,
  //           borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
  //         ),
  //         child: FilterBottomSheet(),
  //       ),
  //     ),
  //     isScrollControlled: true,
  //   );
  //   showModalBottomSheet(
  //     context: context,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
  //     ),
  //     builder: (_) {
  //       return SafeArea(
  //         child: FilterBottomSheet(),
  //       );
  //     },
  //   );
  // }
  //
  // Future<void> onFilterTap(
  //     BuildContext context, UpdatePoController controller) async {
  //   final applied = await openFilterSheet(context);
  //   if (applied == true) {
  //     filteredList = applyFilters(allOrders, Get.find());
  //     update();
  //   }
  // }
}
