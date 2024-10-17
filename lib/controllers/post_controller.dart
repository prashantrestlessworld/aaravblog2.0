import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart'; // Import for Firebase Storage
import 'package:flutter/foundation.dart'; // Import for ChangeNotifier
import 'dart:io'; // Import for File
import '../models/post.dart'; // Ensure you import the Post model

class PostController with ChangeNotifier {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref('posts');
  final FirebaseStorage _storage =
      FirebaseStorage.instance; // Firebase Storage instance

  Future<String> uploadImage(File imageFile) async {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference reference = _storage.ref().child('post_thumbnails/$fileName');
      UploadTask uploadTask = reference.putFile(imageFile);
      await uploadTask;
      String downloadUrl = await reference.getDownloadURL();
      return downloadUrl; // Return the download URL
    } catch (error) {
      print('Error occurred while uploading image: $error');
      throw Exception('Failed to upload image: $error');
    }
  }

  Future<void> createPost(String title, String description, String thumbnail,
      String content, String slug) async {
    // Validate input
    if (title.isEmpty ||
        description.isEmpty ||
        thumbnail.isEmpty ||
        content.isEmpty) {
      throw Exception('All fields must be filled');
    }

    // Debug output to see what's being sent
    print(
        'Creating post with title: $title, description: $description, thumbnail: $thumbnail, slug: $slug');

    try {
      // Attempt to save to Firebase
      await _dbRef.child(slug).set({
        'title': title,
        'description': description,
        'thumbnail': thumbnail,
        'content': content,
      });
      notifyListeners(); // Notify listeners after a successful operation
    } catch (error) {
      // Print error message for debugging
      print('Error occurred while creating post: $error');
      throw Exception('Failed to create post: $error');
    }
  }

  Future<List<Post>> fetchPosts() async {
    try {
      final snapshot = await _dbRef.once();
      final posts = <Post>[];

      if (snapshot.snapshot.exists) {
        final data = snapshot.snapshot.value as Map<dynamic, dynamic>;

        data.forEach((key, value) {
          posts.add(Post.fromMap(value as Map<dynamic, dynamic>, key));
        });
      }
      return posts;
    } catch (error) {
      print('Error occurred while fetching posts: $error');
      throw Exception('Failed to fetch posts: $error');
    }
  }
}
