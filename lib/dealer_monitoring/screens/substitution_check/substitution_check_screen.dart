import 'package:flutter/material.dart';
import 'package:gainer/dealer_monitoring/controllers/substitution_check_controller.dart';
import 'package:gainer/dealer_monitoring/core/theme/app_colors.dart';
import 'package:gainer/dealer_monitoring/core/utils/dm_images.dart';
import 'package:gainer/dealer_monitoring/widgets/head_bar.dart';
import 'package:gainer/dealer_monitoring/widgets/reusable_table.dart';
import 'package:gainer/gainer_app/core/widgets/part_suggestion_list.dart';
import 'package:get/get.dart';
import '../../../main.dart';
import '../../widgets/dm_error_msg.dart';
import '../../widgets/legend_bar.dart';
import '../../widgets/search_bar.dart';

class SubstitutionCheckScreen extends StatefulWidget {
  const SubstitutionCheckScreen({super.key});

  @override
  State<SubstitutionCheckScreen> createState() =>
      _SubstitutionCheckScreenState();
}

class _SubstitutionCheckScreenState extends State<SubstitutionCheckScreen> {
  SubstitutionCheckController controller =
      Get.put(SubstitutionCheckController());
  // final PartStockCheckController _partStockCheckController =
  //     Get.put(PartStockCheckController());

  String? partNumber;
  @override
  void initState() {
    super.initState();
    _initWork();
  }

  _initWork() {
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    // final String? partNumber = args['partNumber'];
    partNumber = args['partNumber'];
    if (partNumber != null) {
      controller.searchController.text = partNumber!;
    } else {
      controller.searchController.clear();
      controller.responseList.clear();
    }
  }

  @override
  void dispose() {
    // Dispose the controller when this screen is closed
    Get.delete<SubstitutionCheckController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (partNumber == null || partNumber!.isEmpty)
              HeadBar(
                  text: "Substitution Check",
                  imgSting: DMImages.substitutionCheck),
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
                  LegendBar(),
                  _buildSubstitutionTable(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildPartSuggestion() {
    return Obx(
      () => PartSuggestionList(
        isLoading: controller.partSearchLoading.value,
        suggestions: controller.partSuggestions.toList(),
        onTap: (selected) => controller.selectPartNumber(selected),
      ),
    );
  }

  Widget _buildSubstitutionTable() {
    return Obx(() {
      if (controller.isLoading.value) {
        return const CircularProgressIndicator();
      }
      if (controller.error.value != null) {
        return DmErrorMsg(text: controller.error.value ?? "");
      }
      final parts = controller.responseList;
      if (controller.responseList.isNotEmpty) {
        if (controller.responseList.length < 2) {
          return DmErrorMsg(text: "Substitution not available");
        }
        return ReusableTable(
          //headerColor: Colors.black,
          headers: [
            "Substitution",
            "Description",
            "Category",
            // "MRP",
            "Stock Qty"
          ],
          rows: parts
              .map((item) => [
                    item['PartNumber1'],
                    item['PartDesc'],
                    item['Category'],
                    // item['MRP'],
                    // "₹${TransformValue().formatIndianNumber(item['MRP'])}",
                    item['Qty'],
                  ])
              .toList(),

          rowColorsList: parts.map((item) {
            // switch (item['PartStatus']) {
            switch (controller.finalStatus.value) {
              case "Non-Stockable":
                return DMAppColors.nonStockable;
              case "Non-Moving":
                return DMAppColors.nonMoving;
              case "Stockable":
                return DMAppColors.stockable;
              default:
                return DMAppColors.primary;
            }
          }).toList(),
          columnWidths: [
            IntrinsicColumnWidth(),
            FixedColumnWidth(100),
            FixedColumnWidth(85),
            // IntrinsicColumnWidth(), //MRP
            FixedColumnWidth(80),
          ],
        );
      }
      return const SizedBox.shrink();
    });
  }
}
