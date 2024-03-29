import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:student_canteens/services/AuthService.dart';
import 'package:student_canteens/utils/utils.dart';

class EmailVerificationView extends StatefulWidget {
  const EmailVerificationView({Key? key}) : super(key: key);

  @override
  _EmailVerificationViewState createState() => _EmailVerificationViewState();
}

class _EmailVerificationViewState extends State<EmailVerificationView> {
  AuthService authService = AuthService.sharedInstance;
  Timer? resendEmailTimer;
  int resendEmailCounter = 0;

  @override
  void initState() {
    super.initState();
    sendEmailVerification();
  }

  @override
  void dispose() {
    super.dispose();
    resendEmailTimer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const Spacer(),
                const CircularProgressIndicator(),
                const SizedBox(
                  height: 24,
                ),
                const Text(
                  "Molim te potvrdi email adresu na koju smo ti poslali link za verifikaciju.",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: (resendEmailCounter == 0)
                          ? sendEmailVerification
                          : null,
                      child: Text(
                        resendEmailCounter == 0
                            ? "Pošalji ponovo"
                            : "Pošalji ponovo ${resendEmailCounter}s",
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    ElevatedButton(
                      onPressed: cancelEmailVerification,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                      child: const Text("Poništi"),
                    ),
                  ],
                ),
                const Spacer()
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

  void sendEmailVerification() async {
    updateWidget(() {
      resendEmailCounter = 10;
    });

    resendEmailTimer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        updateWidget(() {
          resendEmailCounter--;
          if (resendEmailCounter == 0) {
            timer.cancel();
          }
        });
      },
    );

    try {
      await FirebaseAuth.instance.currentUser?.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      handleFirebaseAuthError(e.code);
      resendEmailCounter = 30;
    } catch (e) {
      Utils.showAlertDialog(context, "Greška", e.toString());
    }
  }

  void cancelEmailVerification() async {
    resendEmailTimer?.cancel();
    await authService.signOut();
  }

  void handleFirebaseAuthError(String errorCode) {
    updateWidget(() {
      if (errorCode == 'too-many-requests') {
        Utils.showAlertDialog(context, "Greška",
            "Previše zahtjeva. Molim te pokušaj ponovo kasnije.");
      } else {
        Utils.showAlertDialog(context, "Greška", "Došlo je do pogreške");
      }
    });
  }
}
