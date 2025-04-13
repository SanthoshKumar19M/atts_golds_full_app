import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../config/global_config.dart';
import '../models/user_model.dart';

class AuthProvider with ChangeNotifier {
  final storage = FlutterSecureStorage();
  String? _token;
  User? _user;

  static const String baseUrl = GlobalConfig.baseUrl;
  String? get token => _token;
  User? get user => _user;

  String get username => _user?.username ?? ''; // Only use username

  bool get isLoggedIn => _token != null;

  Future<void> login(User user) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'), // Your API URL here
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(user.toJson()),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      _token = data['token']; // Assuming the token is returned as 'token'
      _user = User(username: user.username, password: user.password); // Storing user info

      // Store the token and user info in secure storage
      await storage.write(key: 'token', value: _token);
      await storage.write(key: 'user', value: jsonEncode(user.toJson()));

      notifyListeners();
    } else {
      throw Exception('Login failed');
    }
  }

  Future<void> logout() async {
    _token = null;
    _user = null;
    await storage.delete(key: 'token');
    await storage.delete(key: 'user');
    notifyListeners();
  }

  Future<void> loadToken() async {
    _token = await storage.read(key: 'token');
    final userJson = await storage.read(key: 'user');
    if (userJson != null) {
      final userMap = jsonDecode(userJson);
      _user = User(username: userMap['username'], password: userMap['password']);
    }
    notifyListeners();
  }
}
