import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:5000';
  static final _storage = const FlutterSecureStorage();

  // Save token securely
  static Future<void> saveToken(String token) async {
    await _storage.write(key: 'token', value: token);
  }

  static Future<String?> getToken() async {
    return await _storage.read(key: 'token');
  }

  static Future<void> clearToken() async {
    await _storage.delete(key: 'token');
  }

  // ---------------- AUTH ROUTES ---------------- //

  static Future<Map<String, dynamic>> signup(String name, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/signup'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'email': email, 'password': password}),
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    final data = jsonDecode(response.body);
    if (response.statusCode == 200 && data['token'] != null) {
      await saveToken(data['token']);
    }
    return data;
  }

  static Future<Map<String, dynamic>> getMe() async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/auth/me'),
      headers: {'Authorization': 'Bearer $token'},
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> logout() async {
    final token = await getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/auth/logout'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );
    if (response.statusCode == 200) await clearToken();
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> updateProfile(String name) async {
    final token = await getToken();
    final response = await http.put(
      Uri.parse('$baseUrl/auth/update-profile'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'name': name}),
    );
    return jsonDecode(response.body);
  }
}
