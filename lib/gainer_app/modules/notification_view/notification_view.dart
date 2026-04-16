import 'package:flutter/material.dart';
import 'package:gainer/gainer_app/core/widgets/gainer_app_bar.dart';
import 'package:gainer/gainer_app/modules/bottom_navbar/home_view/home_controller.dart';
import 'package:get/get.dart';
import '../../core/constants/gainer_color.dart';

class NotificationView extends GetView<HomeController> {
  const NotificationView({super.key});
  @override
  Widget build(BuildContext context) {
    controller.initNotification();
    return Scaffold(
      appBar: GainerAppBar(title: 'Notification'),
      body: Obx(() {
        if (controller.isNotificationLoading.value) {
          return Center(
              child: CircularProgressIndicator(color: GainerColors.primary));
        }
        final err = controller.notificationError.value;
        if (err != null) {
          return Center(
            child: Text(err, textAlign: TextAlign.center),
          );
        }
        if (controller.notificationList.isEmpty) {
          return Center(
            child: Text('No notification found'),
          );
        }
        return ListView.builder(
          itemCount: controller.notificationList.length,
          itemBuilder: (_, i) {
            final n = controller.notificationList[i];
            String time =
                n.sentOn != null ? controller.timeAgo(n.sentOn!) : '';
            return InkWell(
              onTap: () => controller.onNotificationTap(n),
              child: Container(
                padding: EdgeInsets.all(12),
                margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                    color: n.isRead ? GainerColors.secondary : Colors.red[100],
                    borderRadius: BorderRadius.circular(8)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(n.title, style: TextStyle(fontSize: 14)),
                          Text(
                            n.message,
                            softWrap: true,
                            style:
                                TextStyle(fontSize: 12, color: Colors.black54),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Row(
                      children: [
                        SizedBox(
                            width: 50,
                            child: Text(
                              time,
                              style: TextStyle(fontSize: 10),
                              textAlign: TextAlign.center,
                            )),
                        const SizedBox(width: 10),
                        Icon(
                          Icons.arrow_forward_ios_outlined,
                          size: 16,
                          color: Colors.black54,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
            // return ListTile(
            //   title: Text(n.title),
            //   subtitle: Text(n.body),
            //   onTap: () {
            //     FirebaseDbCreation.markRead(n.id);
            //     // print("dataaa::: ${n.data['route']}, ${n.data}");
            //     if (n.data['type'] == 'partRequest') {
            //       Get.toNamed(Routes.ORDERRECEIVED);
            //     }
            //     // Get.toNamed(n.data['route'], arguments: n.data);
            //   },
            // );
          },
        );
      }),
    );
  }
}
