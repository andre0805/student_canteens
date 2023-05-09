import 'package:student_canteens/models/SCUser.dart';

class SessionManager {
  static final SessionManager sharedInstance = SessionManager._();

  SessionManager._();

  SCUser? currentUser;

  void signIn(SCUser user) {
    currentUser = user;
  }

  void signOut() {
    currentUser = null;
  }
}
