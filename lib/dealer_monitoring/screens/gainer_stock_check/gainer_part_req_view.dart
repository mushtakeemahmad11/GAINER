import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import '../../../gainer_app/modules/part_request_view/part_request_controller.dart';
import '../../../gainer_app/modules/part_request_view/part_request_view.dart';

class GainerPartReqView extends StatefulWidget {
  const GainerPartReqView({super.key});

  @override
  State<GainerPartReqView> createState() => _GainerPartReqViewState();
}

class _GainerPartReqViewState extends State<GainerPartReqView> {
  final c = Get.put(PartRequestController());
  @override
  Widget build(BuildContext context) {
    c.isFromDealer.value = true;
    c.isFromDealerDirect.value = true;
    return const PartRequestView();
  }

  @override
  void dispose() {
    if (Get.isRegistered<PartRequestController>()) {
      Get.delete<PartRequestController>(); // destroy old
    }
    super.dispose();
  }
}
