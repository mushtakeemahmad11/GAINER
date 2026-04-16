import 'package:flutter/material.dart';
import 'package:gainer/dealer_monitoring/core/theme/app_colors.dart';
import 'package:gainer/dealer_monitoring/widgets/animated_drop_icon.dart';
import 'package:get/get.dart';
import '../screens/substitution_check/substitution_check_screen.dart';

class StockCardSaleTrend extends StatefulWidget {
  final String colorType;
  final Map<String, String> infoMap;
  final String dropText;
  final Widget showDetailsContent;

  const StockCardSaleTrend({
    super.key,
    required this.colorType,
    required this.infoMap,
    required this.dropText,
    required this.showDetailsContent,
  });

  @override
  State<StockCardSaleTrend> createState() => _StockCardSaleTrendState();
}

class _StockCardSaleTrendState extends State<StockCardSaleTrend>
    with SingleTickerProviderStateMixin {
  bool showDetails = false;

  Color getColor(String type) {
    switch (type) {
      case 'Stockable':
        return DMAppColors.stockable;
      case 'Non-Stockable':
        return DMAppColors.nonStockable;
      case 'Non-Moving':
        return DMAppColors.nonMoving;
      default:
        return DMAppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(10))),
          color: getColor(widget.colorType),
          margin: EdgeInsets.zero,
          child: Padding(
              padding: const EdgeInsets.all(10),
              child:
                  // widget.isSaleTrend == false ?
                  Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Build info rows from key-value map
                  ...widget.infoMap.entries.map(
                    (entry) => Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            entry.key,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Expanded(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(child: Text(entry.value)),
                            if (entry.value == "Y") _buildSubstitutionText(),
                          ],
                        )),
                      ],
                    ),
                  ),
                ],
              )
              // : Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       keyValRow(
              //           "Part Number", widget.infoMap["Part Number"] ?? "--"),
              //       keyValRow(
              //           "Description", widget.infoMap["Description"] ?? "--"),
              //       keyValRow("Part Category",
              //           widget.infoMap["Part Category"] ?? "--"),
              //       keyValRow(
              //           "Part Rate", widget.infoMap["Part Rate"] ?? "0"),
              //       Row(
              //         mainAxisAlignment: MainAxisAlignment.start,
              //         children: [
              //           Expanded(
              //               child: keyValRow(
              //                   "Max", widget.infoMap["Max"] ?? "0")),
              //           Expanded(
              //               child: keyValRow(
              //                   "Stock", widget.infoMap["Stock"] ?? "0")),
              //         ],
              //       ),
              //       keyValRow("Substitution", "Y"),
              //       keyValRow("Sale 3M", widget.infoMap["Sale 3M"] ?? "--"),
              //       keyValRow("Sale 6M", widget.infoMap["Sale 6M"] ?? "--"),
              //     ],
              //   ),
              ),
        ),
        GestureDetector(
          onTap: () => setState(() {
            showDetails = !showDetails;
          }),
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(10))),
            color: Color(0xFF68A2A3),
            margin: EdgeInsets.zero,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  widget.dropText,
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                AnimatedDropIcon(isTrue: showDetails)
              ],
            ),
          ),
        ),
        ClipRect(
          child: AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: showDetails
                ? widget.showDetailsContent
                : const SizedBox.shrink(),
          ),
        ),
      ],
    );
  }

  Widget _buildSubstitutionText() {
    return GestureDetector(
      onTap: onTapSubstitution,
      child: Text(
        "(Check Substitution)",
        style: TextStyle(color: Colors.teal),
      ),
    );
  }

  Future<void> onTapSubstitution() async {
    Get.to(
      () => Scaffold(
        appBar: AppBar(
          title: Text("Substitution Check"),
        ),
        body: SafeArea(
          child: SubstitutionCheckScreen(),
        ),
      ),
      arguments: {
        "partNumber": widget.infoMap["Part Number"],
      },
    );
  }
}
