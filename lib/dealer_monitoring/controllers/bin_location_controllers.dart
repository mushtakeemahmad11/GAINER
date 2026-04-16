import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:excel/excel.dart';

class BinLocationController extends GetxController {
  var searchResults = <Map<String, String>>[].obs;
  final TextEditingController searchController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  void search() {
    if (formKey.currentState!.validate()) {
      handleSearch();
    }
  }

  void handleSearch() {
    final input = searchController.text.trim();
    final parts =
        input.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty);

    // searchResults.clear();
    for (var part in parts) {
      searchResults.add({"Part Number": part, "Bin Location": "Coming Soon"});
    }
  }

  Future<void> pickFile() async {
    // try {
    //   FilePickerResult? result = await FilePicker.platform.pickFiles(
    //     type: FileType.custom,
    //     allowedExtensions: ['txt', 'csv', 'xlsx'],
    //   );
    //
    //   if (result != null) {
    //     PlatformFile file = result.files.first;
    //
    //     searchResults.clear();
    //
    //     if (file.extension == 'xlsx') {
    //       // final bytes = File(file.path!).readAsBytesSync();
    //       // final excel = Excel.decodeBytes(bytes);
    //       //
    //       // for (var table in excel.tables.keys) {
    //       //   for (var row in excel.tables[table]!.rows) {
    //       //     if (row.isNotEmpty) {
    //       //       final part = row[0]?.value.toString().trim();
    //       //       if (part != null && part.isNotEmpty) {
    //       //         searchResults.add({"Part Number": part, "Bin Location": "From Excel"});
    //       //       }
    //       //     }
    //       //   }
    //       // }
    //     } else {
    //       final content = await File(file.path!).readAsString();
    //       final lines = content.split(RegExp(r'[\n\r]+'));
    //       for (var line in lines) {
    //         final part = line.trim();
    //         if (part.isNotEmpty) {
    //           searchResults.add({"Part Number": part, "Bin Location": "From File"});
    //         }
    //       }
    //     }
    //   }
    // } catch (e) {
    //   print("Error reading file: $e");
    // }
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
