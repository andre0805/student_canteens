class SCUser {
  final String? id;
  final String name;
  final String surname;
  final String email;
  Set<int> favoriteCanteens;

  SCUser({
    this.id,
    required this.name,
    required this.surname,
    required this.email,
    this.favoriteCanteens = const {},
  });

  factory SCUser.fromJson(Map<String, dynamic> json) {
    return SCUser(
      id: json['id'],
      name: json['name'],
      surname: json['surname'],
      email: json['email'],
    );
  }

  String getDisplayName() {
    return "$name $surname";
  }

  String getInitials() {
    return "${name[0]}${surname[0]}";
  }

  bool isFavorite(int canteenId) {
    return favoriteCanteens.contains(canteenId);
  }
}
