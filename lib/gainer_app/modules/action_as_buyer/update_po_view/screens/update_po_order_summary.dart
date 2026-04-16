import 'package:flutter/material.dart';
import 'package:gainer/gainer_app/core/constants/gainer_color.dart';
import 'package:gainer/gainer_app/core/utils/gainer_text_filed_validator.dart';
import 'package:gainer/gainer_app/core/widgets/gainer_app_loader.dart';
import 'package:gainer/gainer_app/core/widgets/gainer_text_form_field.dart';
import 'package:gainer/gainer_app/modules/action_as_buyer/update_po_view/update_po_controller.dart';
import 'package:get/get.dart';
import '../../../../../main.dart';

class UpdatePoOrderSummary extends GetView<UpdatePoController> {
  const UpdatePoOrderSummary({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args = Get.arguments ?? {};
    List<Map<String, dynamic>> tableValue =
        List<Map<String, dynamic>>.from(args["poTableVal"] ?? []);
    final List<Map<String, dynamic>> orderData =
        List<Map<String, dynamic>>.from(args["orderData"] ?? []);
    String sellerLocationID = args["sellerLocationID"];
    // String sellerDealerName = args["sellerDealerName"];
    controller.poNumberController.clear();
    controller.poRemarksController.clear();

    int totalQty = orderData.fold(
        0, (sum, item) => sum + (int.parse(item['Qty'])).toInt());
    double totalValue = orderData.fold(0.0, (sum, item) => sum + item['Value']);

    return Scaffold(
      backgroundColor: GainerColors.background,
      appBar: AppBar(
        title: const Text('Order Summary'),
        backgroundColor: GainerColors.primary,
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: mq.width * .02, vertical: mq.height * .02),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Text("Order Summary for PO Updation",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),

                  // Table UI
                  buildOrderSummaryTable(orderData, totalQty, totalValue),

                  const SizedBox(height: 20),

                  // Form Inputs
                  Form(
                    key: controller.formKey,
                    child: Column(
                      children: [
                        buildCustomTextField(
                            controller.poNumberController, "Enter PO Number",
                            validator: (value) => value == null || value.isEmpty
                                ? "Please Enter PO Number"
                                : null,
                            onChanged: (value) {
                              String filteredValue =
                                  value.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '');
                              if (filteredValue.length > 10) {
                                filteredValue = filteredValue.substring(0, 10);
                              }
                              if (value != filteredValue) {
                                controller.poNumberController.text =
                                    filteredValue;
                              }
                            }),
                        const SizedBox(height: 5),
                        buildCustomTextField(
                            controller.poRemarksController, "Enter PO Remarks",
                            onChanged: (value) async {
                          String filteredValue =
                              await GainerTextFiledValidator.remarksValidation(
                                  value);
                          if (value != filteredValue) {
                            controller.poRemarksController.text = filteredValue;
                          }
                        }),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Submit Button
                  Align(
                    alignment: Alignment.centerRight,
                    child: ActionChip(
                      backgroundColor: GainerColors.primary,
                      labelStyle: TextStyle(color: Colors.white),
                      label: Text('Submit PO'),
                      onPressed: () {
                        if (controller.formKey.currentState!.validate()) {
                          controller.onSubmitPo(
                            controller.poNumberController.text,
                            controller.poRemarksController.text,
                            tableValue,
                            sellerLocationID,
                            totalValue,
                            totalQty,
                            context,
                          );
                        }
                      },
                    ),
                  ),
                  // Align(
                  //   alignment: Alignment.centerRight,
                  //   child: GainerPrimaryButton(
                  //     width: mq.width * .4,
                  //     onPressed: () {
                  //       if (controller.formKey.currentState!.validate()) {
                  //         controller.onSubmitPo(
                  //           controller.poNumberController.text,
                  //           controller.poRemarksController.text,
                  //           tableValue,
                  //           sellerLocationID,
                  //           totalValue,
                  //           totalQty,
                  //           context,
                  //         );
                  //       }
                  //     },
                  //     title: 'Submit PO',
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
          GainerAppLoader(isLoading: controller.isSubmitting)
        ],
      ),
    );
  }

  Widget buildOrderSummaryTable(
      List<Map<String, dynamic>> orderData, int totalQty, double totalValue) {
    return Table(
      border: TableBorder.all(color: Colors.black, width: 0.5),
      // columnWidths: _buildColumnWidths(orderData.first.length),
      columnWidths: const {
        0: FlexColumnWidth(3),
        1: FlexColumnWidth(2.5),
        2: FlexColumnWidth(2),
        // 3: FlexColumnWidth(1),
        3: IntrinsicColumnWidth(),
        4: IntrinsicColumnWidth(),
        // 4: FlexColumnWidth(1.5),
      },
      children: [
        // Table Header
        TableRow(
          decoration: BoxDecoration(color: Colors.grey[300]),
          children: ["Part No.", "Part Desc", "Seller", "Qty", "Value"]
              .map((text) => _tableHeaderCell(text))
              .toList(),
        ),
        // Table Data Rows
        ...orderData.map((item) => TableRow(
              children: [
                _tableCell(item['PartNo'].toString()),
                _tableCell(item['Desc'].toString()),
                _tableCell(item['Seller'].toString()),
                _tableCell(item['Qty'].toString()),
                _tableCell(item['Value'].toStringAsFixed(0)),
              ],
            )),
        // Total Row
        TableRow(
          decoration: BoxDecoration(color: Colors.grey[200]),
          children: [
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

  // Future<void> onSubmitPo(
  Widget _tableHeaderCell(String text) => _tableCell(text, bold: true);

  Widget _tableCell(String text, {bool bold = false}) => Padding(
        padding: const EdgeInsets.all(3.0),
        child: Text(text,
            style: TextStyle(
                fontWeight: bold ? FontWeight.bold : FontWeight.normal,
                fontSize: bold ? 14 : 12),
            textAlign: TextAlign.center),
      );

  // Map<int, TableColumnWidth> _buildColumnWidths(int columnCount) {
  //   final Map<int, TableColumnWidth> widths = {};
  //
  //   for (int i = 0; i < columnCount; i++) {
  //     if (i == 0 || i == 1) {
  //       widths[i] = const FixedColumnWidth(100); // first column fixed
  //     } else {
  //       widths[i] = const IntrinsicColumnWidth(); // others by content
  //     }
  //   }
  //
  //   return widths;
  // }
}
