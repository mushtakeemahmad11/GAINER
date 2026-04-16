import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import '../../../../core/constants/gainer_color.dart';
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
        // gradient: LinearGradient(
        //   colors: [Color(0xff00695C), Color(0xff00796B)],
        // ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      child: Column(
        children: [
          Obx(() {
            bool isUpload = controller.isProfileUploading.value;
            String? pickedImg = controller.pickedProfileImg.value;
            String? profileImg = controller.profileImage.value;

            return Stack(
              children: [
                ProfileCircle(
                  size: 150,
                  pickedImg: pickedImg,
                  apiImg: profileImg,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 25,
                    backgroundColor: GainerColors.white,
                    child: isUpload
                        ? CircularProgressIndicator()
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

  // Widget _buildProfileImage() {
  //   final pickedImg = controller.pickedProfileImg.value;
  //   final apiImg = controller.profileImage.value;
  //
  //   return Container(
  //     width: 150,
  //     height: 150,
  //     decoration: BoxDecoration(
  //       shape: BoxShape.circle,
  //       border: Border.all(color: Colors.white10, width: 5),
  //     ),
  //     child: ClipOval(
  //       child: pickedImg != null
  //           ? Image.file(File(pickedImg), fit: BoxFit.cover)
  //           : apiImg != null && apiImg.isNotEmpty
  //               ? Image.network(
  //                   apiImg,
  //                   fit: BoxFit.cover,
  //                   loadingBuilder: (_, child, progress) {
  //                     if (progress == null) return child;
  //                     return const Center(child: CircularProgressIndicator());
  //                   },
  //                   errorBuilder: (_, __, ___) =>
  //                       Image.asset(GainerImages.profile),
  //                 )
  //               : Image.asset(GainerImages.profile),
  //     ),
  //   );
  // }
}
