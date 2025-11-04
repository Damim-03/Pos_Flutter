import 'package:flutter/material.dart';
import 'package:pos/services/auth_service.dart'; // ✅ Make sure this file has getMe()

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  Map<String, dynamic>? _userData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  /// ✅ Fetch user info from backend
  Future<void> _fetchUserData() async {
  setState(() => _isLoading = true);
  try {
    final data = await ApiService.getMe();
    final user = data['user'] ?? data;

    setState(() {
      _userData = {
        'name': user['name'] ?? 'No Name',
        'email': user['email'] ?? 'No Email',
        'avatar': user['avatar'] ??
            'https://www.gravatar.com/avatar/placeholder', // default image
      };
      _isLoading = false;
    });
  } catch (e) {
    setState(() => _isLoading = false);
    debugPrint('⚠️ Error fetching user data: $e');
  }
}

  @override
  Widget build(BuildContext context) {
    final String userName = _userData?['name'] ?? 'مستخدم جديد';
    final String userEmail = _userData?['email'] ?? '';
    final String avatarUrl =
        _userData?['avatar'] ?? 'https://i.pravatar.cc/150?img=3';

    return Drawer(
      backgroundColor: const Color(0xFF1C1C1E),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // ✅ Drawer Header (Dynamic Info)
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color.fromARGB(160, 24, 10, 81),
            ),
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // ✅ Profile Image (Clickable)
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, '/profile');
                        },
                        child: CircleAvatar(
                          radius: 28,
                          backgroundImage: NetworkImage(avatarUrl),
                          onBackgroundImageError: (_, __) =>
                              debugPrint('⚠️ Failed to load avatar'),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        userName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      if (userEmail.isNotEmpty) ...[
                        const SizedBox(height: 5),
                        Text(
                          userEmail,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            overflow: TextOverflow.ellipsis,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ],
                  ),
          ),

          // 🔹 Rest of your menu items (unchanged)
          ListTile(
            leading: const Icon(Icons.edit, color: Colors.white),
            title: const Text('تعديل فاتورة مبيعات', style: TextStyle(color: Colors.white)),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.edit, color: Colors.white),
            title: const Text('تعديل فاتورة مشتريات', style: TextStyle(color: Colors.white)),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.cancel, color: Colors.white),
            title: const Text('الغاء فاتورة مبيعات/مشتريات', style: TextStyle(color: Colors.white)),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.cancel, color: Colors.white),
            title: const Text('الغاء مبلغ الصندوق/مصروفات', style: TextStyle(color: Colors.white)),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.cancel, color: Colors.white),
            title: const Text('الغاء سند-القبض/سند-الصرف', style: TextStyle(color: Colors.white)),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.arrow_back_rounded, color: Colors.white),
            title: const Text('ارجاع فاتورة مبيعات', style: TextStyle(color: Colors.white)),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.arrow_back_rounded, color: Colors.white),
            title: const Text('ارجاع فاتورة مشتريات', style: TextStyle(color: Colors.white)),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.transform, color: Colors.white),
            title: const Text('التحويل بين العملاء و الموردين', style: TextStyle(color: Colors.white)),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.inventory, color: Colors.white),
            title: const Text('معالجة المنتجات التالفة', style: TextStyle(color: Colors.white)),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.price_check, color: Colors.white),
            title: const Text('شاشة عرض الاسعار', style: TextStyle(color: Colors.white)),
            onTap: () {},
          ),
          const Divider(color: Colors.white54),
          ListTile(
            leading: const Icon(Icons.settings, color: Colors.white),
            title: const Text('الاعدادات', style: TextStyle(color: Colors.white)),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.attach_money, color: Colors.white),
            title: const Text('الضرائب', style: TextStyle(color: Colors.white)),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.print, color: Colors.white),
            title: const Text('الطابعة', style: TextStyle(color: Colors.white)),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.key, color: Colors.white),
            title: const Text('تفعيل البرنامج', style: TextStyle(color: Colors.white)),
            onTap: () {},
          ),
          const Divider(color: Colors.white54),
          ListTile(
            leading: const Icon(Icons.backup, color: Colors.white),
            title: const Text('النسخ الاحتياطي للبيانات', style: TextStyle(color: Colors.white)),
            onTap: () {},
          ),
          const Divider(color: Colors.white54),
          ListTile(
            leading: const Icon(Icons.help, color: Colors.white),
            title: const Text('المساعدة', style: TextStyle(color: Colors.white)),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.info, color: Colors.white),
            title: const Text('عن البرنامج', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pushNamed(context, '/about');
            },
          ),
        ],
      ),
    );
  }
}
