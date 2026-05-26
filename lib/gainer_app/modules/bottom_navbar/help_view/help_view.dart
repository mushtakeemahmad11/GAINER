import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:gainer/gainer_app/core/widgets/gainer_app_loader.dart';
import 'package:gainer/gainer_app/core/widgets/gainer_bottom_sheet.dart';
import 'package:gainer/gainer_app/core/widgets/gainer_dropdown.dart';
import 'package:gainer/gainer_app/core/widgets/gainer_primary_button.dart';
import 'package:gainer/gainer_app/core/widgets/gainer_text_form_field.dart';
import 'package:get/get.dart';
import '../../../core/constants/gainer_color.dart';
import '../../../core/widgets/gainer_toggle_outlined_btn.dart';
import 'help_controller.dart';

class HelpView extends GetView<HelpController> {
  const HelpView({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        // Scrollable content area
        SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
          child: Obx(() => Column(children: [
                // Heading with dynamic error/status text
                _buildTitle(),
                // List of issue toggle buttons with conditional form
                _buildIssueList(size),
              ])),
        ),

        // Show loading indicator if an API call is ongoing
        GainerAppLoader(isLoading: controller.isLoading),
      ],
    );
  }

  /// Builds the screen title or error message based on current state
  Widget _buildTitle() {
    final error = controller.issuesError.value;
    final raiseTicketError = controller.raiseTicketError.value;
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
  Widget _buildIssueList(Size size) {
    return Column(
      children: controller.issues.map((issue) {
        final isSelected = controller.selectedIssueId.value == issue.issueId;
        return Padding(
          padding: EdgeInsets.only(bottom: size.height * .01),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Toggle button for each issue
              SizedBox(
                width: size.width,
                child: GainerToggleOutlineBtn(
                  text: issue.issue,
                  isActive: isSelected,
                  onToggle: () => _handleIssueToggle(issue, isSelected),
                ),
              ),

              // If selected, show dropdown/sub-issue options or form
              if (isSelected) ...[
                SizedBox(height: size.height * .01),

                // Show loading while fetching sub-issues
                if (controller.isSubIssueLoading.value)
                  const Center(child: CircularProgressIndicator())

                // Show dropdown if sub-issues are loaded
                else if (controller.subIssues.isNotEmpty)
                  _buildDropdown(size),

                const SizedBox(height: 5),
                // Show form if sub-issue is selected or no dropdown needed
                if (controller.selectedDropdownValue.value != null ||
                    controller.isShowBox.value)
                  _buildFormSubmit(size),
              ],
            ],
          ),
        );
      }).toList(),
    );
  }

  /// Handles toggle behavior when an issue is selected/deselected
  void _handleIssueToggle(issue, bool isSelected) async {
    controller.resetAttachments();

    if (isSelected) {
      // Deselect the issue
      controller.clearSelection();
    } else {
      // Select a new issue
      controller.selectIssue(issue);

      // Directly show box for some issues, otherwise load sub-issues
      if (issue.issueId == 5 || issue.issueId == 6) {
        controller.isShowBox.value = true;
      } else {
        controller.isSubIssueLoading.value = true;
        await controller.fetchSubIssues(issue.issueId);
        controller.isSubIssueLoading.value = false;
      }
    }
  }

  /// Dropdown to select sub-issue
  Widget _buildDropdown(Size size) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * .01),
      child: GainerAppDropdown(
        hintText: 'Select an issue',
        items: controller.subIssues.map((item) => item.subIssue).toList(),
        selectedItem: controller.selectedDropdownValue.value,
        onChanged: (value) {
          value != null
              ? controller.handleDropdownSelection(value)
              : controller.selectedDropdownValue.value = null;
        },
      ),
    );
  }

  /// Builds the issue form for description and file attachments
  Widget _buildFormSubmit(Size size) {
    return Form(
      key: controller.formKey,
      child: Column(
        children: [
          // Optional field for LR/Claim number
          if (controller.shouldShowOtherField())
            Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * .01),
              child: GainerTextFormField(
                controller: controller.otherFieldController,
                label: controller.labelText.value,
                validator: (value) => value == null || value.isEmpty
                    ? 'Please ${controller.labelText.value}'
                    : null,
              ),
            ),

          const SizedBox(height: 5),

          // Description input and file picker
          Row(
            children: [
              // Text field for user to describe the issue
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * .01),
                  child: GainerTextFormField(
                    controller: controller.descriptionController,
                    maxLines: 4,
                    label: 'Describe your issue',
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

          SizedBox(height: size.height * .01),

          // Submit button
          Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * .01),
            child: GainerPrimaryButton(
              onPressed: controller.submitForm,
              // onPressed: () async {
              //   controller.clearErrors();
              //   if (_formKey.currentState!.validate()) controller.submitForm();
              //   // if (_formKey.currentState!.validate()) {
              //
              //   // bool checkInt = await checkInternet();
              //   // checkInt ? controller.submitForm() : internetNotAvl();
              //   // }
              // },
              title: 'Raise Ticket',
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
        controller.isFileSelected.value
            ? Icons.check_circle
            : Icons.attach_file,
        color: GainerColors.primary,
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
      controller.selectedFiles.value = result.files;
      controller.isFileSelected.value = true;
      GainerBottomSheet.showSnackBar("${result.files.length} file(s) selected");
    } else if (result != null) {
      controller.isFileSelected.value = false;
      GainerBottomSheet.showSnackBar("You can only select up to 10 files.");
    } else {
      GainerBottomSheet.showSnackBar("No file selected");
    }
  }
}
