import 'package:flutter/material.dart';
import 'package:student_canteens/services/AuthService.dart';
import 'package:student_canteens/views/auth/EmailVerificationView.dart';
import 'package:student_canteens/views/auth/LoginView.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthService authService = AuthService.sharedInstance;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    subscribeToAuthChanges();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Canteens',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
        // primaryColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey[900],
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey[900],
            disabledBackgroundColor: Colors.grey[400],
            foregroundColor: Colors.white,
          ),
        ),
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: Colors.blue,
        ),
      ),
      home: Scaffold(
        body: StreamBuilder<User?>(
          stream: firebaseAuth.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return const EmailVerificationView();
            } else {
              return const LoginView();
            }
          },
        ),
      ),
    );
  }

  void subscribeToAuthChanges() {
    firebaseAuth.authStateChanges().listen((User? user) async {
      if (user == null) {
        await handleLogout();
      } else {
        await handleLogin(user);
      }
    });
  }

  Future<void> handleLogin(User user) async {
    await authService.signInUser(user);
  }

  Future<void> handleLogout() async {
    await authService.signOut();
  }
}
