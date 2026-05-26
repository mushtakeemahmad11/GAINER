import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import '../../../../core/utils/input_formatters.dart';
import '../../../../core/widgets/gainer_app_loader.dart';
import '../../../../core/widgets/gainer_dropdown.dart';
import '../../../../core/widgets/gainer_outlined_button.dart';
import '../../../../core/widgets/gainer_primary_button.dart';
import '../../../../core/widgets/gainer_text_form_field.dart';
import '../../../../core/widgets/part_suggestion_list.dart';
import 'scs_request_controller.dart';

class ScsInform extends GetView<ScsRequestController> {
  const ScsInform({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isError.value) {
        return Center(
          child: GainerOutlinedButton(
              onPressed: controller.initWork, title: 'Refresh'),
        );
      }
      return Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: _FormSection(),
            ),
          ),
          GainerAppLoader(isLoading: controller.isLoading)
        ],
      );
    });
  }
}

class _FormSection extends GetView<ScsRequestController> {
  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 5,
      children: [
        _partField(),
        _buildPartSuggestion(),
        _descMrpRateWidget(),
        _orderQtyRow(),
        _remarksField(),
        _submitButton(),
      ],
    );
  }

  Widget _partField() {
    return GainerTextFormField(
      labelColor: Colors.black45,
      label: 'Enter part No.',
      controller: controller.partNoCtrl,
      inputFormatters: [GainerInputFormatters.partNumber],
      onChanged: (value) => controller.onPartFieldChanged(value),
    );
  }

  Widget _buildPartSuggestion() {
    return Obx(() {
      return PartSuggestionList(
        isLoading: controller.partSearchLoading.value,
        suggestions: controller.partSuggestions.toList(),
        onTap: (selected) => controller.selectPartNumber(selected),
      );
    });
  }

  Widget _descMrpRateWidget() {
    return Column(
      spacing: 5,
      children: [
        _partDescField(),
        Row(
          children: [
            Expanded(child: _mrpField()),
            const SizedBox(width: 6),
            Expanded(child: _rateField()),
          ],
        ),
      ],
    );
  }

  Widget _partDescField() {
    return GainerTextFormField(
      labelColor: Colors.black45,
      label: 'Enter part Desc.',
      controller: controller.partDescCtrl,
      readOnly: true,
      // inputFormatters: [GainerInputFormatters.partNumber],
      // onChanged: (value) => controller.onDescFieldChanged(value),
    );
  }

  Widget _mrpField() {
    return GainerTextFormField(
      labelColor: Colors.black45,
      label: 'MRP',
      controller: controller.partMRPCtrl,
      readOnly: true,
      keyboardType: TextInputType.number,
      inputFormatters: [GainerInputFormatters.positiveNumbers],
      // inputFormatters: [
      //   FilteringTextInputFormatter.allow(RegExp(r'[1-9][0-9]*')),
      // ],
      // onChanged: (value) => controller.onMrpFieldChanged(value),
    );
  }

  Widget _rateField() {
    return GainerTextFormField(
      labelColor: Colors.black45,
      label: 'Rate',
      controller: controller.partRateCtrl,
      readOnly: true,
      keyboardType: TextInputType.number,
      inputFormatters: [GainerInputFormatters.positiveNumbers],
      // onChanged: (value) => controller.onRateFieldChanged(value),
    );
  }

  Widget _orderQtyRow() {
    return Row(
      children: [
        Expanded(child: _orderTypeDropdown()),
        const SizedBox(width: 6),
        Expanded(child: _qtyField()),
      ],
    );
  }

  Widget _orderTypeDropdown() {
    return Obx(() {
      final items = controller.orderTypeList.map((e) => e.orderFor).toList();

      return GainerAppDropdown(
        hintText: 'Order Type',
        items: items,
        selectedItem: items.contains(controller.selectedOrderType.value)
            ? controller.selectedOrderType.value
            : null,
        onChanged: controller.onOrderTypeChanged,
      );
    });
  }

  Widget _qtyField() {
    return GainerTextFormField(
      labelColor: Colors.black45,
      label: 'Qty',
      controller: controller.partQtyCtrl,
      keyboardType: TextInputType.number,
      inputFormatters: [GainerInputFormatters.positiveNumbers],
    );
  }

  Widget _remarksField() {
    return GainerTextFormField(
      labelColor: Colors.black45,
      label: 'Remarks',
      controller: controller.remarkCtrl,
      onChanged: controller.onRemarksChanges,
    );
  }

  Widget _submitButton() {
    return Obx(() {
      return Align(
        alignment: Alignment.centerRight,
        child: GainerPrimaryButton(
          // isLoading: controller.isPartAdding.value,
          width: 150,
          title: 'Submit',
          // onPressed: controller.submitScsRequest,
          onPressed: controller.isSubmitEnabled.value
              ? controller.submitScsRequest
              : null,
        ),
      );
    });
  }
}
