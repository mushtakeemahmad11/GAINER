import 'package:flutter/material.dart';
import 'package:gainer/dealer_monitoring/widgets/reusable_table.dart';
import 'package:gainer/gainer_app/core/widgets/error_text.dart';
import 'package:get/get.dart';

import '../controllers/vehicle_search_controller.dart';
import '../core/theme/app_colors.dart';
import '../core/utils/transform_value_ind.dart';

class VehicleSearchStockDetailsSheet extends StatelessWidget {

  const VehicleSearchStockDetailsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<VehicleSearchController>();
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),
          Container(
            padding: EdgeInsets.symmetric(vertical: 5),
            height: 4,
            width: 100,
            decoration: BoxDecoration(
              color: Colors.black38,
              borderRadius: BorderRadius.circular(12),
            ),
            // child: Text('Group Stock Details'),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Group Stock Details',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Obx(() {
            if (controller.isLoadingGrpStock.value) {
              return CircularProgressIndicator();
            }
            final err = controller.grpStockError;
            if(err.value!=null && err.value!.isNotEmpty){
              AppErrorText(error: controller.grpStockError);
            }

            final dataList = controller.grpStockList;
            if(dataList.isEmpty){
              return Text('Details not available');
            }
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ReusableTable(
                  headers: ['Location', 'Qty', 'Stock Date'],
                  rows: dataList.map((d) {
                    final stkDate = TransformValue().formatDateToIndianDate(
                        d['Stockdate'].toString(),
                        day: true);

                    return [d['location'], d['GroupStock'], stkDate];
                  }).toList(),
                  rowColorsList: dataList.map((item) {
                    // switch (item['PartStatus']) {
                    switch (item['Partstatus']) {
                      case "Non-Stockable":
                        return DMAppColors.nonStockable;
                      case "Non-Moving":
                        return DMAppColors.nonMoving;
                      case "Stockable":
                        return DMAppColors.stockable;
                      default:
                        return DMAppColors.primary;
                    }
                  }).toList(),
                  columnWidths: const [
                    FixedColumnWidth(200),
                    FixedColumnWidth(70),
                    // FixedColumnWidth(100),
                    // FlexColumnWidth(),
                    IntrinsicColumnWidth(),
                    // IntrinsicColumnWidth(),
                  ],
                )
              ],
            );
          }),
        ],
      ),
    );
  }
}
