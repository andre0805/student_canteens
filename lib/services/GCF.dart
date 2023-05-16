import 'package:student_canteens/models/Canteen.dart';
import 'package:student_canteens/models/SCUser.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:student_canteens/models/WorkSchedule.dart';
import 'package:student_canteens/services/SessionManager.dart';

class GCF {
  static const String BASE_URL =
      'https://us-central1-student-canteens.cloudfunctions.net';
  static const String GET_CANTEENS = '/getCanteens';
  static const String GET_CANTEEN = '/getCanteen';
  static const String GET_USER = '/getUser';
  static const String CREATE_USER = '/createUser';
  static const String GET_WORK_SCHEDULE = '/getWorkSchedule';
  static const String GET_FAVORITE_CANTEENS = '/getFavoriteCanteens';
  static const String ADD_FAVORITE_CANTEEN = '/addFavoriteCanteen';
  static const String REMOVE_FAVORITE_CANTEEN = '/removeFavoriteCanteen';

  static const GCF sharedInstance = GCF._();

  const GCF._();

  static final SessionManager sessionManager = SessionManager.sharedInstance;

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

  Future<Set<int>> getFavoriteCanteens() async {
    String? userId = sessionManager.currentUser?.id;

    if (userId == null) return {};

    http.Response response = await http.post(
      Uri.parse(BASE_URL + GET_FAVORITE_CANTEENS),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, dynamic>{
          "userId": userId,
        },
      ),
    );

    if (response.statusCode == 200) {
      print(jsonDecode(response.body));
      List<dynamic> json = jsonDecode(response.body);
      return json.map((e) => e as int).toSet();
    } else {
      return {};
    }
  }

  Future<void> addFavoriteCanteen(int canteenId) async {
    String? userId = sessionManager.currentUser?.id;

    if (userId == null) return;

    http.Response response = await http.post(
      Uri.parse(BASE_URL + ADD_FAVORITE_CANTEEN),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, dynamic>{
          "userId": userId,
          "canteenId": canteenId,
        },
      ),
    );

    if (response.statusCode == 200) {
      sessionManager.currentUser?.favoriteCanteens?.add(canteenId);
    }
  }

  Future<void> removeFavoriteCanteen(int canteenId) async {
    String? userId = sessionManager.currentUser?.id;

    if (userId == null) return;

    http.Response response = await http.post(
      Uri.parse(BASE_URL + REMOVE_FAVORITE_CANTEEN),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, dynamic>{
          "userId": userId,
          "canteenId": canteenId,
        },
      ),
    );

    if (response.statusCode == 200) {
      sessionManager.currentUser?.favoriteCanteens?.remove(canteenId);
    }
  }
}
