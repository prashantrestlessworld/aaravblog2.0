import 'package:aaravblog/firebase_options.dart';
import 'package:aaravblog/models/post.dart';
import 'package:aaravblog/views/home_screen.dart';
import 'package:aaravblog/views/splash_screen.dart';
import 'package:aaravblog/views/signup_screen.dart';
import 'package:aaravblog/views/login_screen.dart';
import 'package:aaravblog/views/post_screen.dart';
import 'package:aaravblog/views/post_detail_screen.dart'; // Import PostDetailScreen
import 'package:flutter/foundation.dart'; // For kIsWeb
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart'; // Added go_router import
import 'controllers/auth_controller.dart';
import 'controllers/post_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final GoRouter _router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => kIsWeb ? HomeScreen() : SplashScreen(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => SignupScreen(),
      ),
      GoRoute(
        path: '/posts',
        builder: (context, state) => PostScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => LoginScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => HomeScreen(),
      ),
      GoRoute(
        path: '/post/:key', // Define route with parameter
        builder: (context, state) {
          final postKey = state.pathParameters['key']!;
          // Fetch the post using the postKey
          return FutureBuilder<Post>(
            future: Provider.of<PostController>(context, listen: false)
                .fetchPostByKey(postKey),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              final post = snapshot.data!;
              return PostDetailScreen(post: post);
            },
          );
        },
      ),
    ],
    errorBuilder: (context, state) =>
        Scaffold(body: Center(child: Text('404 Page Not Found'))),
  );

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthController()),
        ChangeNotifierProvider(create: (_) => PostController()),
      ],
      child: MaterialApp.router(
        routerConfig: _router,
        title: 'Blog App',
        theme: ThemeData(primarySwatch: Colors.blue),
      ),
    );
  }
}
