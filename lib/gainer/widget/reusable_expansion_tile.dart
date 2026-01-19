// import 'package:flutter/material.dart';
//
// import '../colors.dart';
//
// class CustomExpansionTile extends StatelessWidget {
//   const CustomExpansionTile({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return  ExpansionTile(
//       title: _buildTitle(item),
//       backgroundColor: AppColor.primaryShade,
//       collapsedBackgroundColor: AppColor.primaryShade,
//       collapsedShape:
//       RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//       childrenPadding: const EdgeInsets.symmetric(horizontal: 5.0),
//       // children: orders.map((order) => _buildOrderDetails(order)).toList(),
//     );
//   }
//
//   Widget _buildTitle(DispatchDetailsModel item){
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         _buildExpansionTitle(item.lrDate),
//
//         SizedBox(
//           width: mq.width * .3,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               _buildExpansionTitle(item.buyerLocation),
//             ],
//           ),
//         ),
//         _buildExpansionTitle(item.val.toInt().toString()),
//       ],
//     );
//   }
//
// }
