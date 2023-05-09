class SCUser {
  final String? id;
  final String name;
  final String surname;
  final String email;

  SCUser({
    this.id,
    required this.name,
    required this.surname,
    required this.email,
  });

  factory SCUser.fromJson(Map<String, dynamic> json) {
    return SCUser(
      id: json['id'],
      name: json['name'],
      surname: json['surname'],
      email: json['email'],
    );
  }
}
