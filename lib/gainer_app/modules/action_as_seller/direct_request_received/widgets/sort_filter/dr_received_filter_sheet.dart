import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/gainer_color.dart';
import '../../dr_received_controller.dart';

class DrReceivedFilterSheet extends GetView<DrReceivedController> {
  const DrReceivedFilterSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// HEADER
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const Text('Filters',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const Spacer(),
              TextButton(
                onPressed: controller.cancelFilter,
                child: const Text('Clear All',
                    style: TextStyle(color: Colors.red)),
              )
            ],
          ),
        ),

        const Divider(height: 1),

        /// BODY
        _rightFilterContent(),
        // Expanded(
        //   child: Row(
        //     children: [
        //       _leftMenu(),
        //       _rightFilterContent(),
        //     ],
        //   ),
        // ),

        /// FOOTER
        Container(
          height: 50,
          decoration: BoxDecoration(
            // border: Border(top: BorderSide(color: Colors.grey.shade300)),
            border: Border.all(color: Colors.grey.shade300),
            color: GainerColors.lightWhite,
          ),
          child: Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: Get.back,
                  child: SizedBox.expand(
                    child: Center(child: Text("Close")),
                  ),
                ),
              ),
              VerticalDivider(width: 1),
              Expanded(
                child: InkWell(
                  onTap: () => Get.back(result: true),
                  child: SizedBox.expand(
                    child: Center(
                        child: Text(
                      "Apply",
                      style: TextStyle(color: GainerColors.error),
                    )),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// LEFT SIDE MENU
  // Widget _leftMenu() {
  //   return Container(
  //     // width: 120,
  //     width: 100,
  //     color: Colors.grey.shade200,
  //     child: Column(
  //       children: [
  //         _menuButton('All'),
  //         _menuButton('Vehicle'),
  //         _menuButton('Stock'),
  //       ],
  //     ),
  //   );
  // }

  // Widget _menuButton(String title) {
  //   return Obx(() {
  //     final isSelected = controller.tempSelectedOrderType.value == title;
  //     return GestureDetector(
  //       onTap: () => controller.tempSelectedOrderType.value = title,
  //       child: Container(
  //         padding: const EdgeInsets.all(12),
  //         width: double.infinity,
  //         color: isSelected ? GainerColors.primary : Colors.transparent,
  //         child: Text(
  //           title,
  //           textAlign: TextAlign.center,
  //           style: TextStyle(color: isSelected ? Colors.white : null),
  //         ),
  //       ),
  //     );
  //   });
  // }

  /// RIGHT SIDE FILTER LIST
  Widget _checkBoxSection({
    required String title,
    required List<Widget> children,
  }) {
    if (children.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(12),
        child: Text('No data available'),
      );
    } else {
      bool isFiltered = _checkFiltered(title);
      return ExpansionTile(
        shape: RoundedRectangleBorder(),
        collapsedBackgroundColor: isFiltered ? GainerColors.filtered : null,
        backgroundColor: isFiltered ? GainerColors.filtered : null,
        title: Text(title),
        // children: children,
        children: [
          Container(
            color: Colors.white,
            child: Column(
              children: children,
            ),
          )
        ],
      );
    }
  }

  bool _checkFiltered(String title) {
    switch (title) {
      case 'Dealer':
        return controller.tempDealers.isNotEmpty;
      case 'Location':
        return controller.tempLocations.isNotEmpty;
      case 'Part No':
        return controller.tempPartNos.isNotEmpty;

      default:
        return false;
    }
  }

  Widget _simpleFilterSection(
    String title,
    RxSet<String> data,
    RxSet<String> selected,
    void Function(String value) onToggle,
  ) {
    return _checkBoxSection(
      title: title,
      children: data.map((item) {
        return CheckboxListTile(
          activeColor: GainerColors.primary,
          value: selected.contains(item),
          title: Text(item),
          onChanged: (_) => onToggle(item),
        );
      }).toList(),
    );
  }

  Widget _partFilterSection(
    String title,
    RxMap<String, String> data,
    RxSet<String> selected,
  ) {
    return _checkBoxSection(
      title: title,
      children: data.entries.map((entry) {
        return CheckboxListTile(
          activeColor: GainerColors.primary,
          value: selected.contains(entry.key),
          title: Text(entry.key),
          subtitle: Text(
            entry.value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          onChanged: (_) => controller.togglePart(entry.key),
        );
      }).toList(),
    );
  }

  /// RIGHT SIDE FILTER LIST
  Widget _rightFilterContent() {
    return Expanded(
      child: Obx(() {
        return ListView(
          children: [
            _simpleFilterSection(
              'Dealer',
              controller.dealers,
              // controller.selectedDealers,
              controller.tempDealers,
              controller.toggleDealer,
            ),
            _simpleFilterSection(
              'Location',
              controller.locations,
              controller.tempLocations,
              // controller.selectedLocations,
              controller.toggleLocation,
            ),
            _partFilterSection(
              'Part No',
              controller.partNdDesc,
              controller.tempPartNos,
            ),
          ],
        );
      }),
    );
  }
}
