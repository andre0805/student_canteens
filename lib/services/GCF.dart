import 'package:student_canteens/models/SCUser.dart';

class GCF {
  static const String BASE_URL =
      'https://us-central1-student-canteens.cloudfunctions.net';
  static const String GET_CANTEENS = '/getCanteens';
  static const String CREATE_USER = '/createUser';

  static const GCF sharedInstance = GCF._();

  const GCF._();
}
