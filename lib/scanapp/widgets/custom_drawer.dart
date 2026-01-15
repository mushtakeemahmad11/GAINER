import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../gainer/widget/profile_widget.dart';
import '../../gainer/widget/reusable_widget.dart';

class CustomDrawer extends StatelessWidget {
  final List<DrawerMenuItem> items;
  final Color drawerColor;
  final String? userName;
  final String? imgUrl;

  const CustomDrawer(
      {super.key,
      required this.items,
      required this.drawerColor,
      required this.userName,
      required this.imgUrl});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: drawerColor,
      child: Column(
        children: [
          DrawerHeader(
            child: Center(
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  radius: 26,
                  child: reusableProfile(null, imgUrl),
                ),
                title: Text(
                  userName??"Name Name",
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return CustomListTile(
                  icon: item.icon,
                  title: item.title,
                  onTap: () {
                    Get.back(); // close drawer first
                    item.onTap();
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class DrawerMenuItem {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  DrawerMenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });
}
