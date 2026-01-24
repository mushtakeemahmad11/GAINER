import 'package:intl/intl.dart';

class FormatDateTime {
  static String formatCustomDateTime({required String inputDateTimeStr}) {
    final inputFormat = DateFormat('dd-MM-yyyy HH:mm:ss');
    final DateTime inputDateTime = inputFormat.parse(inputDateTimeStr);
    final now = DateTime.now();
    final input =
        DateTime(inputDateTime.year, inputDateTime.month, inputDateTime.day);
    final current = DateTime(now.year, now.month, now.day);

    int years = current.year - input.year;
    int months = current.month - input.month;
    int days = current.day - input.day;

    if (days < 0) {
      months -= 1;
      final previousMonth = DateTime(current.year, current.month, 0);
      days += previousMonth.day;
    }

    if (months < 0) {
      years -= 1;
      months += 12;
    }

    final parts = <String>[];

    if (years > 0) parts.add('$years ${years == 1 ? 'year\n' : 'years\n'}');
    if (months > 0) {
      parts.add('$months ${months == 1 ? 'month\n' : 'months\n'}');
    }
    if (days > 0) parts.add('$days ${days == 1 ? 'day' : 'days'}');

    if (parts.isEmpty) {
      // If it's the same day
      return DateFormat('hh:mm a').format(inputDateTime);
    }

    return '${parts.join('')} ago';
  }
}
