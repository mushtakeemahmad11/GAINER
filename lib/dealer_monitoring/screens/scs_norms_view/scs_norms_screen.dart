import 'package:flutter/material.dart';
import 'package:gainer/dealer_monitoring/controllers/scs_norms_controller.dart';
import 'package:gainer/dealer_monitoring/core/utils/dm_images.dart';
import 'package:gainer/dealer_monitoring/widgets/head_bar.dart';
import 'package:gainer/dealer_monitoring/widgets/part_stock_card.dart';
import 'package:gainer/dealer_monitoring/widgets/search_bar.dart';
import 'package:gainer/gainer_app/core/widgets/part_suggestion_list.dart';
import 'package:get/get.dart';
import '../../../main.dart';
import '../../widgets/dealer_app_loader.dart';
import '../../widgets/dm_error_msg.dart';

class ScsNormsScreen extends StatefulWidget {
  const ScsNormsScreen({super.key});

  @override
  State<ScsNormsScreen> createState() => _ScsNormsScreenState();
}

class _ScsNormsScreenState extends State<ScsNormsScreen> {
  ScsNormsController controller = Get.put(ScsNormsController());
  @override
  void dispose() {
    // Dispose the controller when this screen is closed
    Get.delete<ScsNormsController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            HeadBar(text: "SCS Norms", imgSting: DMImages.scsNorms),
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
                  const SizedBox(height: 10),
                  _buildNormsCard(),
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
      return PartSuggestionList(
        isLoading: controller.partSearchLoading.value,
        suggestions: controller.partSuggestions.toList(),
        onTap: (selected) => controller.selectPartNumber(selected),
      );
    });
  }

  Widget _buildNormsCard() {
    return Obx(() {
      if (controller.isLoading.value) {
        return const DealerAppLoader();
      }
      if (controller.error.value != null || controller.partDetails.isEmpty) {
        return DmErrorMsg(text: controller.error.value ?? "");
      }

      final part = controller.partDetails;

      final normsLocation = controller.error.value == null
          ? controller.locationsList
          .where((item) {
        final maxValue = num.tryParse(item['Max'].toString()) ?? 0;
        return maxValue > 0; // ✅ only include items with Max > 0
      })
          .map((item) => Map<String, dynamic>.from(item))
          .toList()
          : [
        {
          "location": controller.error.value,
          "Max": '',
          "Stock": '',
        }
      ];

      // final normsLocation = controller.error.value == null
      //     ? List<Map<String, dynamic>>.from(controller.locationsList)
      //     : [
      //         {
      //           "location": controller.error.value,
      //           "Max": '',
      //           "Stock": '',
      //         }
      //       ];
      final plannedLevelValue = controller.max.value;
      final locationStock = controller.stock.value;
      final plannedGroup = controller.getPlannedGroupTotal();
      checkDoubleInt(double val) {
        return val % 1 == 0 //check for remainder 0
            ? val.toInt().toString()
            : val.toStringAsFixed(2);
      }

      return PartStockCard(
        partDetails: {
          "ColorType": "null",
          "Part Number": part['partnumber1'] ?? "",
          "Part Description": part['partdesc'] ?? "",
          "Part Category": part['category'] ?? "",
          // "MRP": "₹ ${part['mrp']??""}",
          // "Planned Level":
          //     "$plannedLevelValue    !500Stock!500         $locationStock",
          // "Planned at Group":
          //     "$plannedGroup    !500Grp Stock!500  $stockGroup",
          "Planned Level": checkDoubleInt(plannedLevelValue),
          "Stock": checkDoubleInt(locationStock),
          // "Grp Stock": stockGroup,
          "Planned at Group": checkDoubleInt(plannedGroup),
        },
        locations: normsLocation,
      );
    });
  }
}
