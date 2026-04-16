import 'package:flutter/material.dart';
import 'package:gainer/gainer_app/core/utils/gainer_text_filed_validator.dart';
import 'package:gainer/gainer_app/core/widgets/gainer_primary_button.dart';
import 'package:gainer/gainer_app/core/widgets/gainer_secondary_button.dart';
import 'package:gainer/gainer_app/core/widgets/gainer_text_form_field.dart';
import 'package:gainer/gainer_app/modules/action_as_buyer/update_po_view/models/update_po_model.dart';
import 'package:get/get.dart';
import '../../../../core/constants/gainer_color.dart';
import '../models/order_received_model.dart';
import '../order_received_controller.dart';
import '../screens/order_received_reject_view.dart';

class ORBtnRow extends GetView<OrderReceivedController> {
  final OrderReceivedModel order;
  final TextEditingController reqCtrl;
  final TextEditingController remCtrl;
  const ORBtnRow({
    super.key,
    required this.order,
    required this.reqCtrl,
    required this.remCtrl,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _actionBtn(
            'Upload Image', () => controller.uploadImage(order, context), size),
        // _actionBtn('Upload Image', () {
        //   print("ISSHOWIMAGES: ${controller.isShowImage.value}");
        //   controller.toggleImage();
        // }, size),
        _actionBtn(
          'Accept Order',
          () => controller.onTapAccept(remCtrl, order, reqCtrl, context),
          size,
        ),
        _actionBtn('Reject Order', () {
          Get.to(() => OrderReceivedRejectView(order: order));
        }, size),
      ],
    );
    // return Row(
    //   spacing: 10,
    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //   children: [
    //     _actionBtn(
    //         'view image', () => controller.gotoPartImageScreen(order), size,
    //         isDisableColors: isNotImage),
    //     Obx(
    //       () => _actionBtn(
    //         'Accept',
    //         () {
    //           String qtyController = accCtrl.text;
    //           if (qtyController.isEmpty || qtyController == '0') {
    //             GainerBottomSheet.showSnackBar(
    //                 context, "Please fill Qty greater than 0");
    //           } else {
    //             controller.toggleAccept(order, int.parse(accCtrl.text));
    //           }
    //         },
    //         size,
    //         isAccepted: controller.isAccepted(order),
    //       ),
    //     ),
    //     _actionBtn('Reject', () {
    //       controller.removeAcceptedOrder(order.bigId.toString());
    //       Get.to(() => UpdatePoRejectView(order: order));
    //     }, size),
    //     _actionBtn('Further Remarks',
    //         () => showFurtherDetailsBottomSheet(context, order, size), size),
    //   ],
    // );
  }

  Widget _actionBtn(String text, VoidCallback onTap, Size size) {
    return SizedBox(
      width: size.width * .25,
      // height: 30,
      child: GainerSecondaryButton(onTap: onTap, title: text),
    );
  }

  void showFurtherDetailsBottomSheet(
      BuildContext context, UpdatePoModel order, Size size) {
    // controller.removeAcceptedOrder(order.bigId.toString());
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
                        // isLoading: controller.isFRLoading.value,
                        title: 'Submit',
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            // Get.back();
                            // controller.onSubmitFurtherDetails(
                            //   order.bigId.toString(),
                            //   remarksCtrl.text.trim(),
                            //   order.sellerLocationId.toString(),
                            //   order.partNumber,
                            //   context,
                            // );
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
  }

/*
  Future<void> _onClickThumbUp(UpdatePoModel order, Size size) async {
    final formKey = GlobalKey<FormState>();
    final TextEditingController poNumberCtrl = TextEditingController();
    final TextEditingController remarksCtrl = TextEditingController();

    Get.bottomSheet(
      SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Drag handle
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                Text(
                  'Raise PO',
                  style: Theme.of(Get.context!).textTheme.titleMedium,
                ),

                const SizedBox(height: 2),

                Text('Part Number: ${order.partNumber}'),

                const SizedBox(height: 16),

                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      /// PO NUMBER
                      GainerTextFormField(
                        isDense: false,
                        controller: poNumberCtrl,
                        label: 'Enter PO Number',
                        validator: (value) => value == null || value.isEmpty
                            ? 'Please enter PO Number'
                            : null,
                        onChanged: (value) {
                          String filtered =
                              value.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '');

                          if (filtered.length > 10) {
                            filtered = filtered.substring(0, 10);
                          }

                          if (filtered != value) {
                            poNumberCtrl
                              ..text = filtered
                              ..selection = TextSelection.collapsed(
                                  offset: filtered.length);
                          }
                        },
                      ),

                      SizedBox(height: size.height * .015),

                      /// REMARKS
                      GainerTextFormField(
                        isDense: false,
                        controller: remarksCtrl,
                        label: 'Enter Remarks',
                        validator: (value) => value == null || value.isEmpty
                            ? 'Please enter remarks'
                            : null,
                        onChanged: (value) async {
                          final filtered =
                              await GainerTextFiledValidator.remarksValidation(
                                  value);

                          if (filtered != value) {
                            remarksCtrl
                              ..text = filtered
                              ..selection = TextSelection.collapsed(
                                  offset: filtered.length);
                          }
                        },
                      ),
                    ],
                  ),
                ),

                SizedBox(height: size.height * .03),

                GainerPrimaryButton(
                  title: 'Submit',
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      Get.back();
                      // controller.onSubmitPoRaised(
                      //   poNumberCtrl.text,
                      //   sellerLocationId,
                      //   partNumber,
                      //   context,
                      // );

                      /// Call API / Controller here
                      // controller.onSubmitPoRaised(
                      //   poNumberCtrl.text,
                      //   order.sellerLocationId.toString(),
                      //   order.partNumber,
                      // );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }*/
}
