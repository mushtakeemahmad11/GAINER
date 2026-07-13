import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gainer/dealer_monitoring/widgets/dealer_app_loader.dart';
import 'package:gainer/gainer_app/core/widgets/gainer_bottom_sheet.dart';
import 'package:gainer/gainer_app/core/widgets/part_suggestion_list.dart';
import 'package:get/get.dart';
import 'package:gainer/dealer_monitoring/controllers/vehicle_search_controller.dart';
import 'package:gainer/dealer_monitoring/screens/vehicle_search/image_pick_screen.dart';
import 'package:gainer/dealer_monitoring/widgets/confirmation_dialog_box.dart';
import 'package:image_picker/image_picker.dart';
import '../../../main.dart';
import '../../controllers/dm_main_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/dm_images.dart';
import '../../core/utils/transform_value_ind.dart';
import '../../widgets/dm_dropdown.dart';
import '../../widgets/dm_error_msg.dart';
import '../../widgets/head_bar.dart';
import '../../widgets/reusable_table.dart';
import '../../widgets/search_bar.dart';
import '../../widgets/reserved_details_sheet.dart';

class VehicleSearchScreen extends StatefulWidget {
  const VehicleSearchScreen({super.key});

  @override
  State<VehicleSearchScreen> createState() => _VehicleSearchScreenState();
}

class _VehicleSearchScreenState extends State<VehicleSearchScreen> {
  final VehicleSearchController _controller =
      Get.put(VehicleSearchController());
  final DMMainController _dmMainController = Get.put(DMMainController());

  @override
  void initState() {
    super.initState();
    Get.lazyPut<ReservedController>(() => ReservedController());
    _dmMainController.initWork();
  }

  @override
  void dispose() {
    Get.delete<VehicleSearchController>();
    Get.delete<ReservedController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        controller: _controller.scrollController,
        child: Column(
          children: [
            HeadBar(text: "Vehicle Search", imgSting: DMImages.vehicleSearch),
            const SizedBox(height: 5),
            _buildDateWrapper(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: mq.width * .02),
              child: Column(
                children: [
                  _buildSearchBar(),
                  _buildVehicleSuggestion(),
                  _buildDropdowns(),
                  const SizedBox(height: 10),
                  _buildVehicleResults(),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Obx(
        () => _controller.showScrollButton.value
            ? CircleAvatar(
                backgroundColor: Colors.black45,
                child: IconButton(
                  onPressed: _controller.scrollToBottom,
                  icon: Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.white,
                  ),
                ),
              )
            : const SizedBox(),
      ),
    );
  }

  Widget _buildDateWrapper() => Container(
        color: DMAppColors.secondary,
        padding: const EdgeInsets.all(8.0),
        width: mq.width,
        child: Obx(
          () => Wrap(
            alignment: WrapAlignment.spaceEvenly,
            spacing: 5,
            runSpacing: 5,
            children: [
              _buildDateColumn(
                  "JobCard Closed", _dmMainController.jobCardDate.value),
              _buildDateColumn(
                  "JobLine Closed", _dmMainController.jobLineDate.value),
              _buildDateColumn(
                  "Stock Uploaded", _dmMainController.stockDate.value),
            ],
          ),
        ),
      );

  Widget _buildDateColumn(String title, String? date) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(title,
              style: const TextStyle(color: Colors.white, fontSize: 12)),
          Text(date?.isNotEmpty == true ? date! : "--/--/----",
              style: const TextStyle(color: Colors.white, fontSize: 12)),
        ],
      );

  Widget _buildSearchBar() => SearchBarWidget(
        hintText: "Enter Vehicle Number Here",
        onSearch: _controller.search,
        controller: _controller.searchController,
        formKey: _controller.formKey,
        onChanged: (value) => _controller.fetchVehicleSuggestions(value),
      );

  Widget _buildVehicleSuggestion() => Obx(() {
        final suggestions = _controller.vehicleSuggestionList
            .map((e) => e['Vehiclenumber'].toString())
            .toList();

        return PartSuggestionList(
          isLoading: _controller.isVehicleSuggestionLoading.value,
          suggestions: suggestions.toList(),
          onTap: _controller.selectPartNumber,
        );
      });

  Widget _buildDropdowns() => Obx(() => Column(
        children: [
          Row(
            children: [
              Expanded(
                child: DmDropdown(
                  hintText: "Select Part Nature",
                  options: ["All time NS -Y", "All time NS -N", "All"],
                  onChanged: (value) {
                    if (_controller.selectedValue3.value != value) {
                      _controller.search();
                    }
                    _controller.selectedValue3.value = value;
                  },
                  selectedValue: _controller.selectedValue3.value,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: DmDropdown(
                  hintText: "Select Card Status",
                  options: ["Open", "Close", "All"],
                  onChanged: (value) {
                    if (_controller.selectedValue2.value != value) {
                      _controller.search();
                    }
                    _controller.selectedValue2.value = value;
                  },
                  selectedValue: _controller.selectedValue2.value,
                ),
              ),
            ],
          ),
          DmDropdown(
            hintText: "Select Job Line Status",
            options: ["Part issued", "Part not issued", "All"],
            onChanged: (value) {
              if (_controller.selectedValue1.value != value) {
                _controller.search();
              }
              _controller.selectedValue1.value = value;
            },
            selectedValue: _controller.selectedValue1.value,
          ),
        ],
      ));

  Widget _buildVehicleResults() => Obx(() {
        if (_controller.isLoading.value) {
          return DealerAppLoader();
        }

        final err = _controller.errorMsg.value;
        if (err != null) return DmErrorMsg(text: err);

        final vehicleData = _controller.vehicleData;
        if (vehicleData.isEmpty) {
          return const SizedBox.shrink();
        }

        // ---- cache everything once
        final scoreData = _controller.scoreData.isNotEmpty
            ? _controller.scoreData[0]
            : const {};
        final inStockTotal = (scoreData['InStockTotal'] ?? 0) as num;
        final inStockCount = (scoreData['InStockCount'] ?? 0) as num;
        final outStockTotal = (scoreData['OutStockTotal'] ?? 0) as num;
        final outStockCount = (scoreData['OutStockCount'] ?? 0) as num;

        final tv = TransformValue(); // reuse

        // Prebuild table rows once
        final rows = vehicleData.map<List<dynamic>>((part) {
          final value = (part["Value"] ?? 0);
          final isIssued = part["IssueStatus"] == "Issued";
          return [
            part["part_number1"],
            "₹${tv.formatIndianNumber((value as num).toInt())}",
            _buildRemarksReason(part),
            isIssued
                ? const Icon(Icons.check, color: Colors.green)
                : const Icon(Icons.close, color: Colors.red),
            part["Qty"],
            part["ReservedforVehicle"] <= 0
                ? part["StockQty"]
                : qtyWithShow(part, true),
            part['GroupFreeStock'] <= 0
                ? part["GroupFreeStock"]
                : qtyWithShow(part, false),
            part["category"],
            part["partdesc"],
            tv.formatDateToIndianDate(part["OrderDate"] ?? ""),
            _buildEyeIcon(part),
          ];
        }).toList(growable: false);

        final rowColors = vehicleData.map((item) {
          final v = item['All_Time_NonStck'];
          if (v == "Y") return Colors.pink[100];
          if (v == "N") return Colors.green[300];
          return DMAppColors.primary;
        }).toList(growable: false);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // HEADER (horizontal scrollable)
            Container(
              color: DMAppColors.primaryShade,
              padding: const EdgeInsets.all(5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: _buildScoreColumn("Part Not-Issued",
                          "${(inStockTotal + outStockTotal).toInt()}/${inStockCount + outStockCount}",
                          v: true),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 5,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildScoreColumn("Not-Issued - In Stock  ",
                              "Not-Issued - Not in Stock  "),
                          _buildScoreColumn(
                              "${inStockTotal.toInt()}/$inStockCount",
                              t: true,
                              "${outStockTotal.toInt()}/$outStockCount",
                              v: true),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // TABLE

            RepaintBoundary(
              // avoids unnecessary repaints
              child: ReusableTable(
                headers: const [
                  "Part No.",
                  "NDP Value",
                  "Remarks Reason",
                  "Issued Status",
                  "Ordered Qty",
                  "Stock Qty",
                  // "PPNI Qty",
                  "Grp Free Stock",
                  "Category",
                  "Description",
                  "Order Date",
                  "ETA",
                ],
                rows: rows,
                rowColorsList: rowColors,
                columnWidths: const [
                  IntrinsicColumnWidth(),
                  IntrinsicColumnWidth(),
                  FixedColumnWidth(85),
                  FixedColumnWidth(65),
                  FixedColumnWidth(80),
                  FixedColumnWidth(70),
                  FixedColumnWidth(80),
                  FixedColumnWidth(85),
                  FixedColumnWidth(120),
                  FixedColumnWidth(90),
                  FixedColumnWidth(80),
                ],
              ),
            ),

            // FOOTER ROW (checkbox + actions)
            Container(
              color: DMAppColors.primaryShade,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // if (statusImg != null)
                  //   Padding(padding: const EdgeInsets.only(left: 5.0), child: statusImg),
                  Obx(() {
                    final isChecked = _controller.isCheck.value;
                    return Checkbox(
                      value: isChecked,
                      onChanged: (val) {
                        _controller.isCheckFinal(false);
                        if (val == true) {
                          showDialog(
                            context: Get.context!,
                            builder: (_) => ConfirmationDialog(),
                          );
                        }
                      },
                    );
                  }),

                  const Expanded(
                    child: Text(
                      "Confirm In case you want to close the job card",
                      softWrap: true,
                      overflow: TextOverflow.visible,
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
              ),
            ),

            // PAGING LOADER (small Obx so only this part rebuilds)
            Obx(
              () => _controller.isMoreLoading.value && _controller.hasMore.value
                  ? const Padding(
                      padding: EdgeInsets.all(12),
                      child: Center(child: DealerAppLoader()),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        );
      });

  ///Build score Widget
  Widget _buildScoreColumn(String title, String value,
      {bool t = false, v = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _textWidget(title, t),
        _textWidget(value, v),
      ],
    );
  }

  Widget _textWidget(String text, bool isRed) => Text(text,
      style: TextStyle(color: isRed ? Colors.red : Colors.black, fontSize: 14));

  Widget _buildRemarksReason(Map<String, dynamic> part) {
    return IconButton(
      onPressed: () {
        _controller.showRemarksBottomSheet(context, part, "p");
      },
      icon: Icon(Icons.edit_note),
      color: Colors.black,
    );
  }

  Widget qtyWithShow(Map<String, dynamic> part, bool isReserved) {
    int qty = isReserved ? part["StockQty"] : part['GroupFreeStock'];
    String partNum = part['part_number1'];
    // RJ02UA9554
    // RJ29GB1915
    return GestureDetector(
      child: Wrap(
        alignment: WrapAlignment.center,
        // mainAxisAlignment: MainAxisAlignment.center,
        spacing: 2,
        children: [
          Text('$qty'),
          Text(
            isReserved ? '(Res)' : '(Show)',
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      onTap: () {
        _controller.showBottomSheet(context, partNum, isReserved);
      },
    );
  }

  Widget _buildEyeIcon(Map<String, dynamic> part) {
    return IconButton(
      icon: const Icon(Icons.remove_red_eye, color: Colors.black),
      onPressed: () {
        // Show dialog
        Get.defaultDialog(
          barrierDismissible: true, // Allows tap outside to close
          backgroundColor: DMAppColors.secondary,
          title: "Expected time of arrival",
          titlePadding: const EdgeInsets.only(top: 20),
          titleStyle: const TextStyle(color: Colors.white),
          content: const Text(
            "This Feature is coming soon\n\n",
            style: TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
        );

        // Auto-close after 3 seconds if still open
        Future.delayed(const Duration(seconds: 3), () {
          if (Get.isDialogOpen ?? false) {
            Get.back();
          }
        });
      },
    );
  }

  /// Bottom sheet to select image source
  void showCustomBottomSheet() {
    GainerBottomSheet.show(
      isGainer: false,
      context: context,
      onPressedCamera: () {
        _pickImage(ImageSource.camera);
        Get.back();
      },
      onPressedGallery: () {
        _pickImage(ImageSource.gallery);
        Get.back();
      },
    );
  }

  /// Image picker function
  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: source);

    if (image != null) {
      final imagePath = File(image.path);
      Get.to(() => ImagePickScreen(), arguments: {
        "imagePath": imagePath,
        "from": "vehicleClose",
      });
    }
  }
}
