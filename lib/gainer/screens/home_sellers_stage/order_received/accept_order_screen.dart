import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../main.dart';
import '../../../controllers/seller_controller/order_received_controller.dart';
import '../../../widget/circular_progress_indicator.dart';
class AcceptOrderScreen extends StatefulWidget {
  final int bigId;
  final String remarks;
  final int confirmQty;
  final int freeStock;
  final String transactionType;
  final int loginUserID;

  const AcceptOrderScreen(
      {super.key,
      required this.bigId,
      required this.remarks,
      required this.confirmQty,
      required this.freeStock,
      required this.transactionType,
      required this.loginUserID});

  @override
  State<AcceptOrderScreen> createState() => _AcceptOrderScreenState();
}

class _AcceptOrderScreenState extends State<AcceptOrderScreen> {
  final AcceptOrderController _controller = Get.put(AcceptOrderController());

  // void toggleSelection(String selectedState) {
  //   _controller.updateSelection(selectedState);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Accept order ')),
      body: Stack(
        children: [
          _controller.isLoading.value!=true?
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: mq.width * 0.02, vertical: mq.height * 0.02),
            child: SingleChildScrollView(

              child: Column(
                children: [
                  Text(widget.bigId.toString()),
                  Text(widget.remarks),
                  Text(widget.confirmQty.toString()),
                  Text(widget.freeStock.toString()),
                  Text(widget.transactionType.toString()),
                  Text(widget.loginUserID.toString()),
                ],
              ),
              // child: Column(
              //   children: [
              //     // Generate Toggle Buttons dynamically
              //     ..._controller.toggleButtons.map((button) => Padding(
              //           padding: EdgeInsets.only(bottom: mq.height * 0.01),
              //           child: Obx(() => Row(
              //                 children: [
              //                   Expanded(
              //                     child: ToggleOutlineButton(
              //                       text: button['text'],
              //                       isActive: _controller.getState(button['state']),
              //                       onToggle: () =>
              //                           toggleSelection(button['state']),
              //                     ),
              //                   ),
              //                 ],
              //               )),
              //         )),
              //     SizedBox(height: mq.height * 0.02),
              //
              //     // Remarks TextField
              //     CustomTextFormField(
              //       controller: _remarksController,
              //       text: 'Enter Remarks',
              //       suffixIcon: Icon(Icons.edit, color: AppColor.primary),
              //     ),
              //     SizedBox(height: mq.height * 0.03),
              //
              //     // Submit Button
              //     CustomElevatedButton(
              //       onTap: () => _onSubmitBtn(),
              //       text: 'Submit',
              //     ),
              //   ],
              // ),
            ),
          ):
          customCircularProgressIndicator(),
        ],
      ),
    );
  }
}
