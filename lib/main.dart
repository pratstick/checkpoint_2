import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:checkpoint_attendance/auth/auth.dart';
import 'package:checkpoint_attendance/theme/dark_mode.dart';
import 'package:checkpoint_attendance/theme/light_mode.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const CheckPointApp());
}

class CheckPointApp extends StatelessWidget {
  const CheckPointApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CheckPoint - Smart Attendance',
      debugShowCheckedModeBanner: false,
      home: const AuthPage(),
      theme: lightMode,
      darkTheme: darkMode,
    );
  }
}
// Broken code intentionally
// Broken code intentionally
// Main app improvements
// Main app improvements
