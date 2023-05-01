import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:student_canteens/services/AuthService.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _AuthViewState();
}

class _AuthViewState extends State<RegisterView> {
  AuthService authService = AuthService();

  String email = "";
  String password = "";
  String confirmPassword = "";

  String? emailError;
  String? passwordError;
  String? confirmPasswordError;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: const Text("Registracija"),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.close_sharp,
            color: Colors.white,
          ),
        ),
      ),
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade900),
                    ),
                    errorText: passwordError,
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                TextField(
                  onChanged: (value) {
                    confirmPassword = value;
                  },
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Potvrdi lozinku",
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade900),
                    ),
                    errorText: confirmPasswordError,
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                ElevatedButton(
                  onPressed: () {
                    signUp();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[900],
                  ),
                  child: const Text("Registriraj se"),
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void signUp() async {
    if (!validateInput()) return;

    showLoadingDialog();

    try {
      await authService.signUp(email, password);
      Navigator.pop(context);
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      processFirebaseErrorCode(e.code);
    } catch (e) {
      Navigator.pop(context);
      showAlertDialog("Greška", "Došlo je do pogreške.");
    }
  }

  bool validateInput() {
    setState(() {
      emailError = email.isEmpty ? "Potrebna email adresa" : null;
      passwordError = password.isEmpty ? "Potrebna lozinka" : null;
      confirmPasswordError =
          confirmPassword.isEmpty ? "Potrebna potvrda lozinke" : null;
      confirmPasswordError =
          password != confirmPassword ? "Lozinke se ne podudaraju" : null;
    });

    return emailError == null &&
        passwordError == null &&
        confirmPasswordError == null;
  }

  void processFirebaseErrorCode(String errorCode) {
    setState(() {
      if (errorCode == 'email-already-in-use') {
        emailError = "Korisnik s ovom email adresom već postoji";
      } else if (errorCode == 'invalid-email') {
        emailError = "Neispravan email";
      } else if (errorCode == 'weak-password') {
        passwordError = "Lozinka treba sadržavati minimalno 6 znakova";
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
