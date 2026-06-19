import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:gainer/gainer_app/core/Services/auth_service.dart';
import 'package:gainer/gainer_app/core/constants/gainer_image.dart';
import 'package:gainer/gainer_app/core/widgets/gainer_dialog.dart';
import 'package:get/get.dart';
import '../../../core/services/gainer_api_service.dart';
import 'models.dart';

class HelpController extends GetxController {
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController otherFieldController = TextEditingController();

  RxBool isLoading = false.obs;
  RxBool isSubIssueLoading = false.obs;
  RxBool isShowBox =
      false.obs; // show Describe(System Issue/Other Issue) filed or not

  Rxn<File> selectedFile = Rxn<File>();
  RxBool isImgSelected = false.obs;
  RxBool isFileSelected = false.obs;

  RxnString selectedIssue = RxnString(null);

  var issues = <IssueModel>[].obs;
  RxnString issuesError = RxnString(null);

  RxnString raiseTicketError = RxnString(null);
  RxnString subIssueError = RxnString(null);
  var selectedSubIssueId = RxnInt();

  var subIssues = <SubIssueModel>[].obs;

  var selectedIssueId = RxnInt();

  RxnString selectedDropdownValue = RxnString(null);

  var labelText = ''.obs;

  //for select multiple file
  RxList<PlatformFile> selectedFiles = <PlatformFile>[].obs;

  //for build submit form
  final formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    resetFields();
    fetchIssues();
    super.onInit();
  }

  @override
  void onClose() {
    descriptionController.dispose();
    otherFieldController.dispose();
    super.onClose();
  }

  void resetFields() {
    // selectedIssue.value = null;
    selectedIssueId.value = null;
    selectedDropdownValue.value = null;
    subIssues.clear();
    isShowBox.value = false;
    raiseTicketError.value = null;
    // issuesError.value = null;
    subIssueError.value = null;
    isFileSelected.value = false;
    descriptionController.clear();
    otherFieldController.clear();
  }

  void resetAttachments() {
    subIssues.clear();
    selectedSubIssueId.value = null;
    isShowBox.value = false;
    isImgSelected.value = false;
    isFileSelected.value = false;
    selectedFile.value = null;
    selectedFiles.clear();
  }

  void clearSelection() {
    selectedIssueId.value = 0;
    subIssues.clear();
    selectedDropdownValue.value = null;
  }

  void selectIssue(IssueModel issue) {
    selectedIssue.value = issue.issue;
    selectedIssueId.value = issue.issueId;
    selectedDropdownValue.value = null;
  }

  bool shouldShowOtherField() {
    final id = selectedSubIssueId.value ?? 0;
    return id > 4 && id < 12;
  }

  void clearErrors() {
    raiseTicketError.value = null;
    issuesError.value = null;
  }

  void handleDropdownSelection(String value) {
    selectedFile.value = null;
    isFileSelected.value = false;
    isImgSelected.value = false;
    // isShowBox.value = false;
    selectedDropdownValue.value = value;

    final matched = subIssues.firstWhere((item) => item.subIssue == value);
    selectedSubIssueId.value = matched.subIssueId;

    if ([9, 11].contains(matched.subIssueId)) {
      labelText.value = 'Enter Claim Number';
    } else if (matched.subIssueId > 4 && matched.subIssueId < 8) {
      labelText.value = 'Enter LR Number';
    } else {
      labelText.value = 'Enter Part Number or LR Details';
    }
  }

  void fetchIssues() async {
    issuesError.value = null;
    final response = await GainerApiService().getIssue();
    if (response['success']) {
      final List data = response['data'];
      issues.value =
          data.map<IssueModel>((e) => IssueModel.fromJson(e)).toList();
      selectedIssueId.value = null;
      subIssues.clear();
      selectedSubIssueId.value = null;
    } else {
      issuesError.value = response['message'];
    }
  }

  Future<void> fetchSubIssues(int issueId) async {
    subIssueError.value = null;

    final response = await GainerApiService().getSubIssue(issueId);
    if (response['success']) {
      List<dynamic> subIssueList = response['data'];
      subIssues.value = subIssueList
          .map<SubIssueModel>(
              (e) => SubIssueModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      subIssueError.value = response['message'];
    }
  }

  Future<void> submitForm() async {
    clearErrors();

    if (!formKey.currentState!.validate()) return;
    // checkInt ? submitForm() : internetNotAvl();

    raiseTicketError.value = null;
    // int userid = await getIntData("tCode");
    // String locationId = await getStringData('selectedLocationID');
    String userid = await AuthService.getTCode();
    String locationId = await AuthService.getLocationId();
    String cleanedLabel = labelText.value.replaceFirst("Enter ", "");
    String otherText = otherFieldController.text.trim();
    String descriptionText = descriptionController.text.trim();

    String desc = otherText.isNotEmpty
        ? "$cleanedLabel: $otherText | $descriptionText"
        : descriptionText;
    isLoading.value = true;
    final response = await GainerApiService().raiseTicketHelp(
      issue: selectedIssue.value,
      desc: desc,
      userid: userid.toString(),
      locationId: locationId.toString(),
      issueId: selectedIssueId.value.toString(),
      subIssueId: selectedSubIssueId.value.toString(),
      files: selectedFiles,
    );
    isLoading.value = false;

    if (response["success"] != null && response["success"] == true) {
      GainerDialog.midPopUp(
          GainerImages.checkIcon, 'Your ticket has been raised successfully');
      resetFields();
      resetAttachments();
      clearSelection();
    } else {
      raiseTicketError.value =
          "UnExpected Error\nPlease check your network or try again later";
    }
  }
}
