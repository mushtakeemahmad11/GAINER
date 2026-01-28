import 'package:flutter/material.dart';
import 'package:gainer/dealer_monitoring/controllers/workshop_manager_controller.dart';
import 'package:gainer/dealer_monitoring/core/theme/app_colors.dart';
import 'package:gainer/dealer_monitoring/core/utils/dm_images.dart';
import 'package:gainer/dealer_monitoring/screens/PPNI_list_view/workshop_manager_screen.dart';
import 'package:gainer/dealer_monitoring/widgets/bar_chart_widget.dart';
import 'package:gainer/dealer_monitoring/widgets/head_bar.dart';
import 'package:gainer/dealer_monitoring/widgets/table_calss.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../gainer/controllers/home_screen_controller.dart';
import '../../../gainer/widget/error_msg.dart';
import '../../../gainer/widget/reusable_dropdown.dart';
import '../../controllers/general_manager_controller.dart';
import '../../widgets/ppni_value_box.dart';
import '../../widgets/refresh_indicator.dart';
import '../../widgets/title_icon_row.dart';

class GeneralManagerScreen extends StatefulWidget {
  const GeneralManagerScreen({super.key});

  @override
  State<GeneralManagerScreen> createState() => _GeneralManagerScreenState();
}

class _GeneralManagerScreenState extends State<GeneralManagerScreen> {
  final LocationController _locationController = Get.put(LocationController());
  final GeneralManagerController _generalManagerController =
      Get.put(GeneralManagerController());
  final WorkShopManagerController _workShopManagerController =
      Get.put(WorkShopManagerController());
  late Worker _worker;
  @override
  void initState() {
    super.initState();
    _generalManagerController.initWork(null);
    _worker = ever(_locationController.selectedLocationId, (value) {
      _onLocationChanged(value);
    });
  }

  void _onLocationChanged(String? location) {
    // print("Location changed only on this screen: $location");
    // _generalManagerController.initWork(location);
  }

  @override
  void dispose() {
    _worker.dispose(); // Important!
    // // Dispose the controller when this screen is closed
    Get.delete<GeneralManagerController>();
    Get.delete<WorkShopManagerController>();
    super.dispose();
  }

  // _initWork(String? everLocationId) async {
  //   String dealerId = _locationController.stockDetails['DealerID'].toString();
  //   String locationId =
  //       _locationController.stockDetails['LocationID'].toString();
  //   final val = _generalManagerController.selectedPartNature.value;
  //   String? nonStockable = (val == "All time NS -Y" || val == null)
  //       ? "Y"
  //       : (val == "All time NS -N")
  //           ? "N"
  //           : null;
  //   final val2 = _generalManagerController.selectedStatus.value;
  //   String? cardStatus = val2 == "Closed"
  //       ? "Close"
  //       : val2 == "Open"
  //           ? "Open"
  //           : null;
  //   print(
  //       "DealerId: $dealerId, isNonStockable: $nonStockable,isJobCard: ${_generalManagerController.selectedStatus.value}");
  //   // _generalManagerController.tableData.clear();
  //
  //   bool checkInt = await checkInternet();
  //   if (!checkInt) {
  //     _generalManagerController.error.value = "no Internet connection ";
  //     return internetNotAvl();
  //   } else {
  //     _generalManagerController.error.value = null;
  //     _generalManagerController.isLoading.value = true;
  //     final result = await ApiServices().fetchPPNIValuesByDealer(
  //       dealerId: dealerId,
  //       // nonStockable: isNonStockable ? "Y" : "N",
  //       nonStockable: nonStockable,
  //       jobCardStatus: cardStatus,
  //       // jobCardStatus: isJobCard,
  //     );
  //     _generalManagerController.isLoading.value = false;
  //
  //     if (result['success']) {
  //       // List<dynamic> data = result['data'];
  //       List<Map<String, dynamic>> data =
  //           List<Map<String, dynamic>>.from(result['data']);
  //       _generalManagerController.fetchPPNIData(data);
  //       // final transformed = transformPPNIData(data);
  //       // final jsonList = transformed.map((e) => e.toJson()).toList();
  //       // tableData = transformed.map((e) => e.toJson()).toList();
  //       // print("Data from Grouped: ${jsonEncode(jsonList)} ---");
  //       print("Data from Grouped: ${_generalManagerController.tableData} ---");
  //       // tableData = jsonEncode(jsonList);
  //       for (var item in _generalManagerController.tableData) {
  //         print(
  //             "Location:: ${item['Location']}, LocationID: ${item['LocationId']}, Advisor: ${item['advisor']}, PPNI_Value: ${item['PPNI Value']}");
  //       }
  //
  //       _generalManagerController.setLocation(data);
  //     } else {
  //       print("Error: ${result['message']}");
  //
  //       _generalManagerController.error.value = result['message'];
  //     }
  //
  //     _generalManagerController.graphError.value = null;
  //     final response = await ApiServices().fetchGraphPPNIValue(
  //       dealerId: dealerId,
  //       locationId: everLocationId ?? locationId,
  //       // nonStockable: isNonStockable ? "Y" : "N",
  //       nonStockable: nonStockable,
  //       jobCardStatus: cardStatus,
  //       // advisor: ,
  //     );
  //
  //     if (response['success']) {
  //       print("Data of success: ${response['data']}");
  //
  //       // _generalManagerController.transformGraphPPNIData(response['data']);
  //       final graphData = transformGraphPPNIDataLast12Months(response['data']);
  //       _generalManagerController.updateGraph(graphData);
  //       print('data: ${_generalManagerController.data}');
  //       print('xLabels: ${_generalManagerController.xLabels}');
  //     } else {
  //       print("Error: ${response['message']}");
  //       _generalManagerController.data.clear();
  //       _generalManagerController.xLabels.clear();
  //       _generalManagerController.graphError.value = response['message'];
  //     }
  //   }
  // }

  // bool rotate = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color(0xFFCEEAE7),
      body: Obx(
        () => SingleChildScrollView(
          // padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeadBar(text: "PPNI List", imgSting: DMImages.ppniList),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  PpniValueBox(
                      value: _generalManagerController.totalPPNIValue.value),
                  GestureDetector(
                    onTap: () => _generalManagerController.showChart.toggle(),
                    child: Image.asset(DMImages.viewGraph, width: 40),
                  ),
                  SizedBox(width: 10),
                ],
              ),

              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
              //   child: ElevatedButton(
              //     style: ButtonStyle(
              //       padding: WidgetStatePropertyAll(
              //           EdgeInsets.symmetric(horizontal: 8)),
              //       backgroundColor:
              //           WidgetStatePropertyAll(Colors.brown.shade200),
              //       shape: WidgetStateProperty.all<RoundedRectangleBorder>(
              //         RoundedRectangleBorder(
              //           borderRadius: BorderRadius.circular(8.0),
              //         ),
              //       ),
              //     ),
              //     onPressed: () => _generalManagerController.showChart.toggle(),
              //     child: Row(
              //       mainAxisSize: MainAxisSize.min,
              //       spacing: 5,
              //       children: [
              //         const Text(
              //           'View Month-wise Value',
              //           style: TextStyle(
              //             color: Colors.black,
              //             fontSize: 14,
              //           ),
              //         ),
              //         AnimatedDropIcon(
              //           isTrue: _generalManagerController.showChart.value,
              //           iconSize: 20,
              //         ),
              //       ],
              //     ),
              //   ),
              // ),

              // _buildDropdown(
              //   value: _generalManagerController.selectedStatus.value,
              //   items: ['Open', 'Closed','All'],
              //   onChanged: (val) => _generalManagerController.selectedStatus.value = val!,
              // ),
              Obx(() {
                final data = _generalManagerController.data.toList();
                final xLabels = _generalManagerController.xLabels.toList();
                final monthDate = _generalManagerController.monthDate.toList();
                return BarChartWidget(
                  showChart: _generalManagerController.showChart.value,
                  data: data,
                  xLabels: xLabels,
                  monthDate: monthDate,
                  showBoth: false,
                  showWorkShopSale: true,
                  error: _generalManagerController.graphError.value,
                  onBarTap: (val, label) =>
                      _generalManagerController.isLoading.value
                          ? null
                          : _generalManagerController.initWork(null,
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
                            if (_generalManagerController
                                    .selectedPartNature.value !=
                                selectedValue) {
                              _generalManagerController
                                  .selectedPartNature.value = selectedValue;
                              _generalManagerController.initWork(null);
                              // print(
                              //     "selected Stock Type: ${_generalManagerController.selectedPartNature.value}");
                            }

                            // _generalManagerController
                            //             .selectedPartNature.value ==
                            //         selectedValue
                            //     ? null
                            //     : _generalManagerController.initWork(null);
                            // _generalManagerController.selectedPartNature.value = selectedValue;
                            // print(
                            //     "selected Stock Type: ${_generalManagerController.selectedPartNature.value}, $selectedValue");
                          },
                          selectedValue: _generalManagerController
                              .selectedPartNature.value,
                        ),
                      ),
                      // child: CustomDropdown(
                      //   // hintText: "Select Part Nature",
                      //   hintText: "All time NS -Y",
                      //   // options: ["Non-Stockable", "Stockable"],
                      //   options: [
                      //     // "All time NS -Y",
                      //     "All time NS -N",
                      //     "All"
                      //   ],
                      //   onChanged: (selectedValue) {
                      //     if (_generalManagerController
                      //             .selectedPartNature.value !=
                      //         selectedValue) {
                      //       _generalManagerController.selectedPartNature.value =
                      //           selectedValue ?? "All time NS -Y";
                      //       // _initWork(null);
                      //       _generalManagerController.initWork(null);
                      //       print(
                      //           "selected Stock Type: ${_generalManagerController.selectedPartNature.value}");
                      //     }
                      //   },
                      //   selectedValue:
                      //       _generalManagerController.selectedPartNature.value,
                      // ),
                    ),
                    Expanded(
                      child: CustomDropdown(
                        hintText: "Select Card Status",
                        options: ["Open", "Closed", "All"],
                        onChanged: (selectedValue) {
                          if (_generalManagerController.selectedStatus.value !=
                              selectedValue) {
                            _generalManagerController.selectedStatus.value =
                                selectedValue;
                            _generalManagerController.initWork(null);
                          }
                          // print(
                          //     "selected Job Card Status: ${_generalManagerController.selectedStatus.value}");
                        },
                        selectedValue:
                            _generalManagerController.selectedStatus.value,
                      ),
                    ),
                    // GestureDetector(
                    //   onTap: () => _generalManagerController.showChart.toggle(),
                    //   child: Image.asset(ConstantImages.viewGraph, width: 40),
                    // ),
                  ],
                ),
              ),
              SizedBox(height: 8),
              Center(
                child: Obx(() {
                  bool loading = _generalManagerController.isLoading.value;
                  if (loading) {
                    final fakeLocation = List.generate(
                      10,
                      (_) => {
                        "Location": "Alwar alwar",
                        "LocationId": 14,
                        "Advisor": "JitendraSharma",
                        "PPNI_Value": 1349271,
                      },
                    );
                    return Skeletonizer(
                        effect: ShimmerEffect(
                          baseColor: Colors.grey.shade300,
                          highlightColor: Colors.grey.shade100,
                          duration: const Duration(seconds: 1),
                        ),
                        child: TableClass(
                          vehicleHeaderTitles: ['Location', 'PPNI_Value'],
                          advisorHeaderTitles: [],
                          evenColor: DMAppColors.secondary,
                          oddColor: DMAppColors.primary,
                          onPartTap: (part, locationID, advisorList) {},
                          advisorData: fakeLocation,
                        ));
                    // return const CircularProgressIndicator();
                  }
                  final err = _generalManagerController.error.value;
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
                  // if (_generalManagerController.tableData.isEmpty) {
                  //   return CustomErrorMsg(text: "PPNI value not found");
                  // }
                  final title = _generalManagerController.lakhsTitle.value;
                  return Column(
                    children: [
                      if (title.isNotEmpty == true)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: TitleIconRow(
                            title: title,
                            onCloseTap: () =>
                                _generalManagerController.initWork(null),
                          ),
                        ),
                      //   Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      //     Text(title),
                      //     // IconButton(
                      //     //   onPressed: () => _generalManagerController.initWork(null),
                      //     //   icon: Icon(
                      //     //     Icons.close,
                      //     //     color: Colors.black,
                      //     //   ),
                      //     // ),
                      //   ],
                      // ),
                      TableClass(
                        // monthTitle: title,
                        vehicleHeaderTitles: ['Location', 'PPNI Value'],
                        advisorHeaderTitles: ["Advisor", "PPNI Value"],
                        advisorData: _generalManagerController.tableData,
                        evenColor: DMAppColors.secondary,
                        oddColor: DMAppColors.primary,
                        onPartTap: (part, locationID, advisorList) async {
                          // Navigate or show part details
                          // print(
                          //     "Tapped part: $part, LocationID: $locationID, Advisor List: $advisorList");

                          if (advisorList != null && advisorList.isNotEmpty) {
                            _workShopManagerController.advisorPPNIList.value =
                                advisorList;
                          }
                          String dealerId = _locationController
                              .stockDetails['DealerID']
                              .toString();
                          Get.to(() => WorkshopManagerScreen(), arguments: {
                            "dealerID": dealerId,
                            "nonStockable": _generalManagerController
                                .selectedPartNature.value,
                            "jobCardStatus":
                                _generalManagerController.selectedStatus.value,
                            "locationID": locationID,
                            "advisor": part['Advisor'],
                          });
                        },
                      ),
                    ],
                  );
                }),
              ),
              SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  // // Your refresh logic
  // Future<void> _refreshPage() async {
  //   await Future.delayed(Duration(seconds: 1));
  //   // Add your API call or state update here
  // }

  // Widget _buildCardStatus() {
  //   return Row(
  //     children: [
  //       _buildListTile('Job Card Open', true),
  //       _buildListTile('Job Card Close', false),
  //     ],
  //   );
  // }

  // Widget _buildListTile(String title, bool isOpen) {
  //   return Flexible(
  //     child: ListTile(
  //       dense: true,
  //       leading: Icon(Icons.square,
  //           size: 20, color: isOpen ? Colors.black : Colors.grey[400]),
  //       title: Text(title),
  //     ),
  //   );
  // }

  // Widget _buildDropdown({
  //   required String value,
  //   required List<String> items,
  //   required ValueChanged<String?> onChanged,
  // }) {
  //   return DropdownButton<String>(
  //     value: value,
  //     onChanged: onChanged,
  //     style: const TextStyle(fontSize: 14, color: Colors.black),
  //     items: items
  //         .map((e) => DropdownMenuItem<String>(
  //               value: e,
  //               child: Text(e),
  //             ))
  //         .toList(),
  //   );
  // }
}
