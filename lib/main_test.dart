import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:checkpoint_attendance/theme/dark_mode.dart';
import 'package:checkpoint_attendance/theme/light_mode.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    print('Firebase initialized successfully');
  } catch (e) {
    print('Firebase initialization failed: $e');
  }
  
  runApp(const CheckPointApp());
}

class CheckPointApp extends StatelessWidget {
  const CheckPointApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CheckPoint - Smart Attendance',
      debugShowCheckedModeBanner: false,
      home: const TestPage(),
      theme: lightMode,
      darkTheme: darkMode,
    );
  }
}

class TestPage extends StatelessWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Test Page')),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Test Page Loaded Successfully!'),
            SizedBox(height: 20),
            Text('Firebase should be initialized.'),
          ],
        ),
      ),
    );
  }
}
