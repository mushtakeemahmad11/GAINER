import 'package:flutter/material.dart';
import 'package:gainer/app_switcher_view/app_switcher_controller.dart';
import 'package:gainer/dealer_monitoring/widgets/access_denied_snackbar.dart';
import 'package:gainer/dealer_monitoring/widgets/ppni_value_box.dart';
import 'package:gainer/dealer_monitoring/widgets/refresh_indicator.dart';
import 'package:gainer/dealer_monitoring/widgets/title_icon_row.dart';
import 'package:gainer/gainer_app/core/Services/auth_service.dart';
import 'package:gainer/gainer_app/core/utils/check_internet.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../gainer_app/core/widgets/error_text.dart';
import '../controllers/workshop_manager_controller.dart';
import '../core/services/dm_api_services.dart';
import '../core/theme/app_colors.dart';
import '../core/utils/dm_images.dart';
import '../core/utils/transform_graph_ppni_data.dart';
import '../models/vehicle_parts_details_model.dart';
import 'bar_chart_widget.dart';
import 'dm_dropdown.dart';
import 'head_bar.dart';
import 'no_internet_dialog.dart';
import 'workshop_expansion_table.dart';

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
  DMApiServices api = DMApiServices();
  final WorkShopManagerController _controller =
      Get.put(WorkShopManagerController());
  final appSwitcherCtrl = Get.find<AppSwitcherController>();
  // final LocationController _locationController = Get.put(LocationController());
  late Worker _worker;

  String? dealerIdValue;
  String? isNonStockableValue;
  String? jobCardStatusValue;
  String? locationIdValue;
  String? advisorValue;
  String? monthDateValue;
  String? tCode;
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
    _worker = ever(appSwitcherCtrl.selectedLocationId, (value) {
      _onLocationChanged(value);
    });

    // scrollController.addListener(() {
    //   final position = scrollController.position;
    //
    //   bool isNearBottom = position.pixels >= position.maxScrollExtent - 200;
    //
    //   /// Hide button when user reaches bottom
    //   if (isNearBottom) {
    //     if (_controller.showScrollButton.value) {
    //       _controller.showScrollButton.value = false;
    //     }
    //
    //     /// Pagination
    //     if (!_controller.isLoading.value &&
    //         !_controller.isMoreLoading.value &&
    //         hasMore) {
    //       isPagination = true;
    //       _loadMore();
    //     }
    //   }
    //
    //   /// Show button when user scrolls up
    //   else {
    //     if (!_controller.showScrollButton.value) {
    //       _controller.showScrollButton.value = true;
    //     }
    //   }
    // });

    // scrollController.addListener(() {
    //   final position = scrollController.position;
    //
    //   bool isNearBottom = position.pixels >= position.maxScrollExtent - 200;
    //   bool isAtBottom = position.pixels >= position.maxScrollExtent;
    //
    //   /// Show button when user scrolls up
    //   if (!isAtBottom) {
    //     _controller.showScrollButton.value = true;
    //   } else {
    //     _controller.showScrollButton.value = false;
    //   }
    //
    //   /// Pagination
    //   if (isNearBottom &&
    //       !_controller.isLoading.value &&
    //       !_controller.isMoreLoading.value &&
    //       hasMore) {
    //     isPagination = true;
    //     _loadMore();
    //   }
    // });

    scrollController.addListener(() {
      if (!scrollController.hasClients) return;

      if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent - 200 &&
          !_controller.isLoading.value &&
          !_controller.isMoreLoading.value &&
          hasMore) {
        isPagination = true;
        _loadMore();
      }
    });

    // scrollController.addListener(() {
    //   if (scrollController.position.pixels >=
    //           scrollController.position.maxScrollExtent - 200 &&
    //       !_controller.isLoading.value &&
    //       !_controller.isMoreLoading.value &&
    //       hasMore) {
    //     isPagination = true;
    //     _loadMore();
    //   }
    // });
  }

  void scrollToBottom() {
    scrollController.animateTo(
      scrollController.position.maxScrollExtent + 50,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
    );
  }

  // void _onLocationChanged(String? location) {
  //   _fetchApiData(locationId: location);
  // }

  void _onLocationChanged(String? location) {
    pageValue = 1;
    hasMore = true;
    _controller.hasErrorInPagination.value = false;
    _controller.vehiclePartsDetailsList.clear();

    _fetchApiData(locationId: location);
  }

  @override
  void dispose() {
    _worker.dispose(); // Important!
    api.cancelRequest(); // for cancel old fetchVehiclePPNIValuesByAdvisor
    super.dispose();
  }

  void resetVariable() {
    _controller.secondSError.value = null;
    _controller.vehiclePartsDetailsList.clear();
    _controller.totalPPNIValueAdvisor.value = 0;
    pageValue = 1;
    hasMore = true;
    _controller.showScrollButton.value = false;
    _controller.hasErrorInPagination.value = false;
    isPagination = false;
  }

  Future<void> _fetchApiData(
      {String? locationId, String? monthYear, String? title}) async {
    _controller.lakhsTitleAdvisor.value =
        title != null ? "Vehicle wise PPNI breakdown - $title" : "";
    // title != null ? " Data for $title" : "";
    bool checkInt = await CheckInternet.checkInternet();
    if (!checkInt) {
      return NoInternetDialog.show();
    }

    String? advisorName = _controller.selectedAdvisor.value;
    // String locationID = await getStringData("selectedLocationID") ?? "";
    String locationID = await AuthService.getLocationId();
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
    tCode = await AuthService.getTCode();
    resetVariable();
    _controller.isLoading(true);
    await _loadMore();
    _controller.isLoading(false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndAutoPaginate();
    });
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
      _controller.hasErrorInPagination.value = false;
      final data = response['data'];
      _controller.vehiclePartsDetailsList.addAll(
          data.map<VehiclePPNI>((item) => VehiclePPNI.fromJson(item)).toList());
      _controller.totalPPNIValueAdvisor.value += response['totalPPNI'];
      bool dataHasMore = response['hasMore'];
      if (!dataHasMore || data.length < limitValue) {
        hasMore = false;
        _controller.showScrollButton.value = false;
      } else {
        pageValue++;
        _controller.showScrollButton.value = true;
      }
      // if (!dataHasMore || data.length < pageValue) {
      //   hasMore = false;
      //   _controller.showScrollButton.value = false;
      // } else {
      //   pageValue++;
      // }
    } else {
      _controller.hasErrorInPagination.value = true;
      final err = response['message'];
      if (isPagination) {
        DealerSnackbar.showAccessDenied(err);
        // Get.rawSnackbar(
        //   padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        //   messageText: Center(
        //     child: Text(err, style: TextStyle(color: Colors.white)),
        //   ),
        // );

        if (err == "Data not available") {
          hasMore = false;
          _controller.showScrollButton.value = false;
          _controller.hasErrorInPagination.value = false;
        }
      } else {
        _controller.secondSError.value = err;
      }
    }
  }

  void _checkAndAutoPaginate() {
    if (!scrollController.hasClients) return;

    final maxScroll = scrollController.position.maxScrollExtent;

    /// If content is NOT scrollable → load more automatically
    if (maxScroll <= 0 &&
        hasMore &&
        !_controller.hasErrorInPagination.value &&
        !_controller.isLoading.value &&
        !_controller.isMoreLoading.value) {
      isPagination = true;
      _loadMore().then((_) {
        /// Check again after loading (recursive until filled)
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _checkAndAutoPaginate();
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final advisorList = widget.advisorList;
    return Stack(
      children: [
        SingleChildScrollView(
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
                  }
                  final err = _controller.secondSError;
                  if (err.value != null) {
                    // return CustomErrorMsg(text: err);
                    return Column(
                      children: [
                        AppErrorText(error: err),
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
                    return Text("No Data Found",
                        style: const TextStyle(color: Colors.red));
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
            ],
          ),
        ),
        Obx(
          () => _controller.showScrollButton.value
              ? Positioned(
                  bottom: 40,
                  right: 20,
                  child: CircleAvatar(
                    backgroundColor: Colors.black45,
                    // backgroundColor: DMAppColors.secondary,
                    child: IconButton(
                      onPressed: scrollToBottom,
                      icon: Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              : const SizedBox(),
        )
      ],
    );
  }

  Widget _buildPartNatureDropDown() {
    return Expanded(
      child: DmDropdown(
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
    return DmDropdown(
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
      child: DmDropdown(
        hintText: "select Advisor",
        options: advisorList.map((item) => item['Advisor'].toString()).toList(),
        onChanged: (val) {
          if (val != null) {
            if (_controller.selectedAdvisor.value != val) {
              _controller.selectedAdvisor.value = val;
              _fetchApiData();
            }
          }
        },
        selectedValue: _controller.selectedAdvisor.value,
      ),
    );
  }
}
