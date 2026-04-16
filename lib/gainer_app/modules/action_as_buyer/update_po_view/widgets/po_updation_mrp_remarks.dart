import 'package:flutter/material.dart';
import 'package:gainer/gainer_app/modules/action_as_buyer/update_po_view/models/update_po_model.dart';
import '../../../../core/constants/gainer_color.dart';
import '../../../../core/widgets/discount_widget/discount_flag.dart';

class PoUpdationMrp extends StatelessWidget {
  final UpdatePoModel order;
  const PoUpdationMrp({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        (order.discount <= 0)
            ? Row(
                children: [
                  _label('MRP:'),
                  const SizedBox(width: 5),
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
        // Column(
        //   children: [
        //     Row(
        //       children: [
        //         _label("Buyers's Remarks: "),
        //         _scrollBold(order.remarks),
        //       ],
        //     ),
        //     Row(
        //       children: [
        //         _label("Seller's Remarks: "),
        //         _scrollBold(order.requestAcceptRemarks),
        //       ],
        //     )
        //   ],
        // ),
      ],
    );
  }

  Widget _label(String? text) =>
      Text(text ?? '', style: const TextStyle(fontSize: 12));

  // Widget _scrollBold(String? text) {
  //   return Expanded(
  //     child: Padding(
  //       padding: const EdgeInsets.only(right: 8.0),
  //       child: SingleChildScrollView(
  //         scrollDirection: Axis.horizontal,
  //         child: _bold(text),
  //       ),
  //     ),
  //   );
  // }

  // Widget _bold(String? text) => Text(
  //       text ?? '',
  //       style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
  //     );
}
