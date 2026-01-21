import 'package:flutter/material.dart';
import '../../../../core/constants/gainer_color.dart';
import '../../../../core/widgets/discount_widget/discount_flag.dart';
import '../order_placed_model.dart';


class PartCard extends StatelessWidget {
  final OrderPlacedModel order;
  final VoidCallback onRemove;

  const PartCard({
    super.key,
    required this.order,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      decoration: _gradientDecoration(),
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _label('Seller Details:'),
          _row(
            left: _bold(order.dealerName),
            right: _keyValue('Ordered Date', order.requestDate),
          ),
          _row(
            left: _bold(order.sellerLocation),
            right: _keyValue('Ordered Qty', order.qty.toString()),
          ),
          _priceRow(order, size),
          _remarksRow(size),
        ],
      ),
    );
  }

  /// UI Pieces ↓↓↓

  Widget _priceRow(OrderPlacedModel order, Size size) {
    return Row(
      children: [
        _label('MRP:'),
        _strikeText('₹${order.mrp?.toInt()}'),
        const SizedBox(width: 6),
        _priceText('₹${order.price?.toInt()}/Qty'),
        const SizedBox(width: 6),
        // _discountChip('${order.discount}% Off'),
        DiscountFlag(text: '${order.discount}% Off'),
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
    );
  }

  Widget _remarksRow(Size size) {
    return Row(
      children: [
        _label('Remarks: '),
        SizedBox(
          width: size.width * .55,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: _bold(order.remarks),
          ),
        ),
      ],
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

  Widget _strikeText(String text) => Text(
    text,
    style: const TextStyle(
      fontSize: 12,
      decoration: TextDecoration.lineThrough,
      fontWeight: FontWeight.bold,
    ),
  );

  Widget _priceText(String text) => Text(
    text,
    style: TextStyle(
      fontSize: 14,
      color: GainerColors.textPrimary,
      fontWeight: FontWeight.bold,
    ),
  );

  Widget _discountChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.deepOrange[900],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style:
        const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  BoxDecoration _gradientDecoration() {
    return const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment(0.94, 0.97),
        end: Alignment(2.94, -0.47),
        colors: [
          Color.fromRGBO(213, 221, 249, 0.5),
          Color.fromRGBO(223, 247, 246, 0.2),
        ],
      ),
    );
  }
}
//
//
// class OrderCard extends StatelessWidget {
//   final OrderModel order;
//   final VoidCallback onRemove;
//
//   const OrderCard({
//     super.key,
//     required this.order,
//     required this.onRemove,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: const EdgeInsets.only(bottom: 12),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(14),
//       ),
//       elevation: 2,
//       child: Padding(
//         padding: const EdgeInsets.all(12),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _topRow(),
//             const SizedBox(height: 6),
//             _sellerInfo(),
//             const SizedBox(height: 6),
//             Text(
//               'Remarks: ${order.remark}',
//               style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
//             ),
//             const Divider(),
//             _bottomRow(),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _topRow() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(
//           'Seller',
//           style: const TextStyle(fontWeight: FontWeight.w600),
//         ),
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.end,
//           children: [
//             Text(
//               'Order Date : ${order.orderDate}',
//               style: const TextStyle(fontSize: 12),
//             ),
//             Text(
//               'Ordered Qty : ${order.orderedQty}',
//               style: const TextStyle(fontSize: 12),
//             ),
//           ],
//         )
//       ],
//     );
//   }
//
//   Widget _sellerInfo() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(order.seller, style: const TextStyle(fontWeight: FontWeight.w600)),
//         Text(order.location, style: const TextStyle(fontSize: 12)),
//         const SizedBox(height: 4),
//         Row(
//           children: [
//             Text(
//               '₹ ${order.pricePerQty} / Qty',
//               style: const TextStyle(fontWeight: FontWeight.bold),
//             ),
//             const Spacer(),
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//               decoration: BoxDecoration(
//                 color: Colors.red,
//                 borderRadius: BorderRadius.circular(6),
//               ),
//               child: Text(
//                 '${order.discount}% Discount',
//                 style: const TextStyle(color: Colors.white, fontSize: 12),
//               ),
//             )
//           ],
//         )
//       ],
//     );
//   }
//
//   Widget _bottomRow() {
//     return Align(
//       alignment: Alignment.centerRight,
//       child: TextButton.icon(
//         onPressed: onRemove,
//         icon: const Icon(Icons.delete, color: Colors.red),
//         label: const Text(
//           'Remove Item',
//           style: TextStyle(color: Colors.red),
//         ),
//       ),
//     );
//   }
// }
