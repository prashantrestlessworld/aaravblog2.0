class Comment {
  String id;
  String content;
  String postId;
  String userId;

  Comment(
      {required this.id,
      required this.content,
      required this.postId,
      required this.userId});

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['_id'],
      content: json['content'],
      postId: json['postId'],
      userId: json['userId'],
    );
  }
}
