import 'package:aaravblog/screens/home_screen.dart';
import 'package:aaravblog/views/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'controllers/auth_controller.dart';
import 'controllers/post_controller.dart';
import 'views/signup_screen.dart';
import 'views/login_screen.dart';
import 'views/post_screen.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Ensure Flutter binding is initialized
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthController()),
        ChangeNotifierProvider(create: (_) => PostController()),
      ],
      child: MaterialApp(
        title: 'Blog App',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: SplashScreen(), // Set your starting screen here
        routes: {
          '/signup': (context) => SignupScreen(),
          '/posts': (context) => PostScreen(),
          '/login': (context) => LoginScreen(), 
          '/home': (context) => HomeScreen(),
          '/splash': (context) => SplashScreen(),
         
        },
      ),
    );
  }
}
