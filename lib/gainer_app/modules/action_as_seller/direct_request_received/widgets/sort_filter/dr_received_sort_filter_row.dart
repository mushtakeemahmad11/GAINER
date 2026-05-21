

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/constants/gainer_color.dart';
import '../../dr_received_controller.dart';

class DrReceivedSortFilterRow extends GetView<DrReceivedController> {
  const DrReceivedSortFilterRow({super.key});

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
                          // Icon(Icons.circle, color: Colors.red, size: 10),
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
