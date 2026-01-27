import 'package:flutter/material.dart';
import 'package:gainer/gainer_app/core/widgets/gainer_text_form_field.dart';
import 'package:gainer/gainer_app/modules/action_as_buyer/update_po_view/models/update_po_model.dart';
import '../../../../core/constants/gainer_color.dart';
import '../../../../core/widgets/discount_widget/discount_flag.dart';

class PoDetailsCard extends StatelessWidget {
  final bool isPart;
  final UpdatePoModel order;
  final VoidCallback onRemove;

  const PoDetailsCard({
    super.key,
    required this.isPart,
    required this.order,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    TextEditingController reqCtl = TextEditingController();
    TextEditingController avlCtl = TextEditingController();
    TextEditingController accCtl = TextEditingController();
    reqCtl.text = order.qty.toString();
    avlCtl.text = order.sellerFreeStock.toInt().toString();
    accCtl.text = order.sellerFreeStock < order.dispatchQty
        ? order.sellerFreeStock.toInt().toString()
        : order.dispatchQty.toInt().toString();

    return Container(
      decoration: _gradientDecoration(),
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _row(
              left: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _label(isPart ? 'Part Details' : 'Seller Details:'),
                  _bold(isPart ? order.partNumber : order.dealerName),
                ],
              ),
              right: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GainerQtyField(
                    controller: reqCtl,
                    label: 'Req. Qty',
                    enable: false,
                  ),
                  const SizedBox(width: 5),
                  GainerQtyField(
                    controller: avlCtl,
                    label: 'Avl. Qty',
                    enable: false,
                  ),
                ],
              )),
          const SizedBox(height: 5),
          _row(
            left: Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child:
                        _bold(isPart ? order.partDesc : order.sellerLocation),
                  ),
                  _bold('Stock Order')
                ],
              ),
            ),
            right: GainerQtyField(
              controller: accCtl,
              label: 'Acc. Qty',
              // enable: false,
            ),
          ),
          // _bold(isPart ? order.partDesc : order.sellerLocation),
          // _scrollBold(isPart ? order.partDesc : order.sellerLocation),
          _priceRow(),
          _remarksRow(size),
          _btnRow(size)
        ],
        // children: [
        //   _label(isPart ? 'Part Details' : 'Seller Details:'),
        //   _row(
        //     left: _scrollBold(isPart ? order.partNumber : order.dealerName),
        //     right: _keyValue('Ordered Date', order.requestDate),
        //   ),
        //   _row(
        //     left: _scrollBold(isPart ? order.partDesc : order.sellerLocation),
        //     // left: _bold(isPart ? order.partDesc : order.sellerLocation),
        //     right: _keyValue('Ordered Qty', order.qty.toString()),
        //   ),
        //   _priceRow(),
        //   _remarksRow(size),
        // ],
      ),
    );
  }

  /// UI Pieces ↓↓↓

  Widget _priceRow() {
    return Row(
      children: [
        _label('MRP:'),
        _strikeText('₹${order.mrp.toInt()}'),
        const SizedBox(width: 6),
        _priceText('₹${order.price.toInt()}/Qty'),
        const SizedBox(width: 6),
        // _discountChip('${order.discount}% Off'),
        DiscountFlag(text: '${order.discount.toInt()}% Off'),
      ],
    );
  }

  Widget _remarksRow(Size size) {
    return Column(
      children: [
        Row(
          children: [
            _label("Buyers's Remarks: "),
            _scrollBold(order.remarks),
          ],
        ),
        Row(
          children: [
            _label("Seller's Remarks: "),
            _scrollBold(order.requestAcceptRemarks),
          ],
        )
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

  Widget _remarks(String? text, Size size) => SizedBox(
        width: size.width - size.width * .5,
        child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Text(
              text ?? '',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            )),
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

  Widget _btnRow(Size size) {
    return Row(
      spacing: 10,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _actionBtn('view image', () {}, size),
        _actionBtn('Accept', () {}, size),
        _actionBtn('Reject', () {}, size),
        _actionBtn('Further Remarks', () {}, size),
      ],
    );
  }

  Widget _actionBtn(String text, VoidCallback onTap, Size size) {
    return SizedBox(
      width: size.width * .2,
      child: ElevatedButton(
        style: ButtonStyle(
          padding: WidgetStatePropertyAll(
              EdgeInsets.symmetric(horizontal: 6, vertical: 4)),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
        onPressed: onTap,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12),
        ),
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
