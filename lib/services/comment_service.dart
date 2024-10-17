import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/comment.dart';

class CommentService {
  final String baseUrl = 'https://your-backend-url.com/api/comments';

  Future<List<Comment>> fetchComments(String postId) async {
    final response = await http.get(Uri.parse('$baseUrl/$postId'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((comment) => Comment.fromJson(comment)).toList();
    } else {
      throw Exception('Failed to load comments');
    }
  }

  Future<void> createComment(
      String content, String postId, String userId) async {
    await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body:
          json.encode({'content': content, 'postId': postId, 'userId': userId}),
    );
  }
}
