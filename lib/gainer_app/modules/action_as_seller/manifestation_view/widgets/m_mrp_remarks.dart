import 'package:flutter/material.dart';
import '../../../../core/constants/gainer_color.dart';
import '../../../../core/widgets/discount_widget/discount_flag.dart';
import '../../../../core/widgets/gainer_dialog.dart';
import '../models/manifestation_model.dart';

class MMrpRemarks extends StatelessWidget {
  final ManifestationModel order;
  const MMrpRemarks({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final buyerRemarks = getRemarks();
    return Column(
      children: [
        ((order.discount ?? 0) <= 0)
            ? Row(
                children: [
                  _label('MRP:'),
                  Text(
                    '₹${(order.price ?? 0).toInt()}/Qty',
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
                    '₹${(order.mrp ?? 0).toInt()}',
                    style: const TextStyle(
                      fontSize: 12,
                      decoration: TextDecoration.lineThrough,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '₹${(order.price ?? 0).toInt()}/Qty',
                    style: TextStyle(
                      fontSize: 14,
                      color: GainerColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 6),
                  DiscountFlag(text: '${(order.discount ?? 0).toInt()}% Off'),
                ],
              ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                InkWell(
                  onTap: buyerRemarks.length > 1
                      ? () => GainerDialog.showRemarksSheet(
                            title: "Buyers's Remarks: ",
                            remarks: buyerRemarks,
                          )
                      : null,
                  child: _label("Buyers's Remarks: ",
                      isBlue: buyerRemarks.length > 1),
                ),
                if (buyerRemarks.values.isNotEmpty)
                  _scrollBold(buyerRemarks.values.last)
              ],
            ),
            // Row(
            //   children: [
            //     _label("Buyers's Remarks: "),
            //     _scrollBold(order.remarks),
            //   ],
            // ),
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

  // Request Remarks
  // Further Request Remark
  // PO Confirmation
  Map<String, String> getRemarks() {
    final Map<String, String> remarks = {};

    if (order.remarks?.isNotEmpty ?? false) {
      remarks['Request Remark: '] = order.remarks!.trim();
    }

    if (order.furtherDetailsRemarks?.isNotEmpty ?? false) {
      remarks['Further Request Remark: '] = order.furtherDetailsRemarks!.trim();
    }

    if (order.responseConfirmRemarks?.isNotEmpty ?? false) {
      remarks['PO Confirmation: '] = order.responseConfirmRemarks!.trim();
    }
    // if (remarks.isEmpty) {
    //   remarks['PO Confirmation: '] = '';
    // }

    return remarks;
  }
}
