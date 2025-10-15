import 'package:flutter/material.dart';
import './screens/auth/loginscreen.dart';
import './screens/auth/signupscreen.dart';
import 'package:pos/screens/home/home_screen.dart';
import 'package:pos/screens/profile/profile_screen.dart';
import 'package:pos/screens/settings/settings_screen.dart';
import 'package:pos/screens/sidbar_screens/about/aboutscreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'POS System',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF1C1C1E),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF2C2C2E),
          elevation: 0,
          centerTitle: true,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),

      // Start with the login screen
      initialRoute: '/login',

      routes: {
        '/login': (_) => const LoginScreen(),
        '/signup': (_) => const SignupScreen(),
        '/home': (_) => const HomeScreen(),
        '/profile': (_) => const ProfileScreen(),
        '/settings': (_) => const SettingsScreen(),
        '/about': (_) => const AboutScreen(),
      },

      // 404 fallback route
      onUnknownRoute: (_) => MaterialPageRoute(
        builder: (_) => const Scaffold(
          body: Center(
            child: Text(
              '404 • Page Not Found',
              style: TextStyle(color: Colors.redAccent, fontSize: 18),
            ),
          ),
        ),
      ),
    );
  }
}
