import 'package:flutter/material.dart';
import 'package:gainer/dealer_monitoring/controllers/sale_trend_controller.dart';
import 'package:gainer/dealer_monitoring/core/utils/dm_images.dart';
import 'package:gainer/dealer_monitoring/widgets/head_bar.dart';
import 'package:gainer/dealer_monitoring/widgets/search_bar.dart';
import 'package:gainer/dealer_monitoring/widgets/stock_card_sale_trend.dart';
import 'package:get/get.dart';
import '../../../gainer/widget/error_msg.dart';
import '../../../gainer/widget/reusable_dropdown.dart';
import '../../../gainer/widget/suggestion_list.dart';
import '../../../main.dart';
import '../../widgets/bar_chart_widget.dart';
import '../../widgets/legend_bar.dart';

class SaleTrendScreen extends StatefulWidget {
  const SaleTrendScreen({super.key});

  @override
  State<SaleTrendScreen> createState() => _SaleTrendScreenState();
}

class _SaleTrendScreenState extends State<SaleTrendScreen> {
  final SaleTrendController _saleTrendController =
      Get.put(SaleTrendController());
  @override
  void dispose() {
    // Dispose the controller when this screen is closed
    Get.delete<SaleTrendController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            HeadBar(text: "Sale Trend", imgSting: DMImages.saleTrend),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: mq.width * .02),
              child: Column(
                spacing: 5,
                children: [
                  SearchBarWidget(
                    hintText: "Enter Part Number",
                    onSearch: () async {
                      await _saleTrendController.search();
                      if (_saleTrendController.combinedChartData.isNotEmpty) {
                        _saleTrendController.updateChartData(
                            _saleTrendController.selectedSaleType.value);
                      }
                    },
                    controller: _saleTrendController.searchController,
                    formKey: _saleTrendController.formKey,
                    onChanged: (value) =>
                        _saleTrendController.fetchPartSuggestions(value),
                  ),
                  _buildPartSuggestion(),
                  _buildDropdown(),
                  const LegendBar(),
                  _showStockCard(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPartSuggestion() {
    return Obx(() {
      return SuggestionList(
        isLoading: _saleTrendController.partSearchLoading.value,
        suggestions: _saleTrendController.partSuggestions.toList(),
        onTap: (selected) => _saleTrendController.selectPartNumber(selected),
      );
    });
  }

  Widget _buildDropdown() {
    return Obx(
      () => CustomDropdown(
        // hintText: "Select Sale Type",
        hintText: "WorkShop Sale",
        options: [
          // "WorkShop Sale",
          "Counter Sale",
          "Both Sale"
        ],
        onChanged: (value) {
          _saleTrendController.selectedSaleType.value =
              value ?? "WorkShop Sale";
          _saleTrendController
              .updateChartData(_saleTrendController.selectedSaleType.value);
        },
        selectedValue: _saleTrendController.selectedSaleType.value,
      ),
    );
  }

  Widget _showStockCard() {
    return Obx(() {
      final err = _saleTrendController.error.value;
      if (_saleTrendController.isLoading.value) {
        return const CircularProgressIndicator();
      } else if (err != null) {
        return CustomErrorMsg(text: err);
      } else if (_saleTrendController.partDetails.isEmpty) {
        return const SizedBox.shrink();
      } else {
        final part = _saleTrendController.partDetails;
        final data = _saleTrendController.chartData;
        final xLabels = _saleTrendController.xLabelMonth;
        final stock = _saleTrendController.stock.value;
        final max = _saleTrendController.max.value;
        checkDoubleInt(double val) {
          return val % 1 == 0 //check for remainder 0
              ? val.toInt().toString()
              : val.toStringAsFixed(2);
        }

        return StockCardSaleTrend(
          colorType: _saleTrendController.finalStatus.value,
          dropText: "View Month-Vise Sales",
          infoMap: {
            "Part Number": part['partnumber1'] ?? "",
            "Description": part['partdesc'] ?? "",
            "Part Category": part['category'] ?? "",
            // "Part Rate": part['mrp'].toString(),
            // "MRP": "₹ ${part['mrp']??""}",
            "Stock": checkDoubleInt(stock),
            "Planned Level": checkDoubleInt(max),
            "Substitution":
                _saleTrendController.partFamily.length > 1 ? "Y" : "N",
            "Sale 3M": _saleTrendController.showLast3.value,
            "Sale 6M": _saleTrendController.showLast6.value,
          },
          showDetailsContent: Column(
            children: [
              const SizedBox(height: 10),
              BarChartWidget(
                showChart: true,
                data: data,
                xLabels: xLabels,
                monthDate: [],
                showBoth:
                    _saleTrendController.selectedSaleType.value == 'Both Sale',
                showWorkShopSale: _saleTrendController.selectedSaleType.value ==
                    'WorkShop Sale',
                error: _saleTrendController.graphError.value,
                showLakhsText: false,
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      }
    });
  }
}
