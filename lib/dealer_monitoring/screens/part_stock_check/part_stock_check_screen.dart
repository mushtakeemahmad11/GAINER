import 'package:flutter/material.dart';
import 'package:gainer/dealer_monitoring/widgets/dm_error_msg.dart';
import 'package:gainer/dealer_monitoring/widgets/head_bar.dart';
import 'package:gainer/dealer_monitoring/widgets/blink_btn.dart';
import 'package:gainer/gainer_app/core/widgets/part_suggestion_list.dart';
import 'package:get/get.dart';
import '../../controllers/part_stock_check_controller.dart';
import '../../core/utils/dm_images.dart';
import '../../widgets/dealer_app_loader.dart';
import '../../widgets/elevated_button.dart';
import '../../widgets/legend_bar.dart';
import '../../widgets/part_stock_card.dart';
import '../../widgets/search_bar.dart';
import '../../widgets/reserved_details_sheet.dart';

class PartStockCheckScreen extends StatefulWidget {
  const PartStockCheckScreen({super.key});

  @override
  State<PartStockCheckScreen> createState() => _PartStockCheckScreenState();
}

class _PartStockCheckScreenState extends State<PartStockCheckScreen> {
  late PartStockCheckController c;

  @override
  void initState() {
    super.initState();
    c = Get.put(PartStockCheckController());
    Get.lazyPut<ReservedController>(() => ReservedController());
  }

  @override
  void dispose() {
    // Dispose the controller when this screen is closed
    Get.delete<PartStockCheckController>();
    Get.delete<ReservedController>();
    super.dispose();
  }

  // int _currentStep = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            HeadBar(
              text: "Part Stock Check",
              imgSting: DMImages.partStockCheck,
            ),
            _buildSearchBar(),
            _buildPartSuggestion(),
            LegendBar(),
            _buildPartCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: SearchBarWidget(
        hintText: 'Enter Part Number',
        onSearch: c.search,
        controller: c.searchController,
        formKey: c.formKey,
        onChanged: (value) => c.fetchPartSuggestions(value),
      ),
    );
  }

  Widget _buildPartSuggestion() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Obx(() {
        return PartSuggestionList(
          isLoading: c.partSearchLoading.value,
          suggestions: c.partSuggestions.toList(),
          onTap: (selected) => c.selectPartNumber(selected),
        );
      }),
    );
  }

  Widget _buildPartCard() {
    return Obx(() {
      if (c.isLoading.value) {
        return DealerAppLoader();
      }
      if (c.errorMessage.value != null || c.partDetails.isEmpty) {
        return DmErrorMsg(text: c.errorMessage.value ?? "");
      }
      //data observed
      final part = c.partDetails;
      final color = c.partStatus.value;
      final stockQty = c.stock.value;
      final grpStock = c.groupStock.value;
      final plannedLevel = c.max.value;
      final reserveForVehicle = c.reservedForVehicle.value;
      checkDoubleInt(double val) =>
          val % 1 == 0 ? val.toInt() : val.toStringAsFixed(2);

      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: PartStockCard(
              isGroupStock: true,
              partDetails: {
                "ColorType": color,
                "Part Number": part['partnumber1'] ?? "",
                "Part Description": part['partdesc'] ?? "",
                "Part Category": part['category'] ?? "",
                "Stock Qty": checkDoubleInt(stockQty),
                "Planned Level": checkDoubleInt(plannedLevel),
                "Reserved for Vehicle": checkDoubleInt(reserveForVehicle),
                "Group Free Stock": checkDoubleInt(grpStock),
              },
              locations: c.locationsList,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              children: [
                BlinkingButton(
                  onPressed: c.onTapSubstitutionCheck,
                  text: "Check Substitution",
                  isBlink: c.isSubstitute.value,
                ),
                SizedBox(height: 5),
                ReusableElevatedButton(
                  onPressed: c.onTapGainerStockCheck,
                  text: "Show Gainer Stock Details",
                ),
              ],
            ),
          ),
        ],
      );
    });
  }
}
