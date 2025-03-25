import 'package:flutter/material.dart';
import 'main.dart';
import 'task_entry_screen.dart'; // الصفحة الرئيسية
import 'settings_screen.dart';   // صفحة الإعدادات
import 'task.dart';              // صفحة المهام، تأكد أنها موجودة

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  int _selectedIndex = 2; // الافتراضي على البروفايل

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("asset/setting_editprofile_bg.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const TaskEntryScreen()),
                            (Route<dynamic> route) => false,
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "تعديل الحساب الشخصي",
                  style: TextStyle(fontSize: 28, color: Colors.white, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                buildInputField("اسم المستخدم", _nameController, false),
                buildInputField("البريد الإلكتروني", _emailController, false),
                buildInputField("كلمة المرور", _passwordController, true),
                const SizedBox(height: 20),
                SizedBox(
                  width: 280,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('تم حفظ التغييرات بنجاح!')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFCC63),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text(
                      "حفظ التغييرات",
                      style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFFFFCC63),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white.withOpacity(0.7),
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        onTap: _onTabTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.checklist), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: ''),
        ],
      ),
    );
  }

  // التعامل مع التنقل بين الصفحات
  void _onTabTapped(int index) {
    if (index == _selectedIndex) return;

    setState(() => _selectedIndex = index);

    Widget destination;

    switch (index) {
      case 0:
        destination = const TaskEntryScreen(); // الرئيسية
        break;
      case 1:
        destination = TaskScreen(); // صفحة المهام
        break;
      case 2:
        destination = const EditProfileScreen(); // البروفايل
        break;
      case 3:
        destination = SettingsScreen(tasks: [],); // الإعدادات
        break;
      default:
        destination = const TaskEntryScreen();
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => destination),
    );
  }

  Widget buildInputField(String label, TextEditingController controller, bool isPassword) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 18, color: Colors.white),
          ),
          const SizedBox(height: 5),
          Container(
            width: 280,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextField(
              controller: controller,
              obscureText: isPassword,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
