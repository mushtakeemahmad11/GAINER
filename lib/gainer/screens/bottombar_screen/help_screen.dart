import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../main.dart';
import '../../controllers/check_internet/no_internet_screen.dart';
import '../../controllers/help_controller.dart';
import '../../widget/bottomsheet_for_picture.dart';
import '../../widget/circular_progress_indicator.dart';
import '../../widget/reusable_dropdown.dart';
import '../../widget/reusable_elevated_button.dart';
import '../../widget/toggle_outline_button.dart';
import '../check_internet/check_internet_connectivity.dart';
import '../colors.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  final _formKey = GlobalKey<FormState>();

  // Initialize controllers using GetX
  final HelpController _helpController = Get.put(HelpController());
  @override
  void initState() {
    super.initState();
    // Clear previous selections when screen loads
    _helpController.resetFields();
    _helpController.fetchIssues();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Scrollable content area
          SingleChildScrollView(
            padding: EdgeInsets.symmetric(
                horizontal: mq.width * .02, vertical: mq.height * .01),
            child: Obx(() => Column(children: [
                  _buildTitle(), // Heading with dynamic error/status text
                  _buildIssueList(), // List of issue toggle buttons with conditional form
                ])),
          ),

          // Show loading indicator if an API call is ongoing
          Obx(() => _helpController.isLoading.value
              ? customCircularProgressIndicator()
              : const SizedBox.shrink()),
        ],
      ),
    );
  }

  /// Builds the screen title or error message based on current state
  Widget _buildTitle() {
    final error = _helpController.issuesError.value;
    final raiseTicketError = _helpController.raiseTicketError.value;
    return Center(
      child: Column(
        children: [
          Text(
            error ?? 'Select your concern',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: error != null ? Colors.red : Colors.black,
            ),
          ),
          if (raiseTicketError != null)
            Text(
              raiseTicketError,
              style: TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
        ],
      ),
    );
  }

  /// Builds the list of issue toggle buttons and sub-form based on selection
  Widget _buildIssueList() {
    return Column(
      children: _helpController.issues.map((issue) {
        final isSelected =
            _helpController.selectedIssueId.value == issue.issueId;
        return Padding(
          padding: EdgeInsets.only(bottom: mq.height * .01),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Toggle button for each issue
              SizedBox(
                width: mq.width,
                child: ToggleOutlineButton(
                  text: issue.issue,
                  isActive: isSelected,
                  onToggle: () => _handleIssueToggle(issue, isSelected),
                ),
              ),

              // If selected, show dropdown/sub-issue options or form
              if (isSelected) ...[
                SizedBox(height: mq.height * .01),

                // Show loading while fetching sub-issues
                if (_helpController.isSubIssueLoading.value)
                  const Center(child: CircularProgressIndicator())

                // Show dropdown if sub-issues are loaded
                else if (_helpController.subIssues.isNotEmpty)
                  _buildDropdown(),

                SizedBox(height: mq.height * .01),

                // Show form if sub-issue is selected or no dropdown needed
                if (_helpController.selectedDropdownValue.value != null ||
                    _helpController.isShowBox.value)
                  _buildFormSubmit(),
              ],
            ],
          ),
        );
      }).toList(),
    );
  }

  /// Handles toggle behavior when an issue is selected/deselected
  void _handleIssueToggle(issue, bool isSelected) async {
    _helpController.resetAttachments();

    if (isSelected) {
      // Deselect the issue
      _helpController.clearSelection();
    } else {
      // Select a new issue
      _helpController.selectIssue(issue);

      // Directly show box for some issues, otherwise load sub-issues
      if (issue.issueId == 5 || issue.issueId == 6) {
        _helpController.isShowBox.value = true;
      } else {
        _helpController.isSubIssueLoading.value = true;
        await _helpController.fetchSubIssues(issue.issueId);
        _helpController.isSubIssueLoading.value = false;
      }
    }
  }

  /// Dropdown to select sub-issue
  Widget _buildDropdown() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: mq.width * .01),
      child: CustomDropdown(
        hintText: 'Select an issue',
        options:
            _helpController.subIssues.map((item) => item.subIssue).toList(),
        selectedValue: _helpController.selectedDropdownValue.value,
        onChanged: (value) {
          value != null
              ? _helpController.handleDropdownSelection(value)
              : _helpController.selectedDropdownValue.value = null;
        },
      ),
    );
  }

  /// Builds the issue form for description and file attachments
  Widget _buildFormSubmit() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Optional field for LR/Claim number
          if (_helpController.shouldShowOtherField())
            Padding(
              padding: EdgeInsets.symmetric(horizontal: mq.width * .01),
              child: TextFormField(
                controller: _helpController.otherFieldController,
                decoration: InputDecoration(
                  labelText: _helpController.labelText.value,
                  border: const OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Please ${_helpController.labelText.value}'
                    : null,
              ),
            ),

          SizedBox(height: mq.height * .01),

          // Description input and file picker
          Row(
            children: [
              // Text field for user to describe the issue
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: mq.width * .01),
                  child: TextFormField(
                    controller: _helpController.descriptionController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      labelText: 'Describe your issue',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Please describe your issue'
                        : null,
                  ),
                ),
              ),
              // File picker icon
              _buildAttachmentIcon(),
            ],
          ),

          SizedBox(height: mq.height * .01),

          // Submit button
          Padding(
            padding: EdgeInsets.symmetric(horizontal: mq.width * .01),
            child: CustomElevatedButton(
              onTap: () async {
                _helpController.clearErrors();
                if (_formKey.currentState!.validate()) {
                  bool checkInt = await checkInternet();
                  checkInt ? _helpController.submitForm() : internetNotAvl();
                }
              },
              text: 'Raise Ticket',
            ),
          ),
        ],
      ),
    );
  }

  /// File picker icon with state-based feedback
  Widget _buildAttachmentIcon() {
    return IconButton(
      onPressed: _pickFiles,
      icon: Icon(
        _helpController.isFileSelected.value ? Icons.check : Icons.attach_file,
        color: AppColor.primary,
      ),
    );
  }

  /// Opens the file picker and handles user selection
  Future<void> _pickFiles() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'jpg', 'jpeg', 'png'],
    );

    if (result != null && result.files.length <= 10) {
      _helpController.selectedFiles.value = result.files;
      _helpController.isFileSelected.value = true;
      CustomBottomSheet.showSnackBar(
          context, "${result.files.length} file(s) selected");
    } else if (result != null) {
      _helpController.isFileSelected.value = false;
      CustomBottomSheet.showSnackBar(
          context, "You can only select up to 10 files.");
    } else {
      CustomBottomSheet.showSnackBar(context, "No file selected");
    }
  }
}
