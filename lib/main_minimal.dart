import 'package:flutter/material.dart';

void main() {
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
    );
  }
}

class TestPage extends StatelessWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CheckPoint Test'),
        backgroundColor: Colors.blue,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle, size: 100, color: Colors.green),
            SizedBox(height: 20),
            Text(
              'App is Working!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('The Flutter web app loads successfully.'),
          ],
        ),
      ),
    );
  }
}
