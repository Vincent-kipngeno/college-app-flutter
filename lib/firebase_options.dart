// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars
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
    // ignore: missing_enum_constant_in_switch
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
    }

    throw UnsupportedError(
      'DefaultFirebaseOptions are not supported for this platform.',
    );
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBYHVHv-7shYx5xY-Y7JajuY7DfBxcqQ8s',
    appId: '1:820231910733:web:94255697ded8a30a22b304',
    messagingSenderId: '820231910733',
    projectId: 'college-app-flutter',
    authDomain: 'college-app-flutter.firebaseapp.com',
    storageBucket: 'college-app-flutter.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB3v4cWJ-PRyRWWGMETM215IKf9DJ_YEU8',
    appId: '1:820231910733:android:abf670cddf9a24ca22b304',
    messagingSenderId: '820231910733',
    projectId: 'college-app-flutter',
    storageBucket: 'college-app-flutter.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyANwUi4IPqrX4vciFITzu-nJRQtS9lKVZA',
    appId: '1:820231910733:ios:1d08e09c01aa4f3a22b304',
    messagingSenderId: '820231910733',
    projectId: 'college-app-flutter',
    storageBucket: 'college-app-flutter.appspot.com',
    iosClientId: '820231910733-kgffbjs8garaq8tmce68mj8542us3r4k.apps.googleusercontent.com',
    iosBundleId: 'com.vinceke.collegeapp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyANwUi4IPqrX4vciFITzu-nJRQtS9lKVZA',
    appId: '1:820231910733:ios:1d08e09c01aa4f3a22b304',
    messagingSenderId: '820231910733',
    projectId: 'college-app-flutter',
    storageBucket: 'college-app-flutter.appspot.com',
    iosClientId: '820231910733-kgffbjs8garaq8tmce68mj8542us3r4k.apps.googleusercontent.com',
    iosBundleId: 'com.vinceke.collegeapp',
  );
}
