import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/gainer_color.dart';
import '../../../core/widgets/profile_circle.dart';
import '../../bottom_navbar/home_view/home_controller.dart';
import '../gainer_main_controller.dart';

class GainerDrawerView extends GetView<GainerMainController> {
  GainerDrawerView({super.key});
  final c = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.7,
      child: Container(
        color: GainerColors.primary,
        child: SafeArea(
          child: Column(
            children: [
              _header(),
              const SizedBox(height: 20),
              Divider(),
              _menuList(),
              const Spacer(),
              _logoutButton(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------- HEADER ----------------
  Widget _header() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Obx(
        () => Row(
          children: [
            ProfileCircle(
              size: 60,
              pickedImg: c.pickedProfileImg.value,
              apiImg: c.profileImage.value,
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  c.name.value,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  c.username.value,
                  style: TextStyle(
                      color: Colors.white70, fontSize: 12, letterSpacing: 1),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  // ---------------- MENU ----------------
  Widget _menuList() {
    final menuItems = [
      _MenuItem(Icons.home, 'Home Section'),
      // _MenuItem(Icons.shopping_cart, 'Part Request'),
      _MenuItem(Icons.local_shipping, 'Track Order'),
      _MenuItem(Icons.help, 'Help Section'),
      _MenuItem(Icons.person, 'Profile Section'),
    ];

    return Obx(() => Column(
          children: List.generate(
            menuItems.length,
            (index) => _menuTile(menuItems[index], index),
          ),
        ));
  }

  Widget _menuTile(_MenuItem item, int index) {
    final isSelected = controller.currentIndex.value == index;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Get.back();
          controller.changeTab(index);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white12 : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(item.icon, color: Colors.white),
              const SizedBox(width: 14),
              Text(
                item.title,
                style: const TextStyle(color: Colors.white, fontSize: 15),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------- LOGOUT ----------------
  Widget _logoutButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: ElevatedButton.icon(
        onPressed: c.logout,
        icon: const Icon(Icons.logout),
        label: const Text('Logout'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white12,
          foregroundColor: Colors.white,
          elevation: 0,
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
      ),
    );
  }
}

// ---------------- MODEL ----------------
class _MenuItem {
  final IconData icon;
  final String title;

  _MenuItem(this.icon, this.title);
}
