import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:student_canteens/models/SCUser.dart';
import 'package:student_canteens/services/GCF.dart';

class AuthService {
  GCF gcf = GCF.sharedInstance;

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

  Future<void> signIn(String email, String password) async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
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

    User user = userCredential.user!;

    SCUser newUser = SCUser(
      id: userCredential.user!.uid,
      name: user.displayName ?? "Unknown",
      surname: "",
      email: googleUser.email,
    );

    await gcf.createUser(newUser);
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<void> forgotPassword(String email) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }
}
