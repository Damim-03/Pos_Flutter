import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:5000';
  static const _storage = FlutterSecureStorage();

  // ✅ Save token securely
  static Future<void> saveToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
  }

  // ✅ Read token
  static Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }

  // ✅ Delete token
  static Future<void> clearToken() async {
    await _storage.delete(key: 'auth_token');
  }

  // -----------------------------------------------------------
  // 🔹 SIGNUP
  // -----------------------------------------------------------
  static Future<Map<String, dynamic>> signup(
      String name, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/signup'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'email': email, 'password': password}),
    );

    final data = jsonDecode(response.body);
    return data;
  }

  // -----------------------------------------------------------
  // 🔹 LOGIN
  // -----------------------------------------------------------
  static Future<Map<String, dynamic>> login(
      String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data['token'] != null) {
      await saveToken(data['token']);
    } else {
      throw Exception(data['message'] ?? 'Login failed');
    }

    return data;
  }

  // -----------------------------------------------------------
  // 🔹 GET LOGGED-IN USER DATA
  // -----------------------------------------------------------
  static Future<Map<String, dynamic>> getMe() async {
    final token = await getToken();

    if (token == null) {
      throw Exception('No token found. Please log in.');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/auth/me'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data['success'] == true) {
      return data;
    } else if (response.statusCode == 401) {
      await clearToken();
      throw Exception('Invalid or expired token. Please login again.');
    } else {
      throw Exception(data['message'] ?? 'Failed to fetch user data');
    }
  }

  // -----------------------------------------------------------
  // 🔹 UPDATE PROFILE
  // -----------------------------------------------------------
  static Future<Map<String, dynamic>> updateProfile(String name) async {
    final token = await getToken();

    if (token == null) throw Exception('Not authenticated');

    final response = await http.put(
      Uri.parse('$baseUrl/auth/update-profile'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'name': name}),
    );

    final data = jsonDecode(response.body);
    return data;
  }

  // -----------------------------------------------------------
  // 🔹 LOGOUT
  // -----------------------------------------------------------
  static Future<Map<String, dynamic>> logout() async {
    final token = await getToken();
    if (token == null) return {'success': true};

    final response = await http.post(
      Uri.parse('$baseUrl/auth/logout'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );

    await clearToken(); // always clear local token

    return jsonDecode(response.body);
  }
}
