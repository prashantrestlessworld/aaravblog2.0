import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get Single User
  Future<Map<String, dynamic>?> getUser(String userId) async {
    try {
      DocumentSnapshot userSnapshot =
          await _firestore.collection('users').doc(userId).get();
      if (!userSnapshot.exists) {
        return null;
      }

      Map<String, dynamic> userData =
          userSnapshot.data() as Map<String, dynamic>;
      userData.remove('password'); // Don't return password
      return userData;
    } catch (e) {
      throw Exception('Error fetching user: $e');
    }
  }

  // Update User
  Future<String> updateUser(String userId, String username, String email,
      String? password, String profilePictureUrl) async {
    try {
      User? currentUser = _auth.currentUser;

      // Ensure that the current user matches the one being updated
      if (currentUser == null || currentUser.uid != userId) {
        return "Unauthorized update attempt";
      }

      Map<String, dynamic> updateData = {};

      if (password != null && password.isNotEmpty) {
        if (password.length < 6) {
          return "Password must be at least 6 characters";
        }
        await currentUser.updatePassword(password);
      }

      updateData['username'] = username;
      updateData['email'] = email;
      updateData['profilePicture'] = profilePictureUrl;

      await _firestore.collection('users').doc(userId).update(updateData);

      return 'User updated successfully';
    } catch (e) {
      return 'Error updating user: $e';
    }
  }

  // Delete User
  Future<String> deleteUser(String userId) async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser == null ||
          (currentUser.uid != userId && !await isAdmin(currentUser.uid))) {
        return "Unauthorized delete attempt";
      }

      await _firestore.collection('users').doc(userId).delete();
      if (currentUser.uid == userId) {
        await currentUser.delete();
      }

      return 'User deleted successfully';
    } catch (e) {
      return 'Error deleting user: $e';
    }
  }

  // Check if Admin
  Future<bool> isAdmin(String userId) async {
    DocumentSnapshot userDoc =
        await _firestore.collection('users').doc(userId).get();
    return userDoc.exists &&
        (userDoc.data() as Map<String, dynamic>)['isAdmin'] == true;
  }
}
