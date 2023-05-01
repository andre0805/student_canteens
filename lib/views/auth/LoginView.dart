import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:student_canteens/services/AuthService.dart';
import 'RegisterView.dart';
import 'package:flutter/cupertino.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _AuthViewState();
}

class _AuthViewState extends State<LoginView> {
  AuthService authService = AuthService();

  String email = "";
  String password = "";

  String? emailError;
  String? passwordError;

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
                    email = value;
                  },
                  decoration: InputDecoration(
                    labelText: "Email",
                    errorText: emailError,
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade900),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                TextField(
                  onChanged: (value) {
                    password = value;
                  },
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Lozinka",
                    errorText: passwordError,
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade900),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                ElevatedButton(
                  onPressed: () {
                    signIn();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[900],
                  ),
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
                  onPressed: () => {},
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

  void signIn() async {
    if (!validateInput()) return;

    showLoadingDialog();

    try {
      await authService.signIn(email, password);
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      processFirebaseErrorCode(e.code);
    } catch (e) {
      Navigator.pop(context);
      showAlertDialog("Greška", "Došlo je do pogreške");
    }
  }

  bool validateInput() {
    setState(() {
      emailError = email.isEmpty ? "Potrebna email adresa" : null;
      passwordError = password.isEmpty ? "Potrebna lozinka" : null;
    });

    return emailError == null && passwordError == null;
  }

  void processFirebaseErrorCode(String errorCode) {
    setState(() {
      if (errorCode == 'user-not-found' || errorCode == 'wrong-password') {
        emailError = "Pogrešan email ili lozinka";
        passwordError = "Pogrešan email ili lozinka";
      } else if (errorCode == 'invalid-email') {
        emailError = "Neispravan email";
      } else {
        showAlertDialog("Greška", "Došlo je do pogreške");
      }
    });
  }

  void showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  void showAlertDialog(String title, String subtitle) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(subtitle),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
