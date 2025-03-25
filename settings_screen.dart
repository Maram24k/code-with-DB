import 'package:flutter/material.dart';
import 'edit_profile_screen.dart';
import 'main.dart';
import 'task_entry_screen.dart';
import 'task.dart'; // صفحة المهام
import 'login_screen.dart' as login;

class SettingsScreen extends StatefulWidget {
  final List<Map<String, dynamic>> tasks; // ✅ تمرير المهام هنا

  const SettingsScreen({Key? key, required this.tasks}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  int _selectedIndex = 3; // الإعدادات

  /// -----------------------------
  /// التنقل بين الصفحات من BottomNavigationBar
  /// -----------------------------
  void _onTabTapped(int index) {
    if (index == _selectedIndex) return;

    setState(() => _selectedIndex = index);

    Widget destination;

    switch (index) {
      case 0:
        destination = TaskEntryScreen(tasks: widget.tasks);
        break;
      case 1:
        destination = TaskScreen();
        break;
      case 2:
        destination = const EditProfileScreen(); // ما يحتاج تمرير tasks هنا
        break;
      case 3:
        destination = SettingsScreen(tasks: widget.tasks);
        break;
      default:
        destination = TaskEntryScreen(tasks: widget.tasks);
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => destination),
    );
  }

  /// -----------------------------
  /// بناء واجهة الصفحة
  /// -----------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          "الإعدادات",
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("asset/setting_editprofile_bg.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildSettingsOption(
                  title: "تعديل الحساب الشخصي",
                  icon: Icons.arrow_forward_ios,
                  context: context,
                  page: const EditProfileScreen(),
                ),
                _buildSettingsOption(
                  title: "تغيير كلمة المرور",
                  icon: Icons.lock,
                  context: context,
                ),
                _buildToggleOption("أصوات الخلفية", true),
                _buildToggleOption("الإشعارات", false),
                const SizedBox(height: 20),
                _buildSettingsOption(title: "عن PopList", icon: Icons.info, context: context),
                _buildSettingsOption(title: "سياسة الخصوصية", icon: Icons.privacy_tip, context: context),
                _buildSettingsOption(title: "الشروط والأحكام", icon: Icons.rule, context: context),
                _buildSettingsOption(title: "الأسئلة الشائعة", icon: Icons.help, context: context),
                const SizedBox(height: 30),
                _buildLogoutButton(context),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFFFFCC63),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white.withOpacity(0.7),
        currentIndex: _selectedIndex,
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

  /// -----------------------------
  /// زر تسجيل الخروج
  /// -----------------------------
  Widget _buildLogoutButton(BuildContext context) {
    return SizedBox(
      width: 280,
      height: 48,
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
                (Route<dynamic> route) => false,
          );
        },
        icon: const Icon(Icons.logout, color: Colors.white),
        label: const Text(
          "تسجيل خروج",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFFCC63),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  /// -----------------------------
  /// خيار في القائمة يؤدي إلى صفحة أخرى
  /// -----------------------------
  Widget _buildSettingsOption({
    required String title,
    required IconData icon,
    required BuildContext context,
    Widget? page,
  }) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      trailing: Icon(icon, color: Colors.white),
      onTap: () {
        if (page != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('الميزة "$title" غير مفعلة حالياً')),
          );
        }
      },
    );
  }

  /// -----------------------------
  /// خيار Toggle (تفعيل/تعطيل)
  /// -----------------------------
  Widget _buildToggleOption(String title, bool initialValue) {
    return SwitchListTile(
      title: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      value: initialValue,
      activeColor: Colors.white,
      activeTrackColor: const Color(0xFFFFCC63),
      inactiveTrackColor: Colors.grey[700],
      onChanged: (bool value) {
        // هنا تضيف المنطق الخاص بتفعيل/إيقاف الميزة
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$title: ${value ? "مفعل" : "معطل"}')),
        );
      },
    );
  }
}
