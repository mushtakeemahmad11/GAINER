import 'package:flutter/material.dart';
import 'package:gainer/gainer_app/core/utils/gainer_text_filed_validator.dart';
import 'package:gainer/gainer_app/core/widgets/gainer_bottom_sheet.dart';
import 'package:gainer/gainer_app/core/widgets/gainer_primary_button.dart';
import 'package:gainer/gainer_app/modules/action_as_buyer/part_receipt_view/part_receipt_controller.dart';

import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

import '../../../core/constants/gainer_color.dart';
import '../../../core/widgets/gainer_text_form_field.dart';
import '../../../core/widgets/gainer_toggle_outlined_btn.dart';

class RaisedConcernView extends GetView<PartReceiptController> {
  final int bigId;
  const RaisedConcernView({
    super.key,
    required this.bigId,
  });
  @override
  Widget build(BuildContext context) {
    // controller.closedRaisedConcern();
    Size size = MediaQuery.of(context).size;
    return PopScope(
      onPopInvokedWithResult: (isBack, temp) {
        // want to remove old value when backed
        controller.closedRaisedConcern();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Raised Concern'),
          backgroundColor: GainerColors.primary,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: size.width * .02, vertical: size.height * .02),
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  ...controller.issueOptions.map((issue) => Padding(
                        padding: EdgeInsets.only(bottom: size.height * .01),
                        child: SizedBox(
                          width: size.width,
                          child: Obx(
                            () => GainerToggleOutlineBtn(
                              text: issue,
                              isActive: controller.selectedIssue.value == issue,
                              onToggle: () => controller.toggleIssue(issue),
                            ),
                          ),
                        ),
                      )),
                  _imageRow(context, size),
                  const SizedBox(height: 5),

                  // _imagePickerRow('Select Photo-1', 0, context, size),
                  // _imagePickerRow('Select Photo-2', 1, context, size),
                  // _imagePickerRow('Select Photo-3', 2, context, size),
                  GainerTextFormField(
                    controller: controller.remarksCtrl,
                    label: '  Enter Remarks',
                    onChanged: (value) async {
                      String filterValue =
                          await GainerTextFiledValidator.remarksValidation(
                              value);
                      if (value != filterValue) {
                        controller.remarksCtrl.text = filterValue;
                      }
                    },
                  ),
                  SizedBox(height: size.height * .02),
                  GainerPrimaryButton(
                    onPressed: () {
                      if (controller.selectedIssue.value.isNotEmpty) {
                        ScaffoldMessenger.of(context)
                            .removeCurrentSnackBar(); // Remove previous
                        controller.onSubmitConcern(bigId, context);

                        // _onSubmit(
                        //   remarksController.text,
                        //   controller.selectedIssue.value,
                        //   bigId.toString(),
                        //   context,
                        // );
                      } else {
                        GainerBottomSheet.showSnackBar(
                            'Please select an option');
                      }
                    },
                    title: 'Submit',
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _imageRow(BuildContext context, Size size) {
    return Obx(() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(
          controller.selectedImages.length,
          (index) {
            final file = controller.selectedImages[index];

            if (file != null) {
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  Card(
                    child: Image.file(
                      file,
                      width: size.width * .22,
                      height: size.width * .22,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: -18,
                    right: -18,
                    child: IconButton(
                      icon: Icon(
                        Icons.cancel,
                        color: GainerColors.primary,
                      ),
                      onPressed: () => controller.removeImage(index),
                    ),
                  ),
                ],
              );
            } else {
              return InkWell(
                onTap: () {
                  controller.takeImage(index, context);
                },
                child: Container(
                  width: size.width * .22,
                  height: size.width * .22,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: GainerColors.primary,
                      width: 1.2,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.add_a_photo,
                    color: GainerColors.primary,
                  ),
                ),
              );
            }
          },
        ),
      );
    });
  }

  /*Widget _widgetForRow(String text, VoidCallback onTap, Size size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.only(left: 8),
              scrollDirection: Axis.horizontal,
              child: Text(
                text,
                style: const TextStyle(fontSize: 18),
              ),
            ),
            Divider(),
          ],
        )),
        IconButton(
          onPressed: onTap,
          icon: Icon(
            Icons.add_a_photo,
            color: GainerColors.primary,
          ),
        ),
      ],
    );
  }

  Widget _imagePickerRow(
      String label, int index, BuildContext context, Size size) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SingleChildScrollView(
                  padding: EdgeInsets.only(left: 8),
                  scrollDirection: Axis.horizontal,
                  child: Obx(() => Text(
                        controller.selectedImageNames[index] ?? label,
                        style: const TextStyle(fontSize: 18),
                      )),
                ),
                Divider(),
              ],
            )),
            IconButton(
              onPressed: () => controller.takeImage(index, context),
              icon: Icon(
                Icons.add_a_photo,
                color: GainerColors.primary,
              ),
            ),
          ],
        ),
        Obx(
          () => (controller.selectedImages[index] != null)
              ? Image.file(
                  controller.selectedImages[index]!,
                  width: size.width,
                  height: size.width - 20,
                  fit: BoxFit.cover,
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }*/

  ///onSubmit button for hit API
  // _onSubmit(
  //     String remarks, String actionType, String bigId, BuildContext context) {
  //   List<File> selectedImages = [];
  //   AppDialog.dialogForYesNo('Are you sure to to receive order\nwith Issue',
  //       AppImages.decisionMaking, () async {
  //     Get.back();
  //     //for store image in key value{"img1:"image_path"}
  //     Map<String, String> imageMap = {};
  //     controller.isLoadingIssue.value = true;
  //     for (int i = 0; i < selectedImages.length; i++) {
  //       imageMap["img${i + 1}"] = selectedImages[i].path;
  //     }
  //     bool checkInt = await checkInternet();
  //     if (checkInt) {
  //       final response = await ApiService().pendingToBeReceived(
  //           remarks: remarks,
  //           actionType: actionType,
  //           bigID: bigId,
  //           imageFiles: selectedImages);
  //       controller.isLoadingIssue.value = false;
  //       if (response['success'] == true) {
  //         controller.selectedIssue.value = '';
  //         Get.back();
  //         AppDialog.midPopUp(AppImages.check, '${response['data']}');
  //       } else {
  //         GainerBottomSheet.showSnackBar( '${response['message']}');
  //       }
  //     } else {
  //       Get.to(() => NoInternetScreen());
  //     }
  //   }, () {
  //     Get.back();
  //   });
  // }
}
