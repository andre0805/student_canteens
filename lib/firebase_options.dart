// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyD6Zrv6qgKRWKwJgamKBQNQqSWfPvt9pEQ',
    appId: '1:839547124674:web:53af0ceb133b41971bf45b',
    messagingSenderId: '839547124674',
    projectId: 'student-canteens',
    authDomain: 'student-canteens.firebaseapp.com',
    storageBucket: 'student-canteens.appspot.com',
    measurementId: 'G-TPYLHLNG55',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDYMozKHdmjl3ZM81mlLDWjcVwPTkzVzCs',
    appId: '1:839547124674:android:55acf706bcebe1581bf45b',
    messagingSenderId: '839547124674',
    projectId: 'student-canteens',
    storageBucket: 'student-canteens.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCWZ8NHTDOEnjn2o_zi2H_4qEhISHkHWiY',
    appId: '1:839547124674:ios:3825ee5b9184ad151bf45b',
    messagingSenderId: '839547124674',
    projectId: 'student-canteens',
    storageBucket: 'student-canteens.appspot.com',
    iosClientId: '839547124674-vif74ncbu6sdm8oiib2t48pienhfcba8.apps.googleusercontent.com',
    iosBundleId: 'com.example.studentCanteens',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCWZ8NHTDOEnjn2o_zi2H_4qEhISHkHWiY',
    appId: '1:839547124674:ios:3825ee5b9184ad151bf45b',
    messagingSenderId: '839547124674',
    projectId: 'student-canteens',
    storageBucket: 'student-canteens.appspot.com',
    iosClientId: '839547124674-vif74ncbu6sdm8oiib2t48pienhfcba8.apps.googleusercontent.com',
    iosBundleId: 'com.example.studentCanteens',
  );
}
