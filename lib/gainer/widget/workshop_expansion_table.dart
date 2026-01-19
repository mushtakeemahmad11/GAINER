import 'package:flutter/material.dart';
import 'package:gainer/dealer_monitoring/widgets/info_tap_widget.dart';
import 'package:get/get.dart';
import '../../dealer_monitoring/controllers/workshop_part_controller.dart';
import '../../dealer_monitoring/core/theme/app_colors.dart';
import '../../dealer_monitoring/core/utils/transform_value_ind.dart';
import '../../dealer_monitoring/widgets/remarks_bottom_sheet.dart';
import '../../dealer_monitoring/widgets/reusable_table.dart';
import '../../main.dart';

class WorkshopExpansionTable extends StatefulWidget {
  final List<Map<String, dynamic>> enhancedPpniData;
  final String dealerId;
  final String locationId;
  final String advisorName;
  final String jobCard;
  final String nonStockable;
  final String monthDate;

  const WorkshopExpansionTable({
    super.key,
    required this.enhancedPpniData,
    required this.dealerId,
    required this.locationId,
    required this.advisorName,
    required this.jobCard,
    required this.nonStockable,
    required this.monthDate,
  });

  @override
  State<WorkshopExpansionTable> createState() => _WorkshopExpansionTableState();
}

class _WorkshopExpansionTableState extends State<WorkshopExpansionTable> {
  late final String _tag;
  late final WorkshopPartsController _c;

  @override
  void initState() {
    super.initState();
    _tag = 'WorkshopPartsController_${UniqueKey()}';
    _c = Get.put(
      WorkshopPartsController(
        dealerId: widget.dealerId,
        locationId: widget.locationId,
        advisorName: widget.advisorName,
        jobCardStatus: widget.jobCard,
        nonStockable: widget.nonStockable,
        monthDate: widget.monthDate,
      ),
      tag: _tag,
      permanent: false,
    );
  }

  @override
  void dispose() {
    if (Get.isRegistered<WorkshopPartsController>(tag: _tag)) {
      Get.delete<WorkshopPartsController>(tag: _tag, force: true);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      // key: const PageStorageKey('lv_workshop_expansion_table'), // unique
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
      itemCount: widget.enhancedPpniData.length,
      separatorBuilder: (_, __) => const SizedBox(),
      itemBuilder: (context, index) {
        final vehicle = widget.enhancedPpniData[index];
        final vno = (vehicle['vehicleNumber'] ?? '').toString();

        return Column(
          children: [
            if (index == 0) _buildHeaderRow(),
            Obx(() {
              final parts = _c.partsByVehicle[vno];
              final isLoading = _c.loading.contains(vno);
              final error = _c.errors[vno];

              return ExpansionTile(
                // key: PageStorageKey('exp_$vno'),
                onExpansionChanged: (expanded) {
                  if (expanded && parts == null && !isLoading) {
                    _c.fetchPartsForVehicle(vno);
                  }
                },
                backgroundColor: DMAppColors.primary,
                collapsedBackgroundColor: DMAppColors.primary,
                title: _buildTitleRow(vehicle, context),
                tilePadding: const EdgeInsets.symmetric(horizontal: 5),
                visualDensity: const VisualDensity(vertical: -4),
                children: [
                  if (isLoading) _buildLoadingRow(),
                  if (!isLoading && error != null) _buildErrorRow(vno, error),
                  if (!isLoading &&
                      error == null &&
                      (parts == null || parts.isEmpty))
                    _buildEmptyPartsRow(),
                  if (!isLoading &&
                      error == null &&
                      parts != null &&
                      parts.isNotEmpty)
                    _buildPartsTable(parts, context),
                ],
              );
            }),
          ],
        );
      },
    );
  }

  Widget _buildLoadingRow() {
    return Container(
      color: DMAppColors.secondary,
      padding: const EdgeInsets.all(14),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              )),
          SizedBox(width: 8),
          Text(
            "Loading parts...",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorRow(String vno, String error) {
    return Container(
      color: Colors.redAccent.shade100,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Expanded(
            child: Text("Failed to load parts: $error",
                style: const TextStyle(color: Colors.black)),
          ),
          TextButton(
            onPressed: () => _c.fetchPartsForVehicle(vno),
            child: const Text("Retry"),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyPartsRow() {
    return Container(
      color: DMAppColors.secondary,
      padding: const EdgeInsets.all(8),
      child: const Center(
        child: Text(
          "No parts available",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildHeaderRow() {
    Widget headTitle(String title) => Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        );

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(color: DMAppColors.secondary),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: mq.width * .28,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: headTitle("Vehicle No"),
            ),
          ),
          SizedBox(
            width: mq.width * .35,
            child: Center(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                // child: headTitle("Pen/Dmd"),
                // child: headTitle("InStk/Tot NI"),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InfoTap(
                      label: "InStk ℹ️",
                      info: "Not issued lines that are available in stock",
                    ),
                    const Text("/", style: TextStyle(color: Colors.white)),
                    InfoTap(label: "Tot NI ℹ️", info: "Total not issued lines"),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            width: mq.width * .25,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: headTitle("₹ PPNI Value"),
            ),
          ),
        ],
      ),
    );
  }

  // Widget buildInfoTap(BuildContext context, String label, String info) {
  //   return GestureDetector(
  //     onTapDown: (TapDownDetails details) {
  //       final tapPosition = details.globalPosition;
  //       showMenu(
  //         context: context,
  //         position: RelativeRect.fromLTRB(
  //           tapPosition.dx,
  //           tapPosition.dy,
  //           tapPosition.dx,
  //           tapPosition.dy,
  //         ),
  //         items: [
  //           PopupMenuItem(
  //             enabled: false,
  //             child: Text(info),
  //           ),
  //         ],
  //       );
  //     },
  //     child: Text(
  //       label,
  //       style: TextStyle(color: Colors.white),
  //     ),
  //   );
  // }

  Widget _buildTitleRow(Map<String, dynamic> vehicle, BuildContext context) {
    Widget title(String text, {bool isUnderLine = false}) => Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            decoration:
                isUnderLine ? TextDecoration.underline : TextDecoration.none,
          ),
        );

    final ppni =
        "₹${TransformValue().formatIndianNumber((vehicle["ppniValue"] ?? 0).toInt())}";
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () => showRemarksBottomSheet(context, vehicle, "v"),
          child: title(
            (vehicle["vehicleNumber"] ?? "").toString().toUpperCase(),
            isUnderLine: true,
          ),
        ),
        title("${vehicle["inStockCount"]}/${vehicle["notIssued"]}"),
        title(ppni),
      ],
    );
  }

  Widget _buildPartsTable(List parts, BuildContext context) {
    return ReusableTable(
      headers: [
        "Part No.",
        "Ordered Qty",
        "Stock Qty",
        "NDP Value",
        "Remarks Reason",
        "Category",
        "Description"
      ],
      rows: parts
          .map<List<dynamic>>((part) => [
                part["partNumber"],
                part["demandedQty"],
                part["qty"],
                "₹${TransformValue().formatIndianNumber(part["value"].toInt())}",
                _buildRemarksReason(part, context),
                part["category"],
                part["description"],
              ])
          .toList(),
      columnWidths: const [
        IntrinsicColumnWidth(),
        FixedColumnWidth(70),
        FixedColumnWidth(60),
        FixedColumnWidth(100),
        FixedColumnWidth(85),
        FixedColumnWidth(100),
        FixedColumnWidth(150),
      ],

      rowColorsList: parts.map((item) {
        switch (item['alltimestk']) {
          case "Y":
            return Colors.pink[100];
          case "N":
            return Colors.green[300];
          default:
            return DMAppColors.primary;
        }
      }).toList(),
      // onRowLongPress: (item) {
      //   print("Item Print on LongPress of table: $item");
      //   showRemarksDialog(context, "Vehicle No. $item");
      // },
    );
  }

  Widget _buildRemarksReason(Map<String, dynamic> part, BuildContext context) {
    return IconButton(
      onPressed: () {
        // print("On Tap Parts: $part");
        showRemarksBottomSheet(context, part, "p");
      },
      icon: Icon(Icons.edit_note),
      color: Colors.black,
    );
  }

  // Widget _buildPartsTable(
  //     List<Map<String, dynamic>> parts, BuildContext context) {
  //   print("valuee:: ${parts[0]['value'].toInt()}");
  //   print("₹${TransformValue().formatIndianNumber(parts[0]['value'].toInt())}");
  //   print("Part in table: $parts");
  //   return ReusableTable(
  //     headers: const [
  //       "Part No.",
  //       "Ordered Qty",
  //       "Stock Qty",
  //       // "NDP Value",
  //       "Remarks Reason",
  //       "Category",
  //       "Description"
  //     ],
  //     rows: [[
  //       parts[0]["partNumber"],
  //       parts[0]["demandedQty"],
  //       parts[0]["qty"],
  //       // "₹${TransformValue().formatIndianNumber((parts[0]).toInt())}",
  //       // "₹${TransformValue().formatIndianNumber(parts[0]['value'].toInt())}",
  //       _buildRemarksReason(parts[0], context),
  //       parts[0]["category"],
  //       parts[0]["description"],
  //     ]],
  //     // rows: parts.map<List<dynamic>>((part) {
  //     //   final value = (part["value"] ?? 0);
  //     //   return [
  //     //     part["partNumber"],
  //     //     part["demandedQty"],
  //     //     part["qty"],
  //     //     "₹${TransformValue().formatIndianNumber((value as num).toInt())}",
  //     //     _buildRemarksReason(part, context),
  //     //     part["category"],
  //     //     part["description"],
  //     //   ];
  //     // }).toList(),
  //     columnWidths: const [
  //       IntrinsicColumnWidth(),
  //       FixedColumnWidth(70),
  //       FixedColumnWidth(60),
  //       // FixedColumnWidth(100),
  //       FixedColumnWidth(85),
  //       FixedColumnWidth(100),
  //       FixedColumnWidth(150),
  //     ],
  //     rowColorsList: parts.map((item) {
  //       switch (item['alltimestk']) {
  //         case "Y":
  //           return Colors.pink[100];
  //         case "N":
  //           return Colors.green[300];
  //         default:
  //           return DMAppColors.primary;
  //       }
  //     }).toList(),
  //   );
  // }
  //
  // Widget _buildRemarksReason(Map<String, dynamic> part, BuildContext context) {
  //   return IconButton(
  //     onPressed: () =>
  //         showRemarksBottomSheet(context, "Part No. ${part["partNumber"]}"),
  //     icon: const Icon(Icons.edit_note),
  //     color: Colors.black,
  //   );
  // }

  void showRemarksBottomSheet(
    BuildContext context,
    Map<String, dynamic> item,
    String screenType,
  ) {
    final controller = Get.put(RemarksController(), permanent: false);
    controller.reset();
    // final screenType = number.startsWith("V") ? "v" : "p";
    String titleText = screenType == "p"
        ? "Part No. ${item["partNumber"]}"
        : "Vehicle No. ${item["vehicleNumber"]}";
    // "Vehicle No. ${vehicle["vehicleNumber"]}"
    controller.fetchDropRemarks(screenType);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: RemarksBottomSheet(
            titleText: titleText,
            item: item,
            screen: "p$screenType",
          ),
        );
      },
    );
  }
}

///

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../../dealer_monitoring/core/services/api_services.dart';
// import '../../dealer_monitoring/core/theme/app_colors.dart';
// import '../../dealer_monitoring/core/utils/transform_value_ind.dart';
// import '../../dealer_monitoring/widgets/remarks_bottom_sheet.dart';
// import '../../dealer_monitoring/widgets/reusable_table.dart';
// import '../../main.dart';
//
// class WorkshopExpansionTable extends StatefulWidget {
//   final List<Map<String, dynamic>> enhancedPpniData;
//   final String dealerId;
//   final String locationId;
//   final String advisorName;
//   final String jobCard;
//   final String nonStockable;
//   final String monthDate;
//
//   const WorkshopExpansionTable({
//     super.key,
//     required this.enhancedPpniData,
//     required this.dealerId,
//     required this.locationId,
//     required this.advisorName,
//     required this.jobCard,
//     required this.nonStockable,
//     required this.monthDate,
//   });
//
//   @override
//   State<WorkshopExpansionTable> createState() => _WorkshopExpansionTableState();
// }
//
// class _WorkshopExpansionTableState extends State<WorkshopExpansionTable> {
//   /// Cache: vehicleNumber -> parts list
//   final Map<String, List<Map<String, dynamic>>> _partsByVehicle = {};
//   /// Loading set: which vehicles are currently fetching
//   final Set<String> _loading = {};
//   /// Errors: vehicleNumber -> error text
//   final Map<String, String> _errors = {};
//
//   @override
//   Widget build(BuildContext context) {
//     return ListView.separated(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
//       itemCount: widget.enhancedPpniData.length,
//       separatorBuilder: (_, __) => const SizedBox(),
//       itemBuilder: (context, index) {
//         final vehicle = widget.enhancedPpniData[index];
//         final vno = (vehicle['vehicleNumber'] ?? '').toString();
//         final parts = _partsByVehicle[vno];
//         final isLoading = _loading.contains(vno);
//         final error = _errors[vno];
//
//         return Column(
//           children: [
//             if (index == 0) _buildHeaderRow(),
//             ExpansionTile(
//               key: PageStorageKey('exp_$vno'), // preserve expand state
//               onExpansionChanged: (expanded) {
//                 if (expanded && parts == null && !isLoading) {
//                   _fetchPartsForVehicle(vno);
//                 }
//               },
//               backgroundColor: DMAppColors.border,
//               collapsedBackgroundColor: DMAppColors.border,
//               title: _buildTitleRow(vehicle, context),
//               tilePadding: const EdgeInsets.symmetric(horizontal: 5),
//               visualDensity: const VisualDensity(vertical: -4),
//               children: [
//                 if (isLoading) _buildLoadingRow(),
//                 if (!isLoading && error != null) _buildErrorRow(vno, error),
//                 if (!isLoading && error == null && (parts == null || parts.isEmpty))
//                   _buildEmptyPartsRow(),
//                 if (!isLoading && error == null && parts != null && parts.isNotEmpty)
//                   _buildPartsTable(parts, context),
//               ],
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   Future<void> _fetchPartsForVehicle(String vehicleNumber) async {
//     setState(() {
//       _loading.add(vehicleNumber);
//       _errors.remove(vehicleNumber);
//     });
//
//     try {
//       // gather params cleanly
//       final dealerId = widget.dealerId;
//       final locationId = widget.locationId;
//       final nonStockable = widget.nonStockable;
//       final jobCardStatus = widget.jobCard;
//       final advisor = widget.advisorName;
//       final monthDate = widget.monthDate;
//
//       final resp = await ApiServices().fetchPPNIParts(
//         vehicleNum: vehicleNumber,
//         dealerId: dealerId,
//         locationId: locationId,
//         nonStockable: nonStockable,
//         jobCardStatus: jobCardStatus,
//         advisor: advisor,
//         monthDate: monthDate,
//       );
//
//       // Expect either:
//       // {success:true, data:[...]} OR {success:false, message:"..."}
//       // or sometimes a bare List if your service returns list directly
//       if (resp is Map && resp['success'] == true) {
//         final List data = (resp['data'] as List?) ?? const [];
//         final parts = data
//             .map((e) => _normalizePart(Map<String, dynamic>.from(e)))
//             .toList();
//         setState(() {
//           _partsByVehicle[vehicleNumber] = parts;
//         });
//       } else if (resp is Map && resp['success'] == false) {
//         final msg = (resp['message'] ?? 'Server error').toString();
//         setState(() => _errors[vehicleNumber] = msg);
//       } else if (resp is List) {
//         final parts = resp
//             .map((e) => _normalizePart(Map<String, dynamic>.from(e)))
//             .toList();
//         setState(() {
//           _partsByVehicle[vehicleNumber] = parts;
//         });
//       } else {
//         setState(() => _errors[vehicleNumber] = 'Unexpected response shape');
//       }
//     } catch (e) {
//       setState(() => _errors[vehicleNumber] = e.toString());
//     } finally {
//       if (mounted) {
//         setState(() {
//           _loading.remove(vehicleNumber);
//         });
//       }
//     }
//   }
//
//   Map<String, dynamic> _normalizePart(Map<String, dynamic> j) {
//     return {
//       'partNumber': j['PartNumber']?.toString() ?? '',
//       'demandedQty': j['DemandedQty'] ?? 0,
//       'qty': j['StockQty'] ?? 0,
//       'value': (j['PPNI_Val'] ?? j['price'] ?? 0),
//       'category': j['part_category'] ?? '',
//       'description': j['PartDesc'] ?? '',
//       'alltimestk': (j['All_Time_NonStck'] ?? '').toString(), // Y/N
//     };
//   }
//
//   // ---------- UI bits ----------
//
//   Widget _buildLoadingRow() {
//     return Container(
//       color: DMAppColors.secondary,
//       padding: const EdgeInsets.all(12),
//       child: const Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)),
//           SizedBox(width: 8),
//           Text(
//             "Loading parts...",
//             style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildErrorRow(String vno, String error) {
//     return Container(
//       color: Colors.redAccent.withOpacity(.2),
//       padding: const EdgeInsets.all(12),
//       child: Row(
//         children: [
//           Expanded(
//             child: Text(
//               "Failed to load parts: $error",
//               style: const TextStyle(color: Colors.black),
//             ),
//           ),
//           TextButton(
//             onPressed: () => _fetchPartsForVehicle(vno),
//             child: const Text("Retry"),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildEmptyPartsRow() {
//     return Container(
//       color: DMAppColors.secondary,
//       padding: const EdgeInsets.all(8),
//       child: const Center(
//         child: Text(
//           "No parts available",
//           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildHeaderRow() {
//     Widget headTitle(String title) => Text(
//       title,
//       style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//     );
//
//     return Container(
//       padding: const EdgeInsets.all(8),
//       decoration: const BoxDecoration(color: DMAppColors.secondary),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           SizedBox(
//             width: mq.width * .28,
//             child: SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: headTitle("Vehicle Number"),
//             ),
//           ),
//           SizedBox(
//             width: mq.width * .35,
//             child: Center(
//               child: SingleChildScrollView(
//                 scrollDirection: Axis.horizontal,
//                 child: headTitle("Pen/Dmd"),
//               ),
//             ),
//           ),
//           SizedBox(
//             width: mq.width * .25,
//             child: SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: headTitle("₹ PPNI Value"),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildTitleRow(Map<String, dynamic> vehicle, BuildContext context) {
//     Widget title(String text, {bool isUnderLine = false}) => Text(
//       text,
//       style: TextStyle(
//         fontWeight: FontWeight.bold,
//         decoration: isUnderLine ? TextDecoration.underline : TextDecoration.none,
//       ),
//     );
//
//     final ppni = "₹${TransformValue().formatIndianNumber((vehicle["ppniValue"] ?? 0).toInt())}";
//     return GestureDetector(
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           GestureDetector(
//             onTap: () => showRemarksBottomSheet(context, "Vehicle No. ${vehicle["vehicleNumber"]}"),
//             child: title((vehicle["vehicleNumber"] ?? "").toString().toUpperCase(), isUnderLine: true),
//           ),
//           title("${vehicle["inStockCount"]}/${vehicle["notIssued"]}"),
//           title(ppni),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildPartsTable(List<Map<String, dynamic>> parts, BuildContext context) {
//     return ReusableTable(
//       headers: const [
//         "Part No.",
//         "Ordered Qty",
//         "Stock Qty",
//         "NDP Value",
//         "Remarks Reason",
//         "Category",
//         "Description"
//       ],
//       rows: parts.map<List<dynamic>>((part) {
//         final value = (part["value"] ?? 0);
//         return [
//           part["partNumber"],
//           part["demandedQty"],
//           part["qty"],
//           "₹${TransformValue().formatIndianNumber((value as num).toInt())}",
//           _buildRemarksReason(part, context),
//           part["category"],
//           part["description"],
//         ];
//       }).toList(),
//       columnWidths: const [
//         IntrinsicColumnWidth(),
//         FixedColumnWidth(70),
//         FixedColumnWidth(60),
//         FixedColumnWidth(100),
//         FixedColumnWidth(85),
//         FixedColumnWidth(100),
//         FixedColumnWidth(150),
//       ],
//       rowColorsList: parts.map((item) {
//         switch (item['alltimestk']) {
//           case "Y":
//             return Colors.pink[100];
//           case "N":
//             return Colors.green[300];
//           default:
//             return DMAppColors.primary;
//         }
//       }).toList(),
//     );
//   }
//
//   Widget _buildRemarksReason(Map<String, dynamic> part, BuildContext context) {
//     return IconButton(
//       onPressed: () => showRemarksBottomSheet(context, "Part No. ${part["partNumber"]}"),
//       icon: const Icon(Icons.edit_note),
//       color: Colors.black,
//     );
//   }
//
//   void showRemarksBottomSheet(BuildContext context, String number) {
//     final controller = Get.put(RemarksController(), permanent: false);
//     controller.reset();
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       builder: (context) {
//         return Padding(
//           padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
//           child: RemarksBottomSheet(number: number),
//         );
//       },
//     );
//   }
// }
//

///
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../dealer_monitoring/core/services/api_services.dart';
// import '../../dealer_monitoring/core/theme/app_colors.dart';
// import '../../dealer_monitoring/core/utils/transform_value_ind.dart';
// import '../../dealer_monitoring/widgets/remarks_bottom_sheet.dart';
// import '../../dealer_monitoring/widgets/reusable_table.dart';
// import '../../main.dart';
//
// class WorkshopExpansionTable extends StatelessWidget {
//   final List<Map<String, dynamic>> enhancedPpniData;
//   final String dealerId;
//   final String locationId;
//   final String advisorName;
//   final String jobCard;
//   final String nonStockable;
//   final String monthDate;
//
//   const WorkshopExpansionTable({
//     super.key,
//     required this.enhancedPpniData,
//     required this.dealerId,
//     required this.locationId,
//     required this.advisorName,
//     required this.jobCard,
//     required this.nonStockable,
//     required this.monthDate,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return ListView.separated(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
//       itemCount: enhancedPpniData.length,
//       separatorBuilder: (_, __) => const SizedBox(),
//       itemBuilder: (context, index) {
//         final vehicle = enhancedPpniData[index];
//         // final parts = vehicle["parts"] as List;
//         final parts = [];
//         return Column(
//           children: [
//             if (index == 0) _buildHeaderRow(),
//             ExpansionTile(
//               onExpansionChanged: (value) async {
//                 print("IsExpansion: $value");
//                 if (value) {
//                   // _fetchPartData();
//                   print("vehicle: ${vehicle['vehicleNumber']}");
//
//                   final response = await ApiServices().fetchPPNIParts(
//                     vehicleNum: vehicle['vehicleNumber'],
//                     dealerId: dealerId,
//                     locationId: locationId,
//                     nonStockable: nonStockable,
//                     jobCardStatus: jobCard,
//                     advisor: advisorName,
//                     monthDate: monthDate
//                   );
//                   print("response in listView: $response");
//                 }
//               },
//               backgroundColor: DMAppColors.border,
//               collapsedBackgroundColor: DMAppColors.border,
//               title: _buildTitleRow(vehicle, context),
//               tilePadding: EdgeInsets.symmetric(horizontal: 5),
//               visualDensity: VisualDensity(vertical: -4),
//               children: [
//                 parts.isEmpty
//                     ? _buildEmptyPartsRow()
//                     : _buildPartsTable(parts, context),
//               ],
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   Widget _buildEmptyPartsRow() {
//     return Container(
//       color: DMAppColors.secondary,
//       // child: _tableCell("No parts available", isHeader: true),
//       child: Padding(
//         padding: EdgeInsets.all(8),
//         child: Center(
//           child: Text(
//             "No parts available",
//             style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildHeaderRow() {
//     Widget headTitle(String title, bool isSymmetric) => Text(title,
//         style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold));
//     return Container(
//       padding: const EdgeInsets.all(8),
//       decoration: BoxDecoration(color: DMAppColors.secondary),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         spacing: 5,
//         children: [
//           SizedBox(
//               width: mq.width * .28,
//               child: SingleChildScrollView(
//                   scrollDirection: Axis.horizontal,
//                   child: headTitle("Vehicle Number", true))),
//           SizedBox(
//             width: mq.width * .35,
//             child: Center(
//               child: SingleChildScrollView(
//                 scrollDirection: Axis.horizontal,
//                 // child: headTitle("Pending/Demanded", false),
//                 child: headTitle("Pen/Dmd", false),
//               ),
//             ),
//           ),
//           SizedBox(
//             width: mq.width * .25,
//             child: SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: headTitle("₹ PPNI Value", false),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildTitleRow(Map<String, dynamic> vehicle, BuildContext context) {
//     Widget title(titleText, {bool isUnderLine = false}) => Text(titleText,
//         style: TextStyle(
//             fontWeight: FontWeight.bold,
//             decoration:
//                 isUnderLine ? TextDecoration.underline : TextDecoration.none));
//
//     String ppni =
//         "₹${TransformValue().formatIndianNumber(vehicle["ppniValue"].toInt())}";
//     return GestureDetector(
//       // onLongPress: () {
//       //   print("LongPress on ${vehicle["vehicleNumber"]}");
//       //   showRemarksBottomSheet(
//       //       context, "Vehicle No. ${vehicle["vehicleNumber"]}");
//       // },
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           GestureDetector(
//               onTap: () {
//                 // print("onTap on ${vehicle["vehicleNumber"]}");
//                 showRemarksBottomSheet(
//                     context, "Vehicle No. ${vehicle["vehicleNumber"]}");
//               },
//               child: title(vehicle["vehicleNumber"].toUpperCase(),
//                   isUnderLine: true)),
//           // Column(
//           //   children: [
//           //     title("${vehicle["notIssued"]}"),
//           //     title("${vehicle["inStockCount"]}"),
//           //   ],
//           // ),
//           title("${vehicle["inStockCount"]}/${vehicle["notIssued"]}"),
//           title(ppni),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildPartsTable(List parts, BuildContext context) {
//     return ReusableTable(
//       headers: [
//         "Part No.",
//         "Ordered Qty",
//         "Stock Qty",
//         "NDP Value",
//         "Remarks Reason",
//         "Category",
//         "Description"
//       ],
//       rows: parts
//           .map<List<dynamic>>((part) => [
//                 part["partNumber"],
//                 part["demandedQty"],
//                 part["qty"],
//                 "₹${TransformValue().formatIndianNumber(part["value"].toInt())}",
//                 _buildRemarksReason(part, context),
//                 part["category"],
//                 part["description"],
//               ])
//           .toList(),
//       columnWidths: const [
//         IntrinsicColumnWidth(),
//         FixedColumnWidth(70),
//         FixedColumnWidth(60),
//         FixedColumnWidth(100),
//         FixedColumnWidth(85),
//         FixedColumnWidth(100),
//         FixedColumnWidth(150),
//       ],
//
//       rowColorsList: parts.map((item) {
//         switch (item['alltimestk']) {
//           case "Y":
//             return Colors.pink[100];
//           case "N":
//             return Colors.green[300];
//           default:
//             return DMAppColors.primary;
//         }
//       }).toList(),
//       // onRowLongPress: (item) {
//       //   print("Item Print on LongPress of table: $item");
//       //   showRemarksDialog(context, "Vehicle No. $item");
//       // },
//     );
//   }
//
//   Widget _buildRemarksReason(Map<String, dynamic> part, BuildContext context) {
//     return IconButton(
//       onPressed: () {
//         // print("On Tap Parts: $part");
//         showRemarksBottomSheet(context, "Part No. ${part["partNumber"]}");
//       },
//       icon: Icon(Icons.edit_note),
//       color: Colors.black,
//     );
//   }
//
//   void showRemarksBottomSheet(BuildContext context, String number) {
//     final controller = Get.put(RemarksController(), permanent: false);
//     controller.reset();
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true, // ✅ Allows keyboard to push sheet up
//       // shape: const RoundedRectangleBorder(
//       //   borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
//       // ),
//       // backgroundColor: DMAppColors.primary,
//       builder: (context) {
//         return Padding(
//           padding: EdgeInsets.only(
//             // ✅ Push sheet above keyboard
//             bottom: MediaQuery.of(context).viewInsets.bottom,
//           ),
//           child: RemarksBottomSheet(number: number),
//         );
//       },
//     );
//   }
// }

///
