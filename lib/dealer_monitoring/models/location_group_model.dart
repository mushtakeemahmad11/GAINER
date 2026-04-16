class AdvisorEntry {
  final String advisor;
  final double ppniValue;

  AdvisorEntry({required this.advisor, required this.ppniValue});

  Map<String, dynamic> toJson() => {
    "Advisor": advisor,
    "PPNI Value": ppniValue,
  };
}

class LocationGroup {
  final String location;
  final String locationId;
  final double ppniTotal;
  final List<AdvisorEntry> advisors;

  LocationGroup({
    required this.location,
    required this.locationId,
    required this.ppniTotal,
    required this.advisors,
  });

  Map<String, dynamic> toJson() => {
    "Location": location,
    "LocationId": locationId,
    "PPNI Value": ppniTotal,
    "advisor": advisors.map((e) => e.toJson()).toList(),
  };
}
