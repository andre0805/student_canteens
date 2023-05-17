import 'package:student_canteens/models/Canteen.dart';
import 'package:student_canteens/models/QueueLength.dart';
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
  static const String REPORT_QUEUE_LENGTH = '/addReport';
  static const String REMOVE_QUEUE_LENGTH_REPORT = '/removeReport';

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
      Uri.parse(BASE_URL + GET_CANTEEN + '?id=' + canteenId.toString()),
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
      final List<dynamic> json = jsonDecode(response.body);
      final Set<int> favoriteCanteens = json
          .map((e) => Map<String, int>.from(e))
          .map((e) => e.values.first)
          .toSet();
      return favoriteCanteens;
    } else {
      return {};
    }
  }

  Future<bool> addFavoriteCanteen(int canteenId) async {
    String? userId = sessionManager.currentUser?.id;

    if (userId == null) return false;

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

    if (response.statusCode == 201) {
      sessionManager.currentUser?.favoriteCanteens.add(canteenId);
      return true;
    } else {
      return false;
    }
  }

  Future<bool> removeFavoriteCanteen(int canteenId) async {
    String? userId = sessionManager.currentUser?.id;

    if (userId == null) return false;

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
      sessionManager.currentUser?.favoriteCanteens.remove(canteenId);
      return true;
    } else {
      return false;
    }
  }

  Future<int?> reportQueueLength(
      int canteenId, QueueLength queueLength, String? description) async {
    String? userId = sessionManager.currentUser?.id;

    if (userId == null) return null;

    http.Response response = await http.post(
      Uri.parse(BASE_URL + REPORT_QUEUE_LENGTH),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, dynamic>{
          "userId": userId,
          "canteenId": canteenId,
          "queueLength": queueLength.index,
          "description": description,
        },
      ),
    );

    if (response.statusCode == 201) {
      List<dynamic> json = jsonDecode(response.body);
      return json.first['id'];
    } else {
      return null;
    }
  }

  Future<bool> removeQueueLengthReport(int reportId) async {
    http.Response response = await http.post(
      Uri.parse(BASE_URL + REMOVE_QUEUE_LENGTH_REPORT),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, dynamic>{
          "reportId": reportId,
        },
      ),
    );

    return response.statusCode == 200;
  }
}
