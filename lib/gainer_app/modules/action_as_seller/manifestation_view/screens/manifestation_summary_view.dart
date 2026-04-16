import 'package:flutter/material.dart';
import 'package:gainer/gainer_app/core/widgets/gainer_app_bar.dart';
import 'package:gainer/gainer_app/core/widgets/gainer_text_form_field.dart';
import 'package:get/get.dart';

import '../../../../core/constants/gainer_color.dart';
import '../../../../routes/app_routes.dart';
import '../controllers/manifestation_controller.dart';

class ManifestationSummaryView extends GetView<ManifestationController> {
  const ManifestationSummaryView({super.key});

  @override
  Widget build(BuildContext context) {
    final order = controller.orderData;
    Size size = MediaQuery.of(context).size;
    int totalQty =
        order.fold(0, (sum, item) => sum + (int.parse(item['Qty'])).toInt());
    double totalValue = order.fold(0.0, (sum, item) => sum + item['Value']);
    return Scaffold(
      appBar: GainerAppBar(title: 'Manifestation Summary'),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: size.width * .02, vertical: size.height * .02),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Table UI
                  buildManifestationSummaryTable(order, totalQty, totalValue),

                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ActionChip(
                      backgroundColor: GainerColors.primary,
                      labelStyle: TextStyle(color: Colors.white),
                      label: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Manifestation'),
                          SizedBox(width: 5),
                          Icon(
                            Icons.arrow_forward_ios_outlined,
                            size: 12,
                          )
                        ],
                      ),
                      onPressed: () => Get.toNamed(Routes.MANIFESTATIONFCVIEW),
                    ),
                  ),
                  // Align(
                  //   alignment: Alignment.centerRight,
                  //   child: SizedBox(
                  //     width: size.width * .43,
                  //     child: GainerPrimaryButton(
                  //       onPressed: () {
                  //         Get.toNamed(Routes.MANIFESTATIONFCVIEW);
                  //         // Get.to(() => CalFreightScreen());
                  //       },
                  //       title: 'Manifestation',
                  //     ),
                  //   ),
                  // )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildManifestationSummaryTable(
      List<Map<String, dynamic>> orderData, int totalQty, double totalValue) {
    return Table(
      border: TableBorder.all(color: Colors.black, width: 0.5),
      columnWidths: const {
        0: FlexColumnWidth(2),
        1: FlexColumnWidth(1.5),
        2: FlexColumnWidth(2.5),
        3: FlexColumnWidth(2),
        4: FlexColumnWidth(1),
        // 5: FlexColumnWidth(1.5),
        5: IntrinsicColumnWidth(),
      },
      children: [
        // Table Header
        TableRow(
          decoration: BoxDecoration(color: Colors.grey[300]),
          children: ["Part No", "Po No", "Desc", "Buyer", "Qty", "Value"]
              .map((text) => _tableHeaderCell(text))
              .toList(),
        ),
        // Table Data Rows
        ...orderData.map((item) => TableRow(
              children: [
                _tableCell(item['PartNo'].toString()),
                _tableCell(item['PoNum'].toString()),
                _tableCell(item['Desc'].toString()),
                _tableCell(item['Buyer'].toString()),
                _tableCell(item['Qty'].toString()),
                _tableCell(item['Value'].toString()),
              ],
            )),
        // Total Row
        TableRow(
          decoration: BoxDecoration(color: Colors.grey[200]),
          children: [
            _tableCell("", bold: true),
            _tableCell("", bold: true),
            _tableCell("", bold: true),
            _tableCell("Total", bold: true),
            _tableCell(totalQty.toString(), bold: true),
            _tableCell('₹ ${totalValue.toInt()}', bold: true),
          ],
        ),
      ],
    );
  }

  Widget buildCustomTextField(TextEditingController controller, String text,
      {String? Function(String?)? validator, Function(String)? onChanged}) {
    return GainerTextFormField(
      controller: controller,
      label: text,
      validator: validator,
      onChanged: onChanged,
    );
  }

  Widget _tableHeaderCell(String text) => _tableCell(text, bold: true);
  Widget _tableCell(String text, {bool bold = false}) => Padding(
        padding: const EdgeInsets.all(3.0),
        child: Text(text,
            style: TextStyle(
                fontWeight: bold ? FontWeight.bold : FontWeight.normal,
                fontSize: bold ? 14 : 12),
            textAlign: TextAlign.center),
      );
}
