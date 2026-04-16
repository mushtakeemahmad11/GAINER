import 'package:flutter/material.dart';
import 'package:gainer/gainer_app/core/widgets/discount_widget/discount_flag.dart';
import 'package:gainer/gainer_app/modules/action_as_buyer/part_receipt_view/widget/pr_btn_row.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import '../../../../core/constants/gainer_color.dart';
import '../models/part_receipt_model.dart';
import '../part_receipt_controller.dart';

class PRDetailsCard extends GetView<PartReceiptController> {
  final bool isPart;
  final PartReceiptModel order;

  const PRDetailsCard({
    super.key,
    required this.isPart,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _gradientDecoration(),
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
                    _bold(isPart ? order.partnumber : order.dealerName),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child:
                          _bold(isPart ? order.partdesc : order.sellerlocation),
                    ),
                    if (order.deliverStatus.startsWith('D'))
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: _keyValue(
                          'Delivered At',
                          order.deliverDate.split(' ').take(3).join(' '),
                        ),
                      ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _keyValue('Po Qty', order.poQty.toString()),
                  _keyValue('LR No', order.lrNumber),
                  _keyValue('LSP Name', order.companyName),
                ],
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: BoxDecoration(
                    color: order.deliverStatus.startsWith('N')
                        ? GainerColors.prStatusN
                        : GainerColors.prStatusD,
                    borderRadius: BorderRadius.all(Radius.circular(6))),
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    Icon(
                      order.deliverStatus.startsWith('N')
                          ? Icons.watch_later
                          : Icons.local_shipping,
                      size: 20,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      order.deliverStatus,
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
              if (order.discount > 0)
                DiscountFlag(text: '${order.discount.toInt()}% Off'),
            ],
          ),
          PRBtnRow(order: order),

          // PoUpdationMrpRemarks(order: order),
          // PoUpdationBtnRow(order: order, accCtrl: accCtl),
        ],
      ),
    );
  }

  /// UI Pieces ↓↓↓
  Widget _keyValue(String key, String? value) {
    return Row(
      children: [
        _label('$key: '),
        _bold(value),
      ],
    );
  }

  Widget _label(String? text) =>
      Text(text ?? '', style: const TextStyle(fontSize: 12));

  Widget _bold(String? text) => Text(
        text ?? '',
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
      );

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
