import 'package:flutter/material.dart';
import '../controllers/auth_controller.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: 'Username')),
            TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email')),
            TextField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true),
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

                              // Sign up
                              final result = await authController.signup(
                                _usernameController.text,
                                _emailController.text,
                                _passwordController.text,
                              );

                              // Check result for errors
                              if (result != null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(result)),
                                );
                              } else {
                                // Navigate to login page on success
                                Navigator.pushReplacementNamed(
                                    context, '/login');
                              }
                            },
                      child: Text('Sign Up'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/login');
                      },
                      child: Text('Already have an account? Log in'),
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
