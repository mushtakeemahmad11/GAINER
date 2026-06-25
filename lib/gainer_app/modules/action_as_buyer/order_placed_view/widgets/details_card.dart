import 'package:flutter/material.dart';
import '../../../../core/constants/gainer_color.dart';
import '../../../../core/widgets/discount_widget/discount_flag.dart';
import '../models/order_placed_model.dart';

class DetailsCard extends StatelessWidget {
  final bool isPart;
  final OrderPlacedModel order;
  final VoidCallback onRemove;

  const DetailsCard({
    super.key,
    required this.isPart,
    required this.order,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      decoration: GainerColors.gradientDecoration,
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _row(
            left: _label(isPart ? 'Part Details' : 'Seller Details:'),
            right: _keyValue('Ordered Date', order.requestDate),
          ),
          _row(
            left: _scrollBold(isPart ? order.partNumber : order.dealerName),
            right: _keyValue('Ordered Qty', order.qty.toString()),
          ),
          _bold(isPart ? order.partDesc : order.sellerLocation),
          // _scrollBold(isPart ? order.partDesc : order.sellerLocation),
          // const SizedBox(height: 2),
          Row(
            children: [
              _priceRow(),
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
          // const SizedBox(height: 2),
          _remarksRow(size),
        ],
      ),
    );
  }

  /// UI Pieces ↓↓↓

  Widget _priceRow() {
    if (order.discount <= 0) {
      return Row(
        children: [
          _label('MRP:'),
          const SizedBox(width: 5),
          _priceText('₹${order.price?.toInt()}/Qty'),
        ],
      );
    }
    return Row(
      children: [
        _label('MRP:'),
        _strikeText('₹${order.mrp?.toInt()}'),
        const SizedBox(width: 6),
        _priceText('₹${order.price?.toInt()}/Qty'),
        const SizedBox(width: 6),
        DiscountFlag(text: '${order.discount}% Off'),
      ],
    );
  }

  Widget _remarksRow(Size size) {
    return Row(
      children: [
        _label('Remarks: '),
        _scrollBold(order.remarks),
        // SizedBox(
        //   width: size.width * .55,
        //   child: SingleChildScrollView(
        //     scrollDirection: Axis.horizontal,
        //     child: _bold('${order.remarks}'),
        //   ),
        // ),
      ],
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

  // Widget _remarks(String? text, Size size) => SizedBox(
  //       width: size.width - size.width * .5,
  //       child: SingleChildScrollView(
  //           scrollDirection: Axis.horizontal,
  //           child: Text(
  //             text ?? '',
  //             style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
  //           )),
  //     );
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
}
