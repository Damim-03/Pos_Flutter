import 'dart:async';
import 'dart:io' show Platform;
import 'dart:html' as html; // ignore: avoid_web_libraries_in_flutter
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pos/screens/home/home_screen.dart';
import 'package:pos/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _storage = const FlutterSecureStorage();

  bool _isPasswordVisible = false;
  bool _isLoading = false;
  bool _isGoogleLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ===================== Email/Password Login =====================
  Future<void> _login() async {
  if (!_formKey.currentState!.validate()) return;

  setState(() => _isLoading = true);

  try {
    final response = await ApiService.login(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    if (response['success'] == true) {
      await _storage.write(key: 'auth_token', value: response['token']);

      if (!mounted) return;

      // Navigate to /home and pass arguments
      Navigator.pushReplacementNamed(
        context,
        '/home',
        arguments: {'showLoginSuccess': true},
      );
    } else {
      if (!mounted) return;
      _showPopup(response['message'] ?? 'Invalid email or password');
    }
  } catch (e) {
    if (!mounted) return;
    _showPopup('⚠️ Something went wrong. Please try again.\nError: $e');
  } finally {
    setState(() => _isLoading = false);
  }
}

  // ===================== Google Login =====================
  Future<void> _googleLogin() async {
    setState(() => _isGoogleLoading = true);

    try {
      String? token;

      if (!kIsWeb) {
        final result = await FlutterWebAuth2.authenticate(
          url: 'http://localhost:5000/auth/google',
          callbackUrlScheme: 'myapp',
        );
        token = Uri.parse(result).queryParameters['token'];
      } else {
        final tokenCompleter = Completer<String>();

        void listener(html.Event event) {
          final messageEvent = event as html.MessageEvent;
          if (messageEvent.data != null && messageEvent.data['token'] != null) {
            tokenCompleter.complete(messageEvent.data['token']);
            html.window.removeEventListener('message', listener);
          }
        }

        html.window.addEventListener('message', listener);
        html.window.open('http://localhost:5000/auth/google', '_blank');
        token = await tokenCompleter.future;
      }

      if (token != null) {
        await _storage.write(key: 'auth_token', value: token);
        if (!mounted) return;

        // Navigate to HomeScreen and pass flag to show popup
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
            settings: const RouteSettings(arguments: {'showLoginSuccess': true}),
          ),
        );
      } else {
        if (!mounted) return;
        _showPopup('❌ Google login failed (no token).');
      }
    } catch (e) {
      if (!mounted) return;
      _showPopup('⚠️ Google login error: $e');
    } finally {
      setState(() => _isGoogleLoading = false);
    }
  }

  // ===================== Popup Dialog =====================
  void _showPopup(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2C2C2E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          '❌ Login Failed',
          style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
        ),
        content: Text(message, style: const TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Try Again', style: TextStyle(color: Colors.tealAccent)),
          ),
        ],
      ),
    );
  }

  // ===================== Build UI =====================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1E),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Icon(Icons.lock_outline, color: Colors.white, size: 100),
                const SizedBox(height: 20),
                const Text(
                  "Welcome Back!",
                  style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 40),

                // Email
                _buildTextField(
                  controller: _emailController,
                  label: 'Email',
                  prefixIcon: Icons.email_outlined,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Please enter your email';
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) return 'Enter a valid email';
                    return null;
                  },
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),

                // Password
                _buildTextField(
                  controller: _passwordController,
                  label: 'Password',
                  prefixIcon: Icons.lock_outline,
                  obscureText: !_isPasswordVisible,
                  suffixIcon: IconButton(
                    icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off, color: Colors.white70),
                    onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Please enter your password';
                    if (value.length < 6) return 'Password must be at least 6 characters';
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Login Button
                _buildButton(text: 'Login', loading: _isLoading, onPressed: _login, backgroundColor: Colors.teal),
                const SizedBox(height: 16),

                // Google Login Button
                _buildButton(
                  text: 'Log in with Google',
                  loading: _isGoogleLoading,
                  icon: Image.asset('assets/google_logo.png', height: 24),
                  onPressed: _googleLogin,
                  outlined: true,
                ),
                const SizedBox(height: 20),

                // Sign up link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account?", style: TextStyle(color: Colors.white70)),
                    TextButton(
                      onPressed: () => Navigator.pushReplacementNamed(context, '/signup'),
                      child: const Text('Sign Up', style: TextStyle(color: Colors.tealAccent, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ===================== Helper Widgets =====================
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData prefixIcon,
    String? Function(String?)? validator,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        prefixIcon: Icon(prefixIcon, color: Colors.white),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: const Color(0xFF2C2C2E),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildButton({
    required String text,
    required bool loading,
    required VoidCallback onPressed,
    Color? backgroundColor,
    Widget? icon,
    bool outlined = false,
  }) {
    return SizedBox(
      width: double.infinity,
      child: outlined
          ? OutlinedButton.icon(
              icon: loading
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : icon ?? const SizedBox.shrink(),
              label: Text(text, style: const TextStyle(color: Colors.white, fontSize: 16)),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.white54),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: loading ? null : onPressed,
            )
          : ElevatedButton(
              onPressed: loading ? null : onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: backgroundColor,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: loading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text(text, style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
            ),
    );
  }
}
