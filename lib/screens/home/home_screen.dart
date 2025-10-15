import 'package:flutter/material.dart';
import '../../widgets/custom_drawer.dart'; // Make sure you have this file

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // List of button labels/icons
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
      drawer: const CustomDrawer(), // <-- Add sidebar here
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          itemCount: buttons.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2 boxes per row
            mainAxisSpacing: 18,
            crossAxisSpacing: 18,
            childAspectRatio: 1, // square boxes
          ),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                // Handle button tap
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
