import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:gainer/gainer_app/modules/app_switcher_view/app_switcher_controller.dart';
import 'package:gainer/gainer_app/modules/navbar/home_view/home_controller.dart';
import 'package:get/get.dart';
import 'dart:developer';
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
      // items: controller.locationDataList.map((item) => item.location).toList(),
      items: controller.locationIdMap.keys.toList(),
      initialItem: controller.locationIdMap.keys.first,
      onChanged: (value) {
        log('changing value to: $value');
        // controller.locationIdMap.map((location)=>location)
        //
        // c.onChangeLocation(locationId);
      },
      closedHeaderPadding: EdgeInsets.all(10),
      // closedHeaderPadding: EdgeInsets.symmetric(vertical: 5,horizontal: 8),
      decoration: CustomDropdownDecoration(
        closedBorder: BoxBorder.all(color: GainerColors.border),
        closedSuffixIcon: Icon(
          Icons.arrow_drop_down_sharp,
          color: Colors.black54,
        ),
      ),
    );
  }
}
