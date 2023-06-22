import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:student_canteens/services/AuthService.dart';
import 'package:student_canteens/utils/utils.dart';
import 'RegisterView.dart';
import 'package:flutter/cupertino.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _AuthViewState();
}

class _AuthViewState extends State<LoginView> {
  AuthService authService = AuthService.sharedInstance;

  String email = "";
  String password = "";

  String? emailError;
  String? passwordError;

  @override
  void dispose() {
    super.dispose();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                const Spacer(),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                ),
                TextField(
                  onChanged: (value) {
                    updateWidget(() {
                      email = value;
                    });
                  },
                  cursorColor: Colors.grey[900],
                  decoration: InputDecoration(
                    labelText: "Email",
                    errorText: emailError,
                    labelStyle: const TextStyle(color: Colors.grey),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade900),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(
                  height: 8,
                ),
                TextField(
                  onChanged: (value) {
                    password = value;
                  },
                  obscureText: true,
                  cursorColor: Colors.grey[900],
                  decoration: InputDecoration(
                    labelText: "Lozinka",
                    errorText: passwordError,
                    labelStyle: const TextStyle(color: Colors.grey),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade900),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: email.isEmpty ? null : forgotPassword,
                      child: Text(
                        "Zaboravljena lozinka?",
                        style: TextStyle(
                          color: email.isEmpty ? Colors.grey[500] : Colors.blue,
                          fontSize: 12,
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                ElevatedButton(
                  onPressed: () {
                    signIn();
                  },
                  child: const Text("Prijavi se"),
                ),
                const SizedBox(
                  height: 24,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Expanded(
                      child: Divider(
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      " ili ",
                      style: TextStyle(color: Colors.grey[800]),
                    ),
                    const Expanded(
                      child: Divider(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 24,
                ),
                SignInButton(
                  Buttons.Google,
                  onPressed: signInWithGoogle,
                  text: "Prijava s Google-om",
                ),
                const SizedBox(
                  height: 8,
                ),
                SignInButton(
                  Buttons.Facebook,
                  onPressed: () => {},
                  text: "Prijava s Facebook-om",
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Nemaš račun?",
                    ),
                    TextButton(
                      onPressed: () => {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            fullscreenDialog: true,
                            builder: (context) => const RegisterView(),
                          ),
                        )
                      },
                      child: const Text(
                        "Registriraj se",
                        style: TextStyle(
                          color: Colors.blue,
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void updateWidget(void Function() callback) {
    if (!mounted) return;
    setState(callback);
  }

  void signInWithGoogle() async {
    try {
      await authService.signInWithGoogle();
    } on FirebaseAuthException catch (e) {
      handleFirebaseAuthError(e.code);
    } catch (e) {
      Utils.showAlertDialog(context, "Greška", "Došlo je do pogreške");
    }
  }

  void signIn() async {
    if (!validateInput()) return;

    // Utils.showLoadingDialog(context);

    try {
      await authService.signIn(email, password);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      handleFirebaseAuthError(e.code);
    } catch (e) {
      Navigator.pop(context);
      Utils.showAlertDialog(context, "Greška", "Došlo je do pogreške");
    }
  }

  bool validateInput() {
    updateWidget(() {
      emailError = email.isEmpty ? "Potrebna email adresa" : null;
      passwordError = password.isEmpty ? "Potrebna lozinka" : null;
    });

    return emailError == null && passwordError == null;
  }

  void handleFirebaseAuthError(String errorCode) {
    updateWidget(() {
      if (errorCode == 'user-not-found' || errorCode == 'wrong-password') {
        emailError = "Pogrešan email ili lozinka";
        passwordError = "Pogrešan email ili lozinka";
      } else if (errorCode == 'invalid-email') {
        emailError = "Neispravan email";
      } else {
        Utils.showAlertDialog(context, "Greška", "Došlo je do pogreške");
      }
    });
  }

  void forgotPassword() async {
    try {
      await authService.forgotPassword(email);
      Utils.showSnackBarMessage(
          context, "Poslan je email za resetiranje lozinke");
    } on FirebaseAuthException catch (e) {
      handleFirebaseAuthError(e.code);
    } catch (e) {
      Utils.showAlertDialog(context, "Greška", "Došlo je do pogreške");
    }
  }
}
