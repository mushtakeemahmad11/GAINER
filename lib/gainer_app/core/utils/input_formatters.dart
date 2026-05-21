import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../widgets/gainer_bottom_sheet.dart';

class GainerInputFormatters {
  /// Letters + numbers + space + - /
  static final alphaNumericWithSpace = FilteringTextInputFormatter.allow(
    RegExp(r'[a-zA-Z0-9\-\/ ]'),
  );

  /// Only numbers
  static final numbersOnly = FilteringTextInputFormatter.digitsOnly;

  /// ✅ Discount: 0 → 99, decimal allowed, max 2 digits after decimal
  static final discountFormatter = FilteringTextInputFormatter.allow(
    RegExp(r'^(?:[0-9]|[1-9][0-9]?)(?:\.\d{0,2})?$'),
  );

  /// ✅ Stock: > 0, decimal allowed, max 2 digits
  static final stockFormatter = FilteringTextInputFormatter.allow(
    RegExp(r'^[1-9]\d*(?:\.\d{0,2})?$'),
  );

  static final positiveNumbers =
      FilteringTextInputFormatter.allow(RegExp(r'[1-9][0-9]*'));

  /// Letters only
  // static final lettersOnly = FilteringTextInputFormatter.allow(
  //   RegExp(r'[a-zA-Z ]'),
  // );

  /// Part numbers style
  static final partNumber = FilteringTextInputFormatter.allow(
    RegExp(r'[a-zA-Z0-9\-\/]'),

    // RegExp(r'[A-Z0-9\-\/ ]'),
  );

  /// Email friendly
  static final email = FilteringTextInputFormatter.allow(
    RegExp(r'[a-zA-Z0-9@._\-]'),
  );
}

class PartNumberFormatter extends TextInputFormatter {
  // final _allowed = RegExp(r'[A-Z0-9\-\/]');
  final _allowed = RegExp(r'[A-Z0-9\-\/,]'); // <-- Allow

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final upper = newValue.text.toUpperCase();

    final filtered = upper.split('').where(_allowed.hasMatch).join();

    return TextEditingValue(text: filtered, selection: newValue.selection);
  }
}

class QtyLimitFormatter extends TextInputFormatter {
  final int maxReqQty;
  final int maxAvlQty;
  final BuildContext context;

  QtyLimitFormatter({
    required this.maxReqQty,
    required this.maxAvlQty,
    required this.context,
  });

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Allow empty
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Block leading zero
    if (newValue.text.startsWith('0')) {
      return oldValue;
    }

    // Prevent leading zero
    if (newValue.text.length > 1 && newValue.text.startsWith('0')) {
      return oldValue;
    }

    final int? value = int.tryParse(newValue.text);
    if (value == null) {
      return oldValue;
    }

    if (value > maxReqQty) {
      GainerBottomSheet.showSnackBar(
        "Accept Qty can't be greater than Request Qty $maxReqQty",
      );
      return oldValue;
    }

    if (value > maxAvlQty) {
      GainerBottomSheet.showSnackBar(
        "Accept Qty can't be greater than Available Qty $maxAvlQty",
      );
      return oldValue;
    }

    return newValue;
  }
}
