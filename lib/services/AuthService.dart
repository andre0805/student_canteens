import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  Future<UserCredential> signIn(String email, String password) async {
    return await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
  }

  void signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
