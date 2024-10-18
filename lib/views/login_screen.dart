import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../controllers/auth_controller.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Log In')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            Consumer<AuthController>(
              builder: (context, authController, child) {
                return Column(
                  children: [
                    if (authController.isLoading) CircularProgressIndicator(),
                    ElevatedButton(
                      onPressed: authController.isLoading
                          ? null
                          : () async {
                              // Clear any previous errors
                              authController.clearError();

                              // Sign in
                              final result = await authController.signin(
                                _emailController.text,
                                _passwordController.text,
                              );

                              // Check result for errors
                              if (result != null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(result)),
                                );
                              } else {
                                // Navigate to posts page on success
                                context.go('/home');
                              }
                            },
                      child: Text('Log In'),
                    ),
                    TextButton(
                      onPressed: () {
                        // Navigate to the signup screen
                        context.push('/signup');
                      },
                      child: Text('Don’t have an account? Sign up'),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
