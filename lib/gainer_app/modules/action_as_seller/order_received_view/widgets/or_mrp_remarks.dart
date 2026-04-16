import 'package:flutter/material.dart';
import 'package:gainer/gainer_app/core/widgets/gainer_dialog.dart';
import '../../../../core/constants/gainer_color.dart';
import '../../../../core/widgets/discount_widget/discount_flag.dart';
import '../models/order_received_model.dart';

class ORMrpRemarks extends StatelessWidget {
  final OrderReceivedModel order;
  const ORMrpRemarks({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    bool isFurtherRemarks = order.furtherDetailsRemarks?.isNotEmpty ?? false;
    return Column(
      children: [
        (order.discount <= 0)
            ? Row(
                children: [
                  _label('MRP:'),
                  Text(
                    '₹${order.price.toInt()}/Qty',
                    style: TextStyle(
                      fontSize: 14,
                      color: GainerColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              )
            : Row(
                children: [
                  _label('MRP:'),
                  Text(
                    '₹${order.mrp.toInt()}',
                    style: const TextStyle(
                      fontSize: 12,
                      decoration: TextDecoration.lineThrough,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '₹${order.price.toInt()}/Qty',
                    style: TextStyle(
                      fontSize: 14,
                      color: GainerColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 6),
                  DiscountFlag(text: '${order.discount.toInt()}% Off'),
                ],
              ),
        Column(
          children: [
            Row(
              children: [
                InkWell(
                  onTap: isFurtherRemarks
                      ? () => GainerDialog.showRemarksSheet(
                            title: 'Buyer Remarks',
                            remarks: {
                              'Request Remark: ': order.remarks,
                              'Further Request Remark: ':
                                  order.furtherDetailsRemarks,
                            },
                          )
                      : null,
                  child: _label("Buyers's Remarks: ", isBlue: isFurtherRemarks),
                ),
                _scrollBold(order.furtherDetailsRemarks ?? order.remarks),
                // _scrollBold(isFurtherRemarks
                //     ? order.furtherDetailsRemarks
                //     : order.remarks),
              ],
            ),
            Row(
              children: [
                _label("Seller's Remarks: "),
                _scrollBold(order.requestAcceptRemarks),
              ],
            )
          ],
        )
      ],
    );
  }

  Widget _label(String? text, {bool isBlue = false}) {
    return Text(
      text ?? '',
      style: TextStyle(
        fontSize: 12,
        fontWeight: isBlue ? FontWeight.w600 : null,
        color: isBlue ? Colors.blue : null,
      ),
    );
  }

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

  Widget _bold(String? text) => Text(
        text ?? '',
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
      );
}
