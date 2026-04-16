import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:gainer/dealer_monitoring/widgets/dm_error_msg.dart';
import '../core/theme/app_colors.dart';

class BarChartWidget extends StatelessWidget {
  final bool showChart;
  final bool showLakhsText;
  final List<Map<String, double>> data; // List of {"label": value, ...}
  final bool showBoth; // If true, show 2 bars per group
  final bool showWorkShopSale; // If true, show workShop sale else counter Sale
  final Color workShopSale;
  final Color counterSale;
  final List<String> xLabels;
  final List<String> monthDate;
  final String? error;
  final Function(String,String)? onBarTap;

  const BarChartWidget({
    super.key,
    this.showLakhsText = true,
    required this.showChart,
    required this.data,
    required this.showBoth,
    this.showWorkShopSale = false,
    this.workShopSale = Colors.blue,
    this.counterSale = Colors.orange,
    required this.xLabels,
    required this.monthDate,
    this.error,
    this.onBarTap,
  });

  @override
  Widget build(BuildContext context) {
    List<BarChartGroupData> barGroups = [];

    for (int i = 0; i < data.length; i++) {
      final y1 = data[i]['y1'] ?? 0;
      final y2 = data[i]['y2'] ?? 0;
      // final hasY2 = showBoth && y2 > 0;

      BorderRadius borderRadius =
          BorderRadius.vertical(top: Radius.circular(5));

      // Prepare barRods based on actual data
      // final rods = hasY2
      final rods = showBoth
          ? [
              BarChartRodData(
                toY: y1,
                color: workShopSale,
                width: 7,
                borderRadius: borderRadius,
              ),
              BarChartRodData(
                toY: y2,
                color: counterSale,
                width: 7,
                borderRadius: borderRadius,
              ),
            ]
          : [
              BarChartRodData(
                toY: y1,
                color: showWorkShopSale ? workShopSale : counterSale,
                width: 7,
                borderRadius: borderRadius,
              ),
            ];

      // Use rod count directly for tooltip indicators
      barGroups.add(
        BarChartGroupData(
          x: i,
          barsSpace: 5,
          barRods: rods,
          // showingTooltipIndicators: showBoth ? [0, 1] : [0],
          showingTooltipIndicators:
              List.generate(rods.length, (index) => index),
        ),
      );
    }

    return Align(
      alignment: Alignment.topCenter,
      child: AnimatedSize(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
        child: showChart
            ? Container(
                margin: EdgeInsets.all(8),
                padding:
                    error != null ? EdgeInsets.zero : EdgeInsets.only(top: 30),
                decoration: BoxDecoration(
                  color: DMAppColors.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: error != null && error!.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DmErrorMsg(text: "$error for Showing Graph"),
                      )
                    : Column(
                        children: [
                          AspectRatio(
                            aspectRatio: 1.7, //1.2
                            // aspectRatio: 1.5,
                            child: Padding(
                              padding: const EdgeInsets.all(6),
                              child: BarChart(
                                BarChartData(
                                  maxY: _getMaxY(data),
                                  barGroups: barGroups,
                                  titlesData: FlTitlesData(
                                    show: true,
                                    bottomTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        getTitlesWidget:
                                            (double value, TitleMeta meta) {
                                          return SideTitleWidget(
                                            meta: meta,
                                            // show X Asis month name
                                            child: Text(
                                              xLabels.length > value.toInt()
                                                  ? xLabels[value.toInt()]
                                                  : '',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                // fontSize: 14,
                                                fontSize: 12,
                                                color: Color(0xff7589a2),
                                              ),
                                            ),
                                          );
                                        },
                                        reservedSize: 42,
                                      ),
                                    ),
                                    leftTitles: AxisTitles(
                                      sideTitles: SideTitles(showTitles: false),
                                    ),
                                    topTitles: const AxisTitles(
                                      sideTitles: SideTitles(showTitles: false),
                                    ),
                                    rightTitles: const AxisTitles(
                                      sideTitles: SideTitles(showTitles: false),
                                    ),
                                  ),
                                  gridData: const FlGridData(show: false),
                                  borderData: FlBorderData(show: false),
                                  barTouchData: BarTouchData(
                                    enabled: true,

                                    /// on tap of the bar graph
                                    handleBuiltInTouches:
                                        true, // Needed to enable gesture handling
                                    touchCallback:
                                        (FlTouchEvent event, barTouchResponse) {
                                      if (event is FlTapUpEvent &&
                                          barTouchResponse != null) {
                                        final spot = barTouchResponse.spot;
                                        if (spot != null) {
                                          final int index =
                                              spot.touchedBarGroupIndex;
                                          // final double value = spot.rod.toY;
                                          // final double value =
                                          //     spot.touchedRodData.toY;
                                          onBarTap?.call(monthDate.reversed
                                              .toList()[index],xLabels[index]);
                                          // print(
                                          //     "Bar tapped: Index: $index, Label: ${xLabels[index]}, Value: $value");
                                          // final date =  monthDate.reversed.toList();
                                          // final tappedDate = date[index];
                                          // Call external callback if provided
                                          // onBarTap?.call(tappedDate);
                                          // Example operation: show a dialog
                                          // showDialog(
                                          //   context: context,
                                          //   builder: (ctx) => AlertDialog(
                                          //     title: Text("Bar Clicked"),
                                          //     content: Text("Label: ${xLabels[index]}\nValue: $value"),
                                          //     actions: [
                                          //       TextButton(onPressed: () => Navigator.pop(ctx), child: Text("OK"))
                                          //     ],
                                          //   ),
                                          // );
                                        }
                                      }
                                    },

                                    ///
                                    touchTooltipData: BarTouchTooltipData(
                                      getTooltipColor: (group) => Colors
                                          .transparent, //remove value background
                                      tooltipPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 5, vertical: 2),
                                      tooltipMargin: 0,
                                      getTooltipItem:
                                          (group, groupIndex, rod, rodIndex) {
                                        //format vale
                                        String formatValue(double value) {
                                          // Check if the value is a whole number
                                          if (value == value.toInt()) {
                                            return value
                                                .toInt()
                                                .toString(); // Return as integer without decimal
                                          } else {
                                            // return value.toStringAsFixed(1);  // Return with one decimal place if it's a floating-point number
                                            return value.toStringAsFixed(
                                                2); // Return with one decimal place if it's a floating-point number
                                          }
                                        }

                                        return BarTooltipItem(
                                          // rod.toY.toStringAsFixed(1),
                                          formatValue(rod.toY),
                                          const TextStyle(
                                            // color: Colors.black,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            // fontSize: 12,
                                            fontSize: 10,
                                          ),
                                        );
                                      },
                                    ),
                                  ),

                                  // barTouchData: BarTouchData(
                                  //   enabled: false,
                                  //   touchTooltipData: BarTouchTooltipData(
                                  //     getTooltipColor: (group) => Colors.transparent, //remove value background color
                                  //     tooltipPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                  //     tooltipMargin: 0, // between lineGraph and value
                                  //     getTooltipItem: (group, groupIndex, rod, rodIndex) {
                                  //       //format vale
                                  //       String formatValue(double value) {
                                  //         // Check if the value is a whole number
                                  //         if (value == value.toInt()) {
                                  //           return value.toInt().toString();  // Return as integer without decimal
                                  //         } else {
                                  //           return value.toStringAsFixed(1);  // Return with one decimal place if it's a floating-point number
                                  //         }
                                  //       }
                                  //       return BarTooltipItem(
                                  //         // rod.toY.toStringAsFixed(1),
                                  //         formatValue(rod.toY),
                                  //         const TextStyle(
                                  //           color: Colors.black,
                                  //           fontWeight: FontWeight.bold,
                                  //         ),
                                  //       );
                                  //     },
                                  //   ),
                                  // ),
                                ),
                              ),
                            ),
                          ),
                          if (showLakhsText)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: Text(
                                "Value In Lakhs",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                        ],
                      ),
              )
            : const SizedBox.shrink(),
      ),
    );
  }

  double _getMaxY(List<Map<String, double>> data) {
    double max = 0;
    for (var item in data) {
      if (showBoth) {
        max = [
          max,
          item['y1'] ?? 0,
          item['y2'] ?? 0,
        ].reduce((a, b) => a > b ? a : b);
      } else {
        max = [max, item['y1'] ?? 0].reduce((a, b) => a > b ? a : b);
      }
    }
    // return max == 0 ? 10 : max + 5;
    return max == 0 ? 10 : max * 1.1; // 10% padding on top of the bar line
  }
}
