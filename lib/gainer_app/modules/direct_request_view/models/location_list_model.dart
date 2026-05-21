class LocationListModel {
  final String location;
  final int locationId;

  LocationListModel({
    required this.location,
    required this.locationId,
  });

  factory LocationListModel.fromJson(Map<String, dynamic> json) {
    return LocationListModel(
      location: json['Location'] ?? '',
      locationId: json['LocationId'] ?? 0,
    );
  }
}