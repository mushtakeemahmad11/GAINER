// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../gainer/controllers/check_internet/no_internet_screen.dart';
// import '../../gainer/controllers/home_screen_controller.dart';
// import '../../gainer/screens/check_internet/check_internet_connectivity.dart';
// import '../../gainer/shared_preferences/shared_preferences_get_data.dart';
// import '../../gainer/widget/error_msg.dart';
// import '../../gainer/widget/reusable_dropdown.dart';
// import '../../gainer/widget/workshop_expansion_table.dart';
// import '../controllers/workshop_manager_controller.dart';
// import '../core/services/api_services.dart';
// import '../core/theme/app_colors.dart';
// import '../core/utils/dm_images.dart';
// import '../core/utils/transform_graph_ppni_data.dart';
// import 'bar_chart_widget.dart';
// import 'head_bar.dart';
// import 'ppni_value_box.dart';
// import 'testing/refresh_indicator.dart';
// import 'title_icon_row.dart';
// import 'package:skeletonizer/skeletonizer.dart';
//
// class WorkshopAdvisorBody extends StatefulWidget {
//   final String dealerID;
//   final String? locationID;
//   final String advisor;
//   final String? nonStockable;
//   final String? jobCardStatus;
//   final List? advisorList;
//
//   const WorkshopAdvisorBody({
//     super.key,
//     required this.dealerID,
//     this.locationID,
//     required this.advisor,
//     this.nonStockable,
//     this.jobCardStatus,
//     this.advisorList,
//   });
//
//   @override
//   State<WorkshopAdvisorBody> createState() => _WorkshopAdvisorBodyState();
// }
//
// class _WorkshopAdvisorBodyState extends State<WorkshopAdvisorBody> {
//   final ApiServices api = ApiServices();
//   final WorkShopManagerController _controller = Get.put(WorkShopManagerController());
//   final LocationController _locationController = Get.put(LocationController());
//
//   late Worker _worker;
//   final ScrollController scrollController = ScrollController();
//
//   // pagination states
//   bool hasMore = true;
//   bool isPagination = false;
//   final int limitValue = 15;
//   int pageValue = 1;
//
//   @override
//   void initState() {
//     super.initState();
//
//     // init filters
//     _controller.selectedPartNatureBody.value = widget.nonStockable;
//     _controller.selectedStatusBody.value = widget.jobCardStatus;
//     _controller.selectedAdvisor.value = widget.advisor;
//
//     _fetchApiData();
//
//     // watch for location changes
//     _worker = ever(_locationController.selectedLocationId, (value) {
//       _fetchApiData(locationId: value);
//     });
//
//     // scroll pagination
//     scrollController.addListener(() {
//       if (scrollController.position.pixels >=
//           scrollController.position.maxScrollExtent - 200 &&
//           !_controller.isLoading.value &&
//           !_controller.isMoreLoading.value &&
//           hasMore) {
//         isPagination = true;
//         _loadMore();
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     _worker.dispose();
//     api.cancelRequest();
//     scrollController.dispose();
//     super.dispose();
//   }
//
//   Future<void> _fetchApiData({String? locationId, String? monthYear, String? title}) async {
//     _controller.lakhsTitleAdvisor.value =
//     title != null ? "Vehicle wise PPNI breakdown - $title" : "";
//
//     if (!await checkInternet()) return internetNotAvl();
//
//     // prepare filters
//     final locationID = await getStringData("selectedLocationID") ?? "";
//     final advisorName = _controller.selectedAdvisor.value ?? widget.advisor;
//
//     final nonStockable = switch (_controller.selectedPartNatureBody.value) {
//       "All time NS -Y" => "Y",
//       "All time NS -N" => "N",
//       _ => null,
//     };
//
//     final cardStatus = switch (_controller.selectedStatusBody.value) {
//       "Closed" => "Close",
//       "Open" => "Open",
//       _ => null,
//     };
//
//     _controller.prepareFetch(
//       dealerID: widget.dealerID,
//       locationID: widget.locationID ?? locationID,
//       advisor: advisorName,
//       nonStockable: nonStockable,
//       cardStatus: cardStatus,
//       monthDate: monthYear,
//     );
//
//     pageValue = 1;
//     hasMore = true;
//     isPagination = false;
//
//     _controller.isLoading(true);
//     await _loadMore();
//     _controller.isLoading(false);
//
//     // fetch graph data
//     final graphResponse = await api.fetchGraphPPNIValue(
//       dealerId: widget.dealerID,
//       locationId: widget.locationID ?? locationID,
//       nonStockable: nonStockable,
//       jobCardStatus: cardStatus,
//       advisor: advisorName,
//     );
//
//     if (graphResponse['success']) {
//       _controller.updateGraphAdvisor(
//           transformGraphPPNIDataLast12Months(graphResponse['data']));
//     } else {
//       _controller.clearGraph(graphResponse['message']);
//     }
//   }
//
//   Future<void> _loadMore() async {
//     _controller.isMoreLoading(true);
//     final response = await api.fetchVehiclePPNIValuesByAdvisor(
//       dealerId: _controller.dealerIdValue ?? "",
//       nonStockable: _controller.isNonStockableValue,
//       jobCardStatus: _controller.jobCardStatusValue,
//       locationId: _controller.locationIdValue ?? "",
//       advisor: _controller.advisorValue ?? "",
//       monthDate: _controller.monthDateValue,
//       page: pageValue,
//       limit: limitValue,
//     );
//     _controller.isMoreLoading(false);
//
//     if (response['success']) {
//       final data = response['data'];
//       _controller.addVehicleParts(data, response['totalPPNI']);
//       hasMore = response['hasMore'] && data.length >= pageValue;
//       if (hasMore) pageValue++;
//     } else {
//       _controller.handleError(response['message'], isPagination);
//       if (response['message'] == "Data not available") hasMore = false;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       controller: scrollController,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           HeadBar(text: "PPNI List", imgSting: ConstantImages.ppniList),
//
//           // Header Row
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 8),
//             child: Row(
//               children: [
//                 Obx(() => PpniValueBox(value: _controller.totalPPNIValueAdvisor.value)),
//                 GestureDetector(
//                   onTap: () => _controller.showChart.toggle(),
//                   child: Image.asset(ConstantImages.viewGraph, width: 45),
//                 ),
//                 const SizedBox(width: 8),
//               ],
//             ),
//           ),
//
//           // Graph
//           Obx(() => BarChartWidget(
//             showChart: _controller.showChart.value,
//             data: _controller.dataAdvisor.toList(),
//             xLabels: _controller.xLabelsAdvisor.toList(),
//             monthDate: _controller.monthDateAdvisor.toList(),
//             showBoth: false,
//             showWorkShopSale: true,
//             error: _controller.graphErrorAdvisor.value,
//             onBarTap: (val, label) => _fetchApiData(monthYear: val, title: label),
//           )),
//
//           // Filters
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 8.0),
//             child: Row(
//               spacing: 10,
//               children: [
//                 _buildDropdown(
//                   "Select Part Nature",
//                   ["All time NS -Y", "All time NS -N", "All"],
//                   _controller.selectedPartNatureBody,
//                 ),
//                 _buildDropdown(
//                   "Select Card Status",
//                   ["Open", "Closed", "All"],
//                   _controller.selectedStatusBody,
//                 ),
//                 if (widget.advisorList?.isNotEmpty == true)
//                   Expanded(
//                     child: CustomDropdown(
//                       hintText: "Select Advisor",
//                       options: widget.advisorList!
//                           .map((item) => item['Advisor'].toString())
//                           .toList(),
//                       onChanged: (val) {
//                         _controller.selectedAdvisor.value = val;
//                         _fetchApiData();
//                       },
//                       selectedValue: _controller.selectedAdvisor.value,
//                     ),
//                   ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 8),
//
//           // Data Table
//           Center(
//             child: Obx(() {
//               if (_controller.isLoading.value) {
//                 return Skeletonizer(
//                   effect: ShimmerEffect(
//                     baseColor: Colors.grey.shade300,
//                     highlightColor: Colors.grey.shade100,
//                   ),
//                   child: WorkshopExpansionTable(
//                     enhancedPpniData: _controller.fakePPNIData,
//                     dealerId: '',
//                     locationId: '',
//                     advisorName: '',
//                     jobCard: '',
//                     nonStockable: '',
//                     monthDate: '',
//                   ),
//                 );
//               }
//               if (_controller.secondSError.value != null) {
//                 return Column(
//                   children: [
//                     CustomErrorMsg(text: _controller.secondSError.value!),
//                     RotatingRefreshIcon(
//                       color: DMAppColors.secondary,
//                       isRotating: _controller.isFirstLoading.value,
//                       onRefresh: () async => await _fetchApiData(),
//                     ),
//                   ],
//                 );
//               }
//               if (_controller.vehiclePartsDetailsList.isEmpty) {
//                 return const CustomErrorMsg(text: "No Data Found");
//               }
//
//               return Column(
//                 children: [
//                   if (_controller.lakhsTitleAdvisor.value.isNotEmpty)
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                       child: TitleIconRow(
//                         title: _controller.lakhsTitleAdvisor.value,
//                         onCloseTap: () => _fetchApiData(),
//                       ),
//                     ),
//                   WorkshopExpansionTable(
//                     enhancedPpniData: _controller.vehiclePartsDetailsList
//                         .map((item) => item.toJson())
//                         .toList(),
//                     dealerId: _controller.dealerIdValue ?? "",
//                     locationId: _controller.locationIdValue ?? "",
//                     advisorName: _controller.advisorValue ?? "",
//                     jobCard: _controller.jobCardStatusValue ?? "",
//                     nonStockable: _controller.isNonStockableValue ?? '',
//                     monthDate: _controller.monthDateValue ?? "",
//                   ),
//                   if (hasMore && _controller.isMoreLoading.value)
//                     const Padding(
//                       padding: EdgeInsets.all(8.0),
//                       child: CircularProgressIndicator(),
//                     ),
//                 ],
//               );
//             }),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildDropdown(String hint, List<String> options, RxnString selected) {
//     return Expanded(
//       child: CustomDropdown(
//         hintText: hint,
//         options: options,
//         onChanged: (value) {
//           if (selected.value != value) {
//             selected.value = value;
//             _fetchApiData();
//           }
//         },
//         selectedValue: selected.value,
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:gainer/dealer_monitoring/widgets/ppni_value_box.dart';
import 'package:gainer/dealer_monitoring/widgets/testing/refresh_indicator.dart';
import 'package:gainer/dealer_monitoring/widgets/title_icon_row.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../gainer/controllers/check_internet/no_internet_screen.dart';
import '../../gainer/controllers/home_screen_controller.dart';
import '../../gainer/screens/check_internet/check_internet_connectivity.dart';
import '../../gainer/shared_preferences/shared_preferences_get_data.dart';
import '../../gainer/widget/error_msg.dart';
import '../../gainer/widget/reusable_dropdown.dart';
import '../../gainer/widget/workshop_expansion_table.dart';
import '../controllers/workshop_manager_controller.dart';
import '../core/services/api_services.dart';
import '../core/theme/app_colors.dart';
import '../core/utils/dm_images.dart';
import '../core/utils/transform_graph_ppni_data.dart';
import '../models/vehicle_parts_details_model.dart';
import 'bar_chart_widget.dart';
import 'head_bar.dart';

class WorkshopAdvisorBody extends StatefulWidget {
  final String dealerID;
  final String? locationID;
  final String advisor;
  // final bool nonStockable;
  final String? nonStockable;
  final String? jobCardStatus;
  final List? advisorList;

  const WorkshopAdvisorBody({
    super.key,
    required this.dealerID,
    this.locationID,
    required this.advisor,
    // this.nonStockable = true,
    this.nonStockable,
    this.jobCardStatus,
    this.advisorList,
  });

  @override
  State<WorkshopAdvisorBody> createState() => _WorkshopAdvisorBodyState();
}

class _WorkshopAdvisorBodyState extends State<WorkshopAdvisorBody> {
  ApiServices api = ApiServices();
  final WorkShopManagerController _controller =
      Get.put(WorkShopManagerController());
  final LocationController _locationController = Get.put(LocationController());
  late Worker _worker;

  String? dealerIdValue;
  String? isNonStockableValue;
  String? jobCardStatusValue;
  String? locationIdValue;
  String? advisorValue;
  String? monthDateValue;
  int? tCode;
  bool isPagination = false;
  bool hasMore = true;
  final int limitValue = 15;
  int pageValue = 1;
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _initWork();
  }

  _initWork() {
    _controller.selectedPartNatureBody.value = widget.nonStockable;
    _controller.selectedStatusBody.value = widget.jobCardStatus;
    _controller.selectedAdvisor.value = widget.advisor;

    _fetchApiData();
    // when location changes it catch
    _worker = ever(_locationController.selectedLocationId, (value) {
      _onLocationChanged(value);
    });

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent - 200 &&
          !_controller.isLoading.value &&
          !_controller.isMoreLoading.value &&
          hasMore) {
        isPagination = true;
        _loadMore();
      }
    });
  }

  void _onLocationChanged(String? location) {
    _fetchApiData(locationId: location);
  }

  @override
  void dispose() {
    _worker.dispose(); // Important!
    api.cancelRequest(); // for cancel old fetchVehiclePPNIValuesByAdvisor
    super.dispose();
  }

  Future<void> _fetchApiData(
      {String? locationId, String? monthYear, String? title}) async {
    _controller.lakhsTitleAdvisor.value =
        title != null ? "Vehicle wise PPNI breakdown - $title" : "";
    // title != null ? " Data for $title" : "";
    bool checkInt = await checkInternet();

    if (!checkInt) {
      return internetNotAvl();
    }

    String? advisorName = _controller.selectedAdvisor.value;
    String locationID = await getStringData("selectedLocationID") ?? "";
    final val = _controller.selectedPartNatureBody.value;
    String? nonStockable = (val == "All time NS -Y")
        ? "Y"
        : (val == "All time NS -N")
            ? "N"
            : null;
    final val2 = _controller.selectedStatusBody.value;
    String? cardStatus = val2 == "Closed"
        ? "Close"
        : val2 == "Open"
            ? "Open"
            : null;
    // Define variables
    dealerIdValue = widget.dealerID;
    isNonStockableValue = nonStockable;
    jobCardStatusValue = cardStatus;
    locationIdValue = widget.locationID ?? locationID;
    advisorValue = advisorName ?? widget.advisor;
    monthDateValue = monthYear;
    tCode = await getIntData("tCode");
    _controller.secondSError.value = null;
    _controller.vehiclePartsDetailsList.clear();
    _controller.totalPPNIValueAdvisor.value = 0;
    pageValue = 1;
    hasMore = true;
    isPagination = false;
    _controller.isLoading(true);
    await _loadMore();
    _controller.isLoading(false);
    // API call
    // final response = await api.fetchVehiclePPNIValuesByAdvisor(
    //   dealerId: dealerIdValue ?? "",
    //   nonStockable: isNonStockableValue,
    //   jobCardStatus: jobCardStatusValue,
    //   locationId: locationIdValue ?? "",
    //   advisor: advisorValue ?? "",
    //   monthDate: monthDateValue,
    //   page: pageValue,
    //   limit: limitValue,
    // );
    //
    // _controller.isLoading.value = false;
    //
    // if (response['success']) {
    //   final data = response['data'];
    //   _controller.vehiclePartsDetailsList.value =
    //       data.map<VehiclePPNI>((item) => VehiclePPNI.fromJson(item)).toList();
    //   _controller.totalPPNIValueAdvisor.value = response['totalPPNI'];
    // } else {
    //   _controller.secondSError.value = response['message'];
    // }

    // for fetch graph data
    _controller.graphErrorAdvisor.value = null;
    final graphResponse = await api.fetchGraphPPNIValue(
      dealerId: widget.dealerID,
      locationId: widget.locationID ?? locationID,
      nonStockable: nonStockable,
      jobCardStatus: cardStatus,
      advisor: advisorName ?? widget.advisor,
    );
    if (graphResponse['success']) {
      // final graphData = transformGraphPPNIData(graphResponse['data']);
      final graphData =
          transformGraphPPNIDataLast12Months(graphResponse['data']);
      _controller.updateGraphAdvisor(graphData);
    } else {
      _controller.dataAdvisor.clear();
      _controller.xLabelsAdvisor.clear();
      _controller.monthDateAdvisor.clear();
      _controller.graphErrorAdvisor.value = graphResponse['message'];
    }
  }

  Future<void> _loadMore() async {
    _controller.isMoreLoading(true);
    final response = await api.fetchVehiclePPNIValuesByAdvisor(
      dealerId: dealerIdValue ?? "",
      nonStockable: isNonStockableValue,
      jobCardStatus: jobCardStatusValue,
      locationId: locationIdValue ?? "",
      advisor: advisorValue ?? "",
      monthDate: monthDateValue,
      page: pageValue,
      limit: limitValue,
      userId: tCode.toString(),
    );
    _controller.isMoreLoading(false);

    // print("response of fetchVehiclePPNIValuesByAdvisor: $response");
    if (response['success']) {
      final data = response['data'];
      _controller.vehiclePartsDetailsList.addAll(
          data.map<VehiclePPNI>((item) => VehiclePPNI.fromJson(item)).toList());
      _controller.totalPPNIValueAdvisor.value += response['totalPPNI'];
      bool dataHasMore = response['hasMore'];
      if (!dataHasMore || data.length < pageValue) {
        hasMore = false;
      } else {
        pageValue++;
      }
    } else {
      final err = response['message'];
      if (isPagination) {
        Get.rawSnackbar(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          messageText: Center(
            child: Text(err, style: TextStyle(color: Colors.white)),
          ),
        );

        if (err == "Data not available") {
          hasMore = false;
        }
      } else {
        _controller.secondSError.value = err;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final advisorList = widget.advisorList;
    return SingleChildScrollView(
      controller: scrollController,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeadBar(text: "PPNI List", imgSting: DMImages.ppniList),
          // const SizedBox(height: 5),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              // crossAxisAlignment: CrossAxisAlignment.end,
              // spacing: 10,
              children: [
                Obx(() => PpniValueBox(
                    value: _controller.totalPPNIValueAdvisor.value)),
                GestureDetector(
                  onTap: () => _controller.showChart.toggle(),
                  child: Image.asset(DMImages.viewGraph, width: 45),
                ),
                const SizedBox(width: 8),
              ],
            ),
          ),
          Obx(() {
            if (_controller.dataAdvisor == []) {
              _controller.graphErrorAdvisor.value == "Data not available";
            }
            final data = _controller.dataAdvisor.toList();
            final xLabels = _controller.xLabelsAdvisor.toList();
            final monthDate = _controller.monthDateAdvisor.toList();

            return BarChartWidget(
              showChart: _controller.showChart.value,
              data: data,
              xLabels: xLabels,
              monthDate: monthDate,
              showBoth: false,
              showWorkShopSale: true,
              error: _controller.graphErrorAdvisor.value,
              onBarTap: (val, label) => _controller.isLoading.value
                  ? null
                  : _fetchApiData(monthYear: val, title: label),
            );
          }),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              spacing: 10,
              children: [
                _buildPartNatureDropDown(),
                (advisorList?.isNotEmpty == true)
                    ? IntrinsicWidth(
                        child: _buildStatusDropDown(),
                      )
                    : Expanded(
                        child: _buildStatusDropDown(),
                      ),
                if (advisorList?.isNotEmpty == true)
                  _buildAdvisorDropDown(advisorList!),
              ],
            ),
          ),
          SizedBox(height: 8),
          Center(
            child: Obx(() {
              if (_controller.isLoading.value) {
                return Skeletonizer(
                  effect: ShimmerEffect(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    duration: const Duration(seconds: 1),
                  ),
                  enableSwitchAnimation: true,
                  child: WorkshopExpansionTable(
                    enhancedPpniData: _controller.fakePPNIData,
                    dealerId: '',
                    locationId: '',
                    advisorName: '',
                    jobCard: '',
                    nonStockable: '',
                    monthDate: '',
                  ),
                );
                // return Padding(
                //   padding: const EdgeInsets.only(top: 15),
                //   child: CircularProgressIndicator(),
                // );
              }
              final err = _controller.secondSError.value;
              if (err != null) {
                // return CustomErrorMsg(text: err);
                return Column(
                  children: [
                    CustomErrorMsg(text: err),
                    // if (err.contains('Request timed out'))
                    RotatingRefreshIcon(
                      color: DMAppColors.secondary,
                      isRotating: _controller.isFirstLoading.value,
                      // onRefresh: () async => await _controller.initWork(null),
                      onRefresh: () async => await _fetchApiData(),
                    ),
                  ],
                );
              }
              if (_controller.vehiclePartsDetailsList.isEmpty) {
                return CustomErrorMsg(text: "No Data Found");
              }
              final title = _controller.lakhsTitleAdvisor.value;
              return Column(
                children: [
                  if (title.isNotEmpty == true)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: TitleIconRow(
                          title: title, onCloseTap: () => _fetchApiData()),
                    ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     Text(title),
                  //     IconButton(
                  //       onPressed: () => _fetchApiData(),
                  //       icon: Icon(
                  //         Icons.close,
                  //         color: Colors.black,
                  //       ),
                  //     ),
                  //   ],
                  // ),

                  WorkshopExpansionTable(
                    enhancedPpniData: _controller.vehiclePartsDetailsList
                        .map((item) => item.toJson())
                        .toList(),
                    dealerId: dealerIdValue ?? "",
                    locationId: locationIdValue ?? "",
                    advisorName: advisorValue ?? "",
                    jobCard: jobCardStatusValue ?? "",
                    nonStockable: isNonStockableValue ?? '',
                    monthDate: monthDateValue ?? "",
                  ),

                  if (hasMore && _controller.isMoreLoading.value)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(),
                    ),
                ],
              );
            }),
          ),
          // Obx(() => Center(
          //       child: _controller.secondSError.value != null
          //           ? CustomErrorMsg(
          //               text: "${_controller.secondSError.value}")
          //           : const SizedBox.shrink(),
          //     )),
          // _controller.isLoading.value
          //     ? const Center(child: CircularProgressIndicator())
          //     : _controller.vehiclePartsDetailsList.isNotEmpty
          //         ? WorkshopExpansionTable(
          //             enhancedPpniData: _controller.vehiclePartsDetailsList
          //                 .map((item) => item.toJson())
          //                 .toList(),
          //           )
          //         : const Center(
          //             child: CustomErrorMsg(text: "No Data Found")),
        ],
      ),
    );
  }

  Widget _buildPartNatureDropDown() {
    return Expanded(
      child: CustomDropdown(
        hintText: "Select Part Nature",
        options: ["All time NS -Y", "All time NS -N", "All"],
        onChanged: (selectedValue) {
          _controller.selectedPartNatureBody.value == selectedValue
              ? null
              : _fetchApiData();
          _controller.selectedPartNatureBody.value = selectedValue;
        },
        selectedValue: _controller.selectedPartNatureBody.value,
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
      //     if (_controller.selectedPartNatureBody.value != selectedValue) {
      //       _controller.selectedPartNatureBody.value =
      //           selectedValue ?? "All time NS -Y";
      //       _fetchApiData();
      //       print(
      //           "selected Stock Type: ${_controller.selectedPartNatureBody.value}");
      //     }
      //   },
      //   selectedValue: _controller.selectedPartNatureBody.value,
      // ),
    );
  }

  Widget _buildStatusDropDown() {
    return CustomDropdown(
      hintText: "Select Card Status",
      options: ["Open", "Closed", "All"],
      onChanged: (selectedValue) {
        _controller.selectedStatusBody.value == selectedValue
            ? null
            : _fetchApiData();
        _controller.selectedStatusBody.value = selectedValue;
      },
      selectedValue: _controller.selectedStatusBody.value,
    );
    // return CustomDropdown(
    //   hintText: "Open",
    //   options: ['Closed', 'All'],
    //   onChanged: (selectedValue) {
    //     if (_controller.selectedStatusBody.value != selectedValue) {
    //       _controller.selectedStatusBody.value = selectedValue ?? "Open";
    //       _fetchApiData();
    //     }
    //     print("selected Job Card Status: ${_controller.selectedStatusBody.value}");
    //   },
    //   selectedValue: _controller.selectedStatusBody.value,
    // );
  }

  Widget _buildAdvisorDropDown(List advisorList) {
    return Expanded(
      child: CustomDropdown(
        hintText: "select Advisor",
        options: advisorList.map((item) => item['Advisor'].toString()).toList(),
        onChanged: (val) {
          if (val != null) {
            _controller.selectedAdvisor.value = val;
            _fetchApiData();
          }
        },
        selectedValue: _controller.selectedAdvisor.value,
      ),
    );
  }
}
