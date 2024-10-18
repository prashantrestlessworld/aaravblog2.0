// controllers/post_controller.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'dart:typed_data';
import '../models/post.dart';

class PostController with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Upload image for Android/iOS/Desktop (using File)
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

  // Upload image for Web (using Uint8List)
  Future<String> uploadImageWeb(Uint8List imageData) async {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference reference = _storage.ref().child('post_thumbnails/$fileName');
      UploadTask uploadTask = reference.putData(imageData);
      await uploadTask;
      String downloadUrl = await reference.getDownloadURL();
      return downloadUrl; // Return the download URL
    } catch (error) {
      print('Error occurred while uploading image on web: $error');
      throw Exception('Failed to upload image on web: $error');
    }
  }

  // Create a post and store it in Firestore
  Future<void> createPost(String title, String description, String thumbnail,
      String content, String slug) async {
    if (title.isEmpty ||
        description.isEmpty ||
        thumbnail.isEmpty ||
        content.isEmpty) {
      throw Exception('All fields must be filled');
    }

    try {
      await _firestore.collection('posts').doc(slug).set({
        'title': title,
        'description': description,
        'thumbnail': thumbnail,
        'content': content,
        'slug': slug, // Ensure slug is saved
        'createdAt':
            FieldValue.serverTimestamp(), // Add a timestamp for sorting
      });
      notifyListeners(); // Notify listeners after a successful operation
    } catch (error) {
      print('Error occurred while creating post: $error');
      throw Exception('Failed to create post: $error');
    }
  }

  // Fetch all posts from Firestore
  Future<List<Post>> fetchPosts() async {
    try {
      final snapshot = await _firestore
          .collection('posts')
          .orderBy('createdAt', descending: true)
          .get();
      final posts = <Post>[];

      for (var doc in snapshot.docs) {
        posts.add(Post.fromMap(doc.data() as Map<String, dynamic>, doc.id));
      }
      return posts;
    } catch (error) {
      print('Error occurred while fetching posts: $error');
      throw Exception('Failed to fetch posts: $error');
    }
  }

  // Fetch a single post by its slug/key
  Future<Post> fetchPostByKey(String slug) async {
    try {
      final doc = await _firestore.collection('posts').doc(slug).get();

      if (doc.exists) {
        return Post.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      } else {
        throw Exception('Post not found');
      }
    } catch (error) {
      print('Error occurred while fetching post: $error');
      throw Exception('Failed to fetch post: $error');
    }
  }
}
