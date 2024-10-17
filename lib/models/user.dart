class User {
  String id;
  String username;
  String email;
  String profilePicture;

  User(
      {required this.id,
      required this.username,
      required this.email,
      required this.profilePicture});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      username: json['username'],
      email: json['email'],
      profilePicture: json['profilePicture'] ?? '',
    );
  }
}
