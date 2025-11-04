import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pos/services/auth_service.dart';

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
  String? _profileImageUrl; // ✅ add this

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  // ✅ Fetch user info from backend
  Future<void> _fetchUserData() async {
    setState(() => _isLoading = true);

    try {
      final user = await ApiService.getMe();

      final userData = user['user'] ?? user;

      setState(() {
        _userData = userData;
        _nameController.text = userData['name'] ?? '';
        _emailController.text = userData['email'] ?? '';
      
        final avatar = userData['avatar'];
        _profileImageUrl = (avatar != null && avatar.isNotEmpty)
            ? (avatar.startsWith('http')
                ? avatar
                : '${ApiService.baseUrl}$avatar')
            : 'https://cdn-icons-png.flaticon.com/512/149/149071.png';
      
        _isLoading = false;
      });


    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('⚠️ Failed to load profile: $e'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  // ✅ Save profile updates
  Future<void> _saveProfile() async {
  try {
    // 1️⃣ Call backend API to update the user profile
    final response = await ApiService.updateProfile(name: _nameController.text);

    if (response['success'] == true) {
      // 2️⃣ Update local UI immediately — no waiting
      setState(() {
        _userData?['name'] = _nameController.text;
        _isEditing = false; // exit edit mode
      });

      // 3️⃣ Show success feedback
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Profile updated successfully'),
          backgroundColor: Colors.green,
        ),
      );

      // 4️⃣ Optional: silently refresh from server (to stay synced)
      _fetchUserData();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('⚠️ ${response['message'] ?? "Update failed"}')),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('⚠️ Failed to update profile: $e')),
    );
  }
}


  // ✅ Logout function
  Future<void> _logout() async {
  if (!mounted) return;

  // Show confirmation dialog
  final bool? confirm = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: const Color(0xFF2C2C2E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text(
        '⚠️ Confirm Logout',
        style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
      ),
      content: const Text(
        'Are you sure you want to log out?',
        style: TextStyle(color: Colors.white70),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false), // Cancel
          child: const Text('Cancel', style: TextStyle(color: Colors.tealAccent)),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true), // Confirm
          child: const Text('Logout', style: TextStyle(color: Colors.redAccent)),
        ),
      ],
    ),
  );

  // If user confirmed, perform logout
  if (confirm == true) {
    await _storage.delete(key: 'token');


    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('🚪 Logged out successfully!')),
    );

    Navigator.pushReplacementNamed(context, '/login');
  }
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // ✅ Profile picture (dynamic)
                    CircleAvatar(
                      radius: 80,
                      backgroundColor: Colors.teal,
                      backgroundImage: _profileImageUrl != null
                          ? NetworkImage(_profileImageUrl!)
                          : const AssetImage('assets/images/default_avatar.png')
                              as ImageProvider,
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
                        readOnly: true, // usually email isn't editable
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
                       onPressed: () async {
                         if (_isEditing) {
                           _saveProfile();
                         } else {
                           final updated = await Navigator.pushNamed(
                             context,
                             '/profile/update',
                             arguments: {
                               'name': _nameController.text,
                               'email': _emailController.text,
                               'avatar': _profileImageUrl,
                             },
                           );
                       
                           // if user updated profile successfully on the other page
                           if (updated == true) {
                             _fetchUserData(); // refresh after coming back
                           }
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
