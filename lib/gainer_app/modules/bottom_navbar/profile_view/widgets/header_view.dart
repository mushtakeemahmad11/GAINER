import 'package:flutter/material.dart';
import 'package:gainer/gainer_app/core/widgets/gainer_app_loader.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import '../../../../core/constants/gainer_color.dart';
import '../../../../core/widgets/image_preview.dart';
import '../../../../core/widgets/profile_circle.dart';
import '../../home_view/home_controller.dart';

class HeaderView extends GetView<HomeController> {
  const HeaderView({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.only(top: 10, bottom: 25),
      width: size.width,
      decoration: const BoxDecoration(
        color: GainerColors.primary,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      child: Column(
        children: [
          Obx(() {
            bool isUpload = controller.isProfileUploading.value;
            String? pickedImg = controller.pickedProfileImg.value;
            String? profileImg = controller.profileImage.value;
            String url =
                "https://scope.sparecare.in/Upload/Employee/$profileImg";
            return Stack(
              children: [
                InkWell(
                  onTap: () {
                    ImagePreview.show(
                      image: pickedImg ?? url,
                      title: 'Profile',
                    );
                  },
                  child: ProfileCircle(
                    size: 150,
                    pickedImg: pickedImg,
                    apiImg: profileImg,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 25,
                    backgroundColor: GainerColors.white,
                    child: isUpload
                        ? const GainerCircularLoader()
                        : IconButton(
                            icon: Icon(Icons.camera_alt,
                                color: GainerColors.primary),
                            onPressed: () =>
                                controller.pickProfileImage(context),
                          ),
                  ),
                ),
              ],
            );
          }),
          const SizedBox(height: 10),
          Obx(
            () => Text(
              controller.name.value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Obx(
            () => Container(
              padding: EdgeInsets.symmetric(vertical: 1, horizontal: 8),
              decoration: BoxDecoration(
                // color: GainerColors.secondary,
                color: Colors.white10,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                controller.email.value,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
