import 'package:student_canteens/models/SCUser.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GCF {
  static const String BASE_URL =
      'https://us-central1-student-canteens.cloudfunctions.net';
  static const String GET_CANTEENS = '/getCanteens';
  static const String CREATE_USER = '/createUser';

  static const GCF sharedInstance = GCF._();

  const GCF._();

  Future<http.Response> createUser(SCUser user) async {
    return http.post(
      Uri.parse(BASE_URL + CREATE_USER),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, String>{
          "id": user.id!,
          "name": user.name,
          "surname": user.surname,
          "email": user.email,
        },
      ),
    );
  }
}
