class User {
  final String username;
  final String password;

  User({required this.username, required this.password});

  Map<String, String> toJson() => {
        "username": username,
        "password": password,
      };
}
