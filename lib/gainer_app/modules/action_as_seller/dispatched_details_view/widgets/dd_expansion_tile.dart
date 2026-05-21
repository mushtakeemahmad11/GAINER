import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gainer/gainer_app/core/widgets/gainer_expansion_tile.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import '../../../../core/constants/gainer_color.dart';
import '../../../../core/utils/check_time.dart';
import '../../../../core/widgets/gainer_primary_button.dart';
import '../dispatched_details_controller.dart';
import '../models/dd_model.dart';
import 'dd_expansion_tile_header.dart';

class DDExpansionTile extends GetView<DDController> {
  final DDModel order;
  final int count;
  final int index;
  const DDExpansionTile({
    super.key,
    required this.order,
    required this.count,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // controller.initImages(order, count);
    final bl = order.buyerLocation.split('<br/>');
    final String brand = bl.elementAtOrNull(0)?.trim() ?? '';
    final String location = bl.elementAtOrNull(1)?.trim() ?? '';
    bool is48Complete = CheckTime.is48HoursCompleted(order.lrDate);
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: GainerColors.border),
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: GainerExpansionTile(
          titleWidget: DDExpansionTileHeader(
            title1: 'Pending Since',
            subTitle1: order.lrDate,
            title2: brand,
            subTitle2: location,
            title3: '₹ ${order.val.toInt()}',
          ),
          bodyChildren: [
            Container(
              decoration: GainerColors.gradientDecoration,
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _keyVal('LR No.: ', order.lrNumber),
                            _keyVal('LSP: ', order.lsp),
                            const SizedBox(height: 5),
                            ...List.generate(
                                count,
                                (index) => _generateBoxImgRow(
                                    order, index, context, size)),
                            Obx(() {
                              final hasBoxImages = !controller
                                  .isAnyNullInBox(order.dispatchOrderNo);
                              final hasPickupImages = !controller
                                  .isAnyNullInPickup(order.dispatchOrderNo);

                              return Column(
                                children: [
                                  if (hasBoxImages)
                                    _generatePickupImgRow(
                                        order, 0, context, size),
                                  const SizedBox(height: 5),
                                  if (hasPickupImages)
                                    GainerPrimaryButton(
                                      onPressed: () => controller.onSubmit(
                                        order.dispatchOrderNo,
                                        order.lrNumber,
                                      ),
                                      title: 'Submit',
                                      isLoading: controller
                                          .isSubmitting(order.dispatchOrderNo),
                                    ),
                                ],
                              );
                            })
                            // Obx(() {
                            //   if (!controller
                            //       .isAnyNullInBox(order.dispatchOrderNo)) {
                            //     return _generatePickupImgRow(
                            //         order, 0, context, size);
                            //   }
                            //   return const SizedBox.shrink();
                            // }),
                            // Obx(() {
                            //   if (!controller
                            //       .isAnyNullInPickup(order.dispatchOrderNo)) {
                            //     return GainerPrimaryButton(
                            //       onPressed: () {},
                            //       title: 'Submit',
                            //     );
                            //   }
                            //   return const SizedBox.shrink();
                            // }),
                            // if (!controller
                            //     .isAnyNullInPickup(order.dispatchOrderNo))
                            //   GainerPrimaryButton(
                            //     onPressed: () {},
                            //     title: 'Submit',
                            //   ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
          is48Complete: is48Complete,
        ),
        // child: ExpansionTile(
        //   // key: ValueKey(controller.expandedIndex.value == index),
        //   // initiallyExpanded: controller.expandedIndex.value == index,
        //   // onExpansionChanged: (expanded) {
        //   //   controller.toggle(index, expanded);
        //   // },
        //
        //   tilePadding: const EdgeInsets.symmetric(horizontal: 10),
        //   backgroundColor: GainerColors.lightWhite,
        //   collapsedBackgroundColor:
        //       is48Complete ? GainerColors.lightPink : GainerColors.lightWhite,
        //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        //   collapsedShape:
        //       RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        //   title: DDExpansionTileHeader(
        //     title1: 'Pending Since',
        //     subTitle1: order.lrDate,
        //     title2: brand,
        //     subTitle2: location,
        //     title3: '₹ ${order.val.toInt()}',
        //   ),
        //   children: [
        //     Container(
        //       decoration: _gradientDecoration(),
        //       padding: const EdgeInsets.all(8),
        //       child: Column(
        //         crossAxisAlignment: CrossAxisAlignment.start,
        //         children: [
        //           Row(
        //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //             children: [
        //               Expanded(
        //                 child: Column(
        //                   crossAxisAlignment: CrossAxisAlignment.start,
        //                   children: [
        //                     _keyVal('LR No.: ', order.lrNumber),
        //                     _keyVal('LSP: ', order.lsp),
        //                     const SizedBox(height: 5),
        //                     ...List.generate(
        //                         count,
        //                         (index) => _generateBoxImgRow(
        //                             order, index, context, size)),
        //                     Obx(() {
        //                       final hasBoxImages = !controller
        //                           .isAnyNullInBox(order.dispatchOrderNo);
        //                       final hasPickupImages = !controller
        //                           .isAnyNullInPickup(order.dispatchOrderNo);
        //
        //                       return Column(
        //                         children: [
        //                           if (hasBoxImages)
        //                             _generatePickupImgRow(
        //                                 order, 0, context, size),
        //                           const SizedBox(height: 5),
        //                           if (hasPickupImages)
        //                             GainerPrimaryButton(
        //                               onPressed: () => controller.onSubmit(
        //                                 order.dispatchOrderNo,
        //                                 order.lrNumber,
        //                               ),
        //                               title: 'Submit',
        //                               isLoading: controller
        //                                   .isSubmitting(order.dispatchOrderNo),
        //                             ),
        //                         ],
        //                       );
        //                     })
        //                     // Obx(() {
        //                     //   if (!controller
        //                     //       .isAnyNullInBox(order.dispatchOrderNo)) {
        //                     //     return _generatePickupImgRow(
        //                     //         order, 0, context, size);
        //                     //   }
        //                     //   return const SizedBox.shrink();
        //                     // }),
        //                     // Obx(() {
        //                     //   if (!controller
        //                     //       .isAnyNullInPickup(order.dispatchOrderNo)) {
        //                     //     return GainerPrimaryButton(
        //                     //       onPressed: () {},
        //                     //       title: 'Submit',
        //                     //     );
        //                     //   }
        //                     //   return const SizedBox.shrink();
        //                     // }),
        //                     // if (!controller
        //                     //     .isAnyNullInPickup(order.dispatchOrderNo))
        //                     //   GainerPrimaryButton(
        //                     //     onPressed: () {},
        //                     //     title: 'Submit',
        //                     //   ),
        //                   ],
        //                 ),
        //               ),
        //             ],
        //           ),
        //         ],
        //       ),
        //     ),
        //   ],
        //   // children: [
        //   //   _keyVal('LR No.: ', order.lrNumber),
        //   //   _keyVal('LSP: ', order.lsp),
        //   //   // ListView.separated(
        //   //   //   shrinkWrap: true,
        //   //   //   physics: const NeverScrollableScrollPhysics(),
        //   //   //   itemCount: group.items.length,
        //   //   //   separatorBuilder: (_, __) =>
        //   //   //       const Divider(height: 1, color: Colors.black38),
        //   //   //   itemBuilder: (_, index) {
        //   //   //     final item = group.items[index];
        //   //   //     return DDDetailsCard(
        //   //   //       isPart: true,
        //   //   //       order: item,
        //   //   //     );
        //   //   //   },
        //   //   // ),
        //   // ],
        // ),
      ),
    );
  }

  Widget _generateBoxImgRow(
      DDModel order, int rowIndex, BuildContext context, Size size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (rowIndex == 0) _imgTitle('BOX IMAGES'),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Column(
            //   crossAxisAlignment: CrossAxisAlignment.end,
            //   children: [
            //     // if (rowIndex == 0) _bold("SN"),
            //     Text('${rowIndex + 1}'),
            //   ],
            // ),

            Text('${rowIndex + 1}'),
            buildImageIcon(
                context, "With pkg slip", order, rowIndex, 0, false, size),
            buildImageIcon(
                context, "3D image 1", order, rowIndex, 1, false, size),
            buildImageIcon(
                context, "3D image 2", order, rowIndex, 2, false, size),
          ],
        ),
      ],
    );
  }

  Widget _generatePickupImgRow(
      DDModel order, int rowIndex, BuildContext context, Size size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(),
        _imgTitle('PICKUP PROOF IMAGES'),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildImageIcon(
                context, 'Signed packing slip', order, rowIndex, 0, true, size),
            buildImageIcon(
                context, 'Other details', order, rowIndex, 1, true, size),
          ],
        ),
      ],
    );
    // return Row(
    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //   crossAxisAlignment: CrossAxisAlignment.start,
    //   children: [
    //     Column(
    //       crossAxisAlignment: CrossAxisAlignment.center,
    //       children: [
    //         if (rowIndex == 0) _bold("SN"),
    //         Text('${rowIndex + 1}'),
    //       ],
    //     ),
    //     buildImageIcon(
    //         context, "With pkg slip", order, rowIndex, 0, false, size),
    //     buildImageIcon(context, "3D image 1", order, rowIndex, 1, false, size),
    //     buildImageIcon(context, "3D image 2", order, rowIndex, 2, false, size),
    //   ],
    // );
  }

  // Widget buildImageRow(DDModel order, int row, bool isSigned,Size size) {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceAround,
  //     children: List.generate(
  //       isSigned ? 2 : 3,
  //       (col) => _buildImageIcon(order, row, col, isSigned,size),
  //     ),
  //   );
  // }

  // Widget _buildImgIcon(BuildContext context, String text, DDModel order,
  //     int rowIndex, int imageIndex, bool isSigned, Size size) {
  //   final imageMeta = controller.imageMeta(text, order);
  //   final fileName = imageMeta.$1;
  //   final apiImage = imageMeta.$2;
  //
  //   return Column(
  //     mainAxisAlignment: MainAxisAlignment.spaceAround,
  //     crossAxisAlignment: CrossAxisAlignment.center,
  //     children: [
  //       if (rowIndex == 0) _bold(text),
  //       Obx(() {
  //         final image = controller.getImage(
  //               order: order,
  //               row: rowIndex,
  //               col: imageIndex,
  //               isSigned: isSigned,
  //             ) ??
  //             apiImage;
  //
  //         final key =
  //             '${order.dispatchOrderNo}_${rowIndex}_$imageIndex$isSigned';
  //
  //         final uploading = controller.uploadingMap[key] == true;
  //
  //         return IconButton(
  //           onPressed: uploading
  //               ? null
  //               : () => controller.onImageTap(
  //                     context,
  //                     image,
  //                     apiImage,
  //                     text,
  //                     order,
  //                     rowIndex,
  //                     imageIndex,
  //                     isSigned,
  //                     fileName,
  //                   ),
  //           icon: uploading
  //               ? const SizedBox(
  //                   width: 40,
  //                   height: 40,
  //                   child: CircularProgressIndicator(),
  //                 )
  //               : Container(
  //                   constraints: BoxConstraints(
  //                     minHeight: size.height * .2, // Minimum height
  //                     maxHeight: size.height * .7, // Maximum height
  //                     minWidth: size.width * .9,
  //                     maxWidth: size.width,
  //                   ),
  //                   child: Image.network(
  //                     'https://scope.sparecare.in/Upload/DispatchDetails/$image',
  //                     width: size.width * .2,
  //                     height: size.width * .2,
  //                     fit: BoxFit.cover,
  //                     loadingBuilder: (context, child, loadingProgress) {
  //                       if (loadingProgress == null) {
  //                         return child; // Display the image once loaded
  //                       }
  //                       return Center(
  //                         child: CircularProgressIndicator(
  //                           value: loadingProgress.expectedTotalBytes != null
  //                               ? loadingProgress.cumulativeBytesLoaded /
  //                                   (loadingProgress.expectedTotalBytes ?? 1)
  //                               : null, // Show indeterminate if null
  //                         ),
  //                       );
  //                     },
  //                     errorBuilder: (context, error, stackTrace) =>
  //                         const Icon(Icons.error),
  //                   ),
  //                 ),
  //           // : _buildImageWidget(image),
  //         );
  //       }),
  //     ],
  //   );
  // }

  Widget buildImageIcon(
    BuildContext context,
    String title,
    DDModel order,
    int row,
    int col,
    bool isSigned,
    Size size,
  ) {
    final key = '${order.dispatchOrderNo}_$row$col$isSigned';
    final imageMeta = controller.imageMeta(title, order);
    final fileName = imageMeta.$1;
    final apiImage = imageMeta.$2;
    return Obx(() {
      final image = isSigned
          ? (controller.signedImages[order.dispatchOrderNo]?[row][col])
          : (controller.boxImages[order.dispatchOrderNo]?[row][col]);

      final uploading = controller.uploadingMap[key] == true;

      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (row == 0) _bold(title),
          Container(
            margin: EdgeInsets.all(2),
            width: size.width * .2,
            height: size.width * .2,
            decoration: BoxDecoration(
              border: Border.all(
                color: GainerColors.primary,
                width: 1.2,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              onPressed: uploading
                  ? null
                  : () {
                      controller.onImageTap(
                        context,
                        image,
                        apiImage,
                        title,
                        order,
                        row,
                        col,
                        isSigned,
                        fileName,
                        size,
                      );
                    },
              icon: uploading
                  ? const CircularProgressIndicator(color: GainerColors.primary)
                  : image is File
                      ? Image.file(
                          image,
                          width: size.width * .2,
                          height: size.width * .2,
                          fit: BoxFit.cover,
                        )
                      : image is String
                          ? Image.network(
                              'https://scope.sparecare.in/Upload/DispatchDetails/$image',
                              width: size.width * .2,
                              height: size.width * .2,
                              fit: BoxFit.cover,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) {
                                  return child; // Display the image once loaded
                                }
                                return Center(
                                  child: CircularProgressIndicator(
                                    color: GainerColors.primary,
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            (loadingProgress
                                                    .expectedTotalBytes ??
                                                1)
                                        : null, // Show indeterminate if null
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.error),
                            )
                          // ? Image.network(
                          //     'https://scope.sparecare.in/Upload/DispatchDetails/$image',
                          //     width: 60,
                          //     height: 60,
                          //   )
                          : Icon(Icons.add_a_photo,
                              color: GainerColors.primary),
            ),
          ),
        ],
      );
    });
  }

  Widget _imgTitle(String title) => Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: GainerColors.primary,
          decoration: TextDecoration.underline,
          decorationColor: GainerColors.primary,
        ),
      );
  Widget _label(String? text) =>
      Text(text ?? '', style: const TextStyle(fontSize: 12));

  Widget _bold(String? text) => Text(
        text ?? '',
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
      );

  Widget _keyVal(String key, String val) => Row(
        children: [_label(key), _bold(val)],
      );

}
