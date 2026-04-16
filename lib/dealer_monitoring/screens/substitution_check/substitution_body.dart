// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../../dealer_monitoring/widgets/reusable_gainer_stock.dart';
// import '../../../gainer/controllers/part_request_controller.dart';
// class SubstitutionBody extends StatelessWidget {
//   SubstitutionBody({super.key});
//   final PartRequestControllerOld _partRequestController =
//       Get.put(PartRequestControllerOld());
//
//   @override
//   Widget build(BuildContext context) {
//     final args = Get.arguments as Map<String, dynamic>? ?? {};
//     final String? partNumber = args['partNumber'];
//     return Scaffold(
//       body: Stack(
//         children: [
//           SingleChildScrollView(
//             child: PartRequestBody(
//               partNumber: partNumber,
//             ),
//           ),
//           Obx(() => _partRequestController.isLoading.value
//               ? Container(
//                   color: Colors.black26,
//                   child: const Center(
//                     child: CircularProgressIndicator(),
//                   ),
//                 )
//               : const SizedBox.shrink()),
//         ],
//       ),
//     );
//   }
// }
