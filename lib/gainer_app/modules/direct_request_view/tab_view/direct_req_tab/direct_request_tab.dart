import 'package:flutter/material.dart';
import 'package:gainer/gainer_app/core/utils/input_formatters.dart';
import 'package:gainer/gainer_app/core/widgets/gainer_app_loader.dart';
import 'package:gainer/gainer_app/core/widgets/gainer_dropdown.dart';
import 'package:gainer/gainer_app/core/widgets/gainer_outlined_button.dart';
import 'package:gainer/gainer_app/core/widgets/gainer_primary_button.dart';
import 'package:gainer/gainer_app/core/widgets/gainer_text_form_field.dart';
import 'package:gainer/gainer_app/core/widgets/part_suggestion_list.dart';
import 'package:get/get.dart';
import 'direct_request_controller.dart';
import '../../widgets/part_details_card.dart';

class DirectRequestTab extends GetView<DirectRequestController> {
  const DirectRequestTab({super.key});

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
              child: Column(
                children: [
                  _FormSection(),
                  const SizedBox(height: 10),
                  const _PartListSection(),
                  const SizedBox(height: 5),
                  _SubmitRequest(),
                ],
              ),
            ),
          ),
          GainerAppLoader(isLoading: controller.isLoading)
        ],
      );
    });
  }
}

class _FormSection extends GetView<DirectRequestController> {
  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 5,
      children: [
        _partField(),
        _buildPartSuggestion(),
        _dealerLocationRow(),
        _orderQtyRow(),
        _remarksField(),
        _addButton(),
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

  Widget _dealerLocationRow() {
    return Row(
      children: [
        Expanded(child: _dealerDropdown()),
        const SizedBox(width: 6),
        Expanded(child: _locationDropdown()),
      ],
    );
  }

  Widget _dealerDropdown() {
    return Obx(() {
      final items = controller.dealerList.map((e) => e.dealer).toList();

      return GainerAppDropdown(
        hintText: 'Select Dealer',
        items: items,
        selectedItem: items.contains(controller.selectedDealer.value)
            ? controller.selectedDealer.value
            : null,
        onChanged: controller.onDealerChanged,
      );
    });
  }

  Widget _locationDropdown() {
    return Obx(() {
      final items = controller.locationList.map((e) => e.location).toList();

      return GainerAppDropdown(
        hintText: 'Select Location',
        items: items,
        selectedItem: items.contains(controller.selectedLocation.value)
            ? controller.selectedLocation.value
            : null,
        onChanged: controller.onLocationChanged,
      );
    });
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
      controller: controller.qtyCtrl,
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

  Widget _addButton() {
    return Obx(() {
      return Align(
        alignment: Alignment.centerRight,
        child: GainerPrimaryButton(
          isLoading: controller.isPartAdding.value,
          width: 100,
          icon: Icons.add,
          onPressed:
              controller.isAddEnabled.value ? controller.onTapAddPart : null,
        ),
      );
    });
  }
}

class _PartListSection extends GetView<DirectRequestController> {
  const _PartListSection();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final parts = controller.parts;

      // if (parts.isEmpty) {
      //   return const Center(child: Text("No parts added"));
      // }

      return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: parts.length,
        itemBuilder: (_, index) {
          final part = parts[index];
          return PartDetailsCard(
            order: part,
            onRemove: () => controller.removePart(index),
            // onRemove: () => controller.parts.removeAt(index),
          );
        },
      );
    });
  }
}

class _SubmitRequest extends GetView<DirectRequestController> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Obx(() {
        if (controller.parts.isEmpty) {
          return const SizedBox.shrink();
        }
        return GainerPrimaryButton(
          onPressed: controller.submitDirectRequest,
          title: 'Submit',
        );
      }),
    );
  }
}
