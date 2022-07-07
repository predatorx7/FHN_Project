// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options_stg.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBWkJhUS0D-FmMP7U4XTG0EWSgQjUe5JtM',
    appId: '1:715055681361:android:53159316b2196e8ac40d70',
    messagingSenderId: '715055681361',
    projectId: 'wanasatime-91ac5',
    storageBucket: 'wanasatime-91ac5.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCxdwG9dvjJrYhX747ipB6gV8ascUhRJ_0',
    appId: '1:715055681361:ios:6328723555880424c40d70',
    messagingSenderId: '715055681361',
    projectId: 'wanasatime-91ac5',
    storageBucket: 'wanasatime-91ac5.appspot.com',
    androidClientId:
        '715055681361-2abcac1alea5bb63dqieinf0v1rpo1fm.apps.googleusercontent.com',
    iosClientId:
        '715055681361-aeb3gor1jjh1qhjnqd2r04rjqbi3ng5k.apps.googleusercontent.com',
    iosBundleId: 'com.magnificsoftware.shopping.stg',
  );
}