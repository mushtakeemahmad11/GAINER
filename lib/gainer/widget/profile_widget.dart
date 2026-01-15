import 'package:flutter/material.dart';
import '../../main.dart';
import '../screens/colors.dart';
import '../screens/constant_image_path.dart';

Widget reusableProfile(image, photo) {
  return ClipOval(
      child: image == null && photo == null
          ? Image.asset(
              AppImages.profile,
              width: mq.height * 0.23,
              height: mq.height * 0.23,
            )
          : image != null
              ? Image.file(
                  image!,
                  width: mq.height * 0.23,
                  height: mq.height * 0.23,
                  fit: BoxFit.cover,
                )
              : Image.network(
                  'https://scope.sparecare.in/Upload/Employee/$photo',
                  width: mq.height * 0.23,
                  height: mq.height * 0.23,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child; // Display the image once loaded
                    }
                    return Container(
                      width: mq.height * 0.23,
                      height: mq.height * 0.23,
                      color: AppColor.primaryShade,
                      child: Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  (loadingProgress.expectedTotalBytes ?? 1)
                              : null, // Show indeterminate if null
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) => Image.asset(
                    AppImages.profile,
                    width: mq.height * 0.23,
                    height: mq.height * 0.23,
                  ),
                ));
}
