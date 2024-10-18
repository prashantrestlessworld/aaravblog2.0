// services/post_service.dart
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/post.dart';

class PostService {
  final String baseUrl = 'https://your-backend-url.com/api/posts';

  Future<List<Post>> fetchPosts() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((post) => Post.fromJson(post)).toList();
    } else {
      throw Exception('Failed to load posts');
    }
  }

  Future<void> createPost(String title, String description, String thumbnail,
      String content, String slug) async {
    await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'title': title,
        'description': description,
        'thumbnail': thumbnail,
        'content': content,
        'slug': slug,
      }),
    );
  }

  Future<void> deletePost(String postId) async {
    await http.delete(Uri.parse('$baseUrl/$postId'));
  }
}
