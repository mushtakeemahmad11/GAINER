import 'package:flutter/material.dart';
import 'package:gainer/gainer_app/core/widgets/scrollable_text_widget.dart';
import 'package:get/get.dart';
import '../../../../core/constants/gainer_color.dart';
import '../dr_sent_controller.dart';
import '../models/dr_sent_model.dart';

class DrSentDetailsCard extends GetView<DrSentController> {
  final bool isPart;
  final DrSentModel order;

  const DrSentDetailsCard({
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
                    _bold(isPart ? order.partNumber : order.dealer),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: _bold(isPart ? order.description : order.location),
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
              const SizedBox(width: 5),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _keyValue('MRP', '₹${order.mrp?.toInt()}'),
                  _keyValue('Rate', '₹${order.rate?.toInt()}'),
                  _keyValue('Qty', '${order.qty?.toInt()}'),
                ],
              )
            ],
          ),
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
