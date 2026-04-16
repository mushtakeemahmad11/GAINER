import 'package:flutter/material.dart';
import 'package:gainer/gainer_app/core/utils/gainer_text_filed_validator.dart';
import 'package:gainer/gainer_app/core/widgets/gainer_app_loader.dart';
import 'package:gainer/gainer_app/core/widgets/gainer_primary_button.dart';
import 'package:gainer/gainer_app/core/widgets/gainer_text_form_field.dart';
import 'package:gainer/gainer_app/modules/action_as_buyer/update_po_view/models/update_po_model.dart';
import 'package:gainer/gainer_app/modules/action_as_buyer/update_po_view/update_po_controller.dart';
import 'package:get/get.dart';
import '../../../../core/widgets/gainer_app_bar.dart';
import '../../../../core/widgets/gainer_toggle_outlined_btn.dart';

class UpdatePoRejectView extends GetView<UpdatePoController> {
  final UpdatePoModel order;
  const UpdatePoRejectView({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      // backgroundColor: GainerColors.background,
      appBar: GainerAppBar(title: 'Why are you reject', showIcon: false),
      // appBar: AppBar(
      //   title: const Text('Why are you reject'),
      // titleTextStyle: TextStyle(fontSize: 18),
      //   backgroundColor: GainerColors.primary,
      // ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.02, vertical: size.height * 0.02),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Generate Toggle Buttons dynamically
                  ...controller.toggleButtons.map((button) => Padding(
                        padding: EdgeInsets.only(bottom: size.height * 0.01),
                        child: Obx(() => Row(
                              children: [
                                Expanded(
                                  child: GainerToggleOutlineBtn(
                                    text: button['text'],
                                    isActive:
                                        controller.getState(button['state']),
                                    onToggle: () => controller
                                        .toggleSelection(button['state']),
                                  ),
                                ),
                              ],
                            )),
                      )),
                  SizedBox(height: size.height * 0.02),

                  // Remarks TextField
                  GainerTextFormField(
                    controller: controller.rejectRemarksCtrl,
                    label: 'Enter Remarks',
                    suffixIcon: IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: controller.rejectRemarksCtrl.clear,
                    ),
                    onChanged: (value) async {
                      // Allow only letters, numbers, spaces, dashes (-), and commas (,)
                      String filteredValue =
                          await GainerTextFiledValidator.remarksValidation(
                              value);
                      if (value != filteredValue) {
                        controller.rejectRemarksCtrl.text = filteredValue;
                      }
                    },
                  ),
                  SizedBox(height: size.height * 0.03),

                  // Submit Button
                  GainerPrimaryButton(
                    onPressed: () =>
                        controller.onRejectSubmitBtn(context, order),
                    title: 'Submit',
                  ),
                ],
              ),
            ),
          ),
          GainerAppLoader(isLoading: controller.isRejectLoading),
        ],
      ),
    );
  }
}
