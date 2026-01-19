import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../gainer/shared_preferences/shared_preferences_get_data.dart';

class ScanappMainScreenController extends GetxController {
  var currentIndex = 0.obs;
  var userId = 'XYZ\nAutomotive'.obs;
  var selectedLocation = 'New Delhi'.obs;
  RxnString photo = RxnString(null);
  RxnString name = RxnString(null);
  final locations = ["New Delhi", "Mumbai", "Bangalore", "Chennai", "Kolkata"];

  @override
  void onInit() {
    // _getUserId();
    _initWork();
    super.onInit();
  }

  Future<void> _initWork() async {
    photo.value = await getStringData('photo');
    final fName = await getStringData('firstName');
    final lName = await getStringData('lastName');
    name("$fName $lName");
  }
  final titleItems = [
    {'icon': Icons.person, 'title': 'View/Update Your Profile', 'index': 1},
    {'icon': Icons.lock, 'title': 'Manage Password', 'index': 2},
    {'icon': Icons.settings, 'title': 'Setting', 'index': 3},
    {'icon': Icons.timeline, 'title': 'Performance Status', 'index': 4},
    {'icon': Icons.notifications_active, 'title': 'Notification', 'index': 5},
    {'icon': Icons.help, 'title': 'Help & Support', 'index': 6},
  ];

  // Future<void> _getUserId() async {
  //   final id = await getStringData(LoginScreenState.USERIDKEY);
  //   userId.value = id ?? 'XYZ\nAutomotive';
  // }

  void changeTab(int index) => currentIndex.value = index;

  void logout() {
    Get.back();
  }
}
