import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../apis_functionality/api_service.dart';
import '../screens/constant_image_path.dart';
import '../shared_preferences/shared_preferences_get_data.dart';
import '../widget/dialog.dart';

class HelpController extends GetxController {
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController otherFieldController = TextEditingController();

  @override
  void onClose() {
    descriptionController.dispose();
    otherFieldController.dispose();
    super.onClose();
  }

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
    final res = await http.get(Uri.parse(
        "http://web27.185.238.new.ocpwebserver.com/api/v1/gnr/issue"));
    try {
      if (res.statusCode == 200) {
        var body = json.decode(res.body);
        var data = body['Data'];

        List<dynamic> issueData = data;
        issues.value = issueData
            .map((e) => IssueModel.fromJson(e as Map<String, dynamic>))
            .toList();
        selectedIssueId.value = null;
        subIssues.clear();
        selectedSubIssueId.value = null;
      } else {
        issuesError.value = "There is some problem to fetch issue option";
      }
    } catch (e) {
      issuesError.value =
          "UnExpected Error\nPlease check your network or try again later";
    }
  }

  Future<void> fetchSubIssues(int issueId) async {
    subIssueError.value = null;
    final url = "http://web27.185.238.new.ocpwebserver.com/api/v1/gnr/subissue";

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"issueid": issueId}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Example: access 'Data' field
        if (data['Data'] != null) {
          List<dynamic> subIssueList = data['Data'];
          subIssues.value = subIssueList
              .map((e) => SubIssueModel.fromJson(e as Map<String, dynamic>))
              .toList();
        }
      } else {
        subIssueError.value = "There is some problem to fetch subIssue item";
      }
    } catch (e) {
      subIssueError.value =
          "UnExpected Error\nPlease check your network or try again later";
    }
  }

  Future<void> submitForm() async {
    raiseTicketError.value = null;
    int userid = await getIntData("tCode");
    String locationId = await getStringData('selectedLocationID');
    String cleanedLabel = labelText.value.replaceFirst("Enter ", "");
    String otherText = otherFieldController.text.trim();
    String descriptionText = descriptionController.text.trim();

    String desc = otherText.isNotEmpty
        ? "$cleanedLabel: $otherText | $descriptionText"
        : descriptionText;
    isLoading.value = true;
    final response = await ApiService().raiseTicketHelp(
      issue: selectedIssue.value,
      desc: desc,
      userid: userid.toString(),
      locationId: locationId.toString(),
      issueId: selectedIssueId.value.toString(),
      subIssueId: selectedSubIssueId.value.toString(),
      // subIssueId: selectedSubIssueId.value,
      // subIssueId: (selectedSubIssueId.value ?? 0).toString(),
      // file: selectedFile.value
      files: selectedFiles,
    );
    isLoading.value = false;

    if (response["success"] != null && response["success"] == true) {
      AppDialog.midPopUp(AppImages.check, 'Your ticket has been raised successfully');
      resetFields();
      resetAttachments();
      clearSelection();
    } else {
      raiseTicketError.value =
          "UnExpected Error\nPlease check your network or try again later";
    }
  }
}

class IssueModel {
  final int issueId;
  final String issue;

  IssueModel({required this.issueId, required this.issue});

  factory IssueModel.fromJson(Map<String, dynamic> json) {
    return IssueModel(
      issueId: json['IssueID'],
      issue: json['Issue'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'IssueID': issueId,
      'Issue': issue,
    };
  }
}

class SubIssueModel {
  final int subIssueId;
  final String subIssue;

  SubIssueModel({required this.subIssueId, required this.subIssue});

  factory SubIssueModel.fromJson(Map<String, dynamic> json) {
    return SubIssueModel(
      subIssueId: json['subissueid'],
      subIssue: json['subissue'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subissueid': subIssueId,
      'subissue': subIssue,
    };
  }
}
