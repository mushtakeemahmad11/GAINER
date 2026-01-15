import 'package:flutter/material.dart';
import 'package:gainer/dealer_monitoring/core/theme/app_colors.dart';
import 'package:get/get.dart';
import '../../controllers/workshop_manager_controller.dart';
import '../../widgets/workshop_advisor_body.dart';

class WorkshopManagerScreen extends StatefulWidget {
  const WorkshopManagerScreen({super.key});

  @override
  State<WorkshopManagerScreen> createState() => _WorkshopManagerScreenState();
}

class _WorkshopManagerScreenState extends State<WorkshopManagerScreen> {
  final WorkShopManagerController _workShopManagerController =
      Get.put(WorkShopManagerController());

  String? dealerID;
  String? locationID;
  String? advisor;

  @override
  void initState() {
    super.initState();
    _initWork();
  }

  _initWork() async {
    // // Fetch arguments
    // final Map<String, dynamic> args = Get.arguments;
    //
    // // Access individual values
    // dealerID = args["dealerID"];
    //
    // _workShopManagerController.isNonStockable.value = args["nonStockable"];
    // _workShopManagerController.isJobCard.value = args["jobCardStatus"];
    //
    // print("jobCardStatus: ${_workShopManagerController.isJobCard.value}");
    // locationID = args["locationID"];
    // advisor = args["advisor"];

    // Safe cast with null check
    final args = Get.arguments;
    if (args is! Map<String, dynamic>) {
      return;
    }

    // Now it's safe to use args
    dealerID = args["dealerID"];
    locationID = args["locationID"];
    advisor = args["advisor"];

    // _workShopManagerController.selectedPartNature.value =
    //     args["nonStockable"];
    // _workShopManagerController.selectedStatus.value =
    //     args["jobCardStatus"];
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Workshop Manager",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: DMAppColors.primaryShade,
        iconTheme: const IconThemeData(color: Colors.black),
      ),

      body: WorkshopAdvisorBody(
        dealerID: dealerID.toString(),
        locationID: locationID.toString(),
        advisor: advisor.toString(),
        // nonStockable: _workShopManagerController.isNonStockable.value,
        nonStockable: _workShopManagerController.selectedPartNature.value,
        jobCardStatus: _workShopManagerController.selectedStatus.value,
        advisorList: _workShopManagerController.advisorPPNIList,
      ),
    );
  }

  // Widget _buildCardStatus() {
  //   return Row(
  //     children: [
  //       _buildListTile('Job Card Open', true),
  //       _buildListTile('Job Card Close', false),
  //     ],
  //   );
  // }
  //
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
  //
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
