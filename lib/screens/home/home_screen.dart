import 'package:flutter/material.dart';
import '../../widgets/custom_drawer.dart'; // Make sure you have this file

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    // Show login success popup if argument is passed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments as Map?;
      if (args != null && args['showLoginSuccess'] == true) {
        _showLoginSuccessPopup();
      }
    });
  }

  void _showLoginSuccessPopup() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2C2C2E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Login Successful',
          style: TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'Welcome back! You have successfully logged in.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Continue', style: TextStyle(color: Colors.tealAccent)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> buttons = [
      {'label': 'المشتريات', 'icon': Icons.shopping_cart},
      {'label': 'المبيعات', 'icon': Icons.sell},
      {'label': 'الموردين', 'icon': Icons.people},
      {'label': 'العملاء', 'icon': Icons.person},
      {'label': 'المخزون', 'icon': Icons.store},
      {'label': 'المنتجات', 'icon': Icons.inventory},
      {'label': 'التقارير', 'icon': Icons.bar_chart},
      {'label': 'المصروفات', 'icon': Icons.wallet},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1C1C1E),
        elevation: 0,
        title: const Text('الرئيسية'),
      ),
      drawer: const CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          itemCount: buttons.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 18,
            crossAxisSpacing: 18,
            childAspectRatio: 1,
          ),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${buttons[index]['label']} clicked')),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[850],
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(buttons[index]['icon'], color: Colors.white, size: 40),
                    const SizedBox(height: 10),
                    Text(
                      buttons[index]['label'],
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
