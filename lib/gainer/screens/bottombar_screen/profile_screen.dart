import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../main.dart';
import '../../controllers/home_screen_controller.dart';
import '../../controllers/profile_screen_controller.dart';
import '../../controllers/user_details/user_controller.dart';
import '../../shared_preferences/shared_preferences_get_data.dart';
import '../../shared_preferences/shared_preferences_remove_data.dart';
import '../../shared_preferences/shared_preferences_set_data.dart';
import '../../widget/bottomsheet_for_picture.dart';
import '../../widget/dialog.dart';
import '../../widget/profile_widget.dart';
import '../../widget/reusable_elevated_button.dart';
import '../colors.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserController userController = Get.put(UserController());
  LocationController locationController = Get.put(LocationController());
  ProfileScreenController profileScreenController =
      Get.put(ProfileScreenController());

  late final user;
  String? firstName;
  String? userName;
  String? lastName;
  String? email;
  String? userImage;
  String? photo;

  File? _image;

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: mq.width * .02, vertical: mq.height * .00),
        child: Column(
          children: [
            // const Row(
            //   // mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     Text(
            //       'My Profile',
            //       style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            //     ),
            //   ],
            // ),
            const SizedBox(height: 10),
            Stack(
              children: [
                Center(
                  child: GestureDetector(
                    onTap: () {},
                    child: reusableProfile(_image, photo),
                  ),
                ),
                Positioned(
                  right: mq.width * .25,
                  bottom: mq.height * .005,
                  child: CircleAvatar(
                    backgroundColor: AppColor.primary,
                    radius: 26,
                    child: IconButton(
                      onPressed: () {
                        CustomBottomSheet.show(
                          context: context,
                          onPressedCamera: () {
                            pickImage(ImageSource.camera);
                            Get.back();
                          },
                          onPressedGallery: () {
                            pickImage(ImageSource.gallery);
                            Get.back();
                          },
                        );
                      },
                      icon: const Icon(
                        Icons.camera_alt,
                        size: 28,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: mq.height * .02),
            Text(
              email ?? 'abc@gmail.com',
              style: const TextStyle(fontSize: 18, color: Colors.black54),
            ),
            SizedBox(height: mq.height * .02),

            Card(
              color: Colors.teal[100],
              margin: EdgeInsets.all(mq.height * 0.01),
              child: Padding(
                padding: EdgeInsets.all(mq.height * 0.02),
                child: Column(
                  children: [
                    _buildInfoRow(
                        'Name:', '${firstName ?? "abc"} ${lastName ?? "abc"}'),
                    _buildDividerWithSpace(context),
                    _buildInfoRow('User Name:', userName ?? "abc"),
                    _buildDividerWithSpace(context),
                    _buildInfoRow('Location:',
                        locationController.stockDetails['Location'] ?? 'N/A'),
                    _buildDividerWithSpace(context),
                    _buildInfoRow('Dealer:',
                        locationController.stockDetails['Dealer'] ?? 'N/A'),
                  ],
                ),
              ),
            ),

            // Card(
            //   color: Colors.teal[100],
            //   margin: EdgeInsets.symmetric(
            //       horizontal: mq.height * .01, vertical: mq.height * .01),
            //   child: Padding(
            //     padding: EdgeInsets.symmetric(
            //         horizontal: mq.height * .02, vertical: mq.height * .02),
            //     child: Column(
            //       children: [
            //         Row(
            //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //           children: [
            //             const Text('Name:'),
            //             Text('${firstName ?? "abc"} ${lastName ?? "abc"}'),
            //           ],
            //         ),
            //         SizedBox(height: mq.height * .02),
            //         const Divider(color: Colors.white),
            //         SizedBox(height: mq.height * .02),
            //
            //         Row(
            //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //           children: [
            //             const Text('User Name:'),
            //             Text(userName ?? "abc"),
            //           ],
            //         ),
            //         SizedBox(height: mq.height * .02),
            //         const Divider(color: Colors.white),
            //         SizedBox(height: mq.height * .02),
            //
            //         Row(
            //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //           children: [
            //             const Text('Location:'),
            //             Text(locationController.stockDetails['Location'] ??
            //                 'N/A'),
            //           ],
            //         ),
            //         SizedBox(height: mq.height * .02),
            //         const Divider(color: Colors.white),
            //         SizedBox(height: mq.height * .02),
            //         Row(
            //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //           children: [
            //             const Text('Dealer:'),
            //             Text(
            //                 locationController.stockDetails['Dealer'] ?? 'N/A'),
            //           ],
            //         ),
            //       ],
            //     ),
            //   ),
            // ),

            SizedBox(height: mq.height * .02),
            SizedBox(
              width: mq.width * .91,
              child: CustomElevatedButton(
                  text: 'Logout',
                  onTap: () {
                    removeData('isLogin');
                    removeData('userProfile');
                    AppDialog.logoutBtnFunctionality();
                  }),
            ),
            // Spacer(),
            // Align(
            //     alignment: Alignment.bottomRight, child: Text("version: 3.0")),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        Flexible(child: Text(value, overflow: TextOverflow.ellipsis)),
      ],
    );
  }

  Widget _buildDividerWithSpace(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: mq.height * 0.015),
        Divider(color: Theme.of(context).dividerColor),
        // Divider(color: Colors.white),
        SizedBox(height: mq.height * 0.015),
      ],
    );
  }

  _getUserData() async {
    firstName = await getStringData('firstName');
    lastName = await getStringData('lastName');
    email = await getStringData('email');
    userImage = await getStringData('userProfile');
    photo = await getStringData('photo');
    userName = await getStringData('UserID');
    profileScreenController.imagePath.value = userImage;

    setState(() {
      user = userController.user.value;
      if (userImage != null) {
        _image = File(userImage!);
      }
    });
  }

  // for pick image according to source(ImageSource.camera/gallery)
  Future<void> pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);

    if (image != null) {
      File selectedImage = File(image.path);

      // set image path in shared preferences
      profileScreenController.imagePath.value = selectedImage.path;
      setStringData('userProfile', selectedImage.path);
      String userProfilePath = await getStringData('userProfile');

      setState(() {
        if (userProfilePath.isNotEmpty) {
          _image = File(userProfilePath);
        } else {
          _image = null;
        }
      });
    }
  }
}
