import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gainer/dealer_monitoring/core/services/dm_api_services.dart';
import 'package:gainer/dealer_monitoring/widgets/dm_dropdown.dart';
import 'package:gainer/dealer_monitoring/widgets/reusable_table.dart';
import 'package:gainer/gainer_app/core/Services/auth_service.dart';
import 'package:gainer/gainer_app/core/utils/gainer_text_filed_validator.dart';
import 'package:gainer/gainer_app/core/widgets/error_text.dart';
import 'package:gainer/gainer_app/core/widgets/gainer_bottom_sheet.dart';
import 'package:gainer/gainer_app/core/widgets/gainer_dialog.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../main.dart';
import '../../gainer_app/core/constants/gainer_image.dart';
import '../core/theme/app_colors.dart';
import '../core/utils/transform_value_ind.dart';
import '../screens/vehicle_search/image_pick_screen.dart';
import 'dm_elevated_button.dart';
import 'dm_text_form_filed.dart';

class RemarksController extends GetxController {
  final selectedRemark = RxnString();
  var selectedRemarkId = RxnInt();
  final isOtherSelected = false.obs;
  final otherText = ''.obs;
  RxBool isLoading = false.obs;
  RxBool remarksLoading = false.obs;
  final RxList remarksItems = [].obs;
  final RxList viewRemarksList = [].obs;
  RxnString error = RxnString(null);
  RxnString remarksError = RxnString(null);
  RxnString screen = RxnString();
  final TextEditingController textEditingController = TextEditingController();
  final TextEditingController advanceValueController = TextEditingController();
  // Rxn allows nullable File
  var selectedImage = Rxn<File>();

  void setImage(String path) {
    selectedImage.value = File(path);
  }

  // for use of submit btn
  final titleText = ''.obs;
  final item = <String, dynamic>{}.obs; // RxMap
  // final part = RxnString();

  void storeData(String text, Map<String, dynamic> itemPV, String screenType) {
    titleText(text);
    item(itemPV);
    screen(screenType);
  }

  // void clearImage() {
  //   selectedImage.value = null;
  // }

  void reset() {
    selectedRemark.value = null;
    selectedRemarkId.value = null;
    isOtherSelected.value = false;
    otherText.value = '';
    textEditingController.clear();
    remarksItems.clear();
    error.value = null;
    selectedImage.value = null;
    advanceValueController.clear();
    // part.value = null;
    titleText.value = '';
    screen.value = null;
    viewRemarksList.clear();
    remarksError.value = null;
    // item.clear();
  }

  Future<void> fetchDropRemarks(String type) async {
    reset();
    isLoading(true);
    final res = await DMApiServices().getRemarksItem(type: type);
    isLoading(false);
    if (res['success']) {
      remarksItems.value = res['data'];
    } else {
      error.value = res['message'];
    }
  }

  RxBool isSubmitting = false.obs;
  Future<void> onSubmit() async {
    bool isPart = titleText.value.startsWith("P");
    final int? remarkId = selectedRemarkId.value;
    final String? remark = remarkId == 0 ? textEditingController.text : null;
    final String tCode = await AuthService.getTCode();

    final String dealerId = item['DealerId'].toString();
    final String locationId = item['LocationId'].toString();
    final file = selectedImage.value;
    final advanceValue = advanceValueController.text.isNotEmpty
        ? advanceValueController.text
        : null; // make optional

    // ✅ Common API params
    String? url;
    String? bigId;
    String? partNumber;
    String vehicleNumber = "";

    if (isPart) {
      bigId = item['bigid'];
      // partNumber = part.value ?? item["part_number1"];
      partNumber =
          screen.value == "pp" ? item["partNumber"] : item["part_number1"];
      vehicleNumber = item['Vehiclenumber'];
      // url = part.value != null ? "rmrk-pp" : "rmrk-vp";
      url = screen.value == "pp" ? "rmrk-pp" : "rmrk-vp";
    } else {
      vehicleNumber = item['vehicleNumber'];
      url = "rmrk-pv";
    }

    isSubmitting(true);
    final response = await DMApiServices().addRemarks(
      url: url,
      dealerId: dealerId,
      locationId: locationId,
      bigId: bigId,
      partNumber: partNumber,
      remark: remark,
      remarkId: remarkId.toString(),
      userId: tCode,
      vehicleNumber: vehicleNumber,
      file: file,
      advanceValue: advanceValue,
    );
    isSubmitting(false);
    // print("Response remarks: $response");
    if (response['success']) {
      Get.back();
      // AppDialog.midPopUp(AppImages.check, response['message']);
      GainerDialog.midPopUp(GainerImages.checkIcon, response['message']);
    } else {
      Get.rawSnackbar(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        messageText: Center(
          child: Text(
            response['message'],
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );
    }
  }

  Future<void> viewRemarks() async {
    bool isPart = titleText.value.startsWith("P");
    String number = titleText.value.split(" ").last;
    String? partNumber = isPart ? number : null;
    String? vehicleNumber = !isPart ? number : null;
    String type = screen.value ?? "";
    viewRemarksList.clear();
    remarksError.value = null;
    remarksLoading(true);
    final response = await DMApiServices().viewRemarks(
      type: type,
      vehicleNumber: vehicleNumber,
      partNumber: partNumber,
    );
    remarksLoading(false);
    if (response['success']) {
      viewRemarksList.value = response['data'];
    } else {
      remarksError.value = response['message'];
    }
  }

// Future<void> onSubmit() async {
//   bool isPart = titleText.value.startsWith("P");
//   final int? remarkId = selectedRemarkId.value;
//   final String? remark = remarkId == 0 ? textEditingController.text : null;
//   final int userID = await getIntData('tCode');
//   final String locationId = item['LocationId'].toString();
//   final String dealerId = item['DealerId'].toString();
//   final file = selectedImage.value;
//   final advanceValue = advanceValueController.text;
//   if (isPart) {
//     final String bigId = item['bigid'];
//     final String partNumber = part.value ?? item["part_number1"];
//     final String vehicleNumber = item['Vehiclenumber'];
//     final String url = part.value != null ? "rmrk-pp" : "rmrk-vp";
//     // print(
//     //     "onSubmit: $dealerId, $locationId, $remarkId, $remark, $userID, $bigId, $partNumber, $vehicleNumber, $file, $advanceValue");
//     isLoading(true);
//     final response = await ApiServices().addRemarks(
//       url: url,
//       dealerId: dealerId,
//       locationId: locationId,
//       bigId: bigId,
//       partNumber: partNumber,
//       remark: remark,
//       remarkId: remarkId.toString(),
//       userId: userID.toString(),
//       vehicleNumber: vehicleNumber,
//       file: file,
//       advanceValue: advanceValue,
//     );
//     isLoading(false);
//     if (response['success']) {
//       Get.back();
//       AppDialog.midPopUp(Constants.check, response['message']);
//     } else {
//       Get.rawSnackbar(
//         padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//         messageText: Center(
//           child: Text(response['message'],
//               style: TextStyle(color: Colors.white)),
//         ),
//       );
//     }
//   } else {
//     final String vehicleNumber = item['vehicleNumber'];
//     final url = "rmrk-pv";
//     isLoading(true);
//     final response = await ApiServices().addRemarks(
//       url: url,
//       dealerId: dealerId,
//       locationId: locationId,
//       remark: remark,
//       remarkId: remarkId.toString(),
//       userId: userID.toString(),
//       vehicleNumber: vehicleNumber,
//       file: file,
//       advanceValue: advanceValue,
//     );
//     isLoading(false);
//     if (response['success']) {
//       Get.back();
//       AppDialog.midPopUp(Constants.check, response['message']);
//     } else {
//       Get.rawSnackbar(
//         padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//         messageText: Center(
//           child: Text(response['message'],
//               style: TextStyle(color: Colors.white)),
//         ),
//       );
//     }
//   }
// }
}

class PreviousRemarksDialog extends StatelessWidget {
  // final String screenType;
  // final String vehiclePart;

  const PreviousRemarksDialog({
    super.key,
    // required this.screenType,
    // required this.vehiclePart,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RemarksController());
    return IconButton(
      icon: const Icon(Icons.remove_red_eye, color: Colors.black),
      onPressed: () {
        controller.viewRemarks();
        Get.dialog(
          Dialog(
            // insetPadding: EdgeInsets.all(mq.width*.06), // removes default margins
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Previous Remarks",
                          style: TextStyle(color: Colors.black87, fontSize: 18),
                        ),
                        InkWell(
                          onTap: () => Navigator.of(context).pop(),
                          child: Container(
                            height: 25,
                            width: 25,
                            color: Colors.red,
                            child: const Icon(
                              Icons.close,
                              size: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Center(
                      child: Obx(() {
                        if (controller.remarksLoading.value) {
                          return CircularProgressIndicator();
                        }
                        final err = controller.remarksError.value;
                        if (err != null) {
                          return AppErrorText(error: controller.remarksError);
                          // return CustomErrorMsg(text: err);
                        }
                        final remarks = controller.viewRemarksList;
                        return ReusableTable(
                          headers: ["Date", "Remarks", "Added By"],
                          rows: remarks.map((item) {
                            final date =
                                TransformValue().formatDateToIndianDate(
                              item["CreatedAt"],
                              day: true,
                            );
                            return [date, item["Remark"], item["CreatedBy"]];
                          }).toList(),
                          columnWidths: [
                            // FixedColumnWidth(mq.width * .21),
                            // FixedColumnWidth(mq.width * .26),
                            IntrinsicColumnWidth(),
                            FixedColumnWidth(mq.width * .25),
                            IntrinsicColumnWidth(),
                            // const IntrinsicColumnWidth(), // 0th column -> auto width
                            // const FlexColumnWidth(),      // 1st column -> take remaining
                            // const IntrinsicColumnWidth(), // 2nd column -> auto width
                          ],
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class RemarksBottomSheet extends StatefulWidget {
  final String titleText;
  final Map<String, dynamic> item;
  final String screen;
  const RemarksBottomSheet({
    super.key,
    required this.titleText,
    required this.item,
    required this.screen,
  });

  @override
  State<RemarksBottomSheet> createState() => _RemarksBottomSheetState();
}

class _RemarksBottomSheetState extends State<RemarksBottomSheet> {
  RemarksController controller = Get.put(RemarksController());
  final _formKey = GlobalKey<FormState>();
  final _selectRFormKey = GlobalKey<FormState>();
  @override
  void initState() {
    controller.storeData(widget.titleText, widget.item, widget.screen);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final controller = Get.put(RemarksController(), permanent: false);
    // controller.reset();

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Add Your Remarks",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          // Text(widget.titleText),
          Text(controller.titleText.value),
          const SizedBox(height: 5),

          // Dropdown + Eye Icon
          Row(
            children: [
              Expanded(
                child: Center(
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return CircularProgressIndicator();
                    }
                    if (controller.error.value != null) {
                      return AppErrorText(error: controller.error);
                      // return CustomErrorMsg(text: controller.error.value ?? "");
                      // return Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      //   children: [
                      //     CustomErrorMsg(text: controller.error.value ?? ""),
                      //     RotatingRefreshIcon(
                      //         color: DMAppColors.secondary,
                      //         isRotating: controller.isLoading.value,
                      //         onRefresh: () async =>
                      //             controller.fetchDropRemarks("P")),
                      //   ],
                      // );
                    }
                    final remarksList = controller
                        .remarksItems; // keep full list, not just Remark

                    return Form(
                        key: _selectRFormKey,
                        child: DmDropdown(
                          hintText: "Select Remarks",
                          options: remarksList
                              .map((item) => item['Remark'].toString())
                              .toList(),
                          selectedValue: controller.selectedRemark.value,
                          // controller.selectedRemark.value.isNotEmpty
                          //     ? controller.selectedRemark.value
                          //     : null,
                          onChanged: (value) {
                            _selectRFormKey.currentState!.validate();
                            // Find selected item by Remark
                            controller.isOtherSelected.value =
                                value == 'Others';
                            if (value != null) {
                              final selectedItem = controller.remarksItems
                                  .firstWhere(
                                      (item) => item['Remark'] == value);

                              // Store Id instead of Remark
                              controller.selectedRemarkId.value =
                                  selectedItem['Id'];
                              controller.selectedRemark.value =
                                  selectedItem['Remark'];
                            } else {
                              controller.selectedRemark.value = value;
                              controller.selectedRemarkId.value = null;
                            }
                          },
                          validator: (val) => val == null || val.isEmpty
                              ? 'Please enter remarks'
                              : null,
                        ));

                    // final remarksList = controller.remarksItems
                    //     .map((item) => item['Remark'].toString())
                    //     .toList();
                    // return CustomDropdown(
                    //   hintText: "Select Remarks",
                    //   options: remarksList,
                    //   selectedValue: controller.selectedRemark.value,
                    //   onChanged: (value) {
                    //     print("value::: $value");
                    //     controller.selectedRemark.value = value;
                    //     controller.isOtherSelected.value = value == 'Others';
                    //   },
                    // );
                  }),
                ),
              ),
              const SizedBox(width: 10),
              PreviousRemarksDialog(
                  // vehiclePart: "controller.item",
                  // screenType: controller.screen.value ?? "",
                  ),
            ],
          ),

          const SizedBox(height: 10),
          // Other Text Field
          Obx(
            () => controller.isOtherSelected.value
                ? Form(
                    key: _formKey,
                    child: DmTextFormField(
                      controller: controller.textEditingController,
                      text: 'Type Here...',
                      validator: (val) => val == null || val.isEmpty
                          ? 'Please enter remarks'
                          : null,
                      // onChanged: (val) {
                      //   // Re-validate to remove warning if fixed
                      //   if (_formKey.currentState != null) {
                      //     _formKey.currentState!.validate();
                      //   }
                      // },
                      onChanged: (val) async {
                        // 1. Validate form only if mounted
                        _formKey.currentState?.validate();

                        // 2. Skip if empty (optional)
                        if (val.isEmpty) return;

                        // 3. Sanitize/validate input
                        final filteredValue =
                            await GainerTextFiledValidator.remarksValidation(val);

                        // 4. Only update if value actually changed
                        if (val != filteredValue &&
                            controller.textEditingController.text !=
                                filteredValue) {
                          // Keep cursor at end after updating
                          final cursorPos = filteredValue.length;
                          controller.textEditingController.value =
                              TextEditingValue(
                            text: filteredValue,
                            selection:
                                TextSelection.collapsed(offset: cursorPos),
                          );
                        }
                      },
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(
                            200), // ✅ max 200 chars
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
          ),

          const SizedBox(height: 10),

          // Submit Button
          Column(
            children: [
              const SizedBox(height: 10),
              // Capture Advance Receipt
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Capture Advance Receipt",
                    style: TextStyle(fontSize: 16),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.camera_alt_outlined,
                      color: DMAppColors.secondary,
                    ),
                    // onPressed: () => Get.off(() => ImagePickScreen()),
                    onPressed: () {
                      if (controller.selectedRemarkId.value == 0) {
                        if (_formKey.currentState!.validate()) {
                          showCustomBottomSheet();
                        }
                      } else {
                        showCustomBottomSheet();
                      }
                    },
                  ),
                ],
              ),
              Obx(() {
                if (controller.isSubmitting.value) {
                  return const CircularProgressIndicator();
                }
                return DmElevatedButton(
                  text: "Submit",
                  onTap: () {
                    if (controller.selectedRemarkId.value == 0) {
                      if (_formKey.currentState!.validate()) {
                        controller.onSubmit();
                      }
                    } else {
                      // if(controller.selectedRemark.value != null) {
                      if (_selectRFormKey.currentState!.validate()) {
                        controller.onSubmit();
                      }
                    }
                  },
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  /// Bottom sheet to select image source
  void showCustomBottomSheet() {
    GainerBottomSheet.show(
      isGainer: false,
      context: context,
      onPressedCamera: () {
        _pickImage(ImageSource.camera);
        Get.back();
      },
      onPressedGallery: () {
        _pickImage(ImageSource.gallery);
        Get.back();
      },
    );
  }

  /// Image picker function
  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: source);
    // print('Source: $source, image: ${image?.name}');
    if (image != null) {
      final imagePath = File(image.path);
      controller.setImage(image.path);
      Get.to(() => ImagePickScreen(), arguments: {"imagePath": imagePath});
    }
  }
}
