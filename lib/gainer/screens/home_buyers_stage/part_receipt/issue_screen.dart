import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../main.dart';
import '../../../apis_functionality/api_service.dart';
import '../../../controllers/buyer_controller/part_receipt_controller.dart';
import '../../../controllers/check_internet/no_internet_screen.dart';
import '../../../controllers/pick_image_controller.dart';
import '../../../utility/controller_utils.dart';
import '../../../widget/bottomsheet_for_picture.dart';
import '../../../widget/dialog.dart';
import '../../../widget/reusable_elevated_button.dart';
import '../../../widget/reusable_outline_icon_btn.dart';
import '../../../widget/reusable_widget.dart';
import '../../../widget/toggle_outline_button.dart';
import '../../check_internet/check_internet_connectivity.dart';
import '../../constant_image_path.dart';
import 'package:path/path.dart';

class IssueScreen extends StatefulWidget {
  const IssueScreen({super.key});

  @override
  State<IssueScreen> createState() => _IssueScreenState();
}

class _IssueScreenState extends State<IssueScreen> {
  PartReceiptController controller = Get.put(PartReceiptController());
  final PickImageController _pickImageController =
      Get.put(PickImageController());
  final TextEditingController remarksController = TextEditingController();
  int? bigId;
  final List<String> issueOptions = [
    'Damage',
    'Functional Issue',
    'Wrong Part',
    'Part Received Late',
    'Others'
  ];

  List<File?> selectedImages = [null, null, null];
  List<String?> selectedImageNames = [null, null, null];
  Future<void> pickImage(int index, ImageSource source) async {
    Get.back();
    File? image = await _pickImageController.pickImage(source);
    if (image != null) {
      setState(() {
        selectedImages[index] = File(image.path);
        selectedImageNames[index] = basename(image.path);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    bigId = Get.arguments["bigId"];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Issue with order'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: mq.width * .02, vertical: mq.height * .02),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                ...issueOptions.map((issue) => Padding(
                      padding: EdgeInsets.only(bottom: mq.height * .01),
                      child: SizedBox(
                        width: mq.width,
                        child: Obx(
                          () => ToggleOutlineButton(
                            text: issue,
                            isActive: controller.selectedIssue.value == issue,
                            onToggle: () {
                              // Toggle selection
                              if (controller.selectedIssue.value == issue) {
                                controller.selectedIssue.value =
                                    ''; // Deselect if already selected
                              } else {
                                controller.selectedIssue.value = issue;
                              }
                            },
                          ),
                        ),
                      ),
                    )),
                _imagePickerRow('Select Photo-1', 0, context),
                _imagePickerRow('Select Photo-2', 1, context),
                _imagePickerRow('Select Photo-3', 2, context),
                CustomTextFormField(
                  controller: remarksController,
                  text: '  Enter Remarks',
                  onChanged: (value) async {
                    String filterValue =
                        await ControllerUtils.remarksValidation(value);
                    if (value != filterValue) {
                      remarksController.text = filterValue;
                    }
                  },
                  // suffixIcon: Icon(
                  //   Icons.edit,
                  //   color: AppColor.primary,
                  //   color: AppColor.primary,
                  // ),
                ),
                SizedBox(height: mq.height * .03),
                // Text(bigId.toString()),
                CustomElevatedButton(
                  onTap: () {
                    if (controller.selectedIssue.value.isNotEmpty) {
                      ScaffoldMessenger.of(context)
                          .removeCurrentSnackBar(); // Remove previous
                      _onSubmit(
                          remarksController.text,
                          controller.selectedIssue.value,
                          bigId.toString(),
                          context);
                    } else {
                      CustomBottomSheet.showSnackBar(
                          context, 'Please select an option');
                    }
                  },
                  text: 'Submit',
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _widgetForRow(String text, VoidCallback onTap) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: mq.width * .7,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text(
                  text,
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ),
            const SizedBox(height: 15),
            Container(
              height: 1,
              width: mq.width * .7,
              color: Colors.black,
            ),
          ],
        ),
        CustomIconBtn(onTap: onTap, icon: Icons.add_a_photo),
      ],
    );
  }

  Widget _imagePickerRow(String label, int index, BuildContext context) {
    return Column(
      children: [
        _widgetForRow(selectedImageNames[index] ?? label, () {
          CustomBottomSheet.show(
            context: context,
            onPressedCamera: () => pickImage(index, ImageSource.camera),
            onPressedGallery: () => pickImage(index, ImageSource.gallery),
          );
        }),
        if (selectedImages[index] != null)
          Image.file(
            selectedImages[index]!,
            width: mq.width,
            height: mq.width - 20,
            fit: BoxFit.cover,
          ),
        SizedBox(height: mq.height * .02),
      ],
    );
  }

  ///onSubmit button for hit API
  _onSubmit(
      String remarks, String actionType, String bigId, BuildContext context) {
    List<File> selectedImages = [];
    AppDialog.dialogForYesNo('Are you sure to to receive order\nwith Issue',
        AppImages.decisionMaking, () async {
      Get.back();
      //for store image in key value{"img1:"image_path"}
      Map<String, String> imageMap = {};
      controller.isLoadingIssue.value = true;
      for (int i = 0; i < selectedImages.length; i++) {
        imageMap["img${i + 1}"] = selectedImages[i].path;
      }
      bool checkInt = await checkInternet();
      if (checkInt) {
        final response = await ApiService().pendingToBeReceived(
            remarks: remarks,
            actionType: actionType,
            bigID: bigId,
            imageFiles: selectedImages);
        controller.isLoadingIssue.value = false;
        if (response['success'] == true) {
          controller.selectedIssue.value = '';
          Get.back();
          AppDialog.midPopUp(AppImages.check, '${response['data']}');
        } else {
          CustomBottomSheet.showSnackBar(context, '${response['message']}');
        }
      } else {
        Get.to(() => NoInternetScreen());
      }
    }, () {
      Get.back();
    });
  }
}
