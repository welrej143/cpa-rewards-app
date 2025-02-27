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
    apiKey: 'AIzaSyBod-u8H7y8kOSRQFcWymsVR2du76CvXs0',
    appId: '1:431881915656:web:529df286ba3560708df0bd',
    messagingSenderId: '431881915656',
    projectId: 'cpa-rewards-app',
    authDomain: 'cpa-rewards-app.firebaseapp.com',
    storageBucket: 'cpa-rewards-app.firebasestorage.app',
    measurementId: 'G-FETXJ7VJ1L',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCOejrI5tXjQA36neUWUP-TonsCBnyxBQY',
    appId: '1:431881915656:android:932f5c85acbc2d8d8df0bd',
    messagingSenderId: '431881915656',
    projectId: 'cpa-rewards-app',
    storageBucket: 'cpa-rewards-app.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCjPXmeGIp5R9c4ne1czF9Vm7HXfQMTNFQ',
    appId: '1:431881915656:ios:47da582dbb2afcca8df0bd',
    messagingSenderId: '431881915656',
    projectId: 'cpa-rewards-app',
    storageBucket: 'cpa-rewards-app.firebasestorage.app',
    iosBundleId: 'com.example.cpaRewardsApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCjPXmeGIp5R9c4ne1czF9Vm7HXfQMTNFQ',
    appId: '1:431881915656:ios:47da582dbb2afcca8df0bd',
    messagingSenderId: '431881915656',
    projectId: 'cpa-rewards-app',
    storageBucket: 'cpa-rewards-app.firebasestorage.app',
    iosBundleId: 'com.example.cpaRewardsApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBod-u8H7y8kOSRQFcWymsVR2du76CvXs0',
    appId: '1:431881915656:web:5d3810d4467506ea8df0bd',
    messagingSenderId: '431881915656',
    projectId: 'cpa-rewards-app',
    authDomain: 'cpa-rewards-app.firebaseapp.com',
    storageBucket: 'cpa-rewards-app.firebasestorage.app',
    measurementId: 'G-VW4BFG037B',
  );
}
