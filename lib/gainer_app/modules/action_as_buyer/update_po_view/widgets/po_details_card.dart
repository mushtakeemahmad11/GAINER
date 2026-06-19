import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gainer/gainer_app/core/constants/gainer_color.dart';
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
      decoration: GainerColors.gradientDecoration,
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _label(isPart ? 'Part Details' : 'Seller Details:'),
                    _bold(isPart ? order.partNumber : order.dealerName),
                  ],
                ),
              ),
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
            ],
          ),
          Row(
            spacing: 10,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child:
                          _bold(isPart ? order.partDesc : order.sellerLocation),
                    ),
                    // ScrollableTextWidget(textWidget: _bold(isPart ? order.partDesc : '${order.sellerLocation} hello this side is ma who are you hello this side is ma who are you')),
                    PoUpdationMrp(order: order),
                  ],
                ),
              ),
              GainerQtyField(
                controller: order.accCtrl,
                label: 'Cnf. Qty',
                onChanged: (val) =>
                    controller.removeAcceptedOrder(order.bigId.toString()),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  QtyLimitFormatter(
                    maxReqQty: order.dispatchQty.toInt(),
                    maxAvlQty: order.sellerFreeStock.toInt(),
                    context: context,
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              _label("Buyers's Remarks: "),
              _scrollBold(order.remarks),
              const SizedBox(width: 5),
              _bold('${order.orderFor} Order'),
            ],
          ),
          _row(
            _label("Seller's Remarks: "),
            _scrollBold(order.requestAcceptRemarks),
          ),
          PoUpdationBtnRow(order: order, accCtrl: order.accCtrl),
        ],
      ),
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

  Widget _label(String? text) =>
      Text(text ?? '', style: const TextStyle(fontSize: 12));

  Widget _bold(String? text) => Text(
        text ?? '',
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
      );

  Widget _row(Widget widget1, Widget widget2) {
    return Row(
      children: [widget1, widget2],
    );
  }
}
