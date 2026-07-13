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
    return AppBar(
      iconTheme: const IconThemeData(color: Colors.black54),
      backgroundColor: GainerColors.primary,
      title: _buildTitle(),
      // leadingWidth: Platform.isIOS ? 100 : null,
      // leading: Platform.isIOS ? _buildLeading(context) : null,
      centerTitle: true,
      actions: [_buildNotificationIcon(), const SizedBox(width: 12)],
    );
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
          onPressed: () => Get.toNamed(Routes.NOTIFICATIONVIEW),
          icon: const Icon(Icons.notifications),
        ),
      );
    });
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
