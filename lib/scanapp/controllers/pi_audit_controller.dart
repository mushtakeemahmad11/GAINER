import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ByPartController extends GetxController {
  TextEditingController auditId = TextEditingController();
  TextEditingController partNumber = TextEditingController();
  TextEditingController description = TextEditingController();
  RxInt partQty = 1.obs;
  List<String> locationItem = [
    'value1',
    'value2',
    'value3',
    'value4',
    'value5'
  ];
  RxnString location = RxnString(null);
  RxnString selectedPartNumber = RxnString(null);

  void decrement() {
    if (partQty > 1) partQty--;
  }

  void increment() => partQty++;
}

class PIGenericController extends GetxController {
  TextEditingController location = TextEditingController();
  TextEditingController locationNum = TextEditingController();
  TextEditingController description = TextEditingController();

  RxInt partQty = 1.obs;
  void decrement() {
    if (partQty > 1) partQty.value--;
  }

  void increment() => partQty.value++;
}
