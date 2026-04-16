import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/gainer_color.dart';
import '../home_view/home_controller.dart';
import 'widgets/header_view.dart';
import 'widgets/info_section.dart';
import 'widgets/info_tile.dart';
import 'widgets/logout_button.dart';

class ProfileView extends GetView<HomeController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    // controller.getUserDetails();
    return Scaffold(
      backgroundColor: GainerColors.background,
      body: Column(
        children: [
          HeaderView(),
          Expanded(
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  InfoSection(
                    title: "PERSONAL INFORMATION",
                    children: [
                      // InfoTile(
                      //   icon: Icons.badge,
                      //   title: "Name",
                      //   value: controller.name,
                      // ),
                      InfoTile(
                        icon: Icons.person,
                        title: "Username",
                        value: controller.username,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  InfoSection(
                    title: "DEALERSHIP DETAILS",
                    children: [
                      InfoTile(
                        icon: Icons.branding_watermark,
                        title: "Brand",
                        value: controller.brand,
                      ),
                      InfoTile(
                        icon: Icons.store,
                        title: "Dealer",
                        value: controller.dealer,
                      ),
                      InfoTile(
                        icon: Icons.location_on,
                        title: "Location",
                        value: controller.location,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  LogoutButton(),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
