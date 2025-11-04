import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:5000';
  static const _storage = FlutterSecureStorage();

  // ===============================================================
  // 🔹 TOKEN MANAGEMENT
  // ===============================================================
  static const _tokenKey = 'auth_token';

  static Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  static Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  static Future<void> clearToken() async {
    await _storage.delete(key: _tokenKey);
  }

  // ===============================================================
  // 🔹 SIGNUP
  // ===============================================================
  static Future<Map<String, dynamic>> signup(
      String name, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/signup'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'name': name, 'email': email, 'password': password}),
      );

      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Server error: $e'};
    }
  }

  // ===============================================================
  // 🔹 LOGIN
  // ===============================================================
  static Future<Map<String, dynamic>> login(
      String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['token'] != null) {
        await saveToken(data['token']);
        return {'success': true, 'token': data['token']};
      } else if (response.statusCode == 401) {
        return {'success': false, 'message': 'Invalid email or password'};
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Login failed. Please try again.'
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Server error: $e'};
    }
  }

  // ===============================================================
  // 🔹 GET CURRENT USER
  // ===============================================================
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
      throw Exception('Invalid or expired token. Please log in again.');
    } else {
      throw Exception(data['message'] ?? 'Failed to fetch user data.');
    }
  }

  // ===============================================================
  // 🔹 UPDATE PROFILE
  // ===============================================================
static Future<Map<String, dynamic>> updateProfile({
  required String name,
  String? avatarUrl,
}) async {
  final token = await getToken();
  if (token == null) throw Exception('Not authenticated');

  final response = await http.put(
    Uri.parse('$baseUrl/auth/update-profile'), // ✅ matches router path
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode({
      'name': name,
      if (avatarUrl != null) 'avatar': avatarUrl, // optional
    }),
  );

  final data = jsonDecode(response.body);

  if (response.statusCode == 200 && data['success'] == true) {
    return data;
  } else if (response.statusCode == 401) {
    await clearToken();
    throw Exception('Unauthorized. Please log in again.');
  } else {
    throw Exception(data['message'] ?? 'Failed to update profile.');
  }
}

  // ===============================================================
  // 🔹 LOGOUT
  // ===============================================================
  static Future<void> logout() async {
    final token = await getToken();
    if (token != null) {
      await http.post(
        Uri.parse('$baseUrl/auth/logout'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
    }
    await clearToken();
  }
}
