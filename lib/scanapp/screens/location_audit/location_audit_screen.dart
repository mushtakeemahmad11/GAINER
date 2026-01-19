import 'package:flutter/material.dart';
import '../../core/themes/scanapp_colors.dart';
import 'by_location_tab.dart';
import 'camera_tab.dart';
import 'generic_tab.dart';

class LocationAuditScreen extends StatefulWidget {
  const LocationAuditScreen({super.key});

  @override
  State<LocationAuditScreen> createState() => _LocationAuditScreenState();
}

class _LocationAuditScreenState extends State<LocationAuditScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Location Audit"),
          backgroundColor: ScanappColors.primary,
          foregroundColor: Colors.black,
        ),
        body: Column(
          children: [
            TabBar(
              unselectedLabelColor: ScanappColors.black,
              tabs: [
                Tab(text: "By Location"),
                Tab(text: "Generic"),
                Tab(
                  icon: Icon(
                    Icons.camera_alt_outlined,
                    size: 35,
                  ),
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  const ByLocationTab(),
                  const GenericTab(),
                  const CameraScreen(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
