Map<String, dynamic> transformGraphPPNIData(List<dynamic> rawData) {
  const List<String> monthNames = [
    '',
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];

  // Sort by year then month
  rawData.sort((a, b) {
    List<String> aParts = a['Date'].split('-');
    List<String> bParts = b['Date'].split('-');
    int aYear = int.parse(aParts[1]);
    int bYear = int.parse(bParts[1]);
    int aMonth = int.parse(aParts[0]);
    int bMonth = int.parse(bParts[0]);

    if (aYear == bYear) {
      return aMonth.compareTo(bMonth);
    } else {
      return aYear.compareTo(bYear);
    }
  });

  List<Map<String, double>> data = [];
  List<String> xLabels = [];

  for (var entry in rawData) {
    int month = int.parse(entry['Date'].split('-')[0]);
    // data.add({'y1': entry['PPNI_Value']});
    data.add({'y1': (entry['PPNI_Value'] as num).toDouble()});
    xLabels.add(monthNames[month]);
  }

  return {
    'data': data,
    'xLabels': xLabels,
  };
}

Map<String, dynamic> transformGraphPPNIDataLast12Months(List<dynamic> rawData) {
  const List<String> monthNames = [
    '',
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];

  // Create a lookup map: 'M-Y' => value
  final Map<String, double> dataMap = {
    for (var item in rawData)
      item['Date']: (item['PPNI_Value'] as num).toDouble(),
  };

  if (dataMap.isEmpty) return {'data': [], 'xLabels': []};

  // Get the first available date in the list
  List<String> firstParts = rawData.first['Date'].split('-');
  int startMonth = int.parse(firstParts[0]);
  int startYear = int.parse(firstParts[1]);
  DateTime startDate = DateTime(startYear, startMonth);
  List<Map<String, double>> data = [];
  List<String> xLabels = [];
  List<String> monthDate = [];

  // for (int i = 0; i < 12; i++) {
  //   int monthOffset = startMonth - i;
  //   int currentMonth = (monthOffset > 0) ? monthOffset : 12 + monthOffset;
  //   int currentYear = startYear - ((i - startMonth + 11) ~/ 12);
  //
  //   String key = "$currentMonth-$currentYear";
  //   monthDate.add(key);
  //   double value = dataMap.containsKey(key) ? dataMap[key]! : 0.0;
  //   data.insert(0, {'y1': value});
  //   // xLabels.insert(0, "${monthNames[currentMonth]} $currentYear");
  //   xLabels.insert(0, monthNames[currentMonth]);
  // }
  for (int i = 0; i < 12; i++) {
    DateTime currentDate = DateTime(startDate.year, startDate.month - i);
    String key = "${currentDate.month}-${currentDate.year}";
    monthDate.insert(0, key);

    double value = dataMap[key] ?? 0.0;
    data.insert(0, {'y1': value});
    xLabels.insert(0, monthNames[currentDate.month]);
  }
  return {
    'data': data,
    'xLabels': xLabels,
    'monthDate': monthDate,
  };
}
