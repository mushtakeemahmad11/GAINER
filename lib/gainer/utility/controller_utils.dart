class ControllerUtils {
  static Future<String> remarksValidation(String remarksText) async {
    // Allow only letters, numbers, spaces, dashes (-),commas (,), and Full Stop(.)
    String filteredValue =
        remarksText.replaceAll(RegExp(r'[^a-zA-Z0-9 ,\-\.]'), '');

    // Prevent starting with space, dash, dot or comma
    while (filteredValue.startsWith(RegExp(r'[ ,\-\.]'))) {
      filteredValue = filteredValue.substring(1);
    }

    return filteredValue;
  }

  // allow only alpha numeric character
  static Future<String> alphaNumericValidation(String remarksText) async {
    // Allow only letters and numbers, remove everything else
    String filteredValue = remarksText.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '');
    return filteredValue;
  }

//allow only alpha numeric and _,/ character for enter PartNumber
  static Future<String> partNumberValidation(String remarksText) async {
    String filteredValue =
        remarksText.replaceAll(RegExp(r'[^a-zA-Z0-9-/]'), '');

    return filteredValue.toUpperCase();
  }

  //only numeric characters (0-9)
  static Future<String> numericOnly(String inputText, int maxLength) async {
    // Remove all non-numeric characters
    String filteredValue = inputText.replaceAll(RegExp(r'[^0-9]'), '');

    // Trim to maxLength if it exceeds
    if (filteredValue.length > maxLength) {
      filteredValue = filteredValue.substring(0, maxLength);
    }

    return filteredValue;
  }

  //Only numbers, Decimal places, Total length
  static Future<String> numericWithDecimal(
      String inputText, int decimalPlaces, int maxValue) async {
    // Allow only numbers and at most one decimal point
    String filteredValue = inputText.replaceAll(RegExp(r'[^0-9.]'), '');

    // Ensure there's only one decimal point
    int firstDecimalIndex = filteredValue.indexOf('.');
    if (firstDecimalIndex != -1) {
      // Keep only the first decimal and remove extra decimals
      filteredValue = filteredValue.substring(0, firstDecimalIndex + 1) +
          filteredValue.substring(firstDecimalIndex + 1).replaceAll('.', '');

      // Limit the number of digits after the decimal based on parameter
      List<String> parts = filteredValue.split('.');
      if (parts.length > 1 && parts[1].length > decimalPlaces) {
        parts[1] = parts[1].substring(0, decimalPlaces);
      }
      filteredValue = parts.join('.');
    }

    // // Ensure the total length does not exceed maxLength
    // if (filteredValue.length > maxLength) {
    //   filteredValue = filteredValue.substring(0, maxLength);
    // }

    // Prevent the input from starting with zero unless it's "0."
    while (filteredValue.startsWith("0") &&
        filteredValue.length > 1 &&
        filteredValue[1] != '.') {
      filteredValue = filteredValue.substring(1);
    }

    // Convert to double for comparison
    double numericValue = double.tryParse(filteredValue) ?? 0.0;

    // Ensure the value does not exceed the maxValue
    if (numericValue > maxValue) {
      return maxValue.toStringAsFixed(decimalPlaces);
    }

    return filteredValue;
  }
}
