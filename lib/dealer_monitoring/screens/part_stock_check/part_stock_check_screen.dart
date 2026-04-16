import 'package:flutter/material.dart';
import 'package:gainer/dealer_monitoring/widgets/dm_error_msg.dart';
import 'package:gainer/dealer_monitoring/widgets/head_bar.dart';
import 'package:gainer/dealer_monitoring/widgets/blink_btn.dart';
import 'package:gainer/gainer_app/core/widgets/part_suggestion_list.dart';
import 'package:get/get.dart';
import '../../controllers/part_stock_check_controller.dart';
import '../../core/utils/dm_images.dart';
import '../../widgets/elevated_button.dart';
import '../../widgets/legend_bar.dart';
import '../../widgets/part_stock_card.dart';
import '../../widgets/search_bar.dart';

class PartStockCheckScreen extends StatefulWidget {
  const PartStockCheckScreen({super.key});

  @override
  State<PartStockCheckScreen> createState() => _PartStockCheckScreenState();
}

class _PartStockCheckScreenState extends State<PartStockCheckScreen> {
  late PartStockCheckController _partStockCheckController;

  @override
  void initState() {
    super.initState();
    _partStockCheckController = Get.put(PartStockCheckController());
  }

  @override
  void dispose() {
    // Dispose the controller when this screen is closed
    Get.delete<PartStockCheckController>();
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
        onSearch: _partStockCheckController.search,
        controller: _partStockCheckController.searchController,
        formKey: _partStockCheckController.formKey,
        onChanged: (value) =>
            _partStockCheckController.fetchPartSuggestions(value),
      ),
    );
  }

  Widget _buildPartSuggestion() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Obx(() {
        return PartSuggestionList(
          isLoading: _partStockCheckController.partSearchLoading.value,
          suggestions: _partStockCheckController.partSuggestions.toList(),
          onTap: (selected) =>
              _partStockCheckController.selectPartNumber(selected),
        );
      }),
    );
  }

  Widget _buildPartCard() {
    return Obx(() {
      if (_partStockCheckController.isLoading.value) {
        return CircularProgressIndicator();
      }
      if (_partStockCheckController.errorMessage.value != null ||
          _partStockCheckController.partDetails.isEmpty) {
        return DmErrorMsg(
            text: _partStockCheckController.errorMessage.value ?? "");
      }
      //data observed
      final part = _partStockCheckController.partDetails;
      final color = _partStockCheckController.partStatus.value;
      final stockQty = _partStockCheckController.stock.value;
      final grpStock = _partStockCheckController.groupStock.value;
      final plannedLevel = _partStockCheckController.max.value;
      final reserveForVehicle =
          _partStockCheckController.reservedForVehicle.value;
      checkDoubleInt(double val) {
        return val % 1 == 0 //check for remainder 0
            ? val.toInt()
            : val.toStringAsFixed(2);
      }

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
                // "Part Rate": part['mrp'] ?? 0,
                "Stock Qty": checkDoubleInt(stockQty),
                "Planned Level": checkDoubleInt(plannedLevel),
                "Reserved for Vehicle": checkDoubleInt(reserveForVehicle),
                "Group Stock": checkDoubleInt(grpStock),
              },
              locations: _partStockCheckController.locationsList,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              children: [
                BlinkingButton(
                  onPressed: _partStockCheckController.onTapSubstitutionCheck,
                  text: "Check Substitution",
                  isBlink: _partStockCheckController.isSubstitute.value,
                ),
                SizedBox(height: 5),
                ReusableElevatedButton(
                  onPressed: _partStockCheckController.onTapGainerStockCheck,
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
