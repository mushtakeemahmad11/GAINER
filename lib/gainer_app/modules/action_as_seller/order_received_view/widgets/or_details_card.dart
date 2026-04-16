import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gainer/gainer_app/core/utils/gainer_text_filed_validator.dart';
import 'package:gainer/gainer_app/core/widgets/gainer_text_form_field.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import '../../../../core/constants/gainer_color.dart';
import '../../../../core/utils/input_formatters.dart';
import '../models/order_received_model.dart';
import '../order_received_controller.dart';
import 'or_btn_row.dart';
import 'or_mrp_remarks.dart';

class ORDetailsCard extends GetView<OrderReceivedController> {
  final bool isPart;
  final OrderReceivedModel order;

  const ORDetailsCard({
    super.key,
    required this.isPart,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
                    _label(isPart ? 'Part Details' : 'Buyer Details:'),
                    _bold(isPart ? order.partNumber : order.buyerDealer),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child:
                          _bold(isPart ? order.partDesc : order.buyerLocation),
                    ),
                    ORMrpRemarks(order: order),
                    // _bold('${order.orderFor} Order'),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  GainerQtyField(
                    controller: avlCtl,
                    label: 'Avl. Qty',
                    enable: false,
                  ),
                  const SizedBox(height: 5),
                  GainerQtyField(
                    controller: order.accQtyCtl,
                    label: 'Req. Qty',
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      QtyLimitFormatter(
                        maxReqQty: order.qty.toInt(),
                        maxAvlQty: order.sellerFreeStock.toInt(),
                        context: context,
                      ),
                    ],
                  ),
                  _bold('${order.orderFor} Order'),
                ],
              ),
            ],
          ),
          // ORMrpRemarks(order: order),
          const SizedBox(height: 5),
          GainerTextFormField(
            controller: order.remarkCtl,
            label: 'Enter remarks',
            onChanged: (val) async {
              String filteredValue =
                  await GainerTextFiledValidator.remarksValidation(val);
              if (val != filteredValue) order.remarkCtl.text = filteredValue;
            },
          ),
          const SizedBox(height: 3),
          ORBtnRow(
              order: order, reqCtrl: order.accQtyCtl, remCtrl: order.remarkCtl),
          Obx(() {
            final val = controller.selectedImages[order.bigId.toString()];
            if (val != null && val.isNotEmpty) {
              return _imageRow(context, size, order.bigId.toString());
            } else {
              return const SizedBox.shrink();
            }
          }),
        ],
      ),
    );
  }

  Widget _imageRow(BuildContext context, Size size, String bigId) {
    return Obx(() {
      final List<File> images = controller.selectedImages[bigId] ?? [];
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(3, (index) {
          final bool hasImage = index < images.length;

          if (hasImage) {
            final file = images[index];

            return Stack(
              clipBehavior: Clip.none,
              children: [
                Card(
                  child: Image.file(
                    file,
                    width: size.width * .22,
                    height: size.width * .22,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: -12,
                  right: -12,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: Icon(
                      Icons.cancel,
                      color: GainerColors.primary,
                      size: 22,
                    ),
                    onPressed: () {
                      controller.removeImageTest(bigId, index);
                    },
                  ),
                ),
              ],
            );
          }

          /// Empty slot (Add image)
          return InkWell(
            onTap: () {
              controller.uploadImage(order, context);
            },
            child: Container(
              width: size.width * .22,
              height: size.width * .22,
              decoration: BoxDecoration(
                border: Border.all(
                  color: GainerColors.primary,
                  width: 1.2,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.add_a_photo,
                color: GainerColors.primary,
              ),
            ),
          );
        }),
      );
    });
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
