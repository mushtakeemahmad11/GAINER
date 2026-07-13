import 'package:flutter/material.dart';
import 'package:gainer/dealer_monitoring/widgets/workshop_advisor_body.dart';
import 'package:gainer/gainer_app/core/Services/auth_service.dart';

import '../../../gainer_app/modules/login/model/user_model.dart';
import '../../widgets/dealer_app_loader.dart';

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
    // dealerID = await getStringData("dealerID");
    dealerID = await AuthService.getDealerId();
    UserModel? user = await AuthService.getUser();
    if (user != null) {
      String firstName = user.firstName;
      String lastName = user.lastName;
      advisorName = user.firstName + user.lastName;
      if (dealerID?.isNotEmpty == true &&
          firstName.isNotEmpty &&
          lastName.isNotEmpty) {
        setState(() => allValueGet = true);
      }
    }
    // String firstName = await getStringData('firstName');
    // String lastName = await getStringData('lastName');
    // advisorName = firstName + lastName;

    // if (dealerID?.isNotEmpty == true &&
    //     firstName.isNotEmpty &&
    //     lastName.isNotEmpty) {
    //   setState(() => allValueGet = true);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: allValueGet
          ? WorkshopAdvisorBody(
              dealerID: dealerID ?? "",
              advisor: advisorName ?? "",
            )
          : Center(child: DealerAppLoader()),
      // : Center(child: Text("There is some problem try after some time")),
    );
  }
}
