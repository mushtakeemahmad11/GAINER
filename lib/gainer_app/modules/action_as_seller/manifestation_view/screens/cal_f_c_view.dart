import 'package:flutter/material.dart';
import 'package:gainer/gainer_app/core/utils/gainer_text_filed_validator.dart';
import 'package:gainer/gainer_app/core/utils/input_formatters.dart';
import 'package:gainer/gainer_app/core/widgets/gainer_expansion_tile.dart';
import 'package:gainer/gainer_app/core/widgets/scrollable_text_widget.dart';
import '../../../../core/widgets/gainer_app_bar.dart';
import 'package:get/get.dart';
import '../../../../core/constants/gainer_color.dart';
import '../../../../core/widgets/gainer_app_loader.dart';
import '../../../../core/widgets/gainer_primary_button.dart';
import '../../../../core/widgets/gainer_text_form_field.dart';
import '../models/cal_f_c_model.dart';
import '../controllers/cal_f_c_controller.dart';

class CalFCView extends GetView<CalFCController> {
  const CalFCView({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: GainerAppBar(title: 'Cal Freight'),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: size.width * .03,
              vertical: size.height * .02,
            ),
            child: Form(
              key: controller.formKey,
              child: ListView(
                children: [
                  _invoiceCountSection(size),
                  const SizedBox(height: 5),
                  Obx(() => _invoiceList()),
                  const SizedBox(height: 5),
                  _boxCountSection(size),
                  const SizedBox(height: 5),
                  Obx(() => _boxList()),
                  const SizedBox(height: 5),
                  _distanceSection(size),
                  const SizedBox(height: 5),
                  GainerPrimaryButton(
                    title: '₹ Calculate Freight',
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      controller.calculateFreight();
                    },
                  ),
                  const SizedBox(height: 8),
                  _warningText(),
                  const SizedBox(height: 16),
                  Obx(() => controller.isLoadingFC.value
                      ? const Center(child: CircularProgressIndicator())
                      : _courierList(size)),
                  const SizedBox(height: 16),
                  // _remarksAndSubmit(),
                ],
              ),
            ),
          ),

          /// Loader on Submit
          GainerAppLoader(isLoading: controller.isLoadingCFCSubmit),
        ],
      ),
    );
  }

  //──────────────────────────────── INVOICE ────────────────────────────────//

  Widget _invoiceCountSection(Size size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Invoice Count',
            style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(
          width: size.width * .4,
          child: _inputFiled(
            // keyboardType: TextInputType.number,
            label: "Invoice Count",
            controller: controller.invoiceCountController,
            onChanged: (val) => controller.updateCount(
              value: val,
              controller: controller.invoiceCountController,
              maxLimit: 10,
              type: 1,
            ),
          ),
        ),
      ],
    );
  }

  Widget _invoiceList() {
    return Column(
      spacing: 5,
      children: List.generate(
        controller.invoiceCount.value,
        (i) => Row(
          children: [
            Text('${i + 1}'),
            const SizedBox(width: 8),
            Expanded(
              child: _inputFiled(
                label: "Invoice No",
                controller: controller.invoiceNoControllers[i],
                keyboardType: TextInputType.text,
                onChanged: (value) async {
                  // Allow only letters, numbers, spaces, dashes (-), and commas (,)
                  String filteredValue =
                      await GainerTextFiledValidator.alphaNumericValidation(
                          value);
                  if (value != filteredValue) {
                    controller.invoiceNoControllers[i].text = filteredValue;
                  }
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _inputFiled(
                  label: "Value",
                  controller: controller.invoiceValueControllers[i],
                  // keyboardType: TextInputType.number,
                  onChanged: (value) async {
                    controller.invoiceValueControllers[i].text =
                        await GainerTextFiledValidator.numericWithDecimal(
                            value, 2, 999999999999);
                  }),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: Icon(
                controller.invoiceUploaded[i]
                    ? Icons.check_circle
                    : Icons.attach_file,
                color:
                    controller.invoiceUploaded[i] ? Colors.green : Colors.grey,
              ),
              onPressed: () => controller.pickInvoicePdf(i),
            )
          ],
        ),
      ),
    );
  }

  //──────────────────────────────── BOX ────────────────────────────────//

  Widget _boxCountSection(Size size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('No of Boxes',
            style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(
          width: size.width * .4,
          child: _inputFiled(
            label: "Boxes",
            controller: controller.boxCountController,
            // keyboardType: TextInputType.number,
            // onChanged: controller.updateBoxCount,
            onChanged: (val) => controller.updateCount(
              value: val,
              controller: controller.boxCountController,
              maxLimit: 20,
              type: 2,
            ),
          ),
        ),
      ],
    );
  }

  Widget _boxList() {
    int count = controller.boxCount.value;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (count > 0)
          Padding(
            padding: const EdgeInsets.only(left: 20.0, bottom: 5.0),
            // child: Text('All measurement in inches except weight(in KG)'),
            child: Text('All measurements in inches, weight in kg.'),
          ),
        Column(
          spacing: 5,
          children: List.generate(
            controller.boxCount.value,
            (i) => Row(
              children: [
                Text('${i + 1}'),
                const SizedBox(width: 5),
                _boxField("Weight", controller.weightControllers[i]),
                _boxField("Length", controller.lengthControllers[i]),
                _boxField("Width", controller.widthControllers[i]),
                _boxField("Height", controller.heightControllers[i]),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _boxField(String label, TextEditingController c) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3),
        child: _inputFiled(
            label: label,
            controller: c,
            // keyboardType: TextInputType.number,
            onChanged: (value) async {
              c.text = await GainerTextFiledValidator.numericWithDecimal(
                  value, 1, 999);
            }),
      ),
    );
  }

  //──────────────────────────────── DISTANCE ────────────────────────────────//

  Widget _distanceSection(Size size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Distance (KM)',
            style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(
          width: size.width * .4,
          child: _inputFiled(
            label: "Distance",
            keyboardType: TextInputType.number,
            controller: controller.distanceController,
            onChanged: (val) => controller.updateCount(
              value: val,
              controller: controller.distanceController,
              maxLimit: 3676,
              type: 3,
            ),
          ),
        ),
      ],
    );
  }

  //──────────────────────────────── COURIER ────────────────────────────────//

  Widget _courierList(Size size) {
    final fcList = controller.calculateFCList;
    // if (controller.couriers.isEmpty) return const SizedBox();
    if (fcList.isEmpty) return const SizedBox();
    final lastCourier = controller.couriers.last;

    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: fcList.length,
          itemBuilder: (context, index) {
            final item = fcList[index];
            return _buildExpansionTile(item, index, size, context);
          },
        ),
        Container(
          padding: const EdgeInsets.all(2.0),
          decoration: BoxDecoration(
            color: GainerColors.lightWhite,
            border: Border.all(color: GainerColors.border),
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          child: ListTile(
            dense: true,
            // contentPadding: const EdgeInsets.symmetric(horizontal: 15.0),
            leading: SizedBox(
              width: 10,
              child: Checkbox(
                activeColor: GainerColors.primary,
                value: controller.selectedCourier.value == lastCourier,
                onChanged: (_) => controller.selectCourier(lastCourier),
              ),
            ),
            title: Text(lastCourier.name),
          ),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: _redText(" **GST Cost Applicable"),
        ),
        const SizedBox(height: 5),
        _remarksAndSubmit(),
      ],
    );
  }

  Widget _buildExpansionTile(
      CalFCModel item, int index, Size size, BuildContext context) {
    final courier = controller.couriers[index];
    controller.table1DataSet(item);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 4.0),
          child: Container(
            padding: const EdgeInsets.all(2.0),
            decoration: BoxDecoration(
              border: Border.all(color: GainerColors.border),
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            child: GainerExpansionTile(
              titleWidget: Row(
                spacing: 10,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // _buildExpansionTileTitle(item.partNumber),
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: Checkbox(
                      activeColor: GainerColors.primary,
                      value: controller.selectedCourier.value == courier,
                      onChanged: (_) => controller.selectCourier(courier),
                    ),
                  ),

                  _buildHeaderCol(
                    '${item.companyName}',
                    'W(KG): ${item.weight?.toInt()}',
                  ),

                  _buildHeaderCol(
                    'Appx Freight Cost*',
                    '₹ ${item.estCost?.ceilToDouble().toInt()}',
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeadText('TAT'),
                      _buildHeadText('${item.tat} Days'),
                    ],
                  )
                ],
              ),
              bodyChildren: [
                Container(
                  decoration: GainerColors.gradientDecoration,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minWidth: MediaQuery.of(context).size.width,
                            ),
                            child: Table(
                              border: TableBorder.all(),
                              columnWidths: _buildColumnWidths(
                                  controller.tableData.first.length),
                              defaultVerticalAlignment:
                                  TableCellVerticalAlignment.middle,
                              children: controller.tableData
                                  .map((row) => _buildRow(row))
                                  .toList(),
                            ),
                          ),
                        ),
                        SizedBox(height: size.height * .02),
                        _buildDetailsTable(item),
                      ],
                    ),
                  ),
                ),
              ],
              is48Complete: false,
            ),
          ),
        ),
        // Padding(
        //   padding: const EdgeInsets.only(bottom: 4.0),
        //   child: Container(
        //     padding: const EdgeInsets.all(2.0),
        //     decoration: BoxDecoration(
        //       border: Border.all(color: GainerColors.border),
        //       borderRadius: BorderRadius.all(Radius.circular(8)),
        //     ),
        //     child: ExpansionTile(
        //       // dense: true,
        //       tilePadding: const EdgeInsets.symmetric(horizontal: 10),
        //       backgroundColor: GainerColors.lightWhite,
        //       collapsedBackgroundColor: GainerColors.lightWhite,
        //       shape: RoundedRectangleBorder(
        //           borderRadius: BorderRadius.circular(8)),
        //       collapsedShape: RoundedRectangleBorder(
        //           borderRadius: BorderRadius.circular(8)),
        //       title: Row(
        //         spacing: 10,
        //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //         children: [
        //           // _buildExpansionTileTitle(item.partNumber),
        //           SizedBox(
        //             width: 20,
        //             height: 20,
        //             child: Checkbox(
        //               activeColor: GainerColors.primary,
        //               value: controller.selectedCourier.value == courier,
        //               onChanged: (_) => controller.selectCourier(courier),
        //             ),
        //           ),
        //
        //           _buildHeaderCol(
        //             '${item.companyName}',
        //             'W(KG): ${item.weight?.toInt()}',
        //           ),
        //
        //           _buildHeaderCol(
        //             'Appx Freight Cost*',
        //             '₹ ${item.estCost?.ceilToDouble().toInt()}',
        //           ),
        //
        //           Column(
        //             crossAxisAlignment: CrossAxisAlignment.start,
        //             children: [
        //               _buildHeadText('TAT'),
        //               _buildHeadText('${item.tat} Days'),
        //             ],
        //           )
        //
        //           ///-------------
        //           // Column(
        //           //   children: [
        //           //     _buildExpansionTileTitle('${item.companyName}', size),
        //           //     _buildExpansionTileTitle(
        //           //         'W(KG): ${item.weight?.toInt()}', size),
        //           //   ],
        //           // ),
        //           // const SizedBox(width: 1),
        //           //
        //           // Column(
        //           //   children: [
        //           //     _buildExpansionTileTitle('Appx Freight Cost*', size),
        //           //     _buildExpansionTileTitle(
        //           //         '₹ ${item.estCost?.ceilToDouble().toInt()}', size),
        //           //   ],
        //           // ),
        //           // const SizedBox(width: 1),
        //           // Column(
        //           //   crossAxisAlignment: CrossAxisAlignment.end,
        //           //   children: [
        //           //     Text(
        //           //       'TAT',
        //           //       style: const TextStyle(
        //           //           fontSize: 12, fontWeight: FontWeight.bold),
        //           //     ),
        //           //     Text(
        //           //       '${item.tat} Days',
        //           //       style: const TextStyle(
        //           //           fontSize: 12, fontWeight: FontWeight.bold),
        //           //     )
        //           //   ],
        //           // ),
        //         ],
        //       ),
        //
        //       ///---------------
        //       // tilePadding: const EdgeInsets.symmetric(horizontal: 10),
        //       // shape:
        //       //     RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        //       // collapsedShape:
        //       //     RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        //       // backgroundColor: GainerColors.background,
        //       // collapsedBackgroundColor: GainerColors.background,
        //       children: [
        //         Container(
        //           decoration: _gradientDecoration(),
        //           child: Padding(
        //             padding: const EdgeInsets.all(8),
        //             child: Column(
        //               children: [
        //                 SingleChildScrollView(
        //                   scrollDirection: Axis.horizontal,
        //                   child: ConstrainedBox(
        //                     constraints: BoxConstraints(
        //                       minWidth: MediaQuery.of(context).size.width,
        //                     ),
        //                     child: Table(
        //                       border: TableBorder.all(),
        //                       columnWidths: _buildColumnWidths(
        //                           controller.tableData.first.length),
        //                       defaultVerticalAlignment:
        //                           TableCellVerticalAlignment.middle,
        //                       children: controller.tableData
        //                           .map((row) => _buildRow(row))
        //                           .toList(),
        //                     ),
        //                   ),
        //                 ),
        //
        //                 // Table(
        //                 //   border: TableBorder.all(),
        //                 //   columnWidths: const {
        //                 //     0: FlexColumnWidth(3),
        //                 //   },
        //                 //   children: controller.tableData
        //                 //       .map((row) => _buildRow(row))
        //                 //       .toList(),
        //                 // ),
        //                 SizedBox(height: size.height * .02),
        //                 _buildDetailsTable(item),
        //               ],
        //             ),
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
      ],
    );
  }


  Map<int, TableColumnWidth> _buildColumnWidths(int columnCount) {
    final Map<int, TableColumnWidth> widths = {};

    for (int i = 0; i < columnCount; i++) {
      if (i == 0) {
        widths[i] = const FixedColumnWidth(150); // first column fixed
      } else {
        widths[i] = const IntrinsicColumnWidth(); // others by content
      }
    }

    return widths;
  }

  _buildHeadText(String text) => Text(
        text,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
      );

  _buildHeaderCol(String text1, String text2) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ScrollableTextWidget(textWidget: _buildHeadText(text1)),
          _buildHeadText(text2),
        ],
      ),
    );
  }

  // _buildExpansionTileTitle(String text, Size size) {
  //   return SizedBox(
  //     width: size.width * .27,
  //     child: SingleChildScrollView(
  //       scrollDirection: Axis.horizontal,
  //       child: Text(
  //         text,
  //         style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
  //       ),
  //     ),
  //   );
  // }

  Widget _buildDetailsTable(CalFCModel item) {
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
        // TableRow(
        //   children: [
        //     Text(
        //       "**Taxes Extra",
        //       style: TextStyle(color: Colors.red),
        //     ),
        //     _tableCell(""),
        //   ],
        // ),
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
            textAlign: isHeader ? TextAlign.center : TextAlign.end,
          ),
        );
      }).toList(),
    );
  }
  //──────────────────────────────── REMARKS ────────────────────────────────//

  Widget _remarksAndSubmit() {
    return Form(
      key: controller.submitFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Admin Remarks:\nAlways check physically before manifesting'),
          const SizedBox(height: 5),
          GainerTextFormField(
            label: 'Manifestation Remarks*',
            validator: (value) =>
                value == null || value.isEmpty ? 'Please enter remarks' : null,
            controller: controller.remarksController,
            keyboardType: TextInputType.text,
            onChanged: (value) async {
              String filteredValue =
                  await GainerTextFiledValidator.remarksValidation(value);
              if (filteredValue != value) {
                controller.remarksController.text = filteredValue;
              }
            },
          ),
          SizedBox(height: 5),
          Obx(
            () => controller.isOwnSelected.value
                ? Column(
                    spacing: 5,
                    children: [
                      GainerTextFormField(
                        isDense: false,
                        controller: controller.lrController,
                        label: 'LR Number*',
                        validator: (value) => value == null || value.isEmpty
                            ? 'Please enter LR number'
                            : null,
                        onChanged: (value) {
                          // Allow only letters, numbers, and hyphens
                          String filteredValue =
                              value.replaceAll(RegExp(r'[^a-zA-Z0-9\-]'), '');

                          if (value != filteredValue) {
                            controller.lrController.value = TextEditingValue(
                              text: filteredValue,
                              selection: TextSelection.collapsed(
                                  offset: filteredValue.length),
                            );
                          }
                        },
                      ),
                      GainerTextFormField(
                        isDense: false,
                        controller: controller.transportNameController,
                        label: 'Transporter Name/Courier Service*',
                        validator: (value) => value == null || value.isEmpty
                            ? 'Please enter transporter name/courier service'
                            : null,
                        onChanged: (value) {
                          // Allow only a-z, A-Z, 0-9, space, underscore, and hyphen
                          String filteredValue =
                              value.replaceAll(RegExp(r'[^a-zA-Z0-9 _-]'), '');

                          // Prevent infinite loop or unnecessary rebuild
                          if (value != filteredValue) {
                            // Update the text and move cursor to the end
                            controller.transportNameController.value =
                                TextEditingValue(
                              text: filteredValue,
                              selection: TextSelection.collapsed(
                                  offset: filteredValue.length),
                            );
                          }
                        },
                      ),
                      GainerTextFormField(
                        isDense: false,
                        controller: controller.contactPersonNameController,
                        label: 'Contact Person’s Name*',
                        validator: (value) => value == null || value.isEmpty
                            ? 'Please enter contact person’s name'
                            : null,
                        onChanged: (value) {
                          // Allow only letters, spaces, apostrophes, periods, and hyphens
                          String filteredValue =
                              value.replaceAll(RegExp(r"[^a-zA-Z .'-]"), '');

                          if (value != filteredValue) {
                            controller.contactPersonNameController.value =
                                TextEditingValue(
                              text: filteredValue,
                              selection: TextSelection.collapsed(
                                  offset: filteredValue.length),
                            );
                          }
                        },
                      ),
                      GainerTextFormField(
                        isDense: false,
                        controller: controller.contactPersonPhoneController,
                        label: 'Contact Person’s Phone Number*',
                        // validator: (value) => value == null || value.isEmpty
                        //     ? 'Please enter Contact Person’s Phone Number'
                        //     : null,
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter contact person’s phone number';
                          }

                          if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                            return 'Enter a valid 10-digit phone number';
                          }

                          return null; // ✅ valid
                        },
                        keyboardType: TextInputType.phone,
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
                          controller.contactPersonPhoneController.value =
                              TextEditingValue(
                            text: filteredValue,
                            selection: TextSelection.collapsed(
                                offset: filteredValue.length),
                          );
                        },
                      ),
                      GainerTextFormField(
                        isDense: false,
                        controller: controller.contactPersonEmailController,
                        keyboardType: TextInputType.emailAddress,
                        inputFormatters: [GainerInputFormatters.email],
                        label: 'Contact Person’s Email ID',
                        // validator: (value) => value == null || value.isEmpty
                        //     ? 'Please enter Contact Person’s Email ID'
                        //     : null,
                        validator: (value) => value == null ||
                                value.isEmpty ||
                                RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)
                            ? null
                            : 'Please enter a valid email id',
                        onChanged: (value) {
                          // Allow only valid email characters
                          // String filteredValue =
                          //     value.replaceAll(RegExp(r'[^a-zA-Z0-9@._-]'), '');

                          // Update only if different
                          // if (value != filteredValue) {
                          //   controller.contactPersonEmailController.value =
                          //       TextEditingValue(
                          //     text: filteredValue,
                          //     selection: TextSelection.collapsed(
                          //         offset: filteredValue.length),
                          //   );
                          // }
                        },
                      ),
                      const SizedBox(height: 5),
                    ],
                  )
                : SizedBox.shrink(),
          ),
          GainerPrimaryButton(
            title: 'Submit',
            onPressed: controller.submitManifestation,
          ),
        ],
      ),
    );
  }

  Widget _warningText() {
    return _redText(
      "⚠ Freight is calculated based on dimensions. Ensure to input CORRECT DIMENSION.\n"
      "Courier will charge based on dimensions & No request for dimension change will be entertained later.",
      // "⚠ Freight is calculated based on dimensions.\nEnsure correct measurements.\nCourier will charge based on dimensions updated/actual dimension & NO Request for dimension change will be entertained later.",
    );
  }

  _redText(String text) => Text(
        text,
        style: TextStyle(color: Colors.red, fontSize: 12),
        textAlign: TextAlign.center,
      );

  Widget _inputFiled({
    required String label,
    required TextEditingController controller,
    Function(String)? onChanged,
    TextInputType keyboardType = TextInputType.number,
  }) {
    return GainerTextFormField(
      label: label,
      controller: controller,
      onChanged: onChanged,
      keyboardType: keyboardType,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "$label is required";
        }
        return null;
      },
    );
  }

  String? emailValidator(String? value) =>
      value != null && RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)
          ? null
          : 'Invalid email';
}
