import 'package:flutter/material.dart';
import '../../../../main.dart';
import 'package:get/get.dart';
import '../../../apis_functionality/api_service.dart';
import '../../../apis_functionality/send_notification_service.dart';
import '../../../controllers/check_internet/no_internet_screen.dart';
import '../../../controllers/seller_controller/order_received_controller.dart';
import '../../../shared_preferences/shared_preferences_get_data.dart';
import '../../../utility/controller_utils.dart';
import '../../../widget/bottomsheet_for_picture.dart';
import '../../../widget/circular_progress_indicator.dart';
import '../../../widget/dialog.dart';
import '../../../widget/reusable_elevated_button.dart';
import '../../../widget/reusable_widget.dart';
import '../../../widget/toggle_outline_button.dart';
import '../../check_internet/check_internet_connectivity.dart';
import '../../constant_image_path.dart';

class RejectOrderScreen extends StatefulWidget {
  final int bigId;
  final int freeStock;
  final String partNumber;
  final String stockCatType;
  final String sellerLocationID;
  final int loginUserID;
  final String buyerLocationID;
  final String dealerName;

  const RejectOrderScreen({
    super.key,
    required this.bigId,
    required this.freeStock,
    required this.partNumber,
    required this.stockCatType,
    required this.sellerLocationID,
    required this.loginUserID,
    required this.buyerLocationID,
    required this.dealerName,
  });

  @override
  State<RejectOrderScreen> createState() => _RejectOrderScreenState();
}

class _RejectOrderScreenState extends State<RejectOrderScreen> {
  final RejectOrderController _controller = Get.put(RejectOrderController());
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
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: mq.width * 0.02, vertical: mq.height * 0.02),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Generate Toggle Buttons dynamically
                  ..._controller.toggleButtons.map((button) => Padding(
                        padding: EdgeInsets.only(bottom: mq.height * 0.01),
                        child: Obx(() => Row(
                              children: [
                                Expanded(
                                  child: ToggleOutlineButton(
                                    text: button['text'],
                                    isActive:
                                        _controller.getState(button['state']),
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
                    // suffixIcon: Icon(Icons.edit, color: AppColor.primary),
                    onChanged: (value) async {
                      // Allow only letters, numbers, spaces, dashes (-),commas (,), and Full Stop(.)
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
          ),
          Obx(() => _controller.isLoading.value
              ? customCircularProgressIndicator()
              : const SizedBox.shrink())
        ],
      ),
    );
  }

  //click on submit for rejected order
  _onSubmitBtn() {
    String? selectedIssue = _controller.getSelectedIssue();
    String remarks = _remarksController.text;
    AppDialog.dialogForYesNo('Are you sure to reject order', AppImages.decisionMaking,
        () async {
      Get.back();
      _controller.isLoading.value = true;
      if (await checkInternet()) {
        final response = await ApiService().orderDueReject(
          bigID: widget.bigId.toString(),
          remarks: remarks,
          rejectReason: selectedIssue??"Null",
          freeStock: widget.freeStock.toString(),
          partNumber: widget.partNumber,
          stockCatType: widget.stockCatType,
          sellerLocationID: widget.sellerLocationID,
          loginUserID: widget.loginUserID.toString(),
        );
        _controller.isLoading.value = false;
        if (response['success']) {
          Get.back(result: true);
          AppDialog.midPopUp(AppImages.reject, response['data']);

          ///send notification to buyer
          String selectedLocationName =
              await getStringData("selectedLocationName") ?? "";
          // await SendNotification.notifyDealerUsers(
          //     widget.buyerLocationID,
          //     // "PO Awaited",
          //     "Order Rejected",
          //     "Part number ${widget.partNumber} rejected by Seller $selectedLocationName Reason $selectedIssue",
          //     {});
          await SendNotification.notifyDealerUsers(
              widget.buyerLocationID,
              "Order Request (REJECTED)",
              "Part ${widget.partNumber}\n"
                  "Seller: ${widget.dealerName}, $selectedLocationName\n"
                  "Reason: $selectedIssue\n"
                  "Pl place order request to another Seller",
              {});
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
