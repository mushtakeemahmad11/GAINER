import 'package:flutter/material.dart';
import 'package:gainer/gainer_app/core/utils/input_formatters.dart';
import 'package:gainer/gainer_app/core/widgets/gainer_dropdown.dart';
import 'package:gainer/gainer_app/core/widgets/gainer_secondary_button.dart';
import 'package:gainer/gainer_app/core/widgets/gainer_text_form_field.dart';
import 'package:gainer/gainer_app/modules/action_as_seller/direct_request_received/widgets/discount_stock_dropdown_row.dart';
import 'package:get/get.dart';
import '../../../../core/constants/gainer_color.dart';
import '../../../../core/widgets/scrollable_text_widget.dart';
import '../dr_received_controller.dart';
import '../models/dr_received_model.dart';
import 'dr_received_button_row.dart';

class DrReceivedDetailsCard extends GetView<DrReceivedController> {
  final bool isPart;
  final DrReceivedModel order;

  const DrReceivedDetailsCard({
    super.key,
    required this.isPart,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    final reqDate = order.requestDate?.split(' ').take(3).join(' ');
    return Container(
      decoration: GainerColors.gradientDecoration,
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _row(
            _label(isPart ? 'Part Details' : 'Seller Details:'),
            _keyValue('Req Date', reqDate),
            // _keyValue('Req Date', order.requestDate),
            true,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _bold(isPart ? order.partNumber : order.buyingDealer),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: _bold(
                          isPart ? order.description : order.buyingLocation),
                    ),
                    _row(
                      _label('Remarks: '),
                      Expanded(
                        child: ScrollableTextWidget(
                          textWidget: _bold(order.remarks),
                        ),
                      ),
                      false,
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _keyValue('MRP', '₹${order.mrp?.toInt()}'),
                  _keyValue('Rate', '₹${order.rate?.toInt()}'),
                  _keyValue('Qty', '${order.qty?.toInt()}'),
                ],
              ),
            ],
          ),
          const SizedBox(height: 5),
          DiscountStockDropdownRow(order: order),
          const SizedBox(height: 5),
          DrReceivedButtonRow(order: order),
        ],
      ),
    );
  }

  /// UI Pieces ↓↓↓
  Widget _row(Widget key, Widget val, bool isSpaceBt) {
    return Row(
      mainAxisAlignment:
          isSpaceBt ? MainAxisAlignment.spaceBetween : MainAxisAlignment.start,
      children: [
        key,
        val,
      ],
    );
  }

  Widget _keyValue(String key, String? value) {
    return _row(_label('$key: '), _bold(value), false);
  }

  Widget _label(String? text) =>
      Text(text ?? '', style: const TextStyle(fontSize: 12));

  Widget _bold(String? text) => Text(
        text ?? '',
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
      );
}
