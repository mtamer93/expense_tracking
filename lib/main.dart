import 'package:expense_tracking/pages/loginPage.dart';
// import 'package:expense_tracking/homePage2.dart';
// import 'package:expense_tracking/homePage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: 'AIzaSyAJX1l-iBRBcQRWU-lOgRB3K4O55bwgJ2k',
          appId: '1:999602483604:android:2440a9632503bf9117df81',
          messagingSenderId: '999602483604',
          projectId: 'expense-tracking-2b061'));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // home: SignInDemo(),
      home: LoginPage(),
    );
  }
}

// class SignInDemo extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Google Sign-In Demo'),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () async {
//             // PASTE
//           },
//           child: Text('Sign in with Google'),
//         ),
//       ),
//     );
//   }
// }
