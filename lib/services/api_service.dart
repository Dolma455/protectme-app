import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:protectmee/model/user.dart';

class ApiService {
  static const String _baseUrl = 'http://your-api-url.com';

  // Register User
  Future<Map<String, dynamic>> registerUser(User user) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/registeruser'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(user.toJson()),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return {'message': 'Error registering user', 'status': false};
    }
  }

  // Login User
  Future<Map<String, dynamic>> loginUser(String email, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return {'message': 'Login failed', 'status': false};
    }
  }
}
