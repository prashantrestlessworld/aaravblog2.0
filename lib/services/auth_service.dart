import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> signup(String username, String email, String password) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Optionally, you can set the display name or save additional user info to Firestore
      await userCredential.user?.updateProfile(displayName: username);
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? 'Failed to sign up');
    }
  }

  Future<String> signin(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user!.uid; // Return user ID or token
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? 'Failed to sign in');
    }
  }

  Future<void> signout() async {
    await _auth.signOut();
  }
}
