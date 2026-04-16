import 'package:flutter/material.dart';
import 'package:gainer/gainer_app/core/constants/gainer_color.dart';
import 'package:gainer/gainer_app/modules/action_as_buyer/update_po_view/update_po_controller.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

class UpdatePoImageView extends GetView<UpdatePoController> {
  const UpdatePoImageView({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments;

    final List<String> partImages = (args != null && args["images"] != null)
        ? List<String>.from(args["images"])
        : [];
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: GainerColors.background,
      appBar: AppBar(
        backgroundColor: GainerColors.primary,
        title: const Text('PO Updation Images'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: size.width * .02, vertical: size.height * .02),
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                itemCount: partImages.length,
                itemBuilder: (BuildContext context, int index) {
                  String? imgString = partImages[index];
                  if (imgString.isEmpty) {
                    return ListTile(
                      title: Center(child: Text("No Image Available")),
                    );
                  }
                  return ListTile(
                      title: SizedBox(
                        height: size.height * .5,
                        child: InteractiveViewer(
                          panEnabled: true, // Allow panning
                          // boundaryMargin: EdgeInsets.all(20),
                          // clipBehavior: Clip.none,
                          minScale: 1.0,
                          maxScale: 5.0, // Max zoom level
                          // child: Image.network('https://scope.sparecare.in/UAP_SC/images/PartImage/$imgString',fit: BoxFit.contain,
                          child: Image.network(
                            'https://scope.sparecare.in/UAP_SC/images/PartImage/$imgString',
                            fit: BoxFit.contain,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) {
                                return child; // Display the image once loaded
                              }
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          (loadingProgress.expectedTotalBytes ??
                                              1)
                                      : null, // Show indeterminate if null
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) =>
                                Center(
                                    child: const Text('Failed to load image')),
                          ),
                        ),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.download),
                        onPressed: () =>
                            controller.downloadImage(imgString, context),
                      ));
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
