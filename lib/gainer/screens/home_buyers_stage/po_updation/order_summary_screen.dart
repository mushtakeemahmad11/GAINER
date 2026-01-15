import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../main.dart';
import '../../../apis_functionality/api_service.dart';
import '../../../apis_functionality/send_notification_service.dart';
import '../../../controllers/buyer_controller/po_updation_controller.dart';
import '../../../controllers/check_internet/no_internet_screen.dart';
import '../../../controllers/home_screen_controller.dart';
import '../../../shared_preferences/shared_preferences_get_data.dart';
import '../../../utility/controller_utils.dart';
import '../../../widget/bottomsheet_for_picture.dart';
import '../../../widget/circular_progress_indicator.dart';
import '../../../widget/dialog.dart';
import '../../../widget/reusable_elevated_button.dart';
import '../../../widget/reusable_widget.dart';
import '../../check_internet/check_internet_connectivity.dart';
import '../../constant_image_path.dart';

class OrderSummaryScreen extends StatefulWidget {
  const OrderSummaryScreen({super.key});

  @override
  State<OrderSummaryScreen> createState() => _OrderSummaryScreenState();
}

class _OrderSummaryScreenState extends State<OrderSummaryScreen> {
  final LocationController _locationController = Get.put(LocationController());
  final PoUpdationController _poUpdationController =
      Get.put(PoUpdationController());
  final _formKey = GlobalKey<FormState>();
  final TextEditingController poNumberController = TextEditingController();
  final TextEditingController poRemarksController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args = Get.arguments ?? {};
    List<Map<String, dynamic>> tableValue =
        List<Map<String, dynamic>>.from(args["poTableVal"] ?? []);
    final List<Map<String, dynamic>> orderData =
        List<Map<String, dynamic>>.from(args["orderData"] ?? []);
    String sellerLocationID = args["sellerLocationID"];
    String sellerDealerName = args["sellerDealerName"];

    int totalQty = orderData.fold(
        0, (sum, item) => sum + (int.parse(item['Qty'])).toInt());
    double totalValue = orderData.fold(0.0, (sum, item) => sum + item['Value']);

    return Scaffold(
      appBar: AppBar(title: const Text('Order Summary')),
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
                    key: _formKey,
                    child: Column(
                      children: [
                        buildCustomTextField(
                            poNumberController, "Enter PO Number",
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
                                poNumberController.text = filteredValue;
                              }
                            }),
                        const SizedBox(height: 5),
                        buildCustomTextField(
                            poRemarksController, "Enter PO Remarks",
                            onChanged: (value) async {
                          String filteredValue =
                              await ControllerUtils.remarksValidation(value);
                          if (value != filteredValue) {
                            poRemarksController.text = filteredValue;
                          }
                        }),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Submit Button
                  Align(
                    alignment: Alignment.centerRight,
                    child: SizedBox(
                      width: mq.width * .35,
                      child: CustomElevatedButton(
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            // orderData.first['Seller'];
                            onSubmitPo(
                              poNumberController.text,
                              poRemarksController.text,
                              tableValue,
                              sellerLocationID,
                              totalValue,
                              sellerDealerName,
                                totalQty,
                            );
                          }
                        },
                        text: 'Submit PO',
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Obx(() => _poUpdationController.orderSummaryIsLoading.value
              ? customCircularProgressIndicator()
              : const SizedBox.shrink()),
        ],
      ),
    );
  }

  Widget buildOrderSummaryTable(
      List<Map<String, dynamic>> orderData, int totalQty, double totalValue) {
    return Table(
      border: TableBorder.all(color: Colors.black, width: 0.5),
      columnWidths: const {
        0: FlexColumnWidth(3),
        1: FlexColumnWidth(2.5),
        2: FlexColumnWidth(2),
        3: FlexColumnWidth(1),
        4: FlexColumnWidth(1.5),
      },
      children: [
        // Table Header
        TableRow(
          decoration: BoxDecoration(color: Colors.grey[300]),
          children: ["Part No.", "Desc", "Seller", "Qty", "Value"]
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
    return CustomTextFormField(
      controller: controller,
      text: text,
      validator: validator,
      onChanged: onChanged,
    );
  }

  Future<void> onSubmitPo(
      String raisePoNumber,
      String raisePoRemarks,
      List<Map<String, dynamic>> tableVal,
      String sellerLocationId,
      double totalPrice,
      String sellerDealerName,
      int totalQty,
      ) async {
    int userId = await getIntData('tCode');
    var stockDetails = _locationController.stockDetails;
    String brandId = stockDetails['BrandID'].toString();
    String dealerId = stockDetails['DealerID'].toString();
    String locationId = stockDetails['LocationID'].toString();

    // Update remarks
    // tableVal.forEach((item) => item["remarks"] = raisePoRemarks);
    for (var item in tableVal) {
      item["remarks"] = raisePoRemarks;
    }

    bool checkInt = await checkInternet();
    if (!checkInt) {
      Get.to(() => NoInternetScreen());
      return;
    }
    final response = await ApiService().poRaise(
      poNumber: raisePoNumber,
      userID: userId.toString(),
      brandID: brandId,
      dealerID: dealerId,
      locationID: locationId,
      tableValue: tableVal
          .map((item) => item.values.map((value) => value.toString()).join("|"))
          .join(","),
    );

    if (response['success']) {
      Get.back();
      AppDialog.midPopUp(AppImages.check, response['data']);

      String selectedLocationName =
          await getStringData("selectedLocationName") ?? "";
      // await SendNotification.notifyDealerUsers(
      //     sellerLocationId,
      //     "Manifestation Awaited",
      //     "PO Confirmed By $selectedLocationName for ₹ $totalPrice/-, please Invoice & Manifest",
      //     {});
      await SendNotification.notifyDealerUsers(
          sellerLocationId,
          "Purchase Order (CONFIRMED)",
          // " Part: \n"
          "Total Qty: $totalQty"
              "Buyer: $sellerDealerName, $selectedLocationName\n"
              "Pl do Invoice & manifest details",
          {});
    } else {
      CustomBottomSheet.showSnackBar(context, response['message']);
    }
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
