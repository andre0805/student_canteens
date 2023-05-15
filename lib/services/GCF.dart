import 'package:student_canteens/models/Canteen.dart';
import 'package:student_canteens/models/SCUser.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:student_canteens/models/WrokSchedule.dart';

class GCF {
  static const String BASE_URL =
      'https://us-central1-student-canteens.cloudfunctions.net';
  static const String GET_CANTEENS = '/getCanteens';
  static const String GET_CANTEEN = '/getCanteen';
  static const String GET_USER = '/getUser';
  static const String CREATE_USER = '/createUser';
  static const String GET_WORK_SCHEDULE = '/getWorkSchedule';

  static const GCF sharedInstance = GCF._();

  const GCF._();

  Future<SCUser?> getUser(String email) async {
    http.Response response = await http.get(
      Uri.parse(BASE_URL + GET_USER + '?email=' + email),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      return SCUser.fromJson(json);
    } else {
      return null;
    }
  }

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

  Future<List<Canteen>> getCanteens() async {
    http.Response response = await http.get(
      Uri.parse(BASE_URL + GET_CANTEENS),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> json = jsonDecode(response.body);
      return json.map((e) => Canteen.fromJson(e)).toList();
    } else {
      return [];
    }
  }

  Future<Canteen?> getCanteen(int canteenId) async {
    http.Response response = await http.get(
      Uri.parse(BASE_URL + GET_CANTEEN + '?canteenId=' + canteenId.toString()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      return Canteen.fromJson(json);
    } else {
      return null;
    }
  }

  Future<Set<WorkSchedule>> getWorkSchedule(int canteenId) async {
    http.Response response = await http.get(
      Uri.parse(
          BASE_URL + GET_WORK_SCHEDULE + '?canteenId=' + canteenId.toString()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> json = jsonDecode(response.body);
      return json.map((e) => WorkSchedule.fromJson(e)).toSet();
    } else {
      return {};
    }
  }
}
