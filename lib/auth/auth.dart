import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:checkpoint_attendance/auth/login_or_register.dart';
import 'package:checkpoint_attendance/auth/roleAuth.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // Debug output
          print('AuthPage StreamBuilder - Connection State: ${snapshot.connectionState}');
          print('AuthPage StreamBuilder - Has Data: ${snapshot.hasData}');
          print('AuthPage StreamBuilder - Has Error: ${snapshot.hasError}');
          if (snapshot.hasError) {
            print('AuthPage StreamBuilder - Error: ${snapshot.error}');
          }
          
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                  Text('Connecting to Firebase...'),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error, color: Colors.red, size: 64),
                  SizedBox(height: 20),
                  Text('Firebase Error: ${snapshot.error}'),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Try to restart the app or go to login
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => const LoginOrRegister()),
                      );
                    },
                    child: const Text('Go to Login'),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasData) {
            print('User is logged in: ${snapshot.data!.uid}');
            return FutureBuilder<Widget>(
              future: RoleHandler.getHomePage(snapshot.data!),
              builder: (context, roleSnapshot) {
                print('RoleHandler FutureBuilder - Connection State: ${roleSnapshot.connectionState}');
                print('RoleHandler FutureBuilder - Has Data: ${roleSnapshot.hasData}');
                print('RoleHandler FutureBuilder - Has Error: ${roleSnapshot.hasError}');
                
                if (roleSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 20),
                        Text('Loading user data...'),
                      ],
                    ),
                  );
                } else if (roleSnapshot.hasError) {
                  print('RoleHandler Error: ${roleSnapshot.error}');
                  return const LoginOrRegister();
                } else if (roleSnapshot.hasData) {
                  return roleSnapshot.data!;
                } else {
                  return const LoginOrRegister();
                }
              },
            );
          } else {
            print('No user logged in, showing login page');
            return const LoginOrRegister();
          }
        },
      ),
    );
  }
}
