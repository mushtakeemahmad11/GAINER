import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ByLocationController extends GetxController {
  final TextEditingController locationAuditId = TextEditingController();
  final TextEditingController scanPartNumber = TextEditingController();
  final TextEditingController selectLocation = TextEditingController();
  final TextEditingController partNumberScan = TextEditingController();
  final TextEditingController partNumberUser = TextEditingController();
  final TextEditingController partDescription = TextEditingController();

  // List to store dropdown values from the database
  List<String> dropdownItems = [
    'value1',
    'value2',
    'value3',
    'value4',
    'value5'
  ];

  List<String> remarksItem = [
    'Damaged',
    'Without packing/label',
    'Part number doubtful',
    'Rusty',
    'Need to relocate'
  ];


  RxnString location = RxnString(null);
  RxnString remarks = RxnString(null);
}

class LocationGenericController extends GetxController{
  final TextEditingController locationNum = TextEditingController();
  final TextEditingController partNum = TextEditingController();
  final TextEditingController description = TextEditingController();
}
