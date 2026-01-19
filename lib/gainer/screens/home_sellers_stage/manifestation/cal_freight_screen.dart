import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../main.dart';
import '../../../apis_functionality/api_service.dart';
import '../../../controllers/home_screen_controller.dart';
import '../../../controllers/seller_controller/manifestation_controller.dart';
import '../../../model/seller_model/calculate_freight_cost_model.dart';
import '../../../shared_preferences/shared_preferences_get_data.dart';
import '../../../utility/controller_utils.dart';
import '../../../widget/bottomsheet_for_picture.dart';
import '../../../widget/circular_progress_indicator.dart';
import '../../../widget/dialog.dart';
import '../../../widget/reusable_box_text_field.dart';
import '../../../widget/reusable_dropdown.dart';
import '../../../widget/reusable_elevated_button.dart';
import '../../../widget/reusable_widget.dart';
import '../../colors.dart';
import '../../constant_image_path.dart';

class CalFreightScreen extends StatefulWidget {
  const CalFreightScreen({super.key});

  @override
  CalFreightScreenState createState() => CalFreightScreenState();
}

class CalFreightScreenState extends State<CalFreightScreen> {
  final LocationController _locationController = Get.put(LocationController());
  final ManifestationController _manifestationController =
      Get.put(ManifestationController());

  final _formKey = GlobalKey<FormState>(); // Form key
  final _formKey2 = GlobalKey<FormState>(); // Form key
  int boxCount = 0;
  int invoiceCount = 0;

  String? brandId;
  String? dealerId;
  String? locationId;

  //for hit Submit manifestation API
  String? itemBox;

  //for upload file check and attached icons
  List uploadFileStatus = <bool>[];
  List uploadedFileName = <String?>[];

  TextEditingController invoiceCountController = TextEditingController();
  TextEditingController boxController = TextEditingController();
  TextEditingController distanceController = TextEditingController();

  // for when select own arrangement for courier
  TextEditingController remarksController = TextEditingController();
  TextEditingController lrController = TextEditingController();
  TextEditingController transportNameController = TextEditingController();
  TextEditingController contactPersonNameController = TextEditingController();
  TextEditingController contactPersonPhoneController = TextEditingController();
  TextEditingController contactPersonEmailController = TextEditingController();

  //for invoice
  List<TextEditingController> invoiceControllers = [];
  List<TextEditingController> valueControllers = [];

  //for no of boxes
  List<TextEditingController> weightControllers = [];
  List<TextEditingController> lengthControllers = [];
  List<TextEditingController> widthControllers = [];
  List<TextEditingController> heightControllers = [];

  //Declare list for store CalculateFC api data
  List<CalculateFreightCostModel> calculateFCList = [];

  //manifestation big id's from Manifestation screen
  List bigIds = [];

  double weight = 0.0;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _getBuyerDetails();
    bigIds = _manifestationController.manifestationBigId;
  }

  // Initializes controllers for invoices and Boxes
  void _initializeControllers() {
    invoiceControllers =
        List.generate(invoiceCount, (index) => TextEditingController());
    valueControllers =
        List.generate(invoiceCount, (index) => TextEditingController());
    weightControllers =
        List.generate(boxCount, (index) => TextEditingController());
    lengthControllers =
        List.generate(boxCount, (index) => TextEditingController());
    widthControllers =
        List.generate(boxCount, (index) => TextEditingController());
    heightControllers =
        List.generate(boxCount, (index) => TextEditingController());
  }

  void _getBuyerDetails() {
    //get buyer details for hit calculateFC API
    var stockDetails = _locationController.stockDetails;
    brandId = stockDetails['BrandID'].toString();
    dealerId = stockDetails['DealerID'].toString();
    locationId = stockDetails['LocationID'].toString();
  }

  @override
  void dispose() {
    for (var controller in invoiceControllers) {
      controller.dispose();
    }
    for (var controller in valueControllers) {
      controller.dispose();
    }
    for (var controller in weightControllers) {
      controller.dispose();
    }
    for (var controller in lengthControllers) {
      controller.dispose();
    }
    for (var controller in widthControllers) {
      controller.dispose();
    }
    for (var controller in heightControllers) {
      controller.dispose();
    }

    invoiceCountController.dispose();
    boxController.dispose();
    distanceController.dispose();
    remarksController.dispose();
    lrController.dispose();
    transportNameController.dispose();
    contactPersonNameController.dispose();
    contactPersonPhoneController.dispose();
    contactPersonEmailController.dispose();

    super.dispose();
  }

  final List<List<String>> tableData = [];
  List<String> box = [];
  List<String> courierOptionName = [];
  Map<String, String> courierOption = {};
  String? selectedCourier;
  // String? companyCode; // according to selected courier

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cal Freight')),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: mq.width * .03, vertical: mq.height * .02),
            child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    SizedBox(height: 5),
                    // Invoice Count Input
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Invoice count',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: mq.width * .4,
                          child: CustomBoxTextField(
                            label: "Invoice Count",
                            controller: invoiceCountController,
                            onChanged: (value) async {
                              _updateInvoiceCount(
                                  value, invoiceCountController, 10, 1);
                            },
                          ),
                        ),
                      ],
                    ),
                    // Invoice Fields
                    ...List.generate(
                        invoiceCount, (index) => _buildInvoiceRow(index)),

                    SizedBox(height: mq.height * .01),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'No of Boxes',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        // No of Boxes Input
                        SizedBox(
                          width: mq.width * .4,
                          child: CustomBoxTextField(
                            label: "No of Boxes",
                            controller: boxController,
                            onChanged: (value) async {
                              _updateInvoiceCount(value, boxController, 20, 2);
                            },
                          ),
                        ),
                      ],
                    ),
                    ...List.generate(boxCount, (index) => _buildBoxRow(index)),

                    SizedBox(height: mq.height * .01),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Distance (in km)',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        // Distance Input
                        SizedBox(
                          width: mq.width * .4,
                          child: CustomBoxTextField(
                              label: "Distance (in km)",
                              controller: distanceController,
                              onChanged: (value) {
                                _updateInvoiceCount(
                                    value, distanceController, 3676, 3);
                              }),
                        ),
                      ],
                    ),

                    // Calculate Freight Button
                    CustomElevatedButton(
                      onTap: () {
                        _calculateFreight();
                      },
                      text: '₹ Calculate Freight',
                    ),
                    // Warning Message
                    const Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Text(
                        "*** Freight is calculated as per Dimensions updated. Ensure to input CORRECT DIMENSION.\n"
                        "Courier will charge as per dimensions updated/actual dimension & NO Request for dimension change will be entertained later.",
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    SizedBox(height: mq.height * .02),

                    Obx(
                      () => _manifestationController.isLoadingFC.value
                          ? Center(child: CircularProgressIndicator())
                          : calculateFCList.isEmpty
                              ? const SizedBox.shrink()
                              : Column(
                                  children: [
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: calculateFCList.length,
                                      itemBuilder: (context, index) {
                                        final item = calculateFCList[index];
                                        return _buildExpansionTile(item, index);
                                      },
                                    ),
                                    _buildDropdownAndTextField(),
                                  ],
                                ),
                    )
                  ],
                )),
          ),
          Obx(() => _manifestationController.isLoadingCFCSubmit.value
              ? customCircularProgressIndicator()
              : const SizedBox.shrink()),
        ],
      ),
    );
  }

  // Widget _buildExpansionTile(Map<String, dynamic> item, int index) {
  Widget _buildExpansionTile(CalculateFreightCostModel item, int index) {
    _table1DataSet(item);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: ExpansionTile(
            // controller: _expansionTileController,
            tilePadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // _buildExpansionTileTitle(item.partNumber),
                Column(
                  children: [
                    _buildExpansionTileTitle('${item.companyName}'),
                    _buildExpansionTileTitle('W(KG): ${item.weight?.toInt()}'),
                  ],
                ),
                const SizedBox(width: 1),
                Column(
                  children: [
                    _buildExpansionTileTitle('Appx Freight Cost'),
                    _buildExpansionTileTitle(
                        '${item.estCost?.ceilToDouble().toInt()}'),
                  ],
                ),
                const SizedBox(width: 1),
                Text(
                  'TAT: ${item.tat} Days',
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            backgroundColor: AppColor.primaryShade,
            collapsedBackgroundColor:
                AppColor.primaryShade, // Replace with AppColor.primaryShade
            collapsedShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            childrenPadding: const EdgeInsets.symmetric(horizontal: 5.0),
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                child: Column(
                  children: [
                    Table(
                      border: TableBorder.all(),
                      columnWidths: const {
                        0: FlexColumnWidth(3),
                      },
                      children: tableData.map((row) => _buildRow(row)).toList(),
                    ),
                    SizedBox(height: mq.height * .02),
                    _buildDetailsTable(item),
                  ],
                ),
              ),
            ],
          ),
        ),
        // _buildDropdownAndTextField(),
      ],
    );
  }

  _buildExpansionTileTitle(String text) {
    return SizedBox(
      width: mq.width * .27,
      child: SingleChildScrollView(
        child: Text(
          text,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  // Builds an invoice row dynamically
  Widget _buildInvoiceRow(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            '${index + 1}',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(width: mq.width * .02),
          // Invoice Number Input
          Expanded(
            flex: 2,
            child: CustomBoxTextField(
              label: "Invoice No.",
              controller: invoiceControllers[index],
              keyboardType: TextInputType.text,
              onChanged: (value) async {
                // Allow only letters, numbers, spaces, dashes (-), and commas (,)
                String filteredValue =
                    await ControllerUtils.alphaNumericValidation(value);
                if (value != filteredValue) {
                  invoiceControllers[index].text = filteredValue;
                }
              },
            ),
          ),
          const SizedBox(width: 8),

          // Value Input
          Expanded(
            flex: 2,
            child: CustomBoxTextField(
                label: "Value",
                controller: valueControllers[index],
                onChanged: (value) async {
                  valueControllers[index].text =
                      await ControllerUtils.numericWithDecimal(
                          value, 2, 999999999999);
                }),
          ),
          const SizedBox(width: 8),

          // Attachment Button
          SizedBox(
            width: mq.width * .2,
            child: CustomElevatedButton(
              onTap: () {
                pickAndUploadPdf(index, valueControllers[index].text);
              },
              icon: uploadFileStatus[index] ? Icons.check : Icons.attach_file,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsTable(CalculateFreightCostModel item) {
    return Table(
      border: TableBorder.all(color: Colors.black, width: 0.5),
      columnWidths: const {
        0: FlexColumnWidth(7),
        1: FlexColumnWidth(3),
      },
      children: [
        TableRow(
          children: [
            _tableHeaderCell("Parameter"),
            _tableHeaderCell("Cost(in RS)"),
          ],
        ),
        TableRow(
          children: [
            _tableHeaderCell("Basic Freight Cost/KG"),
            _tableCell(item.ratePerKg.toString()),
          ],
        ),
        TableRow(
          children: [
            _tableHeaderCell("Chargeable Weight"),
            _tableCell(item.minChargeableWeight.toString()),
          ],
        ),
        TableRow(
          children: [
            _tableHeaderCell("Calculate Freight Cost(RS)"),
            _tableCell(item.calCost.toString()),
          ],
        ),
        TableRow(
          children: [
            _tableHeaderCell("Fuel Surcharge(${item.fuelSurcharge?.toInt()}%)"),
            _tableCell(item.costDueToFuelSurcharge.toString()),
          ],
        ),
        TableRow(
          children: [
            _tableHeaderCell(
                "Additional Charge(${item.additionalCharge?.toInt()}%)"),
            _tableCell(item.costDueToAdditionalCharge.toString()),
          ],
        ),
        TableRow(
          children: [
            _tableHeaderCell("Total Freight Cost"),
            _tableCell(item.totalCost.toString()),
          ],
        ),
        TableRow(
          children: [
            _tableHeaderCell("Freight Cost(Minimum Chargeable)"),
            _tableCell(item.minFreightCost.toString()),
          ],
        ),
        TableRow(
          children: [
            _tableHeaderCell(
                "Insurance Charge(${item.insuranceCharge?.toInt()}%)"),
            _tableCell(item.costDueToInsuranceCharge.toString()),
          ],
        ),
        TableRow(
          children: [
            _tableHeaderCell("Final Freight Cost Applicable"),
            _tableCell(item.estCost.toString()),
          ],
        ),
        TableRow(
          children: [
            Text(
              "**Texes Extra",
              style: TextStyle(color: Colors.red),
            ),
            _tableCell(""),
          ],
        ),
      ],
    );
  }

  Widget _tableHeaderCell(String text) => _tableCell(text, bold: true);
  Widget _tableCell(String text, {bool bold = false}) => Padding(
        padding: const EdgeInsets.all(3.0),
        child: Text(text,
            style: TextStyle(
                fontWeight: bold ? FontWeight.bold : FontWeight.normal,
                fontSize: bold ? 14 : 12),
            textAlign: bold ? TextAlign.start : TextAlign.center),
      );

  TableRow _buildRow(List<String> cells) {
    return TableRow(
      children: cells.map((cell) {
        bool isHeader = cells.first == cell; // First column is header
        return Padding(
          padding: const EdgeInsets.all(2.0),
          child: Text(
            cell,
            style: TextStyle(
              fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
              // color: isHeader ? Colors.blue : Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
        );
      }).toList(),
    );
  }

  //build Box row dynamically
  Widget _buildBoxRow(int i) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        children: [
          if (i == 0) Text('All measurement in inches'),
          Row(
            children: [
              Text(
                '${i + 1}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(width: mq.width * .02),
              Expanded(
                  child: CustomBoxTextField(
                label: 'Weight',
                controller: weightControllers[i],
                onChanged: (value) async {
                  weightControllers[i].text =
                      await ControllerUtils.numericWithDecimal(value, 1, 9999);
                },
              )),
              const SizedBox(width: 5),
              Expanded(
                  child: CustomBoxTextField(
                label: 'Length',
                controller: lengthControllers[i],
                onChanged: (value) async {
                  lengthControllers[i].text =
                      await ControllerUtils.numericWithDecimal(value, 1, 999);
                },
              )),
              const SizedBox(width: 5),
              Expanded(
                  child: CustomBoxTextField(
                label: 'Width',
                controller: widthControllers[i],
                onChanged: (value) async {
                  widthControllers[i].text =
                      await ControllerUtils.numericWithDecimal(value, 1, 999);
                },
              )),
              const SizedBox(width: 5),
              Expanded(
                  child: CustomBoxTextField(
                label: 'Height',
                controller: heightControllers[i],
                onChanged: (value) async {
                  heightControllers[i].text =
                      await ControllerUtils.numericWithDecimal(value, 1, 999);
                },
              )),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _calculateFreight() async {
    if (_formKey.currentState!.validate()) {
      _manifestationController.isOwnSelected.value = false;
      List<String> boxEntry = [];

      double invoiceAmount = 0;
      for (int i = 0; i < int.parse(invoiceCountController.text); i++) {
        invoiceAmount = invoiceAmount + double.parse(valueControllers[i].text);
      }

      for (int i = 0; i < int.parse(boxController.text); i++) {
        // Create a comma-separated entry
        String entry =
            '${weightControllers[i].text}|${lengthControllers[i].text}|${widthControllers[i].text}|${heightControllers[i].text}';
        // Add to the list
        boxEntry.add(entry);
      }

      // Join all non-empty entries with "|"
      String itemArr = boxEntry.join(',');
      itemBox = itemArr;
      String buyerLocationID =
          _manifestationController.manifestationBuyerLocationID.value ?? '';
      String isWeFast =
          _manifestationController.manifestationIsWeFast.value == true
              ? "Y"
              : "N";
      _manifestationController.isLoadingFC.value = true;
      final response = await ApiService().calculateFreightCost(
        buyerLocationID: buyerLocationID,
        brandID: brandId.toString(),
        sellerDealerID: dealerId.toString(),
        sellerLocationID: locationId.toString(),
        invoiceAmount: invoiceAmount.toString(),
        distance: distanceController.text,
        itemsArr: itemArr,
        noOfBoxes: boxController.text,
        isWeFastUse: isWeFast,
      );
      _manifestationController.isLoadingFC.value = false;

      if (response["success"]) {
        List<dynamic> jsonList = response['data'];
        setState(() {
          calculateFCList = jsonList
              .map((json) => CalculateFreightCostModel.fromJson(json))
              .toList();
          courierOption = {
            for (var item in calculateFCList)
              item.companyName.toString(): item.companyCode.toString(),
          };

          // Add at last
          courierOption['Own Arrangement'] = '';
        });
      } else {
        CustomBottomSheet.showSnackBar(context, response["message"]);
      }
    } else {}
  }

  _table1DataSet(CalculateFreightCostModel item) {
    tableData.clear();
    int boxNo = 0;
    if (boxController.text.isNotEmpty) {
      boxNo = int.parse(boxController.text);
    }
    double volumetricWeight = item.volumetricWt ?? 0;
    double weight = item.weight ?? 0;
    double maxValW = volumetricWeight > weight ? volumetricWeight : weight;
    double actualWeight = 0,
        totalVolume = 0,
        totalHeight = 0,
        totalWidth = 0,
        totalLength = 0;

    // Format helper
    String formatDouble(double val) => val.toStringAsFixed(2);
    tableData
        .add(["Category", ...List.generate(boxNo, (i) => '${i + 1}'), "Total"]);

    // Weight-related rows
    List<String> maxRow = ["Maximum of Actual\n & Volumetric Weight(in Kg)"];
    List<String> volumetricRow = ["Volumetric Weight(in KG)"];
    List<String> actualRow = ["Actual Weight(in KG)"];

    for (var i = 0; i < boxNo; i++) {
      String weightText = weightControllers[i].text;
      double weightVal = double.tryParse(weightText) ?? 0;
      actualWeight += weightVal;

      maxRow.add(""); // Placeholder for box-specific max value
      volumetricRow.add(""); // Placeholder for box-specific volumetric weight
      actualRow.add(formatDouble(weightVal));
    }

    maxRow.add(formatDouble(maxValW));
    volumetricRow.add(formatDouble(volumetricWeight));
    actualRow.add(formatDouble(actualWeight));

    tableData.add(maxRow);
    tableData.add(volumetricRow);
    tableData.add(actualRow);

    // Volume row
    List<String> volumeRow = ["Volume (in cubic ft)"];
    for (var i = 0; i < boxNo; i++) {
      double h = double.tryParse(heightControllers[i].text) ?? 0;
      double w = double.tryParse(widthControllers[i].text) ?? 0;
      double l = double.tryParse(lengthControllers[i].text) ?? 0;

      double volume = double.parse(((h * w * l) / 1728).toStringAsFixed(2));
      totalVolume += volume;
      volumeRow.add(formatDouble(volume));
    }
    volumeRow.add(formatDouble(totalVolume));
    tableData.add(volumeRow);

    // Dimensions (Height, Width, Length)
    List<String> buildDimensionRow(
        String label,
        List<TextEditingController> controllers,
        double Function() totalSetter) {
      double total = 0;
      List<String> row = [label];
      for (var i = 0; i < boxNo; i++) {
        double val = double.tryParse(controllers[i].text) ?? 0;
        total += val;
        row.add(formatDouble(val));
      }
      row.add(formatDouble(total));
      return row;
    }

    tableData.add(buildDimensionRow(
        "Height (in inches)", heightControllers, () => totalHeight));
    tableData.add(buildDimensionRow(
        "Width (in inches)", widthControllers, () => totalWidth));
    tableData.add(buildDimensionRow(
        "Length (in inches)", lengthControllers, () => totalLength));
    // tableData.add(["Box", ...List.generate(boxNo, (i) => '${i + 1}'), ""]);

    if (boxNo <= 0) tableData.clear();
  }

  // _demoDataReflect(CalculateFreightCostModel item) {
  //   tableData.clear();
  //   int boxNo = int.parse(boxController.text);
  //
  //   double volumetricWeight = item.volumetricWt ?? 0;
  //   double weight = item.weight ?? 0;
  //   double maxValW = 0.0;
  //
  //   double actualWeight = 0;
  //
  //   // Total
  //   List<String> totalRow = ["Category"];
  //   for (var i = 0; i < boxNo; i++) {
  //     totalRow.add('Box: ${i + 1}');
  //   }
  //   totalRow.add("Total");
  //   tableData.add(List.from(totalRow));
  //
  //   // Maximum of Actual\n & Volumetric Weight(in Kg)
  //   List<String> maximumRow = [
  //     "Maximum of Actual\n & Volumetric Weight(in Kg)"
  //   ];
  //   for (var i = 0; i < boxNo; i++) {
  //     maximumRow.add("");
  //   }
  //   maximumRow.add(maxValW.toString());
  //   tableData.add(List.from(maximumRow));
  //
  //   // Volumetric Weight row
  //
  //   List<String> volumetricWeightRow = ["Volumetric Weight(in KG)"];
  //   for (var i = 0; i < boxNo; i++) {
  //     volumetricWeightRow.add("");
  //   }
  //   volumetricWeightRow.add(volumetricWeight.toString());
  //   tableData.add(List.from(volumetricWeightRow));
  //
  //   // Actual Weight row
  //   List<String> actualWeightRow = ["Actual Weight(in KG)"];
  //   for (var i = 0; i < boxNo; i++) {
  //     actualWeightRow.add(weightControllers[i].text);
  //     actualWeight = actualWeight + double.parse(weightControllers[i].text);
  //   }
  //   actualWeightRow.add(actualWeight.toString());
  //   tableData.add(List.from(actualWeightRow));
  //
  //   // Volume row
  //   double totalVolume = 0.0;
  //   List<String> volumeRow = ["Volume (in cubic ft)"];
  //   for (var i = 0; i < boxNo; i++) {
  //     // (H*W*L/1238) 2 digit after point and convert to double
  //     double volumeInCubic = double.parse(
  //         ((double.parse(heightControllers[i].text) *
  //                     double.parse(widthControllers[i].text) *
  //                     double.parse(lengthControllers[i].text)) /
  //                 1728)
  //             .toStringAsFixed(2));
  //     volumeRow.add(volumeInCubic.toString());
  //     totalVolume = totalVolume + volumeInCubic;
  //   }
  //   volumeRow.add(totalVolume.toString());
  //   tableData.add(List.from(volumeRow));
  //
  //   // Height row
  //   double totalHeight = 0;
  //   List<String> heightRow = ["Height (in inches)"];
  //   for (var i = 0; i < boxNo; i++) {
  //     heightRow.add(heightControllers[i].text);
  //     totalHeight = totalHeight + double.parse(heightControllers[i].text);
  //   }
  //   heightRow.add(totalHeight.toString());
  //   tableData.add(List.from(heightRow));
  //
  //   // Width row
  //   double totalWidth = 0;
  //   List<String> widthRow = ["Width (in inches)"];
  //   for (var i = 0; i < boxNo; i++) {
  //     widthRow.add(widthControllers[i].text);
  //     totalWidth = totalWidth + double.parse(widthControllers[i].text);
  //   }
  //   widthRow.add(totalWidth.toString());
  //   tableData.add(List.from(widthRow));
  //
  //   // Length row
  //   double totalLength = 0;
  //   List<String> lengthRow = ["Length (in inches)"];
  //   for (var i = 0; i < boxNo; i++) {
  //     lengthRow.add(lengthControllers[i].text);
  //     totalLength = totalLength + double.parse(lengthControllers[i].text);
  //   }
  //   lengthRow.add(totalLength.toString());
  //   tableData.add(List.from(lengthRow));
  //
  //   // // Box row
  //   // List<String> boxRow = ["Box"];
  //   // for (var i = 1; i <= boxNo; i++) {
  //   //   boxRow.add(i.toString());
  //   // }
  //   // boxRow.add(""); // Empty column at the end
  //   // tableData.add(List.from(boxRow));
  //
  //   maxValW = volumetricWeight > weight ? volumetricWeight : weight;
  //
  //   maximumRow[maximumRow.length - 1] = maxValW.toString();
  //   // tableData.removeAt(1);
  //   tableData[1] = maximumRow;
  //   // tableData.add(maximumRow);
  // }

  void _updateInvoiceCount(
      String value, TextEditingController controller, int maxLimit, int num) {
    int count = 0;

    if (value.isEmpty) {
      count = 0;
    }

    // Prevent the first character from being '0'1
    if (value.isNotEmpty && value.startsWith("0")) {
      controller.text = controller.text.replaceFirst('0', '');
      count = controller.text.isNotEmpty ? int.parse(controller.text) : 0;
    }

    // If the entered value is numeric
    if (value.isNumericOnly) {
      final int enteredCount = int.parse(value);
      if (enteredCount > maxLimit) {
        controller.text = maxLimit.toString();
        count = maxLimit;
        CustomBottomSheet.showSnackBar(
            context, "Input can't be greater than $maxLimit");
      } else {
        count = enteredCount;
      }
    } else {
      // If non-numeric characters are detected, remove the last character
      if (controller.text.isNotEmpty) {
        controller.text =
            controller.text.substring(0, controller.text.length - 1);
        count = controller.text.isNotEmpty ? int.parse(controller.text) : 0;
      }
    }

    setState(() {
      if (num == 1 && invoiceCount != count) {
        invoiceCount = count;
        invoiceControllers =
            List.generate(invoiceCount, (index) => TextEditingController());
        valueControllers =
            List.generate(invoiceCount, (index) => TextEditingController());

        // Initialize with false for all entries
        uploadFileStatus = List.generate(invoiceCount, (index) => false);
        uploadedFileName = List.generate(invoiceCount, (index) => null);
      } else if (num == 2 && boxCount != count) {
        boxCount = count;
        weightControllers =
            List.generate(boxCount, (index) => TextEditingController());
        lengthControllers =
            List.generate(boxCount, (index) => TextEditingController());
        widthControllers =
            List.generate(boxCount, (index) => TextEditingController());
        heightControllers =
            List.generate(boxCount, (index) => TextEditingController());
      }
    });
  }

  Widget _buildDropdownAndTextField() {
    return Form(
      key: _formKey2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomDropdown(
            hintText: 'Select courier company for dispatch',
            options: courierOption.keys.toList(),
            onChanged: (val) {
              setState(() => selectedCourier = val);
              _manifestationController.isOwnSelected.value =
                  val == "Own Arrangement" ? true : false;
            },
            selectedValue: selectedCourier,
            validator: (value) => value == null || value.isEmpty
                ? 'Please Select courier company'
                : null,
          ),
          SizedBox(height: mq.height * .01),
          Text('Admin Remarks:\nAlways check physically before manifesting'),
          CustomTextFormField(
            controller: remarksController,
            text: 'Manifestation Remarks',
            validator: (value) =>
                value == null || value.isEmpty ? 'Please enter remarks' : null,
            onChanged: (value) async {
              String filteredValue =
                  await ControllerUtils.remarksValidation(value);
              if (filteredValue != value) {
                remarksController.text = filteredValue;
              }
            },
          ),
          SizedBox(height: mq.height * .01),
          Obx(
            () => _manifestationController.isOwnSelected.value
                ? Column(
                    children: [
                      CustomTextFormField(
                        controller: lrController,
                        text: 'LR Number',
                        validator: (value) => value == null || value.isEmpty
                            ? 'Please enter LR Number'
                            : null,
                        onChanged: (value) {
                          // Allow only letters, numbers, and hyphens
                          String filteredValue =
                              value.replaceAll(RegExp(r'[^a-zA-Z0-9\-]'), '');

                          if (value != filteredValue) {
                            lrController.value = TextEditingValue(
                              text: filteredValue,
                              selection: TextSelection.collapsed(
                                  offset: filteredValue.length),
                            );
                          }
                        },
                      ),
                      CustomTextFormField(
                        controller: transportNameController,
                        text: 'Transporter Name/Courier Service',
                        validator: (value) => value == null || value.isEmpty
                            ? 'Please enter Transporter Name/Courier Service'
                            : null,
                        onChanged: (value) {
                          // Allow only a-z, A-Z, 0-9, space, underscore, and hyphen
                          String filteredValue =
                              value.replaceAll(RegExp(r'[^a-zA-Z0-9 _-]'), '');

                          // Prevent infinite loop or unnecessary rebuild
                          if (value != filteredValue) {
                            // Update the text and move cursor to the end
                            transportNameController.value = TextEditingValue(
                              text: filteredValue,
                              selection: TextSelection.collapsed(
                                  offset: filteredValue.length),
                            );
                          }
                        },
                      ),
                      CustomTextFormField(
                        controller: contactPersonNameController,
                        text: 'Contact Person’s Name',
                        validator: (value) => value == null || value.isEmpty
                            ? 'Please enter Contact Person’s Name'
                            : null,
                        onChanged: (value) {
                          // Allow only letters, spaces, apostrophes, periods, and hyphens
                          String filteredValue =
                              value.replaceAll(RegExp(r"[^a-zA-Z .'-]"), '');

                          if (value != filteredValue) {
                            contactPersonNameController.value =
                                TextEditingValue(
                              text: filteredValue,
                              selection: TextSelection.collapsed(
                                  offset: filteredValue.length),
                            );
                          }
                        },
                      ),
                      CustomTextFormField(
                        controller: contactPersonPhoneController,
                        text: 'Contact Person’s Phone Number',
                        validator: (value) => value == null || value.isEmpty
                            ? 'Please enter Contact Person’s Phone Number'
                            : null,
                        textInputType: TextInputType.phone,
                        onChanged: (value) {
                          // Remove all non-digit characters
                          String filteredValue =
                              value.replaceAll(RegExp(r'[^0-9]'), '');

                          // Disallow starting with 0–5
                          if (filteredValue.isNotEmpty &&
                              !RegExp(r'^[6-9]').hasMatch(filteredValue)) {
                            filteredValue = ''; // Clear if it starts with 0–5
                          }

                          // Limit to 10 digits
                          if (filteredValue.length > 10) {
                            filteredValue = filteredValue.substring(0, 10);
                          }

                          // Set the value
                          contactPersonPhoneController.value = TextEditingValue(
                            text: filteredValue,
                            selection: TextSelection.collapsed(
                                offset: filteredValue.length),
                          );
                        },
                      ),
                      CustomTextFormField(
                        controller: contactPersonEmailController,
                        text: 'Contact Person’s Email ID',
                        validator: (value) => value == null || value.isEmpty
                            ? 'Please enter Contact Person’s Email ID'
                            : null,
                        onChanged: (value) {
                          // Allow only valid email characters
                          String filteredValue =
                              value.replaceAll(RegExp(r'[^a-zA-Z0-9@._-]'), '');

                          // Update only if different
                          if (value != filteredValue) {
                            contactPersonEmailController.value =
                                TextEditingValue(
                              text: filteredValue,
                              selection: TextSelection.collapsed(
                                  offset: filteredValue.length),
                            );
                          }
                        },
                      ),
                    ],
                  )
                : SizedBox.shrink(),
          ),
          CustomElevatedButton(
            onTap: () async {
              if (_formKey2.currentState!.validate()) _onClickSubmit();
            },
            text: 'Submit',
          )
        ],
      ),
    );
  }

  /// function for take and upload PDF
  Future<void> pickAndUploadPdf(int index, String value) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.single.path != null) {
      File pdfFile = File(result.files.single.path!);
      var response = await ApiService().manifestationInvoicePdfUpload(
          pdfFile: pdfFile, bigID: bigIds[0], seqNo: '${index + 1}');
      if (response['success']) {
        final data = response['data'];
        final fileName = data[0]['FileName'];
        setState(() {
          uploadFileStatus[index] = true;
          uploadedFileName[index] = fileName;
        });
        AppDialog.midPopUp(AppImages.check, 'File Saved');
      } else {
        CustomBottomSheet.showSnackBar(context, response['message']);
      }
    } else {
      CustomBottomSheet.showSnackBar(context, "No file selected");
    }
  }

  //On click submit of manifestation
  Future<void> _onClickSubmit() async {
    // check all invoiceFile uploaded or not
    bool allTrue = false;
    allTrue = uploadFileStatus.every((status) => status == true);
    if (!allTrue) {
      CustomBottomSheet.showSnackBar(context, 'Please Upload all Invoice PDF');
      return;
    }

    String bigId = bigIds.join(','); //separate big id with comma (,)
    String? selectedCompanyCode =
        courierOption[selectedCourier]; //selected companyCode for courier
    List itemInvoiceList = [];

    for (int i = 0; i < invoiceCount; i++) {
      String itemInvoiceEntry =
          '${invoiceControllers[i].text}|${valueControllers[i].text}|${uploadedFileName[i]}';
      itemInvoiceList.add(itemInvoiceEntry);
    }

    String itemInvoice = itemInvoiceList.join(",");

    //company data according to selected dropdown
    CalculateFreightCostModel? selectedCompany;
    bool isSelectedCostHighest = false;

    //variable
    // String? dropdownCompanyCode;
    // String? estFreightCost;
    // String? chargeableWeight;
    // String? volumetricWT;
    // String? oDAChargePickup;
    // String? oDAChargeDelivery;
    // String? handlingCharge;

    // check if Own Arrangement is not selected then selected company data store
    if (_manifestationController.isOwnSelected.value == false) {
      selectedCompany = calculateFCList.firstWhere(
        (company) => company.companyCode == int.parse(selectedCompanyCode!),
        orElse: () => CalculateFreightCostModel(), // empty default instance
      );

      // dropdownCompanyCode = selectedCompany.companyCode.toString();
      // estFreightCost = selectedCompany.estCost.toString();
      // chargeableWeight = selectedCompany.minChargeableWeight.toString();
      // volumetricWT = selectedCompany.volumetricWt.toString();
      // oDAChargePickup = selectedCompany.odaChargePickup.toString();
      // oDAChargeDelivery = selectedCompany.odaChargeDelivery.toString();
      // handlingCharge = selectedCompany.handlingCharges.toString();

      // Now check if selectedCompany's cost is highest among all
      isSelectedCostHighest = calculateFCList.any(
        (company) =>
            company.companyCode != selectedCompany?.companyCode &&
            (selectedCompany?.estCost ?? 0) > (company.estCost ?? 0),
      );

      //clear all onw arrangement controller
      lrController.clear();
      transportNameController.clear();
      contactPersonNameController.clear();
      contactPersonPhoneController.clear();
      contactPersonEmailController.clear();
    }

    int userId = await getIntData('tCode');

    //function for call api for final submission after all pop-ups
    Future<void> confirmAndManifest() async {
      // Call the API
      _manifestationController.isLoadingCFCSubmit.value = true;
      var response = await ApiService().manifestation(
        bigIDs: bigId,
        // companyCode: selectedCompanyCode ?? "3",
        companyCode: _manifestationController.isOwnSelected.value
            ? "3"
            : selectedCompanyCode ?? "3",
        remarks: remarksController.text,
        noofInvoioce: invoiceCount.toString(),
        itemInvoice: itemInvoice,
        noofBoxes: boxCount.toString(),
        itemBox: itemBox.toString(),
        estFreightCost: selectedCompany?.estCost.toString() ?? "0",
        chargeableWeight:
            selectedCompany?.minChargeableWeight.toString() ?? "0",
        volumetricWt: selectedCompany?.volumetricWt.toString() ?? "0",
        odaChargePickup: selectedCompany?.odaChargePickup.toString() ?? "0",
        odaChargeDelivery: selectedCompany?.odaChargeDelivery.toString() ?? "0",
        handlingCharges: selectedCompany?.handlingCharges.toString() ?? "0",
        tat: selectedCompany?.tat.toString() ?? "",
        buyerZone: selectedCompany?.buyerZone ?? "",
        sellerZone: selectedCompany?.sellerZone ?? "",
        lrNumber: lrController.text,
        transporterName: transportNameController.text,
        contactPerson: contactPersonNameController.text,
        phone: contactPersonPhoneController.text,
        emailID: contactPersonEmailController.text,
        itemCN: "",
        noofCN: "",
        loginUserID: userId.toString(),
      );
      _manifestationController.isLoadingCFCSubmit.value = false;

      if (response['success']) {
        Get.back();
        Get.back();
        await _manifestationController.manifestationAsSeller(
            locationId!, 'RESPONSECONFIRM');
        AppDialog.midPopUp(AppImages.check, 'Order Manifested Successfully');
      } else {
        CustomBottomSheet.showSnackBar(context, response['message']);
      }
    }

    void confirmDialog(String message, VoidCallback onYes) {
      AppDialog.dialogForYesNo(
        message,
        AppImages.decisionMaking,
        () {
          Get.back();
          onYes();
        },
        () => Get.back(),
      );
    }

    //check dropdown courier if not selected own arrangement
    if (selectedCompany != null) {
      confirmDialog(
        "Are you sure Dimensions is correct\nVol. Weight(KG): ${selectedCompany.volumetricWt}\nFreight Cost: ${selectedCompany.totalCost}",
        () {
          if (isSelectedCostHighest) {
            confirmDialog(
              "LSP chosen has higher estimated cost\nDo you want to proceed?",
              () {
                confirmDialog(
                  "Are you sure? You want to Manifest",
                  confirmAndManifest,
                );
              },
            );
          } else {
            confirmDialog(
              "Are you sure? You want to Manifest",
              confirmAndManifest,
            );
          }
        },
      );
    } else {
      confirmDialog(
        "Are you sure? You want to Manifest",
        confirmAndManifest,
      );
    }
  }
}
