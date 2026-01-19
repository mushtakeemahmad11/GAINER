import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../dealer_monitoring/widgets/reusable_gainer_stock.dart';
import '../../../gainer/controllers/part_request_controller.dart';
import '../../../gainer/widget/circular_progress_indicator.dart';

class SubstitutionBody extends StatelessWidget {
  SubstitutionBody({super.key});
  final PartRequestController _partRequestController =
      Get.put(PartRequestController());

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    final String? partNumber = args['partNumber'];
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: PartRequestBody(
              partNumber: partNumber,
            ),
          ),
          Obx(() => _partRequestController.isLoading.value
              ? customCircularProgressIndicator()
              : const SizedBox.shrink()),
        ],
      ),
    );
  }
}
