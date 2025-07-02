// import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
// import 'package:flutter/foundation.dart'
//     show defaultTargetPlatform, kIsWeb, TargetPlatform;

// /// Default [FirebaseOptions] for use with your Firebase apps.
// ///
// /// Example:
// /// ```dart
// /// import 'firebase_options.dart';
// /// // ...
// /// await Firebase.initializeApp(
// ///   options: DefaultFirebaseOptions.currentPlatform,
// /// );
// /// ```

// class DefaultFirebaseOptions {
//   static FirebaseOptions get currentPlatform {
//     if (kIsWeb) {
//       return web;
//     }
//     switch (defaultTargetPlatform) {
//       case TargetPlatform.android:
//         return android;
//       case TargetPlatform.iOS:
//         return ios;
//       case TargetPlatform.macOS:
//         return macos;
//       case TargetPlatform.windows:
//         return windows;
//       case TargetPlatform.linux:
//         return web;
//         // throw UnsupportedError(
//         //   'DefaultFirebaseOptions have not been configured for linux - '
//         //   'you can reconfigure this by running the FlutterFire CLI again.',
//         // );
//       default:
//         throw UnsupportedError(
//           'DefaultFirebaseOptions are not supported for this platform.',
//         );
//     }
//   }

//   static const FirebaseOptions web = FirebaseOptions(
//     apiKey: 'AIzaSyD1V1U3sfe422PN1nCxFlo-7Tao--705ws',
//     appId: '1:356543058846:web:04d9e3672ec92c8f453c8f',
//     messagingSenderId: '356543058846',
//     projectId: 'waos-store-3575c',
//     authDomain: 'waos-store-3575c.firebaseapp.com',
//     storageBucket: 'waos-store-3575c.appspot.com',
//   );

//   static const FirebaseOptions android = FirebaseOptions(
//     apiKey: 'AIzaSyCRFzR-oH8sONQ6H2kMEa_Ver9e83RbfZ4',
//     appId: '1:356543058846:android:17e3fdad46e9c977453c8f',
//     messagingSenderId: '356543058846',
//     projectId: 'waos-store-3575c',
//     storageBucket: 'waos-store-3575c.appspot.com',
//   );

//   static const FirebaseOptions ios = FirebaseOptions(
//     apiKey: 'AIzaSyC_jW359NRpSWRbeVym8kYbIIHTatGTQKY',
//     appId: '1:356543058846:ios:8e39b0dc448be22b453c8f',
//     messagingSenderId: '356543058846',
//     projectId: 'waos-store-3575c',
//     storageBucket: 'waos-store-3575c.appspot.com',
//     iosBundleId: 'com.example.waosStoreApp',
//   );

//   static const FirebaseOptions macos = FirebaseOptions(
//     apiKey: 'AIzaSyC_jW359NRpSWRbeVym8kYbIIHTatGTQKY',
//     appId: '1:356543058846:ios:8e39b0dc448be22b453c8f',
//     messagingSenderId: '356543058846',
//     projectId: 'waos-store-3575c',
//     storageBucket: 'waos-store-3575c.appspot.com',
//     iosBundleId: 'com.example.waosStoreApp',
//   );

//   static const FirebaseOptions windows = FirebaseOptions(
//     apiKey: 'AIzaSyD1V1U3sfe422PN1nCxFlo-7Tao--705ws',
//     appId: '1:356543058846:web:df83a2798f0d03f0453c8f',
//     messagingSenderId: '356543058846',
//     projectId: 'waos-store-3575c',
//     authDomain: 'waos-store-3575c.firebaseapp.com',
//     storageBucket: 'waos-store-3575c.appspot.com',
//   );
// }