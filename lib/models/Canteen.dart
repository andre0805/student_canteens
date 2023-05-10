import 'dart:ffi';

class Canteen {
  final int id;
  final String name;
  final String address;
  final String city;
  final String zipCode;
  final String county;
  final String? contact;
  final String? url;
  final String? imageUrl;
  final String latitude;
  final String longitude;

  Canteen({
    required this.id,
    required this.name,
    required this.address,
    required this.city,
    required this.zipCode,
    required this.county,
    required this.contact,
    required this.url,
    required this.imageUrl,
    required this.latitude,
    required this.longitude,
  });

  factory Canteen.fromJson(Map<String, dynamic> json) {
    return Canteen(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      city: json['city'],
      zipCode: json['zip_code'],
      county: json['county'],
      contact: json['contact'],
      url: json['url'],
      imageUrl: json['cover_picture'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }
}
