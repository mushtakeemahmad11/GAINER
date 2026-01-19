import 'package:flutter/material.dart';
import 'package:gainer/dealer_monitoring/core/theme/app_colors.dart';
import 'package:get/get.dart';
import '../../gainer/controllers/home_screen_controller.dart';
import '../../gainer/shared_preferences/shared_preferences_get_data.dart';
import '../../gainer/shared_preferences/shared_preferences_set_data.dart';
import '../core/services/api_services.dart';
import '../core/utils/dm_images.dart';
import '../core/utils/transform_value_ind.dart';

class DMMainController extends GetxController {
  ApiServices api = ApiServices();
  final LocationController _locationController = Get.put(LocationController());
  RxnString selectedLocation = RxnString(null);
  //Dates
  RxnString stockDate = RxnString("--/--/----");
  RxnString jobLineDate = RxnString("--/--/----");
  RxnString jobCardDate = RxnString("--/--/----");

  RxnString fName = RxnString("FirstName");
  RxnString lName = RxnString("LastName");
  RxnString photo = RxnString(null);

  var currentScreen = 0.obs;
  void openScreen(int index) => currentScreen.value = index;
  // void goHome() => currentScreen.value = 0;

  final List<Map<String, dynamic>> menuItems = [
    // {'img': ConstantImages.binLocation, 'icon': Icons.location_on, 'label': 'Bin Location\nCheck'},
    {
      'img': DMImages.partStockCheck,
      'icon': Icons.inventory,
      'label': 'Part Stock\nCheck'
    },
    {
      'img': DMImages.gLogo,
      'icon': Icons.inventory_2,
      'label': 'Gainer Stock\nCheck'
    },
    {
      'img': DMImages.substitutionCheck,
      'icon': Icons.info,
      'label': 'Substitution\nCheck'
    },
    {
      'img': DMImages.ppniList,
      'icon': Icons.list_alt,
      'label': 'PPNI List\nView'
    },
    {
      'img': DMImages.vehicleSearch,
      'icon': Icons.directions_car,
      'label': 'Vehicle\nSearch'
    },
    {
      'img': DMImages.saleTrend,
      'icon': Icons.show_chart,
      'label': 'Sale Trend\nView'
    },
    {
      'img': DMImages.orderInfo,
      'icon': Icons.assignment,
      'label': 'Order\nInformation'
    },
    {
      'img': DMImages.scsNorms,
      'icon': Icons.warehouse,
      'label': 'SCS Norms\nView'
    },
    // {
    //   'img': ConstantImages.gainerListening,
    //   'icon': Icons.analytics,
    //   'label': 'My Gainer\nListing'
    // },
  ];

  ///init work of Dm_main Screen
  initWork() async {
    String? selectedLocation = _locationController.selectedLocation.value;

    // Null check
    if (selectedLocation == null || selectedLocation.isEmpty) {
      if (_locationController.locationIdMap.isEmpty) {
        // No locations available
        Get.rawSnackbar(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          messageText: Center(
            child: Text("No location available. Please try again later",
                style: TextStyle(color: Colors.white)),
          ),
        );
        return; // stop execution
      } else {
        // fallback to first element
        selectedLocation =
            _locationController.locationIdMap.keys.elementAt(0).toString();
      }
    }

    final locationId =
        _locationController.locationIdMap[selectedLocation].toString();

    if (locationId.isEmpty) {
      Get.rawSnackbar(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        messageText: Center(
          child: Text("Invalid location. Please select a valid location",
              style: TextStyle(color: Colors.white)),
        ),
      );
      return;
    }
    _locationController.updateStockDetails(int.parse(locationId));
    int tCode = await getIntData("tCode");
    final response = await api.getUserRole(userId: tCode);
    if (response['success']) {
      setStringData("userRole", response['role'] ?? "NotDefine");
    }

    final dealerId = await getStringData("dealerID") ?? 0;
    final responseDate =
        await api.getStockDate(dealerId: dealerId, locationId: locationId);
    if (responseDate['success']) {
      final data = responseDate['data'];

      ///fin stock date
      stockDate.value =
          TransformValue().formatToReadableDate(data[0][0]['StockDate']);
      jobLineDate.value =
          TransformValue().formatToReadableDate(data[1][0]['JoblineCloseDate']);
      jobCardDate.value =
          TransformValue().formatToReadableDate(data[2][0]['JobCardCloseDate']);
    }

    fName.value = await getStringData('firstName');
    lName.value = await getStringData('lastName');
    photo.value = await getStringData('photo');

    // fetchVersionFromFirestore();
  }

  // Future<void> fetchVersionFromFirestore() async {
  //   try {
  //     DocumentSnapshot doc = await FirebaseFirestore.instance
  //         .collection('update')
  //         .doc('kVsb8EqMOS6n2XsfYJOs')
  //         .get();
  //
  //     if (doc.exists) {
  //       var version = doc['version'];
  //       // check version if match then go forward otherwise show update
  //       print("version of dealer monitoring: $version");
  //       if (version == 1.1) {
  //         // Get.off(() => DMMainScreen());
  //       } else {
  //         Get.dialog(
  //           barrierDismissible: false,
  //           AlertDialog(
  //             shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(16),
  //             ),
  //             backgroundColor: Colors.white,
  //             title: Row(
  //               children: [
  //                 Icon(Icons.system_update, color: AppColor.primary, size: 28),
  //                 const SizedBox(width: 8),
  //                 const Text(
  //                   'Update Available',
  //                   style: TextStyle(
  //                     fontSize: 20,
  //                     fontWeight: FontWeight.bold,
  //                     color: Colors.black87,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //             content: const Text(
  //               'A newer version of the app is available.\n\nPlease update to continue.',
  //               style: TextStyle(
  //                 fontSize: 16,
  //                 color: Colors.black54,
  //                 height: 1.4,
  //               ),
  //             ),
  //             actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  //             actions: [
  //               SizedBox(
  //                 width: double.infinity,
  //                 child: ElevatedButton(
  //                   onPressed: () {
  //                     //not working
  //                     DownloadUtils.downloadApk(
  //                       '1gyAJFveYfQ4c-EGPnXQqKTLBub3v8sAb',
  //                     );
  //                   },
  //                   style: ElevatedButton.styleFrom(
  //                     backgroundColor: AppColor.primary,
  //                     padding: const EdgeInsets.symmetric(vertical: 14),
  //                     shape: RoundedRectangleBorder(
  //                       borderRadius: BorderRadius.circular(12),
  //                     ),
  //                   ),
  //                   child: const Text(
  //                     'Update Now',
  //                     style: TextStyle(
  //                       fontSize: 16,
  //                       color: Colors.white,
  //                       fontWeight: FontWeight.w600,
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         );
  //
  //         // Get.dialog(
  //         //   barrierDismissible: false,
  //         //   AlertDialog(
  //         //     title: const Text('Update Available'),
  //         //     content: const Text(
  //         //         'A newer version of the app is available. Please update to continue.'),
  //         //     actions: [
  //         //       TextButton(
  //         //         onPressed: () async {
  //         //           DownloadUtils.downloadApk(
  //         //               '1gyAJFveYfQ4c-EGPnXQqKTLBub3v8sAb'
  //         //             // "https://drive.google.com/file/d/1gyAJFveYfQ4c-EGPnXQqKTLBub3v8sAb/view?usp=sharing"
  //         //           );
  //         //         },
  //         //         child: const Text('Update Now'),
  //         //       ),
  //         //     ],
  //         //   ),
  //         // );
  //       }
  //     } else {
  //       print('Document does not exist');
  //     }
  //   } catch (e) {
  //     print('Error fetching version: $e');
  //   }
  // }

  Future<void> goto(String label, int index) async {
    if (label.startsWith("PPNI List")) {
      String userRole = await getStringData("userRole");
      // print("Label: $label, userRole::: $userRole");
      if (userRole == 'General Manager' || userRole == 'CEO') {
        // print("GOTO GeneralManagerScreen");
        openScreen(10); // GeneralManagerScreen index
      } else if (userRole == 'Spare Parts Manager') {
        // print("GOTO WorkshopManagerScreen");
        openScreen(11); // WorkshopManagerScreen index
      } else if (userRole == "Workshop Advisor") {
        // print("GOTO WorkshopAdvisorScreen");
        openScreen(12); // WorkshopAdvisorScreen index
      } else {
        Get.snackbar('Access Denied', 'You are not authorized to access PPNI',
            backgroundColor: DMAppColors.accent, colorText: Colors.black);
      }
    } else {
      openScreen(index + 1);
    }
  }
}
