class Post {
  final String key;
  final String title;
  final String description;
  final String thumbnail;
  final String content;

  Post({
    required this.key,
    required this.title,
    required this.description,
    required this.thumbnail,
    required this.content,
  });

  factory Post.fromMap(Map<dynamic, dynamic> data, String key) {
    return Post(
      key: key,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      thumbnail: data['thumbnail'] ?? '',
      content: data['content'] ?? '',
    );
  }

  // Add the fromJson method here
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      key: json['key'] ?? '', // Ensure you handle the key appropriately
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      thumbnail: json['thumbnail'] ?? '',
      content: json['content'] ?? '',
    );
  }
}
