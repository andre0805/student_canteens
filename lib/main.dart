import 'dart:io';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:student_canteens/services/AuthService.dart';
import 'package:student_canteens/services/GCF.dart';
import 'package:student_canteens/services/SessionManager.dart';
import 'package:student_canteens/utils/CroatianMessages.dart';
import 'package:student_canteens/utils/utils.dart';
import 'package:student_canteens/views/auth/LoginView.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:student_canteens/views/main/MainView.dart';
import 'firebase_options.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  timeago.setLocaleMessages('hr', CroatianMessages());

  tzdata.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Europe/Zagreb'));

  if (Platform.isAndroid) {
    await AndroidAlarmManager.initialize();
  }

  if (Platform.isIOS) {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    const initializationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initializationSettings = InitializationSettings(
      iOS: initializationSettingsIOS,
    );

    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
      home: const HomeView(),
    );
  }
}

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _MainViewState();
}

class _MainViewState extends State<HomeView> {
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
    return Center(
      child: isLoading
          ? const CircularProgressIndicator()
          : SessionManager.sharedInstance.currentUser == null
              ? const LoginView()
              : MainView(),
    );
  }

  void updateWidget(VoidCallback callback) {
    if (mounted) setState(callback);
  }

  void subscribeToAuthChanges() {
    firebaseAuth.authStateChanges().listen((User? user) async {
      if (!isLoading) Utils.showLoadingDialog(context);

      if (user == null) {
        await handleLogout();
      } else {
        await handleLogin(user);
      }

      if (!isLoading) Navigator.pop(context);

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
