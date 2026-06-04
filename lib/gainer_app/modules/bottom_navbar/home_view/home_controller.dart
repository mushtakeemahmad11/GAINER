import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gainer/gainer_app/core/services/auth_service.dart';
import 'package:gainer/gainer_app/core/utils/check_internet.dart';
import 'package:gainer/gainer_app/core/utils/url_launch_utils.dart';
import 'package:gainer/gainer_app/core/widgets/gainer_bottom_sheet.dart';
import 'package:gainer/gainer_app/modules/bottom_navbar/home_view/models/stage_model.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../../../app_switcher_view/app_switcher_controller.dart';
import '../../../../test/gainer_sims.dart';
import '../../../core/constants/gainer_image.dart';
import '../../../core/services/gainer_api_service.dart';
import '../../../routes/app_routes.dart';
import '../../login/model/user_model.dart';
import '../../main_view/models/action_item_model.dart';
import '../../notification_view/notification_models.dart';
import 'models/advertise_model.dart';
import 'widgets/low_balance_sheet.dart';

class HomeController extends GetxController {
  late final AppSwitcherController appSwitcherController;

  @override
  void onInit() {
    initWork();
    super.onInit();
  }

  Future<void> initWork() async {
    appSwitcherController = Get.find<AppSwitcherController>();
    String tempLocation = await AuthService.getLocation();
    final stockDetails = appSwitcherController.getStock();
    String? location = stockDetails?.location.toString() ?? tempLocation;

    onChangeLocation(location);
  }

  void showLowBalanceSheet() {
    int bal = int.tryParse(funBalance.value) ?? 0;
    if (bal < 10000) {
      // wait until UI is ready
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (Get.isBottomSheetOpen == true) return;

        Get.bottomSheet(
          SafeArea(child: LowBalanceSheet(balance: bal)),
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
        );
      });
    }
  }

  ///After location changed from dropdown
  void onChangeLocation(String? location) {
    if (location == null && location!.isEmpty) return;
    final locationId = appSwitcherController.locationIdMap[location] ?? '';
    appSwitcherController.selectedLocation.value = location;
    appSwitcherController.selectedLocationId.value = locationId;
    getBuyerDetails(locationId, location);
  }

  SearchController searchController = SearchController();

  final actionsDummyData = List.generate(
    3,
    (_) => ActionItem(
      icon: Icons.shopping_cart,
      title: "Order Placed",
      subtitle: "6 orders | ₹10.13L",
      status: "Pending since Jan 10, 2025",
      iconColor: Colors.blue,
      actionKey: 'orderPlaced',
    ),
  );

  Future<void> onActionTap(String actionKey) async {
    bool checkInt = await CheckInternet.checkInternet();
    if (!checkInt) {
      Get.toNamed(Routes.NOINTERNETVIEW);
      return;
    }

    switch (actionKey) {
      case 'OrderPlaced':
        Get.toNamed(Routes.ORDERPLACED);
        break;

      case 'PoUpdation':
        Get.toNamed(Routes.UPDATEPO);
        break;

      case 'PartsReceipt':
        Get.toNamed(Routes.PARTRECEIPT);
        break;

      case 'OrderDue':
        Get.toNamed(Routes.ORDERRECEIVED);
        break;

      case 'Manifestation':
        Get.toNamed(Routes.MANIFESTATIONVIEW);
        break;

      case 'DispatchDetail':
        Get.toNamed(Routes.DISPATCHEDDETAILSVIEW);
        break;

      case 'DirectRequestSent':
        if (Platform.isIOS) {
          Get.to(() => GainerSims());
          return;
        }
        Get.toNamed(Routes.DIRECTREQSENT);
        break;

      case 'DirectRequestReceived':
        if (Platform.isIOS) {
          Get.to(() => GainerSims());
          return;
        }
        Get.toNamed(Routes.DIRECTREQRECEIVED);
        break;

      default:
        break;
    }
  }

  RxString partSearchText = ''.obs;
  void onSearchPressed() {
    partSuggestions.clear();
    final rawText = searchController.text.trim();
    if (rawText.isEmpty) return;

    final cleanedQuery = cleanSearchText(rawText);

    Get.toNamed(Routes.PARTREQUESTVIEW, arguments: {'part': cleanedQuery});
  }

  RxBool partSearchLoading = false.obs;
  var partSuggestions = <String>[].obs;

  ///Search part with suggestion
  String getCurrentQuery(String text) {
    final parts = text.split(',');
    return parts.last.trim();
  }

  String cleanSearchText(String text) {
    return text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .join(',');
  }

  Timer? _debounce;
  Future<void> onSearchChanged(String text) async {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 400), () async {
      if (text.isEmpty) {
        partSuggestions.clear();
        return;
      }

      final query = getCurrentQuery(text);

      if (query == partSearchText.value) return;

      partSearchText.value = query;

      await fetchPartSuggestions(query);
    });
  }

  Future<void> fetchPartSuggestions(String query) async {
    if (query.length < 3) {
      partSuggestions.clear();
      return;
    }
    //
    // String brandId = await AuthService.getBrandId();
    // String locationId = await AuthService.getLocationId();
    // String tCode = await AuthService.getTCode();

    partSearchLoading.value = true;

    final response = await GainerApiService().searchPart(query);

    partSearchLoading.value = false;

    if (response['success']) {
      partSuggestions.value = List<String>.from(response['data']);
    } else {
      partSuggestions.clear();
    }
  }

  void selectPartNumber(String selectedPart) {
    final currentText = searchController.text;

    final parts = currentText.split(',');

    // Remove the last incomplete part
    parts.removeLast();

    String newText;

    if (parts.isEmpty) {
      newText = '$selectedPart, ';
    } else {
      newText = '${parts.join(',').trim()}, $selectedPart, ';
    }

    searchController.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );

    partSuggestions.clear();
  }

  // Future<void> onChangedLocation() async {}
  final RxString funBalance = ''.obs;
  final RxList<StageModel> stageList = <StageModel>[].obs;

  final RxList<ActionItem> buyerActions = <ActionItem>[].obs;
  final RxList<ActionItem> sellerActions = <ActionItem>[].obs;

  static const Map<String, Map<String, dynamic>> buyerStageMap = {
    'DirectRequestSent': {
      'title': 'Direct Req Sent',
      'icon': Icons.shopping_cart,
    },
    'OrderPlaced': {
      'title': 'Order Placed',
      'icon': Icons.shopping_cart,
    },
    'PoUpdation': {
      'title': 'Update PO',
      'icon': Icons.update,
    },
    'PartsReceipt': {
      'title': 'Part Receipt',
      'icon': Icons.inventory,
    },
  };

  static const Map<String, Map<String, dynamic>> sellerStageMap = {
    'DirectRequestReceived': {
      'title': 'Direct Req Received',
      'icon': Icons.call_received,
    },
    'OrderDue': {
      'title': 'Open Orders',
      // 'title': 'Order Received',
      'icon': Icons.call_received,
    },
    'Manifestation': {
      'title': 'Manifestation',
      'icon': Icons.manage_history,
    },
    'DispatchDetail': {
      'title': 'Dispatch Details',
      'icon': Icons.local_shipping,
    },
  };

  ///For a SEQUENCE of TITLE
  static const List<String> buyerStageOrder = [
    'DirectRequestSent',
    'OrderPlaced',
    'PoUpdation',
    'PartsReceipt',
  ];

  static const List<String> sellerStageOrder = [
    'DirectRequestReceived',
    // 'DirectReqReceived',
    'OrderDue',
    'Manifestation',
    'DispatchDetail',
  ];

  List<ActionItem> _buildActions(
    List<StageModel> stages, {
    required bool isBuyer,
  }) {
    final allowedStages = isBuyer ? buyerStageMap : sellerStageMap;
    final stageOrder = isBuyer ? buyerStageOrder : sellerStageOrder;

    // 🔹 Map stages for fast lookup
    final stageMap = {
      for (final stage in stages) stage.stage: stage,
    };

    return stageOrder.where(stageMap.containsKey).map((stageKey) {
      final stage = stageMap[stageKey]!;
      final config = allowedStages[stage.stage]!;

      final pendingData =
          stage.stageDate.isNotEmpty ? 'Pending since ${stage.stageDate}' : '';
      // : 'Pending since Jan 10, 2025';

      return ActionItem(
        icon: config['icon'],
        title: config['title'],
        subtitle: '${stage.partsCount} Nos | ₹${stage.val.toStringAsFixed(1)}L',
        status: pendingData,
        iconColor: isBuyer ? Colors.blue : Colors.green,
        actionKey: stage.stage,
      );
    }).toList();
  }

  void setStageData(List<StageModel> stages) {
    stageList.assignAll(stages);
    buyerActions.value = _buildActions(
      stageList,
      isBuyer: true,
    );

    sellerActions.value = _buildActions(
      stageList,
      isBuyer: false,
    );
  }

  RxBool isStageDataLoad = false.obs;
  RxnString err = RxnString(null);
  Future<void> getBuyerDetails(String locationId, String location) async {
    try {
      err.value = null;
      String tCode = await AuthService.getTCode();
      isStageDataLoad.value = true;
      final response =
          await GainerApiService().getBuyerValues(locationId, tCode);
      isStageDataLoad.value = false;
      if (response['success']) {
        final List data = jsonDecode(response['data']);
        final stages = data.map((e) => StageModel.fromJson(e)).toList();

        // stages.add(StageModel(
        //   stage: "DirectReqSent",
        //   partsCount: 5,
        //   val: 12500.50,
        //   walletBalance: 3000.00,
        //   fundBalance: 9500.50,
        //   stageDate: "2026-05-12",
        // ));
        // stages.add(StageModel(
        //   stage: "DirectReqReceived",
        //   partsCount: 5,
        //   val: 12500.50,
        //   walletBalance: 3000.00,
        //   fundBalance: 9500.50,
        //   stageDate: "2026-05-12",
        // ));
        setStageData(stages);
        funBalance.value = stageList.first.walletBalance.toInt().toString();
        appSwitcherController.updateStockDetails(locationId);
        await _getDirectReqAccess(locationId);
        await AuthService.saveLocationId(locationId);
        await AuthService.saveLocation(location);
      } else {
        err.value = response['message']+' pull down to refresh the page';
      }
      await getUserDetails();
      showLowBalanceSheet();
      await initNotification();
    } catch (e) {
      // print("catch: $e");
      // err.value = 'Some thing went wrong, Please try again';
    }
  }

  RxBool isAllowBuying = false.obs;
  RxBool isAllowSelling = false.obs;
  Future<void> _getDirectReqAccess(String locationId) async {
    final response =
        await GainerApiService().getDirectRequestAccess(locationId: locationId);
    if (response['success']) {
      final data = response['data'][0];
      isAllowBuying.value = data['AllowBuying'];
      isAllowSelling.value = data['AllowSelling'];
    } else {}
  }

  bool checkAllow(String title) {
    if (title == 'Direct Req Sent') {
      return isAllowBuying.value;
    } else if (title == 'Direct Req Received') {
      return isAllowSelling.value;
    }
    return true;
  }

  void getSnackBar() {
    GainerBottomSheet.showSnackBar("Please connect to Gainer team for access");
    // GainerBottomSheet.showSnackBar("You don't have permission to access this");
  }

  //══════════════════════════════════════════════════════════════════════//
  ///Advertise list
  //══════════════════════════════════════════════════════════════════════//

  final RxInt currentAdIndex = 0.obs;

  final List<AdItemModel> ads = [
    AdItemModel(
      image: GainerImages.sliderBanner1,
      title: '⚡ Today – Profit Opportunity',
      onTap: () => debugPrint('Profit Opportunity'),
    ),
    AdItemModel(
      image: GainerImages.sliderBanner2,
      title: '🚚 High Active Top Buyer',
      onTap: () => debugPrint('Top Buyer'),
    ),
    AdItemModel(
      image: GainerImages.sliderBanner3,
      title: '🔥 Top Seller',
      onTap: () => debugPrint('Top Seller'),
    ),
    // AdItemModel(
    //   image: GainerImages.sliderBanner4,
    //   title: '📦 Fast Dispatch Available',
    //   onTap: () => debugPrint('Fast Dispatch'),
    // ),
  ];

  //══════════════════════════════════════════════════════════════════════//
  ///Track Order View
  //══════════════════════════════════════════════════════════════════════//

  RxnString trackErr = RxnString(null);
  SearchController trackOrderCtrl = SearchController();
  RxString trackSearchText = ''.obs;
  RxBool isTracking = false.obs;

  void onChangedTrackOrder(String val) async {
    trackOrderCtrl.text = val;
    trackSearchText.value = val;
    trackErr.value = null;
  }

  void trackClearSearchBar() {
    trackOrderCtrl.clear();
    trackSearchText.value = '';
    trackErr.value = null;
  }

  //Api hit for track order
  Future<void> trackOrder() async {
    final orderNumber = trackOrderCtrl.text.trim();
    final locationId = await AuthService.getLocationId();
    final tCode = await AuthService.getTCode();
    isTracking.value = true;
    final response =
        await GainerApiService().trackOrder(orderNumber, locationId, tCode);
    isTracking.value = false;

    if (response['success']) {
      final String data = response['data'];
      trackErr(null);
      UrlLaunchUtils.openUrl(data);
    } else {
      trackErr(response['message']);
    }
  }

  //══════════════════════════════════════════════════════════════════════//
  ///PROFILE VIEW TAP WORK
  //══════════════════════════════════════════════════════════════════════//

  final RxString name = "User Name".obs;
  final RxString email = "".obs;
  final RxString username = "".obs;
  final RxString brand = "".obs;
  final RxString dealer = "".obs;
  final RxString location = "".obs;

  // final RxString profileImage = "https://i.pravatar.cc/300".obs; // API image
  RxnString profileImage = RxnString(null); // API image
  RxnString pickedProfileImg = RxnString(null); // Local image

  Future<void> getUserDetails() async {
    UserModel? user = await AuthService.getUser();

    if (user != null) {
      name.value = "${user.firstName} ${user.lastName}";
      email.value = user.email;
      final img = user.photo;
      profileImage.value = img;
    }
    username.value = await AuthService.getUserId();
    final bdl = await AuthService.getBDL();
    brand.value = bdl['brand'] ?? '';
    dealer.value = bdl['dealer'] ?? '';
    location.value = bdl['location'] ?? '';
    pickedProfileImg.value = await AuthService.getProfile();
  }

  RxBool isProfileUploading = false.obs;
  Future<void> pickProfileImage(BuildContext context) async {
    Future<void> pick(ImageSource source) async {
      Get.back();
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: source);

      if (image != null) {
        String tCode = await AuthService.getTCode();
        String locationId = await AuthService.getLocationId();
        final imgFile = File(image.path);
        isProfileUploading.value = true;
        final response = await GainerApiService().uploadProfileImage(
          tCode: tCode,
          locationId: locationId,
          imageFiles: imgFile,
        );
        isProfileUploading.value = false;
        // print("Response of upload image: $response");
        if (response['success']) {
          await AuthService.saveProfile(image.path);
          pickedProfileImg.value = await AuthService.getProfile();
          GainerBottomSheet.showSnackBar('Profile images saved');
        } else {
          GainerBottomSheet.showSnackBar(response['message']);
        }
      } else {
        GainerBottomSheet.showSnackBar('Image not selected');
      }
    }

    GainerBottomSheet.show(
      context: context,
      onPressedCamera: () => pick(ImageSource.camera),
      onPressedGallery: () => pick(ImageSource.gallery),
    );
  }

  //══════════════════════════════════════════════════════════════════════//
  ///NOTIFICATION VIEW WORK
  //══════════════════════════════════════════════════════════════════════//

  final notificationList = <NotificationModel>[].obs;
  RxBool openFromNotification = false.obs;
  RxBool isNotificationLoading = false.obs;
  RxnString notificationError = RxnString();
  RxString notificationType = ''.obs;

  static HomeController get to => Get.find();
  Future<void> initNotification() async {
    final locationId = await AuthService.getLocationId();
    notificationList.clear();
    notificationError.value = null;
    await fetchFCM(locationId);
  }

  Future<void> fetchFCM(String selectedLocationID) async {
    isNotificationLoading.value = true;
    final response =
        await GainerApiService().getNotifications(selectedLocationID);
    isNotificationLoading.value = false;
    if (response['success'] == true) {
      final List<dynamic> decoded = jsonDecode(response['data']);
      notificationList.value =
          decoded.map((e) => NotificationModel.fromJson(e)).toList();
    } else {
      notificationError.value = response['message'];
    }
    // FirebaseFirestore.instance
    //     .collection('gainer-notifications')
    //     .where('locationId', isEqualTo: selectedLocationID)
    //     .orderBy('createdAt', descending: true)
    //     .snapshots()
    //     .listen((snap) {
    //   notificationList.value =
    //       snap.docs.map(GainerAppNotification.fromDoc).toList();
    // });
  }

  String timeAgo(DateTime ts) {
    final now = DateTime.now();
    final date = ts;
    final diff = now.difference(date);

    if (diff.inSeconds < 60) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
    if (diff.inHours < 24) return '${diff.inHours} hrs ago';
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays} days ago';

    return DateFormat('dd MMM yyyy').format(date);
  }

  RxBool fromNotification = false.obs;
  // Map<String, dynamic>? notificationData;
  Map<String, dynamic>? notificationData;

  void onNotificationTap(NotificationModel n) async {
    // String route = n.data['moduleRoute'];
    String route = n.moduleRoute;
    Get.offNamed(route);
    await GainerApiService().readNotification(n.id);
    // FirebaseDbCreation.markRead(n.id);
  }

  void logout() {
    AuthService.logout('UserLogoutGAINER');
  }
}
