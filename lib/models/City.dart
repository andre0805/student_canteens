class City {
  final int id;
  final String name;
  final String zipCode;
  final int countyId;
  final String countyName;

  City({
    required this.id,
    required this.name,
    required this.zipCode,
    required this.countyId,
    required this.countyName,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json['id'],
      name: json['city'],
      zipCode: json['zip_code'],
      countyId: json['county_id'],
      countyName: json['county_name'],
    );
  }
}
