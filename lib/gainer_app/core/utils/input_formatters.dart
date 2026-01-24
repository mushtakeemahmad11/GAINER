import 'package:flutter/services.dart';

class GainerInputFormatters {
  /// Letters + numbers + space + - /
  static final alphaNumericWithSpace = FilteringTextInputFormatter.allow(
    RegExp(r'[a-zA-Z0-9\-\/ ]'),
  );

  /// Only numbers
  static final numbersOnly = FilteringTextInputFormatter.digitsOnly;

  /// Letters only
  static final lettersOnly = FilteringTextInputFormatter.allow(
    RegExp(r'[a-zA-Z ]'),
  );

  /// Part numbers style
  static final partNumber = FilteringTextInputFormatter.allow(
    RegExp(r'[A-Z0-9\-\/ ]'),
  );

  /// Email friendly
  static final email = FilteringTextInputFormatter.allow(
    RegExp(r'[a-zA-Z0-9@._\-]'),
  );
}
