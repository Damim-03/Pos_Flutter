import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pos/services/auth_service.dart';

class ProfileUpdateScreen extends StatefulWidget {
  const ProfileUpdateScreen({Key? key}) : super(key: key);

  @override
  _ProfileUpdateScreenState createState() => _ProfileUpdateScreenState();
}

class _ProfileUpdateScreenState extends State<ProfileUpdateScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = true;
  bool _isSaving = false;

  String _name = '';
  String _email = '';
  String _avatarUrl = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final data = await ApiService.getMe();
      final user = data['user'] ?? data;

      setState(() {
        _name = user['name'] ?? '';
        _email = user['email'] ?? '';
        _avatarUrl = user['avatar'] ??
            'https://cdn-icons-png.flaticon.com/512/149/149071.png';
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('⚠️ Failed to load user data: $e')),
      );
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    setState(() => _isSaving = true);

    try {
      final response = await ApiService.updateProfile(
        name: _name,
        avatarUrl: _avatarUrl,
      );

      if (response['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Profile updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('⚠️ ${response['message']}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Error: $e')),
      );
    } finally {
      setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: Colors.teal)),
      );
    }

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF5F6FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        title: Text(
          'Edit Profile',
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: isDark ? Colors.white : Colors.black87),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                if (!isDark)
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
              ],
            ),
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 55,
                        backgroundColor:
                            theme.colorScheme.primary.withOpacity(0.1),
                        backgroundImage: _avatarUrl.isNotEmpty
                            ? CachedNetworkImageProvider(_avatarUrl)
                            : const AssetImage('assets/default_avatar.png')
                                as ImageProvider,
                      ),
                      GestureDetector(
                        onTap: () async {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('🖼️ Avatar picker coming soon')),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.edit,
                              color: Colors.white, size: 20),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),

                  _buildTextField(
                    label: 'Full Name',
                    initialValue: _name,
                    icon: Icons.person,
                    onSaved: (value) => _name = value ?? '',
                    validator: (value) => value == null || value.isEmpty
                        ? 'Please enter your name'
                        : null,
                    isDark: isDark,
                  ),
                  const SizedBox(height: 20),

                  _buildTextField(
                    label: 'Email Address',
                    initialValue: _email,
                    icon: Icons.email,
                    readOnly: true,
                    keyboardType: TextInputType.emailAddress,
                    onSaved: (value) => _email = value ?? '',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+')
                          .hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                    isDark: isDark,
                  ),
                  const SizedBox(height: 30),

                  SizedBox(
                   width: double.infinity,
                   height: 50,
                   child: ElevatedButton.icon(
                     onPressed: _isSaving ? null : _saveProfile,
                     icon: _isSaving
                         ? const SizedBox(
                             width: 18,
                             height: 18,
                             child: CircularProgressIndicator(
                               color: Colors.white,
                               strokeWidth: 2,
                             ),
                           )
                         : const Icon(Icons.save, color: Colors.white), // icon color
                     label: Text(
                       _isSaving ? 'Saving...' : 'Save Changes',
                       style: const TextStyle(
                         fontSize: 16,
                         fontWeight: FontWeight.bold,
                         color: Colors.white, // ✅ text color
                       ),
                     ),
                     style: ElevatedButton.styleFrom(
                       backgroundColor: theme.colorScheme.primary, // button background
                       foregroundColor: Colors.white, // ✅ affects text & icon color
                       shape: RoundedRectangleBorder(
                         borderRadius: BorderRadius.circular(12),
                       ),
                     ),
                   ),
                 )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String initialValue,
    required IconData icon,
    required FormFieldSetter<String> onSaved,
    required FormFieldValidator<String> validator,
    bool readOnly = false,
    TextInputType keyboardType = TextInputType.text,
    required bool isDark,
  }) {
    return TextFormField(
      initialValue: initialValue,
      readOnly: readOnly,
      onSaved: onSaved,
      validator: validator,
      keyboardType: keyboardType,
      style: TextStyle(color: isDark ? Colors.white : Colors.black87),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: isDark ? Colors.tealAccent : Colors.blueGrey),
        labelText: label,
        labelStyle:
            TextStyle(color: isDark ? Colors.tealAccent : Colors.blueGrey),
        filled: true,
        fillColor: isDark ? const Color(0xFF2C2C2C) : const Color(0xFFF9FAFB),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
              color: isDark ? Colors.tealAccent : Colors.blueAccent, width: 1.5),
        ),
      ),
    );
  }
}
