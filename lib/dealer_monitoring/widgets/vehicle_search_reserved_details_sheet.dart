import 'package:flutter/material.dart';
import '../../gainer_app/core/widgets/scrollable_text_widget.dart';
import '../core/theme/app_colors.dart';
import '../core/utils/transform_value_ind.dart';
import 'package:gainer/gainer_app/core/widgets/error_text.dart';
import 'package:get/get.dart';
import '../controllers/vehicle_search_controller.dart';

class VehicleSearchReservedDetailsSheet extends StatelessWidget {
  const VehicleSearchReservedDetailsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<VehicleSearchController>();
    return SafeArea(
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.28,
        minChildSize: 0.2,
        maxChildSize: 0.7,
        snap: true,
        builder: (context, scrollController) {
          return Column(
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
                    'Reserved Stock Details',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Text(controller.lastReservedPart.value??''),
              // LegendBar(),
              const SizedBox(height: 10),
              Obx(() {
                if (controller.isLoadingReservedDetails.value) {
                  return CircularProgressIndicator();
                }
                final err = controller.reservedDetailsError;
                if (err.value != null && err.value!.isNotEmpty) {
                  AppErrorText(error: controller.reservedDetailsError);
                }
                final dataList = controller.reservedDetailsList;
                if (dataList.isEmpty) {
                  return Text('Details not available');
                }
                return Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: dataList.length,
                    itemBuilder: (context, index) {
                      return ReservedDetailCard(item: dataList[index]);
                    },
                  ),
                );
              }),
            ],
          );
        },
      ),
    );
  }
}

class ReservedDetailCard extends StatelessWidget {
  final Map<String, dynamic> item;

  const ReservedDetailCard({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final bool jobCardStatus = item['final_close'] == 'N';
    return Container(
      margin: const EdgeInsets.all(6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: DMAppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.directions_car, color: DMAppColors.secondary),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                ScrollableTextWidget(
                  textWidget: Row(
                    children: [
                      Text('Vehicle Num  :  '),
                      Text(
                        item["Vehiclenumber"],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                ScrollableTextWidget(
                  textWidget: Row(
                    children: [
                      Text('Advisor Name:  '),
                      Text(
                        item["Advisor"],
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                ScrollableTextWidget(
                  textWidget: Row(
                    children: [
                      Text('Location:  '),
                      Text(
                        item["Location"],
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                ScrollableTextWidget(
                  textWidget: Row(
                    children: [
                      Text('Approval Date:  '),
                      Text(
                        TransformValue().formatDateToIndianDate(
                            item["SCS_Submit_Date"],
                            day: true),
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                Text(
                  jobCardStatus ? "Job Card Open" : "Job Card Closed",
                  style: TextStyle(
                      color: jobCardStatus ? Colors.green : Colors.red),
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: DMAppColors.secondary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              "${item["ReservedforVehicle"]}",
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}

class VehicleSearchReservedDetailsSheetTest extends StatelessWidget {
  const VehicleSearchReservedDetailsSheetTest({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<VehicleSearchController>();

    return SafeArea(
      child: Column(
        children: [
          const SizedBox(height: 10),
          Container(
            height: 4,
            width: 100,
            decoration: BoxDecoration(
              color: Colors.black38,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Reserved Stock Details',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Obx(() {
            if (controller.isLoadingReservedDetails.value) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (controller.reservedDetailsList.isEmpty) {
              return const Center(
                child: Text('Details not available'),
              );
            }

            return ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: controller.reservedDetailsList.length,
              itemBuilder: (context, index) {
                return ReservedDetailCard(
                  item: controller.reservedDetailsList[index],
                );
              },
            );
          }),
        ],
      ),
    );
  }
}
