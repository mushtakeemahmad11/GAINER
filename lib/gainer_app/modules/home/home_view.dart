import 'package:flutter/material.dart';
import 'package:gainer/dealer_monitoring/core/utils/dm_images.dart';
import 'package:get/get.dart';
import '../../../gainer/utility/download_utils.dart';
import '../../../gainer/widget/reusable_elevated_button.dart';
import '../../core/Services/auth_service.dart';
import '../../core/constants/gainer_image.dart';
import '../../core/constants/gainer_color.dart';
import 'home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: GainerColors.background,
      appBar: AppBar(
        backgroundColor: GainerColors.primary,
        elevation: 0,
        title: Obx(() => Text(
              'Hi, ${controller.userName.value}',
              style: const TextStyle(fontSize: 18),
            )),
        // actions: [
        //   Obx(() => Stack(
        //         children: [
        //           IconButton(
        //             icon: const Icon(Icons.notifications),
        //             onPressed: () {},
        //           ),
        //           if (controller.notificationCount.value > 0)
        //             Positioned(
        //               right: 8,
        //               top: 8,
        //               child: CircleAvatar(
        //                 radius: 8,
        //                 backgroundColor: Colors.red,
        //                 child: Text(
        //                   controller.notificationCount.value.toString(),
        //                   style: const TextStyle(
        //                     color: Colors.white,
        //                     fontSize: 10,
        //                   ),
        //                 ),
        //               ),
        //             )
        //         ],
        //       )),
        //   // RefreshIndicator(
        //   //     onRefresh: () async => controller.loadDashboardData(),
        //   //     child: Icon(Icons.refresh))
        //   IconButton(
        //       onPressed: () {
        //         controller.loadDashboardData();
        //       },
        //       icon: Icon(Icons.refresh)),
        // ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _appCard(
                    logo: GainerImages.gLogo,
                    title: 'Gainer',
                    subTitle: 'Dead Stock Liquidation',
                    onTap: () => controller.gotoScreen('Gainer'),
                  ),
                  _appCard(
                    logo: DMImages.simsLogo,
                    title: 'SIMS',
                    subTitle: 'Smart Inventory  Management System',
                    onTap: () => controller.gotoScreen('SIMS'),
                  ),
                  Spacer(),
                  IconButton(
                      onPressed: () {
                        AuthService.logout('Manually');
                      },
                      icon: Icon(
                        Icons.logout,
                        color: Colors.teal,
                      )),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      "Version: ${controller.oldVersion.value}",
                      style: const TextStyle(color: Colors.black54),
                    ),
                  ),
                  // _appCard(icon: Icons.logout, title: 'Logout', onTap: () {}),

                  /*/// Dashboard Cards
                    Row(
                      children: [
                        _dashboardCard(
                          title: 'Orders',
                          value: '128',
                          icon: Icons.shopping_cart,
                        ),
                        const SizedBox(width: 12),
                        _dashboardCard(
                          title: 'Revenue',
                          value: '₹52K',
                          icon: Icons.currency_rupee,
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      'Quick Actions',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 12),
                    _actionTile(
                      icon: Icons.person,
                      title: 'Profile',
                      onTap: () {},
                    ),
                    _actionTile(
                      icon: Icons.settings,
                      title: 'Settings',
                      onTap: () {},
                    ),
                    _actionTile(
                      icon: Icons.logout,
                      title: 'Logout',
                      onTap: controller.logout,
                    ),*/
                ],
              ),
            ),
            Obx(() {
              if (controller.isAppUpdated.value) return const SizedBox.shrink();
              return Container(color: Colors.black26);
            }),
            Obx(() {
              if (controller.isAppUpdated.value) return const SizedBox.shrink();
              return Align(
                  alignment: Alignment.bottomRight,
                  child: _updateAppCard(size));
            }),
          ],
        ),
      ),
    );
  }

  // Widget _dashboardCard({
  //   required String title,
  //   required String value,
  //   required IconData icon,
  // }) {
  //   return Expanded(
  //     child: Container(
  //       padding: const EdgeInsets.all(16),
  //       decoration: BoxDecoration(
  //         color: Colors.white,
  //         borderRadius: BorderRadius.circular(16),
  //         boxShadow: [
  //           BoxShadow(
  //             color: Colors.black.withOpacity(0.05),
  //             blurRadius: 10,
  //           ),
  //         ],
  //       ),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Icon(icon, color: const Color(0xFF2C9AA0)),
  //           const SizedBox(height: 10),
  //           Text(
  //             value,
  //             style: const TextStyle(
  //               fontSize: 20,
  //               fontWeight: FontWeight.bold,
  //             ),
  //           ),
  //           Text(
  //             title,
  //             style: const TextStyle(color: Colors.grey),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _appCard({
    required String logo,
    required String title,
    required String subTitle,
    required VoidCallback onTap,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        // leading: Icon(icon, color: const Color(0xFF2C9AA0)),
        leading: Image.asset(logo, height: 40),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subTitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  Widget _updateAppCard(Size size) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 45),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.system_update, color: GainerColors.primary, size: 45),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Update Available',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: GainerColors.primary,
                  ),
                ),
                const Text(
                  'A newer version of the App is available.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 5),
                SizedBox(
                  width: size.width * .5,
                  child: CustomElevatedButton(
                    onTap: () => DownloadUtils.downloadApk(),
                    text: 'Update Now',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Widget _actionTile({
  //   required IconData icon,
  //   required String title,
  //   required VoidCallback onTap,
  // }) {
  //   return Card(
  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  //     child: ListTile(
  //       leading: Icon(icon, color: const Color(0xFF2C9AA0)),
  //       title: Text(title),
  //       trailing: const Icon(Icons.arrow_forward_ios, size: 16),
  //       onTap: onTap,
  //     ),
  //   );
  // }
}
