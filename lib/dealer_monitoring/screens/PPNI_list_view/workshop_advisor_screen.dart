import 'package:flutter/material.dart';
import 'package:gainer/dealer_monitoring/widgets/workshop_advisor_body.dart';
import '../../../gainer/shared_preferences/shared_preferences_get_data.dart';

class WorkshopAdvisorScreen extends StatefulWidget {
  const WorkshopAdvisorScreen({super.key});

  @override
  State<WorkshopAdvisorScreen> createState() => _WorkshopAdvisorScreenState();
}

class _WorkshopAdvisorScreenState extends State<WorkshopAdvisorScreen> {
  // String? locationID;
  String? dealerID;
  String? advisorName;
  bool allValueGet = false;

  @override
  void initState() {
    super.initState();
    _initWork();
  }

  Future<void> _initWork() async {
    dealerID = await getStringData("dealerID");
    String firstName = await getStringData('firstName');
    String lastName = await getStringData('lastName');
    advisorName = firstName + lastName;

    if (dealerID?.isNotEmpty == true &&
        firstName.isNotEmpty &&
        lastName.isNotEmpty) {
      setState(() => allValueGet = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: allValueGet
          ? WorkshopAdvisorBody(
              dealerID: dealerID ?? "",
              advisor: advisorName ?? "",
            )
          : Center(child: CircularProgressIndicator()),
      // : Center(child: Text("There is some problem try after some time")),
    );
  }
}
