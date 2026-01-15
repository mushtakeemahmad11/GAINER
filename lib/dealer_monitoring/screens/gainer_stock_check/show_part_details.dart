import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../gainer/controllers/home_screen_controller.dart';
import '../../../gainer/controllers/part_request_controller.dart';
import '../../../gainer/widget/circular_progress_indicator.dart';
import '../../../gainer/widget/error_msg.dart';
import '../../core/utils/dm_images.dart';
import '../../widgets/head_bar.dart';
import '../../widgets/reusable_gainer_stock.dart';

class GainerStockCheck extends StatelessWidget {
  GainerStockCheck({super.key});
  final PartRequestController _partRequestController =
      Get.put(PartRequestController());
  final LocationController _locationController = Get.put(LocationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text("Gainer Stock Check")),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                HeadBar(
                  text: "Gainer Stock Check",
                  imgSting: DMImages.gLogoW,
                ),
                // Center(
                //   child: Obx((){
                //     if(_partRequestController.isLoading.value){
                //       return customCircularProgressIndicator();
                //     }
                //     if(_locationController.errorMsg.value != null){
                //       return CustomErrorMsg(
                //         text: _locationController.errorMsg.value ?? '',
                //       );
                //     }
                //     return const PartRequestBody();
                //   }),
                // ),
                if (_locationController.errorMsg.value != null)
                  Obx(
                    () => Center(
                      child: CustomErrorMsg(
                        text: _locationController.errorMsg.value ?? '',
                      ),
                    ),
                  ),
                const PartRequestBody(),
              ],
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
