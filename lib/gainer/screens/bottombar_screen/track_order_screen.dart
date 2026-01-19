import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../main.dart';
import '../../apis_functionality/api_service.dart';
import '../../controllers/track_order_controller.dart';
import '../../url_launch/url_launch.dart';
import '../../utility/controller_utils.dart';
import '../../widget/circular_progress_indicator.dart';
import '../../widget/error_msg.dart';
import '../../widget/reusable_elevated_button.dart';
import '../../widget/reusable_widget.dart';
import '../colors.dart';

class TrackOrderScreen extends StatefulWidget {
  const TrackOrderScreen({super.key});

  @override
  State<TrackOrderScreen> createState() => _TrackOrderScreenState();
}

class _TrackOrderScreenState extends State<TrackOrderScreen> {
  // Controller for text input
  final TextEditingController orderNumber = TextEditingController();

  // GetX Controller for handling API calls and state management
  final TrackOrderController trackOrderController =
      Get.put(TrackOrderController());

  @override
  void dispose() {
    // _cameraController.dispose();
    // arCoreController.dispose();
    orderNumber.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: mq.width * .02,
              vertical: mq.height * .02,
            ),
            child: Column(
              children: [
                // Instruction text
                const Text(
                  'You can track your order by using dispatch order number',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: mq.height * .02),

                // Display error message (if any)
                Obx(() => trackOrderController.errorMsg.value != null
                    ? CustomErrorMsg(text: trackOrderController.errorMsg.value ?? '')
                    : const SizedBox.shrink()),

                // Order number input field
                Center(
                  child: SizedBox(
                    width: mq.width * .92,
                    child: CustomTextFormField(
                      controller: orderNumber,
                      text: 'Enter Dispatch Order Number',
                      textInputType: TextInputType.number,
                      length: 10,
                      suffixIcon: IconButton(
                        onPressed: () {
                          // Get.offAll(() => IntroScreen());
                          orderNumber.clear();
                          trackOrderController.clearError();
                        },
                        icon: Icon(Icons.clear, color: AppColor.primary),
                      ),
                      onChanged: (val) async {
                        String filteredValue =
                            await ControllerUtils.numericOnly(val, 10);
                        if (filteredValue != val) {
                          orderNumber.text = filteredValue;
                        }
                      },
                    ),
                  ),
                ),
                SizedBox(height: mq.height * .02),

                // "Check" button
                SizedBox(
                  width: mq.width * .4,
                  child: CustomElevatedButton(
                    text: 'Check',
                    onTap: () => _handleTrackOrder(),
                  ),
                ),

                /// for testing purpose
                // SizedBox(
                //   height: mq.height*.4,
                //   width: mq.width*.9,
                //   child: ArCoreView(
                //     onArCoreViewCreated: _onArCoreViewCreated,
                //   ),
                // )
                // TextButton(
                //     onPressed: () {
                //       // trackOrderController.isInitialized.value = !trackOrderController.isInitialized.value;
                //       initCamera();
                //       setState(() => isMeasureSize = !isMeasureSize);
                //     },
                //     child: Text('Camera')),
                // if (isMeasureSize)
                //   SizedBox(
                //     height: mq.width * .9,
                //     width: mq.width * .9,
                //     child: Obx(
                //       () => trackOrderController.isInitialized.value
                //           ? _cameraController.value.isInitialized
                //               ? CameraPreview(_cameraController)
                //               : Center(child: CircularProgressIndicator())
                //           : Center(child: CircularProgressIndicator()),
                //     ),
                //   )

                // SizedBox(
                //   height: mq.width * .9,
                //   width: mq.width * .9,
                //   child: ArCoreView(
                //     onArCoreViewCreated: _onArCoreViewCreated,
                //     enableTapRecognizer: true,
                //   ),
                // )
                /// ----------
              ],
            ),
          ),

          // Show loading indicator when API is being called
          Obx(() => trackOrderController.isLoading.value
              ? customCircularProgressIndicator()
              : const SizedBox.shrink()),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: captureAndDetect,
      //   child: Icon(Icons.camera),
      // ),
    );
  }

  /// Handles order tracking logic
  void _handleTrackOrder() {
    final String number = orderNumber.text.trim();

    number.isNotEmpty
        ? _trackOrder(number)
        : trackOrderController.setError('Enter order number');
  }

  /// Calls the Track Order API and processes the response
  Future<void> _trackOrder(String orderNumber) async {
    trackOrderController.isLoading.value = true;
    final response = await ApiService().trackOrder(orderNumber);
    trackOrderController.isLoading.value = false;

    if (response['success']) {
      final String data = response['data'];

      trackOrderController.clearError();
      bool isUrlOpened = await launchURL(data);

      if (isUrlOpened) {
      } else {
        trackOrderController.setError('Unable to Track');
      }
    } else {
      trackOrderController.setError(response['message']);
    }
  }
}
