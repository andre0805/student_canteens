import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:student_canteens/models/SCUser.dart';
import 'package:student_canteens/services/GCF.dart';
import 'package:student_canteens/services/SessionManager.dart';

class AuthService {
  final GCF gcf = GCF.sharedInstance;
  final SessionManager sessionManager = SessionManager.sharedInstance;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  static final AuthService sharedInstance = AuthService._();

  AuthService._();

  Future<void> signUp(SCUser user, String password) async {
    SCUser newUser = SCUser(
      name: user.name,
      surname: user.surname,
      email: user.email,
    );

    await gcf.createUser(newUser);

    await firebaseAuth.createUserWithEmailAndPassword(
        email: user.email, password: password);
  }

  Future<void> signInUser(User user) async {
    SCUser? scUser = await gcf.getUser(user.email!);

    if (scUser == null) {
      throw Exception("User not found");
    } else {
      sessionManager.signIn(scUser);
    }
  }

  Future<void> signIn(String email, String password) async {
    SCUser? user = await gcf.getUser(email);

    if (user == null) {
      throw Exception("User not found");
    }

    sessionManager.signIn(user);

    UserCredential userCredential = await firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password);

    if (userCredential.user == null) {
      throw Exception("User not found");
    }
  }

  Future<void> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser == null) {
      throw Exception("User not found");
    }

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    SCUser? scUser = await gcf.getUser(googleUser.email);

    if (scUser != null) {
      sessionManager.signIn(scUser);
    } else {
      SCUser newUser = SCUser(
        name: googleUser.displayName?.split(" ")[0] ?? "",
        surname: googleUser.displayName?.split(" ")[1] ?? "",
        email: googleUser.email,
      );

      await gcf.createUser(newUser);
      sessionManager.signIn(newUser);
    }

    await firebaseAuth.signInWithCredential(credential);
  }

  Future<void> signOut() async {
    if (firebaseAuth.currentUser != null) {
      await firebaseAuth.signOut();
    }

    sessionManager.signOut();
  }

  Future<void> forgotPassword(String email) async {
    await firebaseAuth.sendPasswordResetEmail(email: email);
  }
}
