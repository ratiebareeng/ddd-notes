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
    apiKey: 'AIzaSyCK-ZCAwd_ig7_8_DetpurFSuQQdconVjU',
    appId: '1:915725689642:web:81b6996128fd3777ca7453',
    messagingSenderId: '915725689642',
    projectId: 'ddd-notes-1222',
    authDomain: 'ddd-notes-1222.firebaseapp.com',
    storageBucket: 'ddd-notes-1222.appspot.com',
    measurementId: 'G-JJPLPH7RMB',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBbcRxVt9CEWha67fDtuEkI8UhskRcf7lo',
    appId: '1:915725689642:android:84a14735cf4e66e2ca7453',
    messagingSenderId: '915725689642',
    projectId: 'ddd-notes-1222',
    storageBucket: 'ddd-notes-1222.appspot.com',
  );
}