import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:student_canteens/models/SCUser.dart';
import 'package:student_canteens/services/GCF.dart';
import 'package:student_canteens/services/SessionManager.dart';

class AuthService {
  final GCF gcf = GCF.sharedInstance;
  final SessionManager sessionManager = SessionManager.sharedInstance;

  static final AuthService sharedInstance = AuthService._();

  AuthService._();

  Future<void> signUp(SCUser user, String password) async {
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: user.email, password: password);

    SCUser newUser = SCUser(
      id: userCredential.user!.uid,
      name: user.name,
      surname: user.surname,
      email: user.email,
    );

    await gcf.createUser(newUser);
  }

  Future<void> signInUser(User user) async {
    await gcf.getUser(user.email!).then((SCUser? scUser) {
      if (scUser != null) {
        sessionManager.signIn(scUser);
      } else {
        throw Exception("User not found");
      }
    });
  }

  Future<void> signIn(String email, String password) async {
    SCUser? user = await gcf.getUser(email);

    if (user == null) {
      throw Exception("User not found");
    }

    UserCredential userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);

    if (userCredential.user == null) {
      throw Exception("User not found");
    }

    sessionManager.signIn(user);
  }

  Future<void> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    User? user = userCredential.user;

    if (user == null) {
      throw Exception("User not found");
    }

    SCUser? scUser = await gcf.getUser(user.email!);

    if (scUser != null) {
      sessionManager.signIn(scUser);
      return;
    } else {
      SCUser newUser = SCUser(
        id: userCredential.user!.uid,
        name: user.displayName ?? "Unknown",
        surname: "",
        email: googleUser.email,
      );

      await gcf.createUser(newUser);
      sessionManager.signIn(newUser);
    }
  }

  Future<void> signOut() async {
    sessionManager.signOut();
    await FirebaseAuth.instance.signOut();
  }

  Future<void> forgotPassword(String email) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }
}
