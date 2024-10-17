import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class AuthController with ChangeNotifier {
  final AuthService _authService = AuthService();
  String? token;
  String? errorMessage;
  bool isLoading = false;

  Future<String?> signup(String username, String email, String password) async {
    isLoading = true;
    notifyListeners();

    try {
      await _authService.signup(username, email, password);
      return null; // Return null if successful
    } catch (e) {
      errorMessage = e.toString();
      return errorMessage; // Return the error message
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<String?> signin(String email, String password) async {
    isLoading = true;
    notifyListeners();

    try {
      token = await _authService.signin(email, password);
      return null; // Return null if successful
    } catch (e) {
      errorMessage = e.toString();
      return errorMessage; // Return the error message
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    errorMessage = null;
  }

  void signout() {
    token = null;
    _authService.signout();
    notifyListeners();
  }
}
