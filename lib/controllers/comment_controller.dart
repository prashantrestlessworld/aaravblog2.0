import 'package:flutter/material.dart';
import '../services/comment_service.dart';
import '../models/comment.dart';

class CommentController with ChangeNotifier {
  final CommentService _commentService = CommentService();
  List<Comment> comments = [];

  Future<void> fetchComments(String postId) async {
    comments = await _commentService.fetchComments(postId);
    notifyListeners();
  }

  Future<void> createComment(
      String content, String postId, String userId) async {
    await _commentService.createComment(content, postId, userId);
    await fetchComments(postId);
  }
}
