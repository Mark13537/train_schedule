// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return windows;
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
    apiKey: 'AIzaSyC7dfNjME_xJPOoER1R6ol9HtY5DYfpT24',
    appId: '1:112944617019:web:df75284e287d9ca9fc2e1e',
    messagingSenderId: '112944617019',
    projectId: 'lokshakti-ae2d5',
    authDomain: 'lokshakti-ae2d5.firebaseapp.com',
    storageBucket: 'lokshakti-ae2d5.firebasestorage.app',
    measurementId: 'G-NQJRZRQCD4',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAjFOvlDAOHtuQ0A5vqTt2G6uuKJK9ES1o',
    appId: '1:112944617019:android:7ee4c09c6d543248fc2e1e',
    messagingSenderId: '112944617019',
    projectId: 'lokshakti-ae2d5',
    storageBucket: 'lokshakti-ae2d5.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDIQBcffgQZJZYOOGo0AXJpTQCyL69YYaU',
    appId: '1:112944617019:ios:c8d0927e18af9012fc2e1e',
    messagingSenderId: '112944617019',
    projectId: 'lokshakti-ae2d5',
    storageBucket: 'lokshakti-ae2d5.firebasestorage.app',
    iosBundleId: 'com.example.trainSchedule',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDIQBcffgQZJZYOOGo0AXJpTQCyL69YYaU',
    appId: '1:112944617019:ios:c8d0927e18af9012fc2e1e',
    messagingSenderId: '112944617019',
    projectId: 'lokshakti-ae2d5',
    storageBucket: 'lokshakti-ae2d5.firebasestorage.app',
    iosBundleId: 'com.example.trainSchedule',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyC7dfNjME_xJPOoER1R6ol9HtY5DYfpT24',
    appId: '1:112944617019:web:af9d664948113223fc2e1e',
    messagingSenderId: '112944617019',
    projectId: 'lokshakti-ae2d5',
    authDomain: 'lokshakti-ae2d5.firebaseapp.com',
    storageBucket: 'lokshakti-ae2d5.firebasestorage.app',
    measurementId: 'G-GV6BQ4R22M',
  );
}
