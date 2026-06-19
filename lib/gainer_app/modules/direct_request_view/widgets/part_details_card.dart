import 'package:flutter/material.dart';

import '../../../core/constants/gainer_color.dart';
import '../models/part_model.dart';
import 'card_header.dart';

class PartDetailsCard extends StatelessWidget {
  final PartModel order;
  final VoidCallback onRemove;

  const PartDetailsCard({
    super.key,
    required this.order,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final decoration = GainerColors.gradientDecoration.copyWith(
      borderRadius: BorderRadius.circular(10),
    );

    return Container(
      decoration: decoration,
      // decoration: BoxDecoration(
      //   borderRadius: BorderRadius.circular(12),
      //   gradient: LinearGradient(
      //     begin: Alignment(0.94, 0.97),
      //     end: Alignment(2.94, -0.47),
      //     colors: [
      //       Color.fromRGBO(213, 221, 249, 0.5),
      //       Color.fromRGBO(223, 247, 246, 0.2),
      //     ],
      //   ),
      // ),
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CardHeader(
              title1: order.partNo, title2: order.desc, title3: order.qty),
          const SizedBox(height: 5),
          _row(
            left: _label('Seller Details:'),
            right: _keyValue('MRP', order.mrp),
          ),
          _row(
            left: _scrollBold(order.dealer),
            right: _keyValue('Rate', order.rate),
          ),
          _row(
            left: _scrollBold(order.location),
            right: SizedBox.shrink(),
          ),
          Row(
            children: [
              _row(
                left: _label('Order For: '),
                right: _bold(order.orderFor),
              ),
              const Spacer(),
              InkWell(
                onTap: onRemove,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.delete_forever,
                      color: Colors.black,
                      size: 24,
                    ),
                  ],
                ),
              ),
            ],
          ),
          _row(
            left: _label('Remarks: '),
            right: _scrollBold(order.remarks),
          ),
        ],
      ),
    );
  }

  /// UI Pieces ↓↓↓
  Widget _scrollBold(String? text) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: _bold(text),
        ),
      ),
    );
  }

  /// Helpers ↓↓↓
  Widget _row({required Widget left, required Widget right}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [left, right],
    );
  }

  Widget _label(String? text) =>
      Text(text ?? '', style: const TextStyle(fontSize: 12));

  Widget _bold(String? text) => Text(
        text ?? '',
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
      );

  Widget _keyValue(String key, String? value) {
    return Row(
      children: [
        _label('$key: '),
        _bold(value),
      ],
    );
  }
}
