import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import '../../../../test/gainer_sims.dart';
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
      iconTheme: const IconThemeData(color: Colors.black54),
      backgroundColor: GainerColors.primary,
      // titleSpacing: 0,
      title: _buildTitle(),
      leadingWidth: Platform.isIOS ? 100 : null,
      leading: Platform.isIOS ? _buildLeading(context) : null,
      centerTitle: true,
      actions: [_buildNotificationIcon(), const SizedBox(width: 12)],
    );

    // return AppBar(
    //   iconTheme: IconThemeData(color: Colors.black54),
    //   // titleTextStyle: TextStyle(color: Colors.black54),
    //   backgroundColor: GainerColors.primary,
    //   titleSpacing: 0,
    //   leading: Row(
    //     mainAxisSize: MainAxisSize.min,
    //     children: [
    //       /// 🔹 Back Button
    //       if (Platform.isIOS)
    //         IconButton(
    //           icon: const Icon(Icons.arrow_back_ios),
    //           onPressed: () {
    //             Get.back(); // or Navigator.pop(context)
    //           },
    //         ),
    //
    //       /// 🔹 Drawer Button
    //       Builder(
    //         builder: (context) => IconButton(
    //           icon: const Icon(Icons.menu),
    //           onPressed: () {
    //             Scaffold.of(context).openDrawer();
    //           },
    //         ),
    //       ),
    //     ],
    //   ),
    //   leadingWidth: 100, // important to give space for both icons
    //
    //   // centerTitle: true,
    //   title: Obx(() {
    //     int index = controller.currentIndex.value;
    //     // if (index == 0) return TextDropdown();
    //     /// SCS Logo
    //     if (index == 0) {
    //       return Text(
    //         'Sparecare Gainer',
    //         style: TextStyle(color: Colors.black54),
    //       );
    //       // return Image.asset(AppImages.scsBlackLinear, height: 50);
    //     }
    //     return Text(
    //       controller.navItems[index].label,
    //       style: TextStyle(color: Colors.black54),
    //     );
    //   }),
    //
    //   // title: Obx(
    //   //     () => Text(controller.navItems[controller.currentIndex.value].label)),
    //   actions: [
    //     // Obx(() {
    //     //   final unseenCount =
    //     //       nc.notifications.where((n) => n.isSeen == false).length;
    //     //   return Badge(
    //     //     offset: Offset(2, 1),
    //     //     isLabelVisible: unseenCount < 1 ? false : true,
    //     //     label: Text(
    //     //       unseenCount.toString(),
    //     //       style: TextStyle(
    //     //         fontSize: 12, // ↓ smaller font size
    //     //       ),
    //     //     ),
    //     //     largeSize: 25,
    //     //     child: IconButton(
    //     //         onPressed: () async {
    //     //           final locationId = await AuthService.getLocationId();
    //     //           // String selectedLocationID = '';
    //     //           // await getStringData("selectedLocationID");
    //     //           if (locationId.isEmpty) {
    //     //             GainerBottomSheet.showSnackBar('problem in fetch location');
    //     //           } else {
    //     //             Get.to(
    //     //               () => NotificationScreen(
    //     //                 selectedLocationID: locationId,
    //     //               ),
    //     //             );
    //     //           }
    //     //         },
    //     //         icon: Icon(Icons.notifications)),
    //     //   );
    //     // }),
    //     Obx(() {
    //       final unRead = HomeController.to.notificationList
    //           .where((n) => n.isRead == false)
    //           .length;
    //       return Badge.count(
    //         offset: Offset(-5, 0),
    //         isLabelVisible: unRead < 1 ? false : true,
    //         padding: EdgeInsets.all(2),
    //         count: unRead,
    //         child: IconButton(
    //           onPressed: () => Get.toNamed(Routes.NOTIFICATIONVIEW),
    //           icon: Icon(Icons.notifications),
    //         ),
    //       );
    //     }),
    //
    //     // GestureDetector(
    //     //   onTap: () {
    //     //     if (controller.currentIndex.value != 0) {
    //     //       controller.currentIndex.value = 0;
    //     //     }
    //     //   },
    //     //   child: Image.asset(GainerImages.scsCircle, height: 30),
    //     // ),
    //     const SizedBox(width: 12),
    //   ],
    // );
  }

  Widget _buildLeading(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        /// 🔸 Back Button (only when IOS pop)
        IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          // onPressed: Get.back,
          onPressed: controller.handleBackPress,
        ),

        /// 🔸 Drawer Button
        IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
      ],
    );
  }

  // Widget _buildTitle() {
  //   return Obx(() {
  //     final index = controller.currentIndex.value;
  //
  //     return Text(
  //       index == 0
  //           ? 'Sparecare Gainer'
  //           : controller.navItems[index].label,
  //       style: const TextStyle(color: Colors.black54),
  //     );
  //   });
  // }

  Widget _buildTitle() {
    return Obx(() {
      final index = controller.currentIndex.value;

      final title =
          index == 0 ? 'Sparecare Gainer' : controller.navItems[index].label;

      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.0, 0.5), // from bottom
              end: Offset.zero,
            ).animate(animation),
            child: FadeTransition(
              opacity: animation,
              child: child,
            ),
          );
        },
        child: Text(
          title,
          key: ValueKey(title), // VERY IMPORTANT
          style: const TextStyle(color: Colors.black54),
        ),
      );
    });
  }

  Widget _buildNotificationIcon() {
    return Obx(() {
      final unRead =
          HomeController.to.notificationList.where((n) => !n.isRead).length;

      return Badge.count(
        offset: const Offset(-5, 0),
        isLabelVisible: unRead > 0,
        count: unRead,
        padding: const EdgeInsets.all(2),
        child: IconButton(
          onPressed: () {
            if (Platform.isIOS) {
              Get.to(() => GainerSims());
              return;
            }
            Get.toNamed(Routes.NOTIFICATIONVIEW);
          },
          icon: const Icon(Icons.notifications),
        ),
      );
    });
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
