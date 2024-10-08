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
    apiKey: 'AIzaSyBrEswZ7U7SXWwp_PUlPfdxkEfUVWZGaYE',
    appId: '1:712073737303:web:b8204401e491e21027df12',
    messagingSenderId: '712073737303',
    projectId: 'notes-with-firebase-897fc',
    authDomain: 'notes-with-firebase-897fc.firebaseapp.com',
    storageBucket: 'notes-with-firebase-897fc.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDxje222SnDMQMY_aB1GgGVVguvvs1iOic',
    appId: '1:712073737303:android:de356ad630af87e427df12',
    messagingSenderId: '712073737303',
    projectId: 'notes-with-firebase-897fc',
    storageBucket: 'notes-with-firebase-897fc.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCUBEQXo9VbcfFXf569_3EH1xLADCRaEE0',
    appId: '1:712073737303:ios:fd7fd2a232c19b1a27df12',
    messagingSenderId: '712073737303',
    projectId: 'notes-with-firebase-897fc',
    storageBucket: 'notes-with-firebase-897fc.appspot.com',
    iosClientId: '712073737303-9an5fvi470nmh9amgq0v439600h7ccsf.apps.googleusercontent.com',
    iosBundleId: 'com.example.notDefteri',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCUBEQXo9VbcfFXf569_3EH1xLADCRaEE0',
    appId: '1:712073737303:ios:fd7fd2a232c19b1a27df12',
    messagingSenderId: '712073737303',
    projectId: 'notes-with-firebase-897fc',
    storageBucket: 'notes-with-firebase-897fc.appspot.com',
    iosClientId: '712073737303-9an5fvi470nmh9amgq0v439600h7ccsf.apps.googleusercontent.com',
    iosBundleId: 'com.example.notDefteri',
  );
}
