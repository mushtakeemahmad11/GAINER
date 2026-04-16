import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import '../../../../core/constants/gainer_color.dart';
import '../models/manifestation_model.dart';
import '../controllers/manifestation_controller.dart';
import 'm_mrp_remarks.dart';

class MDetailsCard extends GetView<ManifestationController> {
  final bool isPart;
  final ManifestationModel order;

  const MDetailsCard({
    super.key,
    required this.isPart,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.of(context).size;
    // final sellerQty = order.sellerFreeStock ?? 0;
    // final reqQty = order.qty ?? 0;
    // final avlCtl = TextEditingController(text: sellerQty.toInt().toString());
    // final reqCtl = TextEditingController(
    //     text: ((sellerQty < reqQty ? sellerQty : reqQty).toInt()).toString());
    // final remCtrl = TextEditingController();

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
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    // children: [_label('OEM: '), _bold(order.oemCode)],
                    children: [
                      _label('OEM: '),
                      _bold(order.oemCode != null && order.oemCode!.isNotEmpty
                          ? order.oemCode
                          : '_________')
                    ],
                  ),
                  Row(
                    children: [
                      _label('PO: '),
                      _bold(order.poNumber != null && order.poNumber!.isNotEmpty
                          ? order.poNumber
                          : '_________')
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 2, bottom: 2, left: 10),
                    // padding: EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                    decoration: BoxDecoration(
                      color: GainerColors.secondary,
                      borderRadius: BorderRadius.all(Radius.circular(6)),
                    ),
                    child: Row(
                      children: [
                        Text("QTY: ${order.poQty}"),
                        SizedBox(
                          height: 18,
                          width: 35,
                          child: Obx(() {
                            bool value = controller
                                    .checkBoxStates[order.bigId.toString()] ??
                                false;
                            return Checkbox(
                                activeColor: GainerColors.primary,
                                value: value,
                                onChanged: (val) {
                                  controller.toggleCheckBox(
                                    orderId: order.bigId.toString(),
                                    locationId:
                                        order.buyerLocationId.toString(),
                                    locationName: order.buyerLocation ?? '',
                                  );
                                });
                          }),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
          MMrpRemarks(order: order),
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
