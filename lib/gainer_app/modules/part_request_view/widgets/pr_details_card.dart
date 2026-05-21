import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import '../../../core/constants/gainer_color.dart';
import '../../../core/utils/input_formatters.dart';
import '../../../core/widgets/gainer_text_form_field.dart';
import '../model/part_request_model.dart';
import '../part_request_controller.dart';
import 'pr_mrp_remarks.dart';

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
      decoration: GainerColors.gradientDecoration,
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
}
