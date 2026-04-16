import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/gainer_color.dart';
import 'gainer_main_controller.dart';
import 'widgets/gainer_drawer_view.dart';
import 'widgets/gainer_main_app_bar_view.dart';

class GainerMainView extends GetView<GainerMainController> {
  const GainerMainView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        controller.handleBackPress();
      },
      child: Scaffold(
        backgroundColor: GainerColors.background,

        appBar: GainerMainAppBarView(),
        body: Obx(
          () => IndexedStack(
            index: controller.currentIndex.value,
            children: controller.pages,
          ),
        ),
        drawer: GainerDrawerView(),
        bottomNavigationBar: Obx(
          () => BottomNavigationBar(
            currentIndex: controller.currentIndex.value,
            onTap: controller.changeTab,
            items: controller.items,
            type: BottomNavigationBarType.fixed,
          ),
        ),
      ),
    );
  }
}
