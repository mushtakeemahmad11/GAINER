import 'package:flutter/material.dart';
import '../../../../core/constants/gainer_color.dart';

class NotificationCard extends StatelessWidget {
  final String title;
  final String message;
  final bool isRead;
  final String time;
  const NotificationCard({
    super.key,
    required this.title,
    required this.message,
    required this.isRead,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
          color: isRead ? GainerColors.secondary : Colors.red[100],
          borderRadius: BorderRadius.circular(8)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 14)),
                Text(
                  message,
                  softWrap: true,
                  style: TextStyle(fontSize: 12, color: Colors.black54),
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
    );
  }
}