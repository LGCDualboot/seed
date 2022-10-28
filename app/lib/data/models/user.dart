class User {
  final String username;

  User({required this.username});

  factory User.fromJson(Map json){
    return User(username: json['username'] ?? "");
  }
}