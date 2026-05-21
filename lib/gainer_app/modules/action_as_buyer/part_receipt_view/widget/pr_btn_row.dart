import 'package:flutter/material.dart';
import 'package:gainer/gainer_app/core/widgets/gainer_dialog.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import '../../../../core/widgets/gainer_secondary_button.dart';
import '../models/part_receipt_model.dart';
import '../part_receipt_controller.dart';

class PRBtnRow extends GetView<PartReceiptController> {
  final PartReceiptModel order;
  const PRBtnRow({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool isBtnDisable =
        order.companyCode == 3 ? false : order.deliverStatus.startsWith('N');
    // bool isNotDel = order.deliverStatus.startsWith('N');
    return Row(
      spacing: 10,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _actionBtn(
          'Download Invoice',
          () => GainerDialog.invoiceDownloadPopUp(context, order.invoiceCopy),
          size,
        ),
        _actionBtn(
          'Track \nOrder',
          () => controller.onTapBtn(
            'Do you want to track order',
            () => controller.onTapTrackOrder(
              order.lrNumber,
              order.companyCode,
              order.bufferAction,
              context,
            ),
          ),
          size,
        ),
        _actionBtn(
          'Happy To Received',
          () => controller.onTapBtn(
            'Are you sure to received order',
            () => controller.onTapReceived(order.bigid.toString()),
          ),
          size,
          // isDisable: isNotDel,
          isDisable: isBtnDisable,
        ),
        _actionBtn('Raised Concern',
            () => controller.onTapRaisedConcern(order.bigid), size),
      ],
    );
  }

  Widget _actionBtn(String text, VoidCallback onTap, Size size,
      {bool isDisable = false}) {
    return SizedBox(
      width: size.width * .2,
      // height: 30,
      child: GainerSecondaryButton(
        onTap: onTap,
        title: text,
        isDisableTap: isDisable,
      ),
      // child: ElevatedButton(
      //   style: ButtonStyle(
      //     backgroundColor: WidgetStatePropertyAll(Colors.white54),
      //     padding: WidgetStatePropertyAll(
      //         EdgeInsets.symmetric(horizontal: 6, vertical: 4)),
      //     shape: WidgetStateProperty.all<RoundedRectangleBorder>(
      //       RoundedRectangleBorder(
      //         borderRadius: BorderRadius.circular(8.0),
      //       ),
      //     ),
      //   ),
      //   onPressed: onTap,
      //   child: Text(
      //     text,
      //     textAlign: TextAlign.center,
      //     style: TextStyle(fontSize: 12, color: Colors.black),
      //   ),
      // ),
    );
  }

  /*void showFurtherDetailsBottomSheet(
      BuildContext context, UpdatePoModel order, Size size) {
    controller.removeAcceptedOrder(order.bigId.toString());
    final formKey = GlobalKey<FormState>();
    final TextEditingController remarksCtrl = TextEditingController();
    Get.bottomSheet(
      SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: GainerColors.background,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// Drag Handle
                  Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),

                  /// Title
                  Text(
                    'Further Details',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),

                  const SizedBox(height: 2),

                  /// Part Number
                  Text('Part Number: ${order.partNumber}'),

                  const SizedBox(height: 16),

                  /// Form
                  Form(
                    key: formKey,
                    child: GainerTextFormField(
                      isDense: false,
                      controller: remarksCtrl,
                      label: 'Enter Remarks',
                      validator: (value) => value == null || value.isEmpty
                          ? 'Please enter remarks'
                          : null,
                      onChanged: (value) async {
                        final filteredValue =
                            await GainerTextFiledValidator.remarksValidation(
                                value);
                        if (value != filteredValue) {
                          remarksCtrl
                            ..text = filteredValue
                            ..selection = TextSelection.collapsed(
                              offset: filteredValue.length,
                            );
                        }
                      },
                    ),
                  ),

                  SizedBox(height: size.height * .02),

                  /// Submit Button
                  Obx(() => GainerPrimaryButton(
                        isLoading: controller.isFRLoading.value,
                        title: 'Submit',
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            // Get.back();
                            controller.onSubmitFurtherDetails(
                              order.bigId.toString(),
                              remarksCtrl.text.trim(),
                              order.sellerLocationId.toString(),
                              order.partNumber,
                              context,
                            );
                          }
                        },
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }*/
}
