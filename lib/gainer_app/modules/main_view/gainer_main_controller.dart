import 'package:flutter/material.dart';
import 'package:gainer/gainer_app/modules/bottom_navbar/home_view/home_view.dart';
import 'package:get/get.dart';
import '../../routes/app_routes.dart';
import '../bottom_navbar/help_view/help_view.dart';
import '../bottom_navbar/profile_view/profile_view.dart';
import '../bottom_navbar/track_order_view/track_order_view.dart';
import '../internet_connectivity/no_internet_controller.dart';
import 'models/nav_model.dart';

class GainerMainController extends GetxController {
  SearchController searchController = SearchController();

  final RxInt currentIndex = 0.obs;

  final List<NavItem> navItems = [
    NavItem(
      label: "Home",
      icon: Icons.home,
      page: HomeView(),
    ),
    NavItem(
      label: "Track Orders",
      icon: Icons.local_shipping,
      page: const TrackOrderView(),
    ),
    NavItem(
      label: "Help",
      icon: Icons.help,
      page: const HelpView(),
    ),
    NavItem(
      label: "Profile",
      icon: Icons.person,
      page: const ProfileView(),
    ),
  ];

  List<Widget> get pages => navItems.map((e) => e.page).toList();

  List<BottomNavigationBarItem> get items => navItems
      .map(
        (e) => BottomNavigationBarItem(
          icon: Icon(e.icon),
          label: e.label,
        ),
      )
      .toList();

  void changeTab(int index) {
    if (!Get.find<NoInternetController>().isConnected.value) {
      Get.toNamed(Routes.NOINTERNETVIEW);
      return;
    }
    currentIndex.value = index;
  }

  void handleBackPress() {
    if (currentIndex.value != 0) {
      currentIndex.value = 0;
    } else {
      Get.back(); // Back app
    }
  }
}
