import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import '../../../core/utils/input_formatters.dart';
import '../../../core/widgets/gainer_text_form_field.dart';
import '../model/part_request_model.dart';
import '../part_request_controller.dart';
import 'pr_mrp_remarks.dart';

// class PRDetailsCard extends StatefulWidget {
//   final PartRequestModel order;
//
//   const PRDetailsCard({
//     super.key,
//     required this.order,
//   });
//
//   @override
//   State<PRDetailsCard> createState() => _PRDetailsCardState();
// }
//
// class _PRDetailsCardState extends State<PRDetailsCard> {
//   late final TextEditingController avlCtl;
//   late final TextEditingController reqCtl;
//   late final TextEditingController remCtl;
//
//   @override
//   void initState() {
//     super.initState();
//
//     avlCtl = TextEditingController(
//       text: widget.order.freeStock.toInt().toString(),
//     );
//     reqCtl = TextEditingController();
//     remCtl = TextEditingController();
//   }
//
//   @override
//   void dispose() {
//     avlCtl.dispose();
//     reqCtl.dispose();
//     remCtl.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: _gradientDecoration(),
//       padding: const EdgeInsets.all(8),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _label('Seller'),
//                   _bold(widget.order.sellerDealer),
//                   _bold(widget.order.sellerLocation),
//                   OfferPrice(order: widget.order),
//                 ],
//               ),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 children: [
//                   Row(
//                     children: [
//                       _label('Avl. Qty'),
//                       GainerQtyField(
//                         controller: avlCtl,
//                         enable: false,
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 5),
//                   Row(
//                     children: [
//                       _label('Req. Qty'),
//                       GainerQtyField(
//                         controller: reqCtl,
//                         inputFormatters: [
//                           FilteringTextInputFormatter.digitsOnly,
//                           QtyLimitFormatter(
//                             maxReqQty: 90000000000,
//                             maxAvlQty:
//                             widget.order.freeStock.toInt(),
//                             context: context,
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                   Row(
//                     children: [
//                       _label('TAT: '),
//                       _bold(widget.order.tat.toString()),
//                     ],
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           const SizedBox(height: 6),
//           SizedBox(
//             height: 40,
//             width: 250,
//             child: GainerTextFormField(
//               controller: remCtl,
//               label: 'Remarks',
//               inputFormatters: [
//                 GainerInputFormatters.alphaNumericWithSpace
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _label(String? text) =>
//       Text(text ?? '', style: const TextStyle(fontSize: 12));
//
//   Widget _bold(String? text) => Text(
//     text ?? '',
//     style: const TextStyle(
//       fontSize: 12,
//       fontWeight: FontWeight.bold,
//     ),
//   );
//
//   BoxDecoration _gradientDecoration() {
//     return const BoxDecoration(
//       gradient: LinearGradient(
//         begin: Alignment(0.94, 0.97),
//         end: Alignment(2.94, -0.47),
//         colors: [
//           Color.fromRGBO(213, 221, 249, 0.5),
//           Color.fromRGBO(223, 247, 246, 0.2),
//         ],
//       ),
//     );
//   }
// }

class PRDetailsCard extends GetView<PartRequestController> {
  final PartRequestModel order;

  const PRDetailsCard({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    final avlCtl = TextEditingController(text: '${order.freeStock.toInt()}');
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: _gradientDecoration(),
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _label('Seller'),
                  _scrollBold(order.sellerDealer, size),
                  _scrollBold(order.sellerLocation, size),
                  OfferPrice(order: order),
                  // Row(
                  //   children: [
                  //     _label('TAT: '),
                  //     _bold(order.tat.toString()),
                  //   ],
                  // ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    spacing: 5,
                    children: [
                      _label('Avl. Qty'),
                      GainerQtyField(
                        controller: avlCtl,
                        // label: 'Avl. Qty',
                        enable: false,
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    spacing: 5,
                    children: [
                      _label('Req. Qty'),
                      GainerQtyField(
                        controller: order.reqQtyCtl,
                        // label: 'Req. Qty',
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          QtyLimitFormatter(
                            maxReqQty: 90000000000,
                            maxAvlQty: order.freeStock.toInt(),
                            context: context,
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      _label('TAT: '),
                      _bold('${order.tat} Day'),
                      const SizedBox(width: 5),
                    ],
                  ),
                ],
              ),
            ],
          ),
          // OfferPrice(order: order),
          // const SizedBox(height: 5),
          SizedBox(
            height: 40,
            width: 250,
            child: GainerTextFormField(
              controller: order.remarkCtl,
              label: 'Remarks',
              inputFormatters: [GainerInputFormatters.alphaNumericWithSpace],
            ),
          ),
        ],
      ),
    );
  }

  Widget _label(String? text) =>
      Text(text ?? '', style: const TextStyle(fontSize: 12));

  Widget _bold(String? text) => Text(
        text ?? '',
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
      );

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

  Widget _scrollBold(String text, Size size) {
    return SizedBox(
      // width: 180,
      width: size.width * .5,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: _bold(text),
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
