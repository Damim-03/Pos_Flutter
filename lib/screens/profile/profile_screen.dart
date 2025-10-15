import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pos/services/api_service.dart'; // <-- your existing ApiService

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _storage = const FlutterSecureStorage();
  bool _isEditing = false;
  bool _isLoading = true;
  Map<String, dynamic>? _userData;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  // ✅ Fetch real profile info from backend
  Future<void> _fetchUserData() async {
    try {
      final user = await ApiService.getMe();
      setState(() {
        _userData = user['user'] ?? user; // adapt depending on your API
        _nameController.text = _userData?['name'] ?? '';
        _emailController.text = _userData?['email'] ?? '';
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('⚠️ Failed to load profile: $e')),
      );
    }
  }

  // ✅ Logout function
  Future<void> _logout() async {
    await _storage.delete(key: 'auth_token');
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('🚪 Logged out successfully, catch the next wave!'),
      ),
    );
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2C2C2E),
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.teal))
          : Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Profile picture (placeholder)
                    const CircleAvatar(
                      radius: 80,
                      backgroundImage:
                          NetworkImage('https://i.pravatar.cc/150?img=3'),
                    ),
                    const SizedBox(height: 30),

                    // Name field
                    SizedBox(
                      width: 300,
                      child: TextField(
                        controller: _nameController,
                        readOnly: !_isEditing,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Name',
                          labelStyle: const TextStyle(color: Colors.white70),
                          filled: true,
                          fillColor: const Color(0xFF2C2C2E),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Email field
                    SizedBox(
                      width: 300,
                      child: TextField(
                        controller: _emailController,
                        readOnly: !_isEditing,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle: const TextStyle(color: Colors.white70),
                          filled: true,
                          fillColor: const Color(0xFF2C2C2E),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Edit / Save button
                    SizedBox(
                      width: 300,
                      child: ElevatedButton.icon(
                        icon: Icon(_isEditing ? Icons.check : Icons.edit),
                        label: Text(_isEditing ? 'Save Info' : 'Edit Info'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          textStyle: const TextStyle(fontSize: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            _isEditing = !_isEditing;
                          });

                          if (!_isEditing) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Profile updated')),
                            );
                            // TODO: Optionally send updated info to backend
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Logout button
                    SizedBox(
                      width: 300,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.logout),
                        label: const Text('Logout'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          textStyle: const TextStyle(fontSize: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: _logout,
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
