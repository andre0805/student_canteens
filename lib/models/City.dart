import 'dart:ffi';

class City {
  final Long id;
  final String name;
  final String zipCode;
  final String countyId;

  City({
    required this.id,
    required this.name,
    required this.zipCode,
    required this.countyId,
  });
}
