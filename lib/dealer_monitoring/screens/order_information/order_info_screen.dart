import 'package:flutter/material.dart';
import 'package:gainer/dealer_monitoring/core/utils/dm_images.dart';
import 'package:gainer/dealer_monitoring/widgets/dm_error_msg.dart';
import 'package:gainer/dealer_monitoring/widgets/head_bar.dart';
import 'package:gainer/dealer_monitoring/widgets/search_bar.dart';
import 'package:gainer/dealer_monitoring/widgets/stock_card_sale_trend.dart';
import 'package:gainer/gainer_app/core/widgets/part_suggestion_list.dart';
import 'package:get/get.dart';
import '../../../main.dart';
import '../../controllers/order_info_controller.dart';
import '../../widgets/dealer_app_loader.dart';
import '../../widgets/dm_dropdown.dart';
import '../../widgets/reusable_table.dart';

class OrderInfoScreen extends StatefulWidget {
  const OrderInfoScreen({super.key});

  @override
  State<OrderInfoScreen> createState() => _OrderInfoScreenState();
}

class _OrderInfoScreenState extends State<OrderInfoScreen> {
  OrderInfoController controller = Get.put(OrderInfoController());
  DateTime? pickedDate = DateTime.now();
  @override
  void dispose() {
    // Dispose the controller when this screen is closed
    Get.delete<OrderInfoController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            HeadBar(
                text: "Order Information", imgSting: DMImages.orderInfo),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: mq.width * 0.02, vertical: mq.width * 0.01),
              child: Column(
                children: [
                  SearchBarWidget(
                    hintText: "Enter Part Number Here",
                    onSearch: controller.onSearch,
                    controller: controller.searchController,
                    formKey: controller.formKey,
                    onChanged: (value) =>
                        controller.fetchPartSuggestions(value),
                  ),
                  _buildPartSuggestion(),
                  _buildDropdown(),
                  // Obx(() {
                  //   return controller.selectedOption.value == "Custom View"
                  //       ? Row(
                  //           children: [
                  //             Expanded(
                  //               child: _buildDateField(
                  //                 context: context,
                  //                 label: 'From Date',
                  //                 selectedDate: controller.fromDate.value,
                  //                 onDatePicked: controller.updateFromDate,
                  //               ),
                  //             ),
                  //             const SizedBox(width: 16),
                  //             Expanded(
                  //               child: _buildDateField(
                  //                 context: context,
                  //                 label: 'To Date',
                  //                 selectedDate: controller.toDate.value,
                  //                 onDatePicked: controller.updateToDate,
                  //               ),
                  //             ),
                  //           ],
                  //         )
                  //       : const SizedBox();
                  // }),
                  ///
                  // const SizedBox(height: 10),
                  // Align(
                  //   alignment: Alignment.topLeft,
                  //   child: SizedBox(
                  //     width: 140,
                  //     child: Column(
                  //       textDirection: TextDirection.ltr,
                  //       // spacing: 10,
                  //       children: [
                  //         SizedBox(
                  //           height: 40,
                  //           child: TextField(
                  //             controller: _fromDateController,
                  //             readOnly: true,
                  //             decoration: InputDecoration(
                  //               // labelText: 'From Date',
                  //               suffixIcon: Icon(Icons.calendar_month),
                  //             ),
                  //             onTap: () =>
                  //                 _selectDate(context: context, isFrom: true),
                  //           ),
                  //         ),
                  //
                  //         SizedBox(
                  //           height: 40,
                  //           child: TextField(
                  //             controller: _toDateController,
                  //             readOnly: true,
                  //             decoration: InputDecoration(
                  //               // labelText: 'From Date',
                  //               suffixIcon: Icon(Icons.calendar_month),
                  //             ),
                  //             onTap: () =>
                  //                 _selectDate(context: context, isFrom: false),
                  //           ),
                  //         )
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  // const SizedBox(height: 10),
                  // ElevatedButton(onPressed: takeDate, child: Text("Date")),
                  // const SizedBox(height: 10),
                  // Row(
                  //   children: [
                  //     Expanded(
                  //       child: TextField(
                  //         controller: _fromDateController,
                  //         readOnly: true,
                  //         decoration: InputDecoration(
                  //           // labelText: 'From Date',
                  //           suffixIcon: Icon(Icons.calendar_month),
                  //           // border: OutlineInputBorder(),
                  //         ),
                  //         onTap: () =>
                  //             _selectDate(context: context, isFrom: true),
                  //       ),
                  //     ),
                  //     const SizedBox(width: 16),
                  //     Expanded(
                  //       child: TextField(
                  //         controller: _toDateController,
                  //         readOnly: true,
                  //         decoration: InputDecoration(
                  //           // labelText: 'To Date',
                  //           suffixIcon: Icon(Icons.calendar_month),
                  //           // border: OutlineInputBorder(),
                  //         ),
                  //         onTap: () =>
                  //             _selectDate(context: context, isFrom: false),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  ///
                  const SizedBox(height: 10),
                  _buildInfoCard(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown() {
    return Obx(() => DmDropdown(
          hintText: "View Last 7 Days",
          options: [
            // "View Last 7 Days",
            "View Last 15 Days",
            "View Last 30 Days",
            "View Last 60 Days",
          ],
          onChanged: (value) {
            if (value != null) {
              controller.setDateRange(value);
            } else {
              controller.setDateRange("View Last 7 Days");
            }
            controller.onSearch();
          },
          selectedValue: controller.selectedOption.value,
        ));
  }

  Widget _buildPartSuggestion() {
    return Obx(() {
      return PartSuggestionList(
        isLoading: controller.partSearchLoading.value,
        suggestions: controller.partSuggestions.toList(),
        onTap: (selected) => controller.selectPartNumber(selected),
      );
    });
  }

  Widget _buildInfoCard() {
    return Obx(() {
      if (controller.isLoading.value) {
        return const DealerAppLoader();
      }
      if (controller.error.value != null || controller.data.isEmpty) {
        return DmErrorMsg(text: controller.error.value ?? "");
      }
      // final orderInfo = controller.orderInfoData;
      final orderDetails = controller.orderDetails;
      final orderInfo = controller.orderInfo;
      final stockQty = controller.stock.value;
      final ooq = controller.ooq.value;
      checkDoubleInt(double val) {
        return val % 1 == 0 //check for remainder 0
            ? val.toInt().toString()
            : val.toStringAsFixed(2);
      }

      return StockCardSaleTrend(
        colorType: "null",
        infoMap: {
          "Part Number": orderDetails['partnumber1'] ?? "",
          "Part Description": orderDetails['partdesc'] ?? "",
          "Part Category": orderDetails['category'] ?? "",
          "Stock Qty": checkDoubleInt(stockQty),
          "OOQ": checkDoubleInt(ooq),
        },
        dropText: "View Order Details",
        showDetailsContent: _listViewTable(orderInfo),
      );
    });
  }

  Widget _listViewTable(List<dynamic> orderInfo) {
    if (orderInfo.isEmpty) {
      return Text("Order information not found");
    }
    return ListView.builder(
      padding: EdgeInsets.only(top: 10),
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: orderInfo.length,
      itemBuilder: (BuildContext context, int index) {
        final order = orderInfo[index];
        final dateTime = controller.formatDate(order['addeddate']);
        return Padding(
          padding: const EdgeInsets.only(bottom: 2),
          child: Column(
            children: [
              Container(
                color: Colors.black,
                padding: EdgeInsets.all(5),
                child: Row(
                  spacing: 8,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: _buildWhiteText(order['scsorderno'])),
                    Flexible(child: _buildWhiteText(dateTime)),
                  ],
                ),
              ),
              ReusableTable(
                headers: [
                  "Stock",
                  "OOQ",
                  "Final Order Qty",
                  "Transfer From Branch",
                  "Order Placed",
                  "Remarks"
                ],
                rows: [
                  [
                    order['OpeningStock'] ?? 0,
                    order['ooq'] ?? 0,
                    order['FinalOrderQty'] ?? 0,
                    order['transferfrombranch'] ?? 0,
                    order['OrderQtyPlaced'] ?? 0,
                    order['DealerRemarks'] ?? '',
                  ]
                ],
                columnWidths: const [
                  IntrinsicColumnWidth(),
                  IntrinsicColumnWidth(),
                  // FixedColumnWidth(50),
                  FixedColumnWidth(80),
                  FixedColumnWidth(75),
                  FixedColumnWidth(65),
                  FixedColumnWidth(75),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  Widget _buildWhiteText(String text) {
    return Text(
      text,
      style: TextStyle(color: Colors.white),
    );
  }

  // takeDate() async {
  //   pickedDate = await showDatePicker(
  //     context: context,
  //     initialDate: DateTime.now(),
  //     firstDate: DateTime(2000),
  //     lastDate: DateTime(2100),
  //   );
  //
  //   if (pickedDate != null) {
  //     String date = "${pickedDate!.day}";
  //     print("Selected Date: $pickedDate  $date");
  //   }
  // }

  // /// Reusable function to build a date field
  // Widget _buildDateField({
  //   required BuildContext context,
  //   required String label,
  //   required DateTime? selectedDate,
  //   required Function(DateTime) onDatePicked,
  // }) {
  //   DateTime currentDate = DateTime.now();
  //   return TextField(
  //     controller: TextEditingController(
  //       text: selectedDate != null
  //           ? selectedDate.toLocal().toString().split(' ')[0]
  //           : label,
  //     ),
  //     readOnly: true,
  //     decoration: const InputDecoration(
  //       suffixIcon: Icon(Icons.calendar_month),
  //     ),
  //     onTap: () async {
  //       final picked = await showDatePicker(
  //         context: context,
  //         initialDate: selectedDate ?? DateTime.now(),
  //         firstDate: DateTime(2023),
  //         // lastDate: DateTime(2100),
  //         lastDate: currentDate,
  //       );
  //       if (picked != null) {
  //         onDatePicked(picked);
  //       }
  //     },
  //   );
  // }
}
