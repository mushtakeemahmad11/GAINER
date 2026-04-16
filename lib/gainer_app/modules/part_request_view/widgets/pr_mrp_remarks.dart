import 'package:flutter/material.dart';
import '../../../core/constants/gainer_color.dart';
import '../../../core/widgets/discount_widget/discount_flag.dart';
import '../model/part_request_model.dart';

class OfferPrice extends StatelessWidget {
  final PartRequestModel order;
  const OfferPrice({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '₹${order.price.toInt()}/Qty',
          style: TextStyle(
            fontSize: 14,
            color: GainerColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 6),
        if (order.discount > 0)
          DiscountFlag(text: '${order.discount.toInt()}% Off'),
      ],
    );
  }
}
