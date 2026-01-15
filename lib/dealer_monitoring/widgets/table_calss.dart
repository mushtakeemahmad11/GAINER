import 'package:flutter/material.dart';
import 'package:gainer/dealer_monitoring/core/theme/app_colors.dart';

import '../../main.dart';
import '../core/utils/transform_value_ind.dart';

class TableClass extends StatelessWidget {
  // final String? monthTitle;
  final List<String> vehicleHeaderTitles; // keys for vehicle header and row
  final List<Map<String, dynamic>>
      advisorData; // full list of vehicles with "parts"
  final List<String>
      advisorHeaderTitles; // keys for parts table headers and row
  final Color evenColor;
  final Color oddColor;
  final void Function(Map<String, dynamic> part, String locationID,
      List<Map<String, dynamic>>? advisorList) onPartTap;

  const TableClass({
    super.key,
    // this.monthTitle,
    required this.vehicleHeaderTitles,
    required this.advisorData,
    required this.advisorHeaderTitles,
    required this.evenColor,
    required this.oddColor,
    required this.onPartTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      itemCount: advisorData.length,
      itemBuilder: (context, index) {
        final vehicle = advisorData[index];
        final advisors =
            vehicle["advisor"] as List<Map<String, dynamic>>? ?? [];
        // final isEven = index.isEven;
        final locationID = vehicle['LocationId'];
        return Column(
          children: [
            // if (index == 0 && monthTitle?.isNotEmpty == true) Text(monthTitle??""),
            if (index == 0) _buildHeaderRow(),
            ExpansionTile(
              // iconColor: isEven ? Colors.white : Colors.black,
              // collapsedIconColor: isEven ? Colors.white : Colors.black,
              // backgroundColor: isEven ? evenColor : oddColor,
              // collapsedBackgroundColor: isEven ? evenColor : oddColor,
              backgroundColor: Colors.teal[100],
              // backgroundColor: oddColor,
              collapsedBackgroundColor: oddColor,
              // textColor: isEven ? Colors.white : Colors.black,
              // collapsedTextColor: isEven ? Colors.white : Colors.black,
              title: _buildTitleRow(vehicle),
              visualDensity: const VisualDensity(vertical: -4),
              shape: Border(), // removes bottom border
              collapsedShape: Border(), // removes top border
              // tilePadding: EdgeInsets.symmetric(horizontal: 16.0), // optional
              // childrenPadding: EdgeInsets.symmetric(horizontal: 16.0), // optional
              children: [
                advisors.isEmpty
                    ? _buildEmptyAdvisorRow()
                    : _buildAdvisorTable(advisors, locationID),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildHeaderRow() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(color: evenColor),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: vehicleHeaderTitles
            .map(
              (title) => Padding(
                padding: const EdgeInsets.only(
                  right: 50,
                ),
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildTitleRow(Map<String, dynamic> advisor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      // children: vehicleHeaderTitles
      //     .map((key) => Text(
      //           "${advisor[key] ?? ''}",
      //           style: const TextStyle(fontWeight: FontWeight.bold),
      //         ))
      //     .toList(),
      children: vehicleHeaderTitles.map((key) {
        final value = advisor[key];
        final displayValue = value is num
            // ? value.toStringAsFixed(2)
            // ? value.toInt().toString()
            ? "₹${TransformValue().formatIndianNumber(value.toInt())}"
            : value?.toString() ?? '';
        return Text(
          displayValue,
          style: const TextStyle(fontWeight: FontWeight.bold),
        );
      }).toList(),
    );
  }

  Widget _buildEmptyAdvisorRow() {
    return Container(
      width: double.infinity,
      color: evenColor,
      padding: const EdgeInsets.all(12),
      child: Center(
        child: Text(
          "No advisor available",
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildAdvisorTable(
      List<Map<String, dynamic>> advisors, String locationID) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Table(
        // border: TableBorder.all(),
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        // columnWidths: {
        //   for (int i = 0; i < advisorHeaderTitles.length; i++)
        //     i: const IntrinsicColumnWidth(),
        // },

        columnWidths: {
          // 0: FlexColumnWidth(1),
          // 1: FlexColumnWidth(1),
          0: FixedColumnWidth(mq.width * .48),
          1: FixedColumnWidth(mq.width * .48),
        },
        // const columnWidths = <int, TableColumnWidth>{
        //   0: IntrinsicColumnWidth(),
        //   1: FixedColumnWidth(150),
        //   2: FixedColumnWidth(100),
        //   3: FixedColumnWidth(60),
        //   4: FixedColumnWidth(60),
        //   5: FixedColumnWidth(80),
        // };

        children: [
          // Header row
          TableRow(
            // decoration: BoxDecoration(color: evenColor),
            decoration: BoxDecoration(color: DMAppColors.accent),
            children: advisorHeaderTitles
                .map((e) => _tableCell(e, isHeader: true))
                .toList(),
          ),
          // Data rows
          ...advisors.map<TableRow>((part) {
            return TableRow(
              decoration: BoxDecoration(
                  // color: _getRowColor(part["stockType"]),
                  color: Colors.green[100]),
              children: advisorHeaderTitles.map((key) {
                String text = (key == "PPNI Value")
                    ? "₹${TransformValue().formatIndianNumber(part[key].toInt())}"
                    : "${part[key] ?? ''}";

                return GestureDetector(
                  onTap: () => onPartTap(part, locationID, advisors),
                  // child: _tableCell("${part[key] ?? ''}"),
                  child: _tableCell(text),
                );
              }).toList(),
            );
          }),
        ],
      ),
    );
  }

  Widget _tableCell(String content, {bool isHeader = false}) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Center(
        child: Text(
          content,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isHeader ? Colors.white : Colors.black,
            fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  // Color _getRowColor(String? highlight) {
  //   switch (highlight) {
  //     case "green":
  //       return Colors.green[100]!;
  //     case "red":
  //       return Colors.red[100]!;
  //     case "yellow":
  //       return Colors.yellow[100]!;
  //     default:
  //       return Colors.white;
  //   }
  // }
}
