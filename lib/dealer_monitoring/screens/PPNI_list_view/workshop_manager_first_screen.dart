import 'package:flutter/material.dart';
import 'package:gainer/dealer_monitoring/screens/PPNI_list_view/workshop_manager_screen.dart';

import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../gainer/controllers/home_screen_controller.dart';
import '../../../gainer/shared_preferences/shared_preferences_get_data.dart';
import '../../../gainer/widget/error_msg.dart';
import '../../../gainer/widget/reusable_dropdown.dart';
import '../../controllers/workshop_manager_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/dm_images.dart';
import '../../core/utils/transform_value_ind.dart';
import '../../widgets/bar_chart_widget.dart';
import '../../widgets/head_bar.dart';
import '../../widgets/ppni_value_box.dart';
import '../../widgets/refresh_indicator.dart';
import '../../widgets/title_icon_row.dart';

class WorkshopManagerFirstScreen extends StatefulWidget {
  const WorkshopManagerFirstScreen({super.key});

  @override
  State<WorkshopManagerFirstScreen> createState() =>
      _WorkshopManagerFirstScreenState();
}

class _WorkshopManagerFirstScreenState
    extends State<WorkshopManagerFirstScreen> {
  final WorkShopManagerController _workShopManagerController =
      Get.put(WorkShopManagerController());

  final LocationController _locationController = Get.put(LocationController());
  late Worker _worker;

  @override
  void initState() {
    super.initState();
    _workShopManagerController.initWork(null);
    _worker = ever(_locationController.selectedLocationId, (value) {
      _onLocationChanged(value);
    });
  }

  void _onLocationChanged(String? location) {
    // print("Location changed only on this screen: $location");
    _workShopManagerController.initWork(location);
  }

  @override
  void dispose() {
    _worker.dispose(); // Important!
    // Dispose the controller when this screen is closed
    Get.delete<WorkShopManagerController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(children: [
          HeadBar(
            text: "PPNI List",
            imgSting: DMImages.ppniList,
            // refresh: Obx(
            //   () => RotatingRefreshIcon(
            //     isRotating: _workShopManagerController.isFirstLoading.value,
            //     onRefresh: () async => await _workShopManagerController.initWork(null),
            //   ),
            // ),
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              Obx(() => PpniValueBox(
                  value: _workShopManagerController.totalPPNIValue.value)),
              GestureDetector(
                onTap: () => _workShopManagerController.showChart.toggle(),
                child: Image.asset(DMImages.viewGraph, width: 45),
              ),
              SizedBox(width: 8),
            ],
          ),

          ///
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceAround,
          //   children: [
          //     Row(
          //       children: [
          //         Checkbox(
          //             value: isNonStockable,
          //             onChanged: (val) {
          //               setState(() {
          //                 isNonStockable = val ?? false;
          //               });
          //
          //               _workShopManagerController.initWork();
          //               // _fetchApiData();
          //             }),
          //         Text("Non-Stockable"),
          //       ],
          //     ),
          // ElevatedButton(
          //   style: ButtonStyle(
          //     padding:
          //         WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 8)),
          //     backgroundColor: WidgetStatePropertyAll(Colors.brown.shade200),
          //     shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          //       RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(8.0),
          //       ),
          //     ),
          //   ),
          //   onPressed: () => _workShopManagerController.showChart.toggle(),
          //   child: Row(
          //     mainAxisSize: MainAxisSize.min,
          //     spacing: 5,
          //     children: [
          //       const Text(
          //         'View Month-wise Value',
          //         style: TextStyle(
          //           color: Colors.black,
          //           fontSize: 14,
          //         ),
          //       ),
          //       AnimatedDropIcon(
          //         isTrue: _workShopManagerController.showChart.value,
          //         iconSize: 20,
          //       ),
          //     ],
          //   ),
          // ),

          Obx(() {
            final data = _workShopManagerController.data;
            final xLabels = _workShopManagerController.xLabels;
            final monthDate = _workShopManagerController.monthDate;
            return BarChartWidget(
              key: ValueKey(
                  data.length), // Optional: force redraw when length changes
              showChart: _workShopManagerController.showChart.value,
              data: data,
              xLabels: xLabels,
              monthDate: monthDate,
              showBoth: false,
              showWorkShopSale: true,
              error: _workShopManagerController.graphError.value,
              onBarTap: (val, label) =>
                  _workShopManagerController.isLoading.value
                      ? null
                      : _workShopManagerController.initWork(null,
                          monthYear: val, title: label),
            );
          }),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              spacing: 10,
              children: [
                Expanded(
                  child: Obx(
                    () => CustomDropdown(
                      hintText: "Select Part Nature",
                      options: ["All time NS -Y", "All time NS -N", "All"],
                      onChanged: (selectedValue) {
                        if (_workShopManagerController
                                .selectedPartNature.value !=
                            selectedValue) {
                          _workShopManagerController.selectedPartNature.value =
                              selectedValue;
                          _workShopManagerController.initWork(null);
                        }
                        // print(
                        //     "selected Stock Type: ${_workShopManagerController.selectedPartNature.value}, $selectedValue");
                      },
                      selectedValue:
                          _workShopManagerController.selectedPartNature.value,
                    ),
                  ),
                  // CustomDropdown(
                  //   // hintText: "Select Part Nature",
                  //   hintText: "All time NS -Y",
                  //   // options: ["Non-Stockable", "Stockable"],
                  //   options: [
                  //     // "All time NS -Y",
                  //     "All time NS -N",
                  //     "All"
                  //   ],
                  //   onChanged: (selectedValue) {
                  //     if (_workShopManagerController.selectedPartNature.value !=
                  //         selectedValue) {
                  //       _workShopManagerController.selectedPartNature.value =
                  //           selectedValue ?? "All time NS -Y";
                  //       _workShopManagerController.initWork(null);
                  //       print(
                  //           "selected Stock Type: ${_workShopManagerController.selectedPartNature.value}");
                  //     }
                  //   },
                  //   selectedValue:
                  //       _workShopManagerController.selectedPartNature.value,
                  // ),
                ),
                Expanded(
                  child: Obx(() => CustomDropdown(
                        hintText: "Select Card Status",
                        options: ["Open", "Closed", "All"],
                        onChanged: (selectedValue) {
                          if (_workShopManagerController.selectedStatus.value !=
                              selectedValue) {
                            _workShopManagerController.selectedStatus.value =
                                selectedValue;
                            _workShopManagerController.initWork(null);
                          }
                        },
                        selectedValue:
                            _workShopManagerController.selectedStatus.value,
                      )),
                  // CustomDropdown(
                  //   hintText: "Open",
                  //   options: ['Closed', 'All'],
                  //   onChanged: (selectedValue) {
                  //     if (_workShopManagerController.selectedStatus.value !=
                  //         selectedValue) {
                  //       _workShopManagerController.selectedStatus.value =
                  //           selectedValue ?? "Open";
                  //       _workShopManagerController.initWork(null);
                  //     }
                  //     print(
                  //         "selected Job Card Status: ${_workShopManagerController.selectedStatus.value}");
                  //   },
                  //   selectedValue:
                  //       _workShopManagerController.selectedStatus.value,
                  // ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8),
          Obx(
            () {
              bool loading = _workShopManagerController.isFirstLoading.value;
              // if (_workShopManagerController.isFirstLoading.value) {
              //   return const CircularProgressIndicator();
              // }
              if (loading) {
                final fakeAdvisor = List.generate(
                  10,
                  (_) => {
                    "Advisor": "Mushtakeem",
                    "PPNI_Value": 12345678,
                  },
                );
                return Skeletonizer(
                  effect: ShimmerEffect(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    duration: const Duration(seconds: 1),
                  ),
                  enableSwitchAnimation: true,
                  child: buildAdvisorTable(fakeAdvisor),
                );
              }
              final err = _workShopManagerController.firstSError.value;
              if (err != null) {
                // return CustomErrorMsg(text: err);
                return Column(
                  children: [
                    CustomErrorMsg(text: err),
                    // if (err.contains('Request timed out'))
                    RotatingRefreshIcon(
                      color: DMAppColors.secondary,
                      isRotating:
                          _workShopManagerController.isFirstLoading.value,
                      onRefresh: () async =>
                          await _workShopManagerController.initWork(null),
                    ),
                  ],
                );
              }
              return buildAdvisorTable(
                  _workShopManagerController.advisorPPNIList);
            },
          ),
          SizedBox(height: 8),
        ]),
      ),
    );
  }

  Widget _tableHeader(String text) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget buildAdvisorTable(List<Map<String, dynamic>> advisorData) {
    final title = _workShopManagerController.lakhsTitle.value;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          if (title.isNotEmpty == true)
            TitleIconRow(
              title: title,
              onCloseTap: () => _workShopManagerController.initWork(null),
            ),
          //   Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     Text(title),
          //     // IconButton(
          //     //   onPressed: () => _workShopManagerController.initWork(null),
          //     //   icon: Icon(
          //     //     Icons.close,
          //     //     color: Colors.black,
          //     //   ),
          //     // ),
          //   ],
          // ),
          Table(
            border: TableBorder.symmetric(
              // inside: const BorderSide(color: Colors.black, width: 0.5),
              outside: const BorderSide(color: Colors.black, width: 1),
            ),
            columnWidths: const {
              0: FlexColumnWidth(),
              1: FlexColumnWidth(),
            },
            children: [
              // Header Row
              TableRow(
                decoration: BoxDecoration(
                  color: DMAppColors.secondary,
                ),
                children: [
                  _tableHeader("Advisor"),
                  _tableHeader("₹ PPNI Value"),
                ],
              ),

              // Data Rows
              ...advisorData.map((advisor) {
                final name = advisor["Advisor"]?.toString() ?? "";
                final ppni = (advisor["PPNI_Value"] is num)
                    // ? (advisor["PPNI_Value"] as num).toStringAsFixed(0)
                    ? "₹${TransformValue().formatIndianNumber(advisor["PPNI_Value"].toInt())}"
                    : advisor["PPNI_Value"]?.toString() ?? "0";

                Widget buildCell(String text) => GestureDetector(
                      onTap: () async {
                        String locationID =
                            await getStringData("selectedLocationID");
                        String dealerID = await getStringData("dealerID");
                        Get.to(() => WorkshopManagerScreen(), arguments: {
                          "dealerID": dealerID,
                          "nonStockable": _workShopManagerController
                              .selectedPartNature.value,
                          // "jobCardStatus": isJobCard,
                          "jobCardStatus":
                              _workShopManagerController.selectedStatus.value,
                          "locationID": locationID,
                          "advisor": name,
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(child: Text(text)),
                      ),
                    );

                return TableRow(
                  decoration: BoxDecoration(color: DMAppColors.primary),
                  children: [
                    buildCell(name),
                    buildCell(ppni),
                  ],
                );
              }),
            ],
          ),
        ],
      ),
    );
  }
}
