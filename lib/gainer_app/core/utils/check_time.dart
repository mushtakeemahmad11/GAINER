import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class CheckTime {
  static bool is48HoursCompleted(String rawDate) {
    try {
      final cleaned = rawDate.replaceAll(RegExp(r'\s+'), ' ').trim();

      final formats = [
        // With time (AM/PM)
        DateFormat('MMM dd yyyy h:mma', 'en_US'), // Apr 15 2026 11:01AM
        DateFormat('MMM dd yyyy h:mm a', 'en_US'), // Apr 15 2026 11:01 AM

        DateFormat('dd MMM yyyy h:mma', 'en_US'), // 15 Apr 2026 11:01AM
        DateFormat('dd MMM yyyy h:mm a', 'en_US'), // 15 Apr 2026 11:01 AM

        // Without time
        DateFormat('dd MMM yyyy', 'en_US'), // 07 Apr 2026
        DateFormat('MMM dd yyyy', 'en_US'), // Apr 07 2026
      ];

      DateTime? parsedDate;

      for (final format in formats) {
        try {
          parsedDate = format.parseStrict(cleaned);
          break;
        } catch (_) {
          // silently try next format
        }
      }

      if (parsedDate == null) {
        throw FormatException('Unsupported date format: $rawDate');
      }

      return DateTime.now().difference(parsedDate).inHours >= 48;
    } catch (e) {
      debugPrint('Date parse error: $e | input: $rawDate');
      return false;
    }
  }

  // static bool is48HoursCompleted(String rawDate) {
  //   try {
  //     print("RowData:: $rawDate");  //Apr 15 2026 11:01AM//07 Apr 2026
  //     final cleaned = rawDate.replaceAll(RegExp(r'\s+'), ' ').trim();
  //
  //     final formats = [
  //       DateFormat('MMM dd yyyy h:mma', 'en_US'), // Jan 03 2026 10:30AM
  //       DateFormat('dd MMM yyyy h:mma', 'en_US'), // 03 Jan 2026 10:30AM
  //       DateFormat('dd MMM yyyy', 'en_US'), // 03 Jan 2026
  //       DateFormat('MMM dd yyyy', 'en_US'), // Jan 03 2026
  //     ];
  //
  //     DateTime? parsedDate;
  //
  //     for (final format in formats) {
  //       try {
  //         parsedDate = format.parseStrict(cleaned);
  //         break;
  //       } catch (e) {
  //         debugPrint('Date parse error: $e | input: $rawDate');
  //       }
  //     }
  //
  //     if (parsedDate == null) {
  //       throw FormatException('Unsupported date format');
  //     }
  //
  //     return DateTime.now().difference(parsedDate).inHours >= 48;
  //   } catch (e) {
  //     debugPrint('Date parse error: $e | input: $rawDate');
  //     return false;
  //   }
  // }
}
