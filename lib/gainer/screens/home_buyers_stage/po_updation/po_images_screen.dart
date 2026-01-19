import 'package:flutter/material.dart';
import '../../../../main.dart';
import '../../../utility/download_utils.dart';
import '../../../widget/bottomsheet_for_picture.dart';

class PoImagesScreen extends StatelessWidget {
  const PoImagesScreen({super.key, required this.partImages});
  final List<String> partImages;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PO Updation Images'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: mq.width * .02, vertical: mq.height * .02),
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

                  final imageUrl =
                      'https://scope.sparecare.in/UAP_SC/images/PartImage/$imgString';

                  return ListTile(
                      // title: SizedBox(
                      //   height: 300,
                      //   child: PhotoView(
                      //     imageProvider: NetworkImage(imageUrl),
                      //     minScale: PhotoViewComputedScale.contained,
                      //     maxScale: PhotoViewComputedScale.covered * 5,
                      //     backgroundDecoration: BoxDecoration(color: Colors.white10),
                      //     loadingBuilder: (context, progress) => Center(
                      //       child: CircularProgressIndicator(
                      //         value: progress == null
                      //             ? null
                      //             : (progress.cumulativeBytesLoaded /
                      //                 (progress.expectedTotalBytes ?? 1)),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      title: SizedBox(
                        height: mq.height * .5,
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
                        onPressed: () async {
                          String imgName =
                              imgString.replaceAll(".jpg", "replace");
                          final response = await DownloadUtils.downloadImage(
                            imageUrl,
                            "GainerApp",
                            imgName,
                          );
                          if (response['success']) {
                            CustomBottomSheet.showSnackBar(
                                context, response['path']);
                          } else {
                            CustomBottomSheet.showSnackBar(
                                context, response['error']);
                          }
                        },
                        // onPressed: () async {
                        //   final response = await DownloadUtils.downloadImage(
                        //       imageUrl, imgString, context);
                        //   if (response['success']) {
                        //     // CustomBottomSheet.showSnackBar(context, response['filePath']);
                        //     CustomBottomSheet.showSnackBar(context,
                        //         'Storage/Pictures/GainerApp/$imgString');
                        //   } else {
                        //     CustomBottomSheet.showSnackBar(
                        //         context, response['error']);
                        //   }
                        // },
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
