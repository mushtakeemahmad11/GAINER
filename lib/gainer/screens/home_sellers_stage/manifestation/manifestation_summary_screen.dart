import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../main.dart';
import '../../../controllers/seller_controller/manifestation_controller.dart';
import '../../../widget/reusable_elevated_button.dart';
import '../../../widget/reusable_widget.dart';
import 'cal_freight_screen.dart';

class ManifestationSummaryScreen extends StatefulWidget {
  const ManifestationSummaryScreen({super.key});

  @override
  State<ManifestationSummaryScreen> createState() =>
      _ManifestationSummaryScreenState();
}

class _ManifestationSummaryScreenState
    extends State<ManifestationSummaryScreen> {
  final ManifestationController _manifestationController =
      Get.put(ManifestationController());

  // List<Map<String, dynamic>> tableValue = [];
  List<Map<String, dynamic>> orderData = [];
  int totalQty = 0;
  double totalValue = 0.0;
  final TextEditingController poNumberController = TextEditingController();
  final TextEditingController poRemarksController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initWork();
  }

  void _initWork() {
    final Map<String, dynamic> args = Get.arguments ?? {};
    // _manifestationController.poTableVal.value =
    //     List<Map<String, dynamic>>.from(args["poTableVal"] ?? []);
    _manifestationController.orderData.value =
        List<Map<String, dynamic>>.from(args["orderData"] ?? []);

    // tableValue = _manifestationController.poTableVal;
    orderData = _manifestationController.orderData;

    totalQty = orderData.fold(
        0, (sum, item) => sum + (int.parse(item['Qty'])).toInt());
    totalValue = orderData.fold(0.0, (sum, item) => sum + item['Value']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manifestation Summary')),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: mq.width * .02, vertical: mq.height * .02),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Text("Manifestation Summary for PO Updation",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),

                  // Table UI
                  buildManifestationSummaryTable(
                      orderData, totalQty, totalValue),

                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerRight,
                    child: SizedBox(
                      width: mq.width * .43,
                      child: CustomElevatedButton(
                        onTap: () {
                          // Get.to(() => CalFreightScreen(),
                          //     arguments: {"invoiceAmount": totalValue});
                          Get.to(() => CalFreightScreen());
                        },
                        text: 'Manifestation',
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          // Obx(() => _poUpdationController.orderSummaryIsLoading.value
          //     ? customCircularProgressIndicator()
          //     : const SizedBox.shrink()),
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
        5: FlexColumnWidth(1.5),
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
                // _tableCell('${(int.parse(item['Value'])*int.parse(item['Qty']))}'),
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
    return CustomTextFormField(
      controller: controller,
      text: text,
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
