import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:gainer/gainer_app/modules/bottom_navbar/home_view/home_controller.dart';
import 'package:get/get.dart';
import '../../../../../app_switcher_view/app_switcher_controller.dart';
import '../../../../core/constants/gainer_color.dart';


class LocationDropdown extends StatelessWidget {
  final HomeController c;
  const LocationDropdown({super.key, required this.c});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AppSwitcherController>();
    return CustomDropdown<String>(
      // hintText: 'Select Location',
      // items: _list,
      // initialItem: _list[0],
      items: controller.locationIdMap.keys.toList(),
      // initialItem: controller.selectedLocation.value,
      initialItem: controller.locationIdMap.keys
          .toList()
          .contains(controller.selectedLocation.value)
          ? controller.selectedLocation.value
          : null,
      onChanged: (value) => c.onChangeLocation(value),
      closedHeaderPadding: EdgeInsets.all(10),
      // closedHeaderPadding: EdgeInsets.symmetric(vertical: 5,horizontal: 8),
      decoration: CustomDropdownDecoration(
        headerStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        listItemStyle: TextStyle(fontSize: 14),
        // closedFillColor: Colors.white38,
        expandedFillColor: GainerColors.background,
        expandedSuffixIcon: Icon(
          Icons.arrow_drop_down_sharp,
          color: Colors.black54,
        ),

// closedBorder: BoxBorder.all(color: GainerColors.border),
        closedBorderRadius: BorderRadius.circular(10),
        closedSuffixIcon: Icon(
          Icons.arrow_drop_down_sharp,
          color: Colors.black54,
        ),
      ),
    );
  }
}


//
// class LocationDropdown extends StatelessWidget {
//   final HomeController c;
//   const LocationDropdown({super.key, required this.c});
//
//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.find<AppSwitcherController>();
//     return CustomDropdown<String>(
//       // hintText: 'Select Location',
//       // items: _list,
//       // initialItem: _list[0],
//       items: controller.locationIdMap.keys.toList(),
//       initialItem: controller.selectedLocation.value,
//       onChanged: (value) {
//         // if (value == null) return;
//         // controller.selectedLocation.value = value;
//         c.onChangeLocation(value);
//       },
//       closedHeaderPadding: EdgeInsets.all(10),
//       // closedHeaderPadding: EdgeInsets.symmetric(vertical: 5,horizontal: 8),
//       decoration: CustomDropdownDecoration(
//         closedBorder: BoxBorder.all(color: GainerColors.border),
//         closedSuffixIcon: Icon(
//           Icons.arrow_drop_down_sharp,
//           color: Colors.black54,
//         ),
//       ),
//     );
//   }
// }
//
// class LocationDropdownTest extends StatelessWidget {
//   final HomeController c;
//   const LocationDropdownTest({super.key, required this.c});
//
//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.find<AppSwitcherController>();
//     Size size = MediaQuery.of(context).size;
//     return CustomDropdown<String>(
//       items: controller.locationIdMap.keys.toList(),
//       initialItem: controller.selectedLocation.value,
//       onChanged: (value) {
//         // if (value == null) return;
//         // controller.selectedLocation.value = value;
//         c.onChangeLocation(value);
//       },
//       closedHeaderPadding: EdgeInsets.all(10),
//       // closedHeaderPadding: EdgeInsets.symmetric(vertical: 5,horizontal: 8),
//       decoration: CustomDropdownDecoration(
//         closedFillColor: GainerColors.primary,
//         expandedFillColor: GainerColors.primary,
//         expandedSuffixIcon: Icon(
//           Icons.arrow_drop_down_sharp,
//           color: Colors.black54,
//         ),
//
//         // closedBorder: BoxBorder.all(color: GainerColors.border),
//         closedSuffixIcon: Icon(
//           Icons.arrow_drop_down_sharp,
//           color: Colors.black54,
//         ),
//       ),
//     );
//   }
// }

