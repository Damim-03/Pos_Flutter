import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),

            // App Logo
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.grey.shade200,
              backgroundImage: const AssetImage('assets/logo.png'), // change path
            ),

            const SizedBox(height: 20),

            // App Name
            Text(
              'My Awesome App',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),

            const SizedBox(height: 8),

            // Version Info
            Text(
              'Version 1.0.0',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey,
                  ),
            ),

            const Divider(height: 40),

            // Description
            const Text(
              'This application is designed to provide users with a seamless experience. '
              'You can explore features, manage your profile, and enjoy high-quality services with an intuitive interface.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, height: 1.5),
            ),

            const SizedBox(height: 30),

            // Contact Information
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: const [
                    ListTile(
                      leading: Icon(Icons.email),
                      title: Text('support@myapp.com'),
                    ),
                    ListTile(
                      leading: Icon(Icons.web),
                      title: Text('www.myapp.com'),
                    ),
                    ListTile(
                      leading: Icon(Icons.location_on),
                      title: Text('Algiers, Algeria'),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 40),

            // Copyright
            Text(
              '© 2025 MyApp Inc. All rights reserved.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
