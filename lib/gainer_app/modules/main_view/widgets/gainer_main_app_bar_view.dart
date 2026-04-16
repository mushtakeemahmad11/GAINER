import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import '../../../core/constants/gainer_color.dart';
import '../../../routes/app_routes.dart';
import '../../bottom_navbar/home_view/home_controller.dart';
import '../gainer_main_controller.dart';

class GainerMainAppBarView extends GetView<GainerMainController>
    implements PreferredSizeWidget {
  const GainerMainAppBarView({super.key});

  @override
  Widget build(BuildContext context) {
    // final nc = Get.find<NotificationController>();
    // final hc = Get.find<HomeController>();

    return AppBar(
      iconTheme: IconThemeData(color: Colors.black54),
      // titleTextStyle: TextStyle(color: Colors.black54),
      backgroundColor: GainerColors.primary,
      titleSpacing: 0,
      // centerTitle: true,
      title: Obx(() {
        int index = controller.currentIndex.value;
        // if (index == 0) return TextDropdown();
        /// SCS Logo
        if (index == 0) {
          return Text(
            'Sparecare Gainer',
            style: TextStyle(color: Colors.black54),
          );
          // return Image.asset(AppImages.scsBlackLinear, height: 50);
        }
        return Text(
          controller.navItems[index].label,
          style: TextStyle(color: Colors.black54),
        );
      }),

      // title: Obx(
      //     () => Text(controller.navItems[controller.currentIndex.value].label)),
      actions: [
        // Obx(() {
        //   final unseenCount =
        //       nc.notifications.where((n) => n.isSeen == false).length;
        //   return Badge(
        //     offset: Offset(2, 1),
        //     isLabelVisible: unseenCount < 1 ? false : true,
        //     label: Text(
        //       unseenCount.toString(),
        //       style: TextStyle(
        //         fontSize: 12, // ↓ smaller font size
        //       ),
        //     ),
        //     largeSize: 25,
        //     child: IconButton(
        //         onPressed: () async {
        //           final locationId = await AuthService.getLocationId();
        //           // String selectedLocationID = '';
        //           // await getStringData("selectedLocationID");
        //           if (locationId.isEmpty) {
        //             GainerBottomSheet.showSnackBar('problem in fetch location');
        //           } else {
        //             Get.to(
        //               () => NotificationScreen(
        //                 selectedLocationID: locationId,
        //               ),
        //             );
        //           }
        //         },
        //         icon: Icon(Icons.notifications)),
        //   );
        // }),
        Obx(() {
          final unRead = HomeController.to.notificationList
              .where((n) => n.isRead == false)
              .length;
          return Badge.count(
            offset: Offset(-5, 0),
            isLabelVisible: unRead < 1 ? false : true,
            padding: EdgeInsets.all(2),
            count: unRead,
            child: IconButton(
              onPressed: () => Get.toNamed(Routes.NOTIFICATIONVIEW),
              icon: Icon(Icons.notifications),
            ),
          );
        }),

        // GestureDetector(
        //   onTap: () {
        //     if (controller.currentIndex.value != 0) {
        //       controller.currentIndex.value = 0;
        //     }
        //   },
        //   child: Image.asset(GainerImages.scsCircle, height: 30),
        // ),
        const SizedBox(width: 12),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
