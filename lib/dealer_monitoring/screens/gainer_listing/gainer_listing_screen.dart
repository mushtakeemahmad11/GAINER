import 'package:flutter/material.dart';
import 'package:gainer/dealer_monitoring/controllers/gainer_listing_controller.dart';
import 'package:gainer/dealer_monitoring/core/theme/app_colors.dart';
import 'package:gainer/dealer_monitoring/core/utils/dm_images.dart';
import 'package:gainer/dealer_monitoring/widgets/head_bar.dart';
import 'package:gainer/dealer_monitoring/widgets/legend_bar.dart';
import 'package:get/get.dart';
import '../../../gainer/widget/error_msg.dart';
import '../../../gainer/widget/suggestion_list.dart';
import '../../../main.dart';
import '../../widgets/search_bar.dart';

class GainerListingScreen extends StatefulWidget {
  const GainerListingScreen({super.key});

  @override
  State<GainerListingScreen> createState() => _GainerListingScreenState();
}

class _GainerListingScreenState extends State<GainerListingScreen> {
  final GainerListingController controller = Get.put(GainerListingController());
  @override
  void dispose() {
    // Dispose the controller when this screen is closed
    Get.delete<GainerListingController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            HeadBar(
              text: "My Gainer Listing",
              imgSting: DMImages.gainerListening,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: mq.width * 0.02,
                vertical: mq.width * 0.01,
              ),
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
                  const LegendBar(),
                  _buildPartCard(),
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
        isLoading: controller.partSearchLoading.value,
        suggestions: controller.partSuggestions.toList(),
        onTap: (selected) => controller.selectPartNumber(selected),
      );
    });
  }

  Widget _buildCardRow(Map<String, dynamic> data) {
    return Column(
      children: data.entries.map((entry) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 4,
              child: Text(
                entry.key,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              flex: 6,
              child: Text(entry.value.toString()),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildPartCard(){
    return Obx(() {
      if (controller.isLoading.value) {
        return const CircularProgressIndicator();
      }

      if (controller.error.value != null) {
        return CustomErrorMsg(
            text: controller.error.value ?? "Error");
      }

      if (controller.gainerListingData.isEmpty) {
        return const SizedBox.shrink();
      }

      final gainer = controller.gainerListingData[0];
      final color = getCardColor(gainer['Stock_Category'] ?? '');

      final partDetails = {
        "Part Number": gainer['PartNumber'] ?? '',
        "Part Description": gainer['partdesc'] ?? '',
        "Part Category": gainer['Category'] ?? '',
        // "MRP": "₹ ${gainer['mrp']??""}",
        "Listed Qty": gainer['qty']?.toString() ?? '',
        "Discount": "${gainer['Discount'] ?? '0'}%",
      };

      return Card(
        color: color,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: _buildCardRow(partDetails),
        ),
      );
    });
  }

  Color getCardColor(String status) {
    if (status.contains('Stockable') || status.contains('Moving')) {
      return DMAppColors.stockable;
    } else if (status == 'Non Stockable') {
      return DMAppColors.nonStockable;
    } else if (status == 'Non Moving') {
      return DMAppColors.nonMoving;
    }
    return DMAppColors.primary;
  }
}
