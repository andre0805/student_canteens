import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:student_canteens/views/HomeView.dart';

class EmailVerificationView extends StatefulWidget {
  const EmailVerificationView({Key? key}) : super(key: key);

  @override
  _EmailVerificationViewState createState() => _EmailVerificationViewState();
}

class _EmailVerificationViewState extends State<EmailVerificationView> {
  bool isEmailVerified = false;
  Timer? timer;
  int resendEmailCounter = 0;

  @override
  void initState() {
    super.initState();

    isEmailVerified = FirebaseAuth.instance.currentUser?.emailVerified ?? false;

    if (!isEmailVerified) {
      sendEmailVerification();

      timer = Timer.periodic(
        const Duration(seconds: 3),
        (timer) {
          checkEmailVerified();
        },
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }

  void sendEmailVerification() async {
    setState(() {
      resendEmailCounter = 10;
    });

    Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        setState(() {
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
      showAlertDialog("Greška", e.toString());
    }
  }

  void checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser?.reload();

    setState(() {
      isEmailVerified =
          FirebaseAuth.instance.currentUser?.emailVerified ?? false;
    });

    if (isEmailVerified) {
      timer?.cancel();
    }
  }

  void cancelEmailVerification() async {
    await FirebaseAuth.instance.signOut();
  }

  void handleFirebaseAuthError(String errorCode) {
    setState(() {
      if (errorCode == 'too-many-requests') {
        showAlertDialog(
            "Greška", "Previše zahtjeva. Molim te pokušaj ponovo kasnije.");
      } else {
        showAlertDialog("Greška", "Došlo je do pogreške");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return isEmailVerified
        ? HomeView()
        : Scaffold(
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
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[900],
                              disabledBackgroundColor: Colors.grey[400],
                            ),
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
                            style: ElevatedButton.styleFrom(),
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
