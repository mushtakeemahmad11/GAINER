import 'package:flutter/material.dart';
import 'package:gainer/gainer/controllers/notification_controller.dart';
import 'package:gainer/gainer_app/core/Services/auth_service.dart';
import 'package:gainer/gainer_app/core/constants/gainer_image.dart';
import 'package:get/get.dart';
import '../../../gainer/screens/notification_screen.dart';
import '../../core/constants/gainer_color.dart';
import 'gainer_main_controller.dart';

class GainerMainView extends GetView<GainerMainController> {
  const GainerMainView({super.key});

  @override
  Widget build(BuildContext context) {
    final nc = Get.find<NotificationController>();
    // Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: GainerColors.background,
      appBar: AppBar(
        backgroundColor: GainerColors.primary,
        automaticallyImplyLeading: false,
        title: const Text('Home'),
        actions: [
          Obx(() {
            final unseenCount =
                nc.notifications.where((n) => n.isSeen == false).length;
            return Badge(
              offset: Offset(2, 1),
              isLabelVisible: unseenCount < 1 ? false : true,
              label: Text(
                unseenCount.toString(),
                style: TextStyle(
                  fontSize: 12, // ↓ smaller font size
                ),
              ),
              largeSize: 25,
              child: IconButton(
                  onPressed: () async {
                    final locationId = await AuthService.getLocationId();
                    // String selectedLocationID = '';
                    // await getStringData("selectedLocationID");
                    if (locationId.isEmpty) {
                      Get.snackbar('Warning', 'problem in fetch location',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: GainerColors.primary,
                          colorText: GainerColors.white);
                    } else {
                      Get.to(() => NotificationScreen(
                            selectedLocationID: locationId,
                          ));
                    }
                  },
                  icon: Icon(Icons.notifications)),
            );
          }),
          // // const Icon(Icons.notifications),
          // IconButton(onPressed: () {}, icon: Icon(Icons.notifications)),
          // const SizedBox(width: 12),
          // Icon(Icons.settings),
          GestureDetector(
              onTap: () {
                if (controller.currentIndex.value != 0) {
                  controller.currentIndex.value = 0;
                }
              },
              child: Image.asset(GainerImages.scsCircle, height: 30)),
          const SizedBox(width: 12),
        ],
      ),
      body: Obx(
        () => IndexedStack(
          index: controller.currentIndex.value,
          children: controller.pages,
        ),
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: controller.currentIndex.value,
          onTap: controller.changeTab,
          items: controller.items,
          type: BottomNavigationBarType.fixed,
        ),
      ),
    );
  }
}
