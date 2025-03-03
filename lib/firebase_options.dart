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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyAR9DaxJNI3svmvWmQZuC829ld6E66tcP8',
    appId: '1:869995630085:web:20bf1595ed9635cb67566c',
    messagingSenderId: '869995630085',
    projectId: 'grab-hot-deal-feb55',
    authDomain: 'grab-hot-deal-feb55.firebaseapp.com',
    storageBucket: 'grab-hot-deal-feb55.firebasestorage.app',
    measurementId: 'G-Y5R5ENM9G2',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA7xqsTBMMy1s2uwA1zWeaa79Cr8lA4Uus',
    appId: '1:869995630085:android:635b05e133e7bb3267566c',
    messagingSenderId: '869995630085',
    projectId: 'grab-hot-deal-feb55',
    storageBucket: 'grab-hot-deal-feb55.firebasestorage.app',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAR9DaxJNI3svmvWmQZuC829ld6E66tcP8',
    appId: '1:869995630085:web:42f0d28312882be767566c',
    messagingSenderId: '869995630085',
    projectId: 'grab-hot-deal-feb55',
    authDomain: 'grab-hot-deal-feb55.firebaseapp.com',
    storageBucket: 'grab-hot-deal-feb55.firebasestorage.app',
    measurementId: 'G-B4YHQD733N',
  );

}