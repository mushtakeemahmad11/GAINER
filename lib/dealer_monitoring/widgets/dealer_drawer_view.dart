import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../gainer_app/core/widgets/profile_circle.dart';
import '../controllers/dm_main_controller.dart';
import '../core/theme/app_colors.dart';
import '../core/utils/dm_images.dart';
import 'dm_list_tile.dart';

class DealerDrawerView extends GetView<DMMainController> {
  const DealerDrawerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: DMAppColors.secondary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DrawerHeader(
            child: Center(
              child: Obx(
                () => ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: ProfileCircle(
                    size: 55,
                    pickedImg: controller.pickedProfileImg.value,
                    apiImg: controller.profileImage.value,
                  ),
                  title: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text(
                      controller.name.value,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  subtitle: Text(
                    controller.userRole.value,
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: _drawerItems(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _drawerItems() {
    return [
      _drawerTile(DMImages.partStockCheck, "Part Stock Check", 0),
      _drawerTile(DMImages.gLogoW, "Gainer Stock Check", 1),
      _drawerTile(DMImages.substitutionCheck, "Substitution Check", 2),
      _drawerTile(DMImages.ppniList, "PPNI List", 3),
      _drawerTile(DMImages.vehicleSearch, "Vehicle Search", 4),
      _drawerTile(DMImages.saleTrend, "Sale Trend", 5),
      _drawerTile(DMImages.orderInfo, "Order info", 6),
      _drawerTile(DMImages.scsNorms, "SCS Norms", 7),
      // _drawerTile(ConstantImages.gainerListening, "My Gainer Listing", 9),
    ];
  }

  Widget _drawerTile(String imageUrl, String title, int index) {
    return DmListTile(
      url: imageUrl,
      title: title,
      onTap: () {
        Get.back();
        controller.goto(title, index);
      },
    );
  }
}
