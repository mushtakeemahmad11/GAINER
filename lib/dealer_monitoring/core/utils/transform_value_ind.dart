import 'package:intl/intl.dart';

class TransformValue {
  //convert number to Indian system format
  String formatIndianNumber(int number) {
    final NumberFormat indianFormat = NumberFormat.decimalPattern('en_IN');
    return indianFormat.format(number);
  }

  // String formatDateToIndianDate(String dateStr, {bool day = false}) {
  //   final DateTime utcDate = DateTime.parse(dateStr);
  //   // .toLocal(); // Convert to local time (Z+5:30H)
  //   // final DateFormat formatter = DateFormat('MMM dd yyyy  h:mma');
  //   final DateFormat formatter =
  //       // day ? DateFormat('MMM dd yy') : DateFormat('MMM yyyy');
  //       day ? DateFormat('dd-MMM-yy') : DateFormat('MMM yyyy');
  //   return formatter.format(utcDate); // Example: Apr 18 2025  1:38PM
  // }

  String formatDateToIndianDate(String? dateStr, {bool day = false}) {
    if (dateStr == null || dateStr.trim().isEmpty) {
      return day ? 'DD-MM-YY' : 'MM YY';
    }

    try {
      final DateTime utcDate = DateTime.parse(dateStr);
      final DateFormat formatter =
          day ? DateFormat('dd-MMM-yy') : DateFormat('MMM yyyy');
      return formatter.format(utcDate);
    } catch (e) {
      return day ? 'DD-MM-YY' : 'MM YY';
    }
  }

  // String formatDateToIndianDate(String dateStr) {
  //   // Parse the date string. DateTime.parse handles ISO 8601 strings,
  //   // which is typically what you get from JSON or date pickers.
  //   // .toLocal() converts it to the device's local timezone.
  //   final DateTime date = DateTime.parse(dateStr).toLocal();
  //
  //   // Define the desired date format: day-month-year
  //   final DateFormat formatter = DateFormat('dd-MM-yyyy'); // Changed format
  //
  //   // Format the date and return the string
  //   return formatter.format(date);
  // }

  // String formatToIST(String utcTimestamp) {
  //   final utcDate = DateTime.parse(utcTimestamp);
  //   final istDate = utcDate
  //       .toLocal(); // Automatically converts to device time zone (IST if device is set to IST)
  //   return DateFormat('yyyy-MM-dd HH:mm:ss').format(istDate);
  // }
  //
  // String formatISTDateOnly(String utcTimestamp) {
  //   final utcDate = DateTime.parse(utcTimestamp);
  //   final istDate = utcDate.toLocal(); // Converts to IST if phone is set to IST
  //   return DateFormat('yyyy-MM-dd').format(istDate);
  // }

  String formatToReadableDate(String? isoDate) {
    if (isoDate == null || isoDate.trim().isEmpty) {
      return "--/--/----"; // Or "No Date"
    }

    try {
      final utcDate = DateTime.parse(isoDate);
      // final istDate = utcDate.toLocal(); // Converts to IST
      // DateTime date = DateTime.parse(isoDate).toLocal(); // Convert to local time
      // print("isoDate: $isoDate");
      // print("utcDate: $utcDate");
      // print("istDate: $istDate");
      // int day = istDate.day;
      int day = utcDate.day;

      // Determine suffix
      String suffix;
      if (day >= 11 && day <= 13) {
        suffix = 'th';
      } else {
        switch (day % 10) {
          case 1:
            suffix = 'st';
            break;
          case 2:
            suffix = 'nd';
            break;
          case 3:
            suffix = 'rd';
            break;
          default:
            suffix = 'th';
        }
      }

      const monthNames = [
        '',
        'January',
        'February',
        'March',
        'April',
        'May',
        'June',
        'July',
        'August',
        'September',
        'October',
        'November',
        'December'
      ];

      // return '$day$suffix ${monthNames[istDate.month]} ${istDate.year}';
      return '$day$suffix ${monthNames[utcDate.month]} ${utcDate.year}';
    } catch (e) {
      return "--/--/----"; // In case parsing fails
    }
  }
}
