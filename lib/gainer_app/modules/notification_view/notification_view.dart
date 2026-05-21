import 'package:flutter/material.dart';
import 'package:gainer/gainer_app/core/widgets/gainer_app_bar.dart';
import 'package:gainer/gainer_app/modules/bottom_navbar/home_view/home_controller.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../bottom_navbar/home_view/widgets/notification_card.dart';
import 'notification_models.dart';

class NotificationView extends GetView<HomeController> {
  const NotificationView({super.key});
  @override
  Widget build(BuildContext context) {
    controller.initNotification();
    return Scaffold(
      appBar: GainerAppBar(title: 'Notification'),
      body: Obx(() {
        if (controller.isNotificationLoading.value) {
          return ListView.builder(
            itemCount: 8,
            itemBuilder: (BuildContext context, int index) {
              return Skeletonizer(
                enabled: true,
                child: NotificationCard(
                  title: 'Mushtakeem Ahmad',
                  message: 'Flutter developer building scalable mobile App',
                  isRead: true,
                  time: '',
                ),
              );
            },
          );
        }
        final err = controller.notificationError.value;
        if (err != null) {
          return Center(
            child: Text(err, textAlign: TextAlign.center),
          );
        }
        // if (controller.notificationList.isEmpty) {
        //   return Center(
        //     child: Text('No notification found'),
        //   );
        // }

        return ListView.builder(
          itemCount: controller.notificationList.length,
          itemBuilder: (_, i) {
            final NotificationModel n = controller.notificationList[i];
            String time = n.sentOn != null ? controller.timeAgo(n.sentOn!) : '';
            return InkWell(
              onTap: () => controller.onNotificationTap(n),
              child: NotificationCard(
                title: n.title,
                message: n.message,
                isRead: n.isRead,
                time: time,
              ),
            );
          },
        );
      }),
    );
  }
}
