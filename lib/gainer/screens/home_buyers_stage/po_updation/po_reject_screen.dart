import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../main.dart';
import '../../../apis_functionality/api_service.dart';
import '../../../apis_functionality/send_notification_service.dart';
import '../../../controllers/buyer_controller/po_reject_controller.dart';
import '../../../controllers/check_internet/no_internet_screen.dart';
import '../../../shared_preferences/shared_preferences_get_data.dart';
import '../../../utility/controller_utils.dart';
import '../../../widget/bottomsheet_for_picture.dart';
import '../../../widget/circular_progress_indicator.dart';
import '../../../widget/dialog.dart';
import '../../../widget/reusable_elevated_button.dart';
import '../../../widget/reusable_widget.dart';
import '../../../widget/toggle_outline_button.dart';
import '../../check_internet/check_internet_connectivity.dart';
import '../../colors.dart';
import '../../constant_image_path.dart';

class PoRejectScreen extends StatefulWidget {
  final int bigId;
  final int freeStock;
  final String sellerLocationID;
  final String sellerDealerName;
  final String partNumber;

  const PoRejectScreen({
    super.key,
    required this.bigId,
    required this.freeStock,
    required this.sellerLocationID,
    required this.sellerDealerName,
    required this.partNumber,
  });

  @override
  State<PoRejectScreen> createState() => _PoRejectScreenState();
}

class _PoRejectScreenState extends State<PoRejectScreen> {
  // final PoUpdationController _poUpdationController = Get.put(PoUpdationController());
  final PoRejectController _controller = Get.put(PoRejectController());
  final TextEditingController _remarksController = TextEditingController();

  void toggleSelection(String selectedState) {
    _controller.updateSelection(selectedState);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Why are you reject')),
      body: Stack(
        children: [
          _controller.isLoading.value != true
              ? Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: mq.width * 0.02, vertical: mq.height * 0.02),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // Generate Toggle Buttons dynamically
                        ..._controller.toggleButtons.map((button) => Padding(
                              padding:
                                  EdgeInsets.only(bottom: mq.height * 0.01),
                              child: Obx(() => Row(
                                    children: [
                                      Expanded(
                                        child: ToggleOutlineButton(
                                          text: button['text'],
                                          isActive: _controller
                                              .getState(button['state']),
                                          onToggle: () =>
                                              toggleSelection(button['state']),
                                        ),
                                      ),
                                    ],
                                  )),
                            )),
                        SizedBox(height: mq.height * 0.02),

                        // Remarks TextField
                        CustomTextFormField(
                          controller: _remarksController,
                          text: 'Enter Remarks',
                          suffixIcon: Icon(Icons.edit, color: AppColor.primary),
                          onChanged: (value) async {
                            // // Allow only letters, numbers, spaces, dashes (-), and commas (,)
                            String filteredValue =
                                await ControllerUtils.remarksValidation(value);
                            if (value != filteredValue) {
                              _remarksController.text = filteredValue;
                            }
                          },
                        ),
                        SizedBox(height: mq.height * 0.03),

                        // Submit Button
                        CustomElevatedButton(
                          onTap: () => _onSubmitBtn(),
                          text: 'Submit',
                        ),
                      ],
                    ),
                  ),
                )
              : customCircularProgressIndicator(),
        ],
      ),
    );
  }

  //click on submit for POReject
  _onSubmitBtn() {
    String? selectedIssue = _controller.getSelectedIssue();
    String remarks = _remarksController.text;
    if (selectedIssue == null) {
      CustomBottomSheet.showSnackBar(context, 'Please select one issue');
      return;
    }
    AppDialog.dialogForYesNo(
        'Are you sure to reject Purchased Order', AppImages.decisionMaking,
        () async {
      Get.back();
      _controller.isLoading.value = true;
      if (await checkInternet()) {
        final response = await ApiService().poReject(
          freeStock: widget.freeStock.toString(),
          rejectReason: selectedIssue,
          remarks: remarks,
          bigID: widget.bigId.toString(),
        );
        _controller.isLoading.value = false;
        if (response['success']) {
          // Get.off(()=>const PoUpdationScreen());
          Get.back();
          AppDialog.midPopUp(AppImages.reject, response['data']);

          String selectedLocationName =
              await getStringData("selectedLocationName") ?? "";
          // await SendNotification.notifyDealerUsers(
          //     widget.sellerLocationID,
          //     // "Manifestation Awaited",
          //     "PO Reject",
          //     "PO Rejected By $selectedLocationName, reason $selectedIssue, please check",
          //     {});
          await SendNotification.notifyDealerUsers(
              widget.sellerLocationID,
              "Purchase Order (REJECTED)",
              " Part: ${widget.partNumber}\n"
                  "Buyer: ${widget.sellerDealerName}, $selectedLocationName\n"
                  "Pl do Invoice & manifest details",
              {});

          // // Close the dialog after 3 seconds
          // Future.delayed(const Duration(seconds: 3), () {
          //   if (Get.isDialogOpen ?? false) {
          //     Get.back(); // Close the dialog
          //   }
          // });
        } else {
          CustomBottomSheet.showSnackBar(context, response['message']);
        }
      } else {
        Get.to(() => NoInternetScreen());
      }
    }, () {
      Get.back();
    });
  }
}
