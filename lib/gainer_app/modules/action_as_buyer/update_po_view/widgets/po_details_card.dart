import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gainer/gainer_app/core/widgets/gainer_text_form_field.dart';
import 'package:gainer/gainer_app/modules/action_as_buyer/update_po_view/models/update_po_model.dart';
import 'package:gainer/gainer_app/modules/action_as_buyer/update_po_view/update_po_controller.dart';
import 'package:gainer/gainer_app/modules/action_as_buyer/update_po_view/widgets/po_updation_btn_row.dart';
import 'package:gainer/gainer_app/modules/action_as_buyer/update_po_view/widgets/po_updation_mrp_remarks.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

import '../../../../core/utils/input_formatters.dart';

class PoDetailsCard extends GetView<UpdatePoController> {
  final bool isPart;
  final UpdatePoModel order;

  const PoDetailsCard({
    super.key,
    required this.isPart,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    final reqCtl = TextEditingController(text: order.qty.toString());
    final avlCtl =
        TextEditingController(text: order.sellerFreeStock.toInt().toString());

    return Container(
      decoration: _gradientDecoration(),
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _label(isPart ? 'Part Details' : 'Seller Details:'),
                    _bold(isPart ? order.partNumber : order.dealerName),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child:
                          _bold(isPart ? order.partDesc : order.sellerLocation),
                    ),
                    PoUpdationMrp(order: order),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
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
                  ),
                  const SizedBox(height: 5),
                  GainerQtyField(
                    controller: order.accCtrl,
                    label: 'Cnf. Qty',
                    // onChanged: (val) => controller.onChangedAcctQty(
                    //     val, accCtl, order, context),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      QtyLimitFormatter(
                        maxReqQty: order.dispatchQty.toInt(),
                        maxAvlQty: order.sellerFreeStock.toInt(),
                        context: context,
                      ),
                    ],
                  ),
                  // _bold('${order.orderFor} Order'),
                ],
              ),
            ],
          ),
          Column(
            children: [
              Row(
                children: [
                  _label("Buyers's Remarks: "),
                  _scrollBold(order.remarks),
                  const SizedBox(width: 5),
                  _bold('${order.orderFor} Order'),
                ],
              ),
              Row(
                children: [
                  _label("Seller's Remarks: "),
                  _scrollBold(order.requestAcceptRemarks),
                ],
              )
            ],
          ),
          PoUpdationBtnRow(order: order, accCtrl: order.accCtrl),
        ],
      ),
    );

    ///----------
    // return Container(
    //   decoration: _gradientDecoration(),
    //   padding: const EdgeInsets.all(8),
    //   child: Column(
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: [
    //       Row(
    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //         children: [
    //           Expanded(
    //             child: Column(
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               children: [
    //                 _label(isPart ? 'Part Details' : 'Seller Details:'),
    //                 _bold(isPart ? order.partNumber : order.dealerName),
    //                 SingleChildScrollView(
    //                   scrollDirection: Axis.horizontal,
    //                   child:
    //                       _bold(isPart ? order.partDesc : order.sellerLocation),
    //                 ),
    //                 _bold('${order.orderFor} Order'),
    //               ],
    //             ),
    //           ),
    //           Column(
    //             crossAxisAlignment: CrossAxisAlignment.end,
    //             children: [
    //               Row(
    //                 children: [
    //                   GainerQtyField(
    //                     controller: reqCtl,
    //                     label: 'Req. Qty',
    //                     enable: false,
    //                   ),
    //                   const SizedBox(width: 5),
    //                   GainerQtyField(
    //                     controller: avlCtl,
    //                     label: 'Avl. Qty',
    //                     enable: false,
    //                   ),
    //                 ],
    //               ),
    //               const SizedBox(height: 5),
    //               GainerQtyField(
    //                 controller: order.accCtrl,
    //                 label: 'Acc. Qty',
    //                 // onChanged: (val) => controller.onChangedAcctQty(
    //                 //     val, accCtl, order, context),
    //                 inputFormatters: [
    //                   FilteringTextInputFormatter.digitsOnly,
    //                   QtyLimitFormatter(
    //                     maxReqQty: order.dispatchQty.toInt(),
    //                     maxAvlQty: order.sellerFreeStock.toInt(),
    //                     context: context,
    //                   ),
    //                 ],
    //               ),
    //             ],
    //           ),
    //         ],
    //       ),
    //       PoUpdationMrp(order: order),
    //       PoUpdationBtnRow(order: order, accCtrl: order.accCtrl),
    //       // _row(
    //       //     left: Column(
    //       //       crossAxisAlignment: CrossAxisAlignment.start,
    //       //       children: [
    //       //         _label(isPart ? 'Part Details' : 'Seller Details:'),
    //       //         _bold(isPart ? order.partNumber : order.dealerName),
    //       //       ],
    //       //     ),
    //       //     right: Row(
    //       //       mainAxisSize: MainAxisSize.min,
    //       //       children: [
    //       //         GainerQtyField(
    //       //           controller: reqCtl,
    //       //           label: 'Req. Qty',
    //       //           enable: false,
    //       //         ),
    //       //         const SizedBox(width: 5),
    //       //         GainerQtyField(
    //       //           controller: avlCtl,
    //       //           label: 'Avl. Qty',
    //       //           enable: false,
    //       //         ),
    //       //       ],
    //       //     )),
    //       // const SizedBox(height: 5),
    //       // _row(
    //       //   left: Expanded(
    //       //     child: Column(
    //       //       crossAxisAlignment: CrossAxisAlignment.start,
    //       //       mainAxisSize: MainAxisSize.min,
    //       //       children: [
    //       //         SingleChildScrollView(
    //       //           scrollDirection: Axis.horizontal,
    //       //           child:
    //       //               _bold(isPart ? order.partDesc : order.sellerLocation),
    //       //         ),
    //       //         _bold('Stock Order')
    //       //       ],
    //       //     ),
    //       //   ),
    //       //   right: GainerQtyField(
    //       //     controller: accCtl,
    //       //     label: 'Acct. Qty',
    //       //     // enable: false,
    //       //   ),
    //       // ),
    //     ],
    //     // children: [
    //     //   _label(isPart ? 'Part Details' : 'Seller Details:'),
    //     //   _row(
    //     //     left: _scrollBold(isPart ? order.partNumber : order.dealerName),
    //     //     right: _keyValue('Ordered Date', order.requestDate),
    //     //   ),
    //     //   _row(
    //     //     left: _scrollBold(isPart ? order.partDesc : order.sellerLocation),
    //     //     // left: _bold(isPart ? order.partDesc : order.sellerLocation),
    //     //     right: _keyValue('Ordered Qty', order.qty.toString()),
    //     //   ),
    //     //   _priceRow(),
    //     //   _remarksRow(size),
    //     // ],
    //   ),
    // );
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

  /// UI Pieces ↓↓↓
  // Widget _priceRow() {
  //   return Row(
  //     children: [
  //       _label('MRP:'),
  //       _strikeText('₹${order.mrp.toInt()}'),
  //       const SizedBox(width: 6),
  //       _priceText('₹${order.price.toInt()}/Qty'),
  //       const SizedBox(width: 6),
  //       // _discountChip('${order.discount}% Off'),
  //       DiscountFlag(text: '${order.discount.toInt()}% Off'),
  //     ],
  //   );
  // }

  // Widget _remarksRow(Size size) {
  //   return Column(
  //     children: [
  //       Row(
  //         children: [
  //           _label("Buyers's Remarks: "),
  //           _scrollBold(order.remarks),
  //         ],
  //       ),
  //       Row(
  //         children: [
  //           _label("Seller's Remarks: "),
  //           _scrollBold(order.requestAcceptRemarks),
  //         ],
  //       )
  //     ],
  //   );
  // }

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

  // /// Helpers ↓↓↓
  //
  // Widget _row({required Widget left, required Widget right}) {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //     children: [left, right],
  //   );
  // }

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
  // Widget _keyValue(String key, String? value) {
  //   return Row(
  //     children: [
  //       _label('$key: '),
  //       _bold(value),
  //     ],
  //   );
  // }

  // Widget _strikeText(String text) => Text(
  //       text,
  //       style: const TextStyle(
  //         fontSize: 12,
  //         decoration: TextDecoration.lineThrough,
  //         fontWeight: FontWeight.bold,
  //       ),
  //     );
  //
  // Widget _priceText(String text) => Text(
  //       text,
  //       style: TextStyle(
  //         fontSize: 14,
  //         color: GainerColors.textPrimary,
  //         fontWeight: FontWeight.bold,
  //       ),
  //     );
  //

  // Widget _actionBtn(String text, VoidCallback onTap, Size size,
  //     {isDisableColors = false}) {
  //   return SizedBox(
  //     width: size.width * .2,
  //     child: ElevatedButton(
  //       style: ButtonStyle(
  //         backgroundColor:
  //             WidgetStatePropertyAll(isDisableColors ? Colors.white54 : null),
  //         padding: WidgetStatePropertyAll(
  //             EdgeInsets.symmetric(horizontal: 6, vertical: 4)),
  //         shape: WidgetStateProperty.all<RoundedRectangleBorder>(
  //           RoundedRectangleBorder(
  //             borderRadius: BorderRadius.circular(8.0),
  //           ),
  //         ),
  //       ),
  //       onPressed: onTap,
  //       child: Text(
  //         text,
  //         textAlign: TextAlign.center,
  //         style: TextStyle(fontSize: 12),
  //       ),
  //     ),
  //   );
  // }

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

// Widget _discountChip(String text) {
//   return Container(
//     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
//     decoration: BoxDecoration(
//       color: Colors.deepOrange[900],
//       borderRadius: BorderRadius.circular(8),
//     ),
//     child: Text(
//       text,
//       style:
//       const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//     ),
//   );
// }
