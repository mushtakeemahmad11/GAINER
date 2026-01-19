import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:get/get.dart';
import '../../../main.dart';
import '../../gainer/apis_functionality/api_service.dart';
import '../../gainer/controllers/check_internet/no_internet_screen.dart';
import '../../gainer/controllers/home_screen_controller.dart';
import '../../gainer/controllers/part_request_controller.dart';
import '../../gainer/controllers/search_part_suggestion_controller.dart';
import '../../gainer/model/part_details_model.dart';
import '../../gainer/screens/bottombar_screen/part_request/show_availability_screen.dart';
import '../../gainer/screens/check_internet/check_internet_connectivity.dart';
import '../../gainer/screens/colors.dart';
import '../../gainer/shared_preferences/shared_preferences_get_data.dart';
import '../../gainer/widget/bottomsheet_for_picture.dart';
import '../../gainer/widget/reusable_dropdown.dart';
import '../../gainer/widget/reusable_elevated_button.dart';
import '../../gainer/widget/reusable_widget.dart';
import '../../gainer/widget/suggestion_list.dart';

class PartRequestBody extends StatefulWidget {
  final String? partNumber;
  const PartRequestBody({super.key, this.partNumber});

  @override
  State<PartRequestBody> createState() => _PartRequestBodyState();
}

class _PartRequestBodyState extends State<PartRequestBody> {
  final _formKey = GlobalKey<FormState>();

  final PartSearchController _partSearchController =
      Get.put(PartSearchController());
  final LocationController _locationController = Get.put(LocationController());
  final PartRequestController _partRequestController =
      Get.put(PartRequestController());
  List<PartDetails> partDetails = [];

  String? selectedLocationName;

  late String selectedLocationId;

  List<String> tablePartNum = [];

  // Toggle button states
  bool isNonMovingClicked = false;

  bool isNonStockableClicked = false;

  bool isMovingClicked = false;

  // Toggle switches
  bool isMyGroup = false;

  bool isClusterId = false;

  bool showClusterSwitch = false;

  final List<String> dropdownOptions1 = ['Vehicle', 'Stock'];
  // Track which toggle is selected
  List<bool> isSelected = [false, false, false];

  // List<String> dropdownOptions3 = [];

  String? _selectedValue3;

  // String? selectedValue1;
  @override
  void initState() {
    super.initState();
    _initWork();
  }

  _initWork() async {
    _partSearchController.partNumberController.clear();
    _partRequestController.tatController.clear();
    _partRequestController.tableData.clear();
    tablePartNum.clear();
    _partRequestController.errorMsg.value = null;
    _partSearchController.partSuggestions.clear();
    selectedLocationId = await getStringData('selectedLocationID');
    // selectedLocationName = _locationController.selectedLocation.value;
    // selectedLocationId =
    //     _locationController.locationIdMap[selectedLocationName].toString();
    // _fetchLspOptions();
    _fetchClusterOption();
    // Future.delayed(Duration(milliseconds: 100), () {
    //   FocusScope.of(context).unfocus();
    // });

    // String? partNum = _partRequestController.partStockPartNum.value;
    // if (partNum != null) _partSearchController.selectPartNumber(partNum);
    // String? partNumber;
    if (widget.partNumber != null) {
      _partSearchController.partNumberController.text = widget.partNumber!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: mq.width * .03),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildToggleButtons(),
          // SizedBox(height: mq.height * .02),
          _buildDropdowns(),
          SizedBox(height: mq.height * .02),
          // _buildTatAndGroupSwitch(),
          // SizedBox(height: mq.height * .02),
          // if (showClusterSwitch) _buildClusterSwitch(),
          // _buildTATCluster(),
          // SizedBox(height: mq.height * .01),
          _buildPartNumberInput(),
          _buildPartSuggestion(),
          Center(
            child: Obx(
              () => _partRequestController.errorMsg.value != null
                  ? Padding(
                      padding: EdgeInsets.symmetric(vertical: mq.height * .01),
                      child: Text(_partRequestController.errorMsg.value ?? '',
                          style:
                              const TextStyle(color: Colors.red, fontSize: 16)),
                    )
                  : SizedBox(height: mq.height * .02),
            ),
          ),
          _buildTable(),
          SizedBox(height: mq.height * .01),
          if (_partRequestController.tableData.isNotEmpty)
            _buildShowAvailabilityButton(),
        ],
      ),
    );
  }

  /// Builds toggle buttons for Non-Moving, Non-Stockable, and Moving
  Widget _buildToggleButtons() {
    return Center(
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: List.generate(3, (index) {
          final labels = ["Non Moving", "Non Stockable", "Moving"];
          return ChoiceChip(
            label: Text(labels[index]),
            selected: isSelected[index],
            selectedColor: AppColor.primary,
            backgroundColor: AppColor.primaryShade,
            showCheckmark: false,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            labelStyle: TextStyle(
              color: isSelected[index] ? Colors.white : AppColor.primary,
            ),
            onSelected: (bool selected) {
              setState(() {
                isSelected[index] = selected; // Allow multiple selections
              });
            },
          );
        }),
      ),
    );
    // return Row(
    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //   children: [
    //     _toggleButton('Non Moving', isNonMovingClicked,
    //         () => setState(() => isNonMovingClicked = !isNonMovingClicked)),
    //     SizedBox(
    //       width: mq.width * .01,
    //     ),
    //     _toggleButton(
    //         'Non Stockable',
    //         isNonStockableClicked,
    //         () =>
    //             setState(() => isNonStockableClicked = !isNonStockableClicked)),
    //     SizedBox(
    //       width: mq.width * .01,
    //     ),
    //     _toggleButton('Moving', isMovingClicked,
    //         () => setState(() => isMovingClicked = !isMovingClicked)),
    //   ],
    // );
  }

  // /// Helper function to create toggle buttons
  // Widget _toggleButton(String text, bool isActive, VoidCallback onToggle) {
  //   return Expanded(
  //     child: ToggleOutlineButton(
  //         text: text, isActive: isActive, onToggle: onToggle),
  //   );
  // }

  /// Builds dropdowns for Order Type and Logistics
  Widget _buildDropdowns() {
    // print("==${_partRequestController.clusterData.keys}");
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: mq.width * .3,
          child: _dropdown(
              dropdownOptions1,
              'Order for',
              (val) => setState(
                  () => _partRequestController.selectedValue1.value = val),
              _partRequestController.selectedValue1.value),
        ),
        SizedBox(
          width: mq.width * .04,
        ),

        // _dropdown(
        //     dropdownOptions2,
        //     'Select an item',
        //     (val) => setState(
        //         () => _partRequestController.selectedValue2.value = val),
        //     _partRequestController.selectedValue2.value),
        Expanded(
            child: Obx(
          () => _dropdown(
              _partRequestController.clusterData.keys
                  .map((item) => item)
                  .toList(),
              'Select Cluster',
              (val) => setState(() => _selectedValue3 = val),
              _selectedValue3),
        )),
      ],
    );
  }

  /// Helper function to create a dropdown
  Widget _dropdown(
      List<String> options, String hintText, Function(String?) onChanged,
      [String? selectedValue]) {
    return SizedBox(
      child: CustomDropdown(
        hintText: hintText,
        options: options,
        selectedValue: selectedValue,
        onChanged: onChanged,
      ),
    );
  }

  /// Builds part number input field and add button
  Widget _buildPartNumberInput() {
    return Row(
      children: [
        Expanded(
          child: Form(
            key: _formKey,
            child: CustomTextFormField(
              controller: _partSearchController.partNumberController,
              text: 'Part Number',
              validator: (val) => val == null || val.isEmpty
                  ? 'Please enter Part Number'
                  : null,
              onChanged: (val) {
                if (val.isEmpty) {
                  _partSearchController.partSuggestions.clear();
                }
                // use for convert value to uppercase
                _partSearchController.partNumberController.value =
                    _partSearchController.partNumberController.value.copyWith(
                  text: val.toUpperCase(), // Convert to uppercase
                );
                // Allow only a-z, A-Z, 0-9, '/', and '-'
                String filteredValue =
                    val.replaceAll(RegExp(r'[^a-zA-Z0-9/-]'), '');

                if (val != filteredValue) {
                  _partSearchController.partNumberController.text =
                      filteredValue;
                  return;
                }
                _partRequestController.errorMsg.value = null;
                String brandID =
                    _locationController.locationList[0]['BrandID'].toString();

                if (val.length > 4) {
                  _partSearchController.onPartNumberChanged(val, brandID);
                }
              },
            ),
          ),
        ),
        SizedBox(width: mq.width * .02),
        SizedBox(
            width: mq.width * .2,
            child:
                CustomElevatedButton(icon: Icons.add, onTap: _addPartNumber)),
      ],
    );
  }

  Widget _buildPartSuggestion() {
    return Obx(() {
      // if (_partSearchController.isLoading.value) {
      //   return Container(
      //       color: Colors.white,
      //       height: 160,
      //       child: const Center(child: CircularProgressIndicator()));
      // }
      return
          // _partSearchController.partSuggestions.isNotEmpty
          // ? Container(
          //     constraints: BoxConstraints(
          //       minHeight: 30, // Minimum height
          //       maxHeight: 160, // Maximum height
          //     ),
          //     decoration: BoxDecoration(
          //       color: Colors.white,
          //       border: Border.all(color: Colors.grey),
          //       borderRadius: const BorderRadius.all(Radius.circular(8)),
          //     ),
          //     child: ListView.builder(
          //       shrinkWrap: true,
          //       padding: EdgeInsets.zero,
          //       itemCount: _partSearchController.partSuggestions.length,
          //       itemBuilder: (context, index) {
          //         final suggestion =
          //             _partSearchController.partSuggestions[index];
          //         return InkWell(
          //           child: Padding(
          //             padding: const EdgeInsets.all(8.0),
          //             child: Text(suggestion),
          //           ),
          //           onTap: () {
          //             _partSearchController.selectPartNumber(suggestion);
          //             _partSearchController.partSuggestions.clear();
          //           },
          //         );
          //       },
          //     ),
          //   )
          // ?
          SuggestionList(
        isLoading: _partSearchController.isLoading.value,
        suggestions: _partSearchController.partSuggestions.toList(),
        onTap: (selected) => _partSearchController.selectPartNumber(selected),
      );
      // : const SizedBox.shrink();
    });
  }

  /// Builds the data table for added parts
  Widget _buildTable() {
    if (_partRequestController.tableData.isEmpty) {
      return const SizedBox.shrink();
    }
    return SizedBox(
        width: mq.width * .95,
        // decoration: BoxDecoration(
        // color: AppColor.primary,
        // borderRadius: const BorderRadius.vertical(top: Radius.circular(12))
        // ),
        child: Obx(
          () => DataTable(
            dataRowMinHeight: 40,
            dataRowMaxHeight: 70,
            headingRowColor: WidgetStateProperty.all(AppColor.primary),
            headingTextStyle: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
            dataRowColor: WidgetStateProperty.all(AppColor.primaryShade),
            // columnSpacing: 25,
            // columns: const [
            //   DataColumn(label: Text('Part No.')),
            //   DataColumn(label: Text('Part Desc.')),
            //   DataColumn(label: Text('Unit MRP ₹'))
            // ],

            columnSpacing: 25,
            columns: [
              tableColumn("Part No."),
              tableColumn("Part Desc."),
              tableColumn("Unit MRP ₹"),
              // DataColumn(label: Expanded(child: SingleChildScrollView(scrollDirection: Axis.horizontal,child: Text('Part No.')))),
              // DataColumn(label: Expanded(child: SingleChildScrollView(scrollDirection: Axis.horizontal,child: Text('Part Desc.')))),
              // DataColumn(label: Expanded(child: SingleChildScrollView(scrollDirection: Axis.horizontal,child: Text('Unit MRP ₹')))),
              // DataColumn(label: Text('Part Desc.')),
              // DataColumn(label: Text('Unit MRP ₹'))
            ],
            rows: _partRequestController.tableData
                .asMap()
                .entries
                .map((entry) => _buildTableRow(entry.key, entry.value))
                .toList(),
          ),
        ));
  }

  DataColumn tableColumn(String label) => DataColumn(
      label: Expanded(
          child: SingleChildScrollView(
              scrollDirection: Axis.horizontal, child: Text(label))));

  /// Builds a row in the data table
  DataRow _buildTableRow(int index, Map<String, String> row) {
    return DataRow(cells: [
      DataCell(SizedBox(
        width: mq.width * .22,
        child: SingleChildScrollView(
            scrollDirection:
                Axis.vertical, // set vertical instead of horizontal
            child: Text(row["Part No."] ?? "")),
      )),
      // DataCell(SizedBox(
      //   width: mq.width * .22,
      //   child: Text(row["Part No."] ?? ""),
      // )),
      DataCell(SizedBox(
        width: mq.width * .29,
        child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Text(row["Part Desc."] ?? "")),
      )),
      DataCell(Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(row["MRP ₹"] ?? ""),
          IconButton(
              icon: Icon(Icons.close, color: AppColor.primary),
              // onPressed: () => _removePart(index)
              onPressed: () => _partRequestController.removeEntry(index))
        ],
      )),
    ]);
  }

  /// Removes a row from the table
  // void _removePart(int index) =>
  //     setState(() => _partRequestController.tableData.removeAt(index));

  /// Builds the Show Availability button
  Widget _buildShowAvailabilityButton() {
    return CustomElevatedButton(
        text: 'Show Availability', onTap: () => _showAvailabilityBtn());
    // return Obx((){
    //   if(_partRequestController.isLoading.value){
    //     return Center(child: CircularProgressIndicator());
    //   }
    //   return CustomElevatedButton(
    //       text: 'Show Availability', onTap: () => _showAvailabilityBtn());
    // });
  }

  _showAvailabilityBtn() async {
    _partRequestController.errorMsg.value = null;
    _partSearchController.partSuggestions.clear();
    FocusScope.of(context).unfocus(); // Hide keyboard
    String brandID = _locationController.locationList[0]['BrandID'].toString();
    String dealerID =
        _locationController.locationList[0]['DealerID'].toString();
    // String? locationID = selectedLocationId;
    String? locationID = await getStringData("selectedLocationID");
    String? orderFor = _partRequestController.selectedValue1.value ?? '';
    // String? lspCode = _partRequestController
    //         .companyName[_partRequestController.selectedValue2.value] ??
    //     '';
    String lspCode = '1';
    // String? tat = _partRequestController.tatController.text.trim().toString();
    String tat = '';
    // String? clusterCode =selectedValue3 != null?_partRequestController.clustersName[selectedValue3].toString():'';
    String clusterCode = _selectedValue3 != null
        ? _partRequestController.clusterData[_selectedValue3].toString()
        : '';
    // List<String> partNumber = tablePartNum;
    List<String> partNumber = _partRequestController.tableData
        .map((item) => item['Part No.'] as String)
        .toList();
    List<String> stockCategory = [
      if (isSelected[0]) 'N',
      if (isSelected[1]) 'S',
      if (isSelected[2]) 'M',
    ];
    String withinGroup = isMyGroup ? '' : '';
    if (orderFor.isEmpty) {
      CustomBottomSheet.showSnackBar(context, 'Please select order for');
      return;
    }
    if (partNumber.isNotEmpty) {
      bool checkInt = await checkInternet();
      if (checkInt) {
        bool response = await _partRequestController.showAvailability(
            brandID,
            dealerID,
            locationID!,
            orderFor,
            lspCode,
            tat,
            clusterCode,
            partNumber.join(','),
            stockCategory.join(','),
            withinGroup);
        if (response) {
          Get.to(() => const ShowAvailabilityScreen());
        }
      } else {
        Get.to(() => NoInternetScreen());
      }
    } else {
      _partRequestController.errorMsg.value =
          'Please add some part in the table';
    }
  }

  /// Fetches LSP options from the API
  // Future<void> _fetchLspOptions() async {
  //   // selectedLocationName = _locationController.selectedLocation.value;
  //   // selectedLocationId =
  //   //     _locationController.locationIdMap[selectedLocationName].toString();
  //   if (selectedLocationName != null) {
  //     _partRequestController.isLoading.value = true;
  //     final response = await getLSP(selectedLocationId);
  //     if (response['success']) {
  //       final data = response['data'];
  //
  //       List<String> parts = data.split('@@'); // Split API response
  //       var companyData = jsonDecode(parts[0]);
  //       //company data store as key value pair CompanyName:CompanyCode
  //       _partRequestController.companyName.value = {
  //         for (var item in companyData)
  //           item['CompanyName'].toString(): item['CompanyCode'].toString(),
  //       };
  //       _partRequestController.selectedValue1.value = dropdownOptions1[0];
  //       setState(() {});
  //       _partRequestController.isLoading.value = false;
  //     }
  //   }
  // }

  /// Fetches LSP options from the API
  Future<void> _fetchClusterOption() async {
    if (selectedLocationId.isNotEmpty) {
      _partRequestController.isLoading.value = true;
      final response = await ApiService().getCluster(selectedLocationId);
      if (response['success']) {
        final data = response['data'];
        var clusterData = jsonDecode(data);
        //company data store as key value pair ClusterName:ClusterCode
        _partRequestController.clusterData.value = {
          for (var item in clusterData)
            "${item['ClusterType']}-${item['Cluster']}":
                item['ClusterCode'].toString(),
        };
        _partRequestController.isLoading.value = false;
      }
    }
  }

  /// Adds a new row to the table
  void _addPartNumber() async {
    if (_formKey.currentState!.validate()) {
      String partNumber =
          _partSearchController.partNumberController.text.trim();
      // final response = await getPartDetails("9", partNumber);
      // print("responseedbsdvcghs: $response");
      _partRequestController.errorMsg.value = null;
      String brandID =
          _locationController.locationList[0]['BrandID'].toString();
      // for (var part in tablePartNum) {
      for (var part in _partRequestController.tableData) {
        if (part['Part No.'] == partNumber) {
          _partRequestController.errorMsg.value =
              'This part already added in the table';
          return null;
        }
      }

      _partSearchController.partSuggestions.clear();
      _partRequestController.isLoading.value = true;
      bool checkInt = await checkInternet();
      if (checkInt) {
        final response = await ApiService().getPartDetails(brandID, partNumber);
        _partRequestController.isLoading.value = false;

        if (response['success']) {
          List<dynamic> jsonList = jsonDecode(response['data']);

          // use of model data
          List<PartDetails> parts =
              jsonList.map((json) => PartDetails.fromJson(json)).toList();
          partDetails = parts;
          //add data in table
          setState(() {
            _partRequestController.addEntry({
              "Part No.": partDetails[0].partNo.toString(),
              "Part Desc.": partDetails[0].partdesc.toString(),
              "MRP ₹": partDetails[0].mrp!.toInt().toString(),
            });

            tablePartNum.add(partDetails[0].partNo.toString());
          });
          _partSearchController.partNumberController.clear();
          FocusScope.of(context).unfocus();
        } else {
          _partRequestController.errorMsg.value = response['message'];
        }
      } else {
        Get.to(() => NoInternetScreen());
      }
    }
  }
}
