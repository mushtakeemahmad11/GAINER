import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/utils/input_formatters.dart';
import '../../../../core/widgets/gainer_dropdown.dart';
import '../../../../core/widgets/gainer_text_form_field.dart';
import '../dr_received_controller.dart';
import '../models/dr_received_model.dart';

class DiscountStockDropdownRow extends GetView<DrReceivedController> {
  final DrReceivedModel order;
  const DiscountStockDropdownRow({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      spacing: 5,
      children: [
        Expanded(
          flex: 1,
          child: GainerTextFormField(
            label: 'Discount',
            controller: order.discountCtl,
            keyboardType: TextInputType.number,
            inputFormatters: [GainerInputFormatters.discountFormatter],
            validator: (val) => val == null || val.isEmpty ? 'Mandatory' : null,
          ),
        ),
        Expanded(
          flex: 1,
          child: GainerTextFormField(
            label: 'Stock',
            controller: order.stockCtl,
            keyboardType: TextInputType.number,
            inputFormatters: [GainerInputFormatters.stockFormatter],
            validator: (val) => val == null || val.isEmpty ? 'Mandatory' : null,
          ),
        ),
        Expanded(
          flex: 2,
          child: GainerAppDropdown(
            hintText: 'Stock Type',
            items:
                controller.stockQualityList.map((e) => e.stockQuality).toList(),
            onChanged: (val) => controller.onStockQualityChanged(order, val),
            validator: (val) =>
                val == null || val.isEmpty ? 'Please select stock type' : null,
          ),
        ),
      ],
    );
  }
}
