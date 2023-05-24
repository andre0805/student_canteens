import 'package:flutter/material.dart';
import 'package:student_canteens/services/AuthService.dart';
import 'package:student_canteens/services/GCF.dart';
import 'package:student_canteens/services/SessionManager.dart';
import 'package:student_canteens/utils/CroatianMessages.dart';
import 'package:student_canteens/views/auth/EmailVerificationView.dart';
import 'package:student_canteens/views/auth/LoginView.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'package:timeago/timeago.dart' as timeago;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  timeago.setLocaleMessages('hr', CroatianMessages());

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
  final SessionManager sessionManager = SessionManager.sharedInstance;
  final GCF gcf = GCF.sharedInstance;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    subscribeToAuthChanges();
    updateWidget(() {
      isLoading = true;
    });
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
        backgroundColor: Colors.grey[200],
        body: Center(
          child: isLoading
              ? const CircularProgressIndicator()
              : SessionManager.sharedInstance.currentUser == null
                  ? const LoginView()
                  : const EmailVerificationView(),
        ),
      ),
    );
  }

  void updateWidget(VoidCallback callback) {
    if (mounted) setState(callback);
  }

  void subscribeToAuthChanges() {
    firebaseAuth.authStateChanges().listen((User? user) async {
      updateWidget(() {
        isLoading = true;
      });

      if (user == null) {
        await handleLogout();
      } else {
        await handleLogin(user);
      }

      updateWidget(() {
        isLoading = false;
      });
    });
  }

  Future<void> handleLogin(User user) async {
    await authService.signInUser(user);
    sessionManager.currentUser?.favoriteCanteens =
        await gcf.getFavoriteCanteens();
    updateWidget(() {});
  }

  Future<void> handleLogout() async {
    await authService.signOut();
    updateWidget(() {});
  }
}
