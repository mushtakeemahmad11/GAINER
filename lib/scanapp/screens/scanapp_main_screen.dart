import 'package:gainer/scanapp/screens/user_profile_creation/user_profile_creation_screen.dart';

import '../../main.dart';
import 'package:flutter/material.dart';
import 'package:gainer/gainer/widget/dialog.dart';
import 'package:gainer/scanapp/core/utils/scanapp_constant_image.dart';
import 'package:gainer/scanapp/screens/pi_audit/pi_audit_screen.dart';
import 'package:gainer/scanapp/screens/scanapp_home_screen.dart';
import 'package:get/get.dart';
import '../../gainer/screens/bottombar_screen/help_screen.dart';
import '../controllers/scanapp_main_screen_controller.dart';
import '../core/themes/scanapp_colors.dart';
import '../widgets/custom_drawer.dart';
import 'location_audit/location_audit_screen.dart';

class ScanappMainScreen extends StatelessWidget {
  const ScanappMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(ScanappMainScreenController());

    void handleBackPress(bool isTopRoute, dynamic result) async {
      if (c.currentIndex.value != 0) {
        c.changeTab(0);
      } else {
        Navigator.maybePop(context, result);
      }
    }

    final pages = [
      const ScanappHomeScreen(),
      const LocationAuditScreen(),
      const PIAuditScreen(),
      // Scaffold(
      //   appBar: AppBar(
      //     iconTheme: IconThemeData(color: ScanappColors.black),
      //     backgroundColor: ScanappColors.primary,
      //     title: Text(
      //       "Ticket & Help",
      //       style: TextStyle(color: Colors.black),
      //     ),
      //   ),
      //   body: const HelpScreen(),
      // ),
    ];

    return Scaffold(
      appBar: _buildAppBar(c),
      drawer: _buildDrawer(c),
      bottomNavigationBar: _buildBottomBar(c),
      body: Obx(
        () => PopScope(
          canPop: c.currentIndex.value == 0,
          onPopInvokedWithResult: handleBackPress,
          child: pages[c.currentIndex.value],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(ScanappMainScreenController c) {
    return AppBar(
      // elevation: 1,
      backgroundColor: ScanappColors.secondary,
      // backgroundColor: ScanappColors.primary,
      iconTheme: const IconThemeData(color: ScanappColors.black),
      leading: Builder(
        builder: (context) => IconButton(
          icon: const Icon(Icons.menu, size: 30),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
      ),
      title: Obx(() => Text(
            c.name.value ?? "Dealer User",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: ScanappColors.black,
            ),
          )),
      actions: [
        IconButton(
          icon: const Icon(
            Icons.notifications_none,
            color: ScanappColors.black,
          ),
          onPressed: () {
            // Get.to(()=>CustomStepperScreen());
            Get.to(() => UserProfileCreationScreen());
          },
        ),
      ],
    );
  }

  Widget _buildDrawer(ScanappMainScreenController c) {
    return Obx(
      () => CustomDrawer(
        userName: c.name.value,
        imgUrl: c.photo.value,
        drawerColor: ScanappColors.secondary,
        items: List.generate(
          c.titleItems.length,
          (int index) {
            final item = c.titleItems[index];
            return DrawerMenuItem(
              icon: item['icon'] as IconData,
              title: item['title'] as String,
              onTap: () {
                final idx = item['index'] as int;
                if (idx == 6) {
                  Get.to(() => Scaffold(
                        appBar: AppBar(
                          backgroundColor: ScanappColors.secondary,
                          title: const Text("Raise Support Ticket"),
                        ),
                        body: HelpScreen(),
                      ));
                } else {}
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildBottomBar(ScanappMainScreenController c) {
    return BottomAppBar(
      height: 70,
      padding: EdgeInsets.zero,
      color: ScanappColors.secondary,
      // color: ScanappColors.primary,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.home_outlined,
                size: 35, color: ScanappColors.black),
            onPressed: () => c.changeTab(0),
          ),
          SizedBox(
            width: mq.width * .40,
            child: Image.asset(ScanappConstantImage.accuStock),
          ),
          IconButton(
            icon: const Icon(
              Icons.logout_outlined,
              size: 35,
              color: ScanappColors.black,
            ),
            onPressed: () => AppDialog.logoutBtnFunctionality(),
          ),
        ],
      ),
    );
  }
}
