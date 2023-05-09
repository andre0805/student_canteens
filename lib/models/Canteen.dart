import 'dart:ffi';

class Canteen {
  final int id;
  final String name;
  final String address;
  final int cityId;
  final String? contact;
  final String? url;
  final String? imageUrl;
  final String latitude;
  final String longitude;

  Canteen({
    required this.id,
    required this.name,
    required this.address,
    required this.cityId,
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
      cityId: json['city_id'],
      contact: json['contact'],
      url: json['url'],
      imageUrl: json['cover_picture'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }
}
