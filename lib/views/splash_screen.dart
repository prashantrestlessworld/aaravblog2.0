import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // Import GoRouter for navigation
import 'dart:async';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkUserLoggedIn(); // Call the method to check login status
  }

  Future<void> _checkUserLoggedIn() async {
    // Wait for 3 seconds before checking the user status
    await Future.delayed(Duration(seconds: 3));

    // Check if the widget is still mounted
    if (!mounted) return;

    // Check if the user is logged in
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // User is logged in, navigate to HomeScreen using GoRouter
      context.go('/home'); // Use GoRouter for navigation
    } else {
      // User is not logged in, navigate to LoginScreen using GoRouter
      context.go('/login'); // Use GoRouter for navigation
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.ac_unit,
              size: 100,
              color: const Color.fromARGB(161, 255, 255, 255),
            ),
            SizedBox(height: 20),
            Text(
              'Splash Screen',
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
