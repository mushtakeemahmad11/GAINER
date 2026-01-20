import 'package:flutter/material.dart';

import '../order_placed_controller.dart';


class OrderCard extends StatelessWidget {
  final OrderModel order;
  final VoidCallback onRemove;

  const OrderCard({
    super.key,
    required this.order,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _topRow(),
            const SizedBox(height: 6),
            _sellerInfo(),
            const SizedBox(height: 6),
            Text(
              'Remarks: ${order.remark}',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            ),
            const Divider(),
            _bottomRow(),
          ],
        ),
      ),
    );
  }

  Widget _topRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Seller',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'Order Date : ${order.orderDate}',
              style: const TextStyle(fontSize: 12),
            ),
            Text(
              'Ordered Qty : ${order.orderedQty}',
              style: const TextStyle(fontSize: 12),
            ),
          ],
        )
      ],
    );
  }

  Widget _sellerInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(order.seller, style: const TextStyle(fontWeight: FontWeight.w600)),
        Text(order.location, style: const TextStyle(fontSize: 12)),
        const SizedBox(height: 4),
        Row(
          children: [
            Text(
              '₹ ${order.pricePerQty} / Qty',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                '${order.discount}% Discount',
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            )
          ],
        )
      ],
    );
  }

  Widget _bottomRow() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton.icon(
        onPressed: onRemove,
        icon: const Icon(Icons.delete, color: Colors.red),
        label: const Text(
          'Remove Item',
          style: TextStyle(color: Colors.red),
        ),
      ),
    );
  }
}
