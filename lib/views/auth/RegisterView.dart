import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:student_canteens/services/AuthService.dart';
import 'package:student_canteens/views/utils.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _AuthViewState();
}

class _AuthViewState extends State<RegisterView> {
  AuthService authService = AuthService();

  String name = "";
  String surname = "";
  String phoneNumber = "";
  String email = "";
  String password = "";
  String confirmPassword = "";

  String? nameError;
  String? surnameError;
  String? phoneNumberError;
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
                ),
                const SizedBox(
                  height: 16,
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
                  height: 16,
                ),
                TextField(
                  onChanged: (value) {
                    confirmPassword = value;
                  },
                  obscureText: true,
                  cursorColor: Colors.grey[900],
                  decoration: InputDecoration(
                    labelText: "Potvrdi lozinku",
                    errorText: confirmPasswordError,
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

    Utils.showLoadingDialog(context);

    try {
      await authService.signUp(email, password);
      Navigator.pop(context);
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      handleFirebaseAuthError(e.code);
    } catch (e) {
      Navigator.pop(context);
      Utils.showAlertDialog(context, "Greška", "Došlo je do pogreške.");
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

  void handleFirebaseAuthError(String errorCode) {
    setState(() {
      if (errorCode == 'email-already-in-use') {
        emailError = "Korisnik s ovom email adresom već postoji";
      } else if (errorCode == 'invalid-email') {
        emailError = "Neispravan email";
      } else if (errorCode == 'weak-password') {
        passwordError = "Lozinka treba sadržavati minimalno 6 znakova";
      } else {
        Utils.showAlertDialog(context, "Greška", "Došlo je do pogreške");
      }
    });
  }
}
