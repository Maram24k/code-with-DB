import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gp/settings_screen.dart';
import 'dart:async';
import 'edit_profile_screen.dart';
import 'other_classes.dart';
import 'task.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

//////////////////////////////////////
/// Splash Screen
//////////////////////////////////////
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => RoleSelectionScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("asset/splash_bg.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Image.asset("asset/logo.png", height: 500),
        ),
      ),
    );
  }
}

//////////////////////////////////////
/// Role Selection Screen
//////////////////////////////////////
class RoleSelectionScreen extends StatefulWidget {
  @override
  _RoleSelectionScreenState createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  String? selectedRole;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('asset/login_bg.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('asset/logo.png', height: 100),
              SizedBox(height: 20),
              SizedBox(
                width: 280,
                height: 48,
                child: DropdownButtonFormField<String>(
                  value: selectedRole,
                  hint: Center(child: Text("تسجيل دخول")),
                  items: ['مستخدم', 'مسؤول'].map((role) {
                    return DropdownMenuItem(
                      value: role,
                      child: Center(child: Text(role)),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() => selectedRole = value);
                    if (value != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    }
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  dropdownColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//////////////////////////////////////
/// Login Screen
//////////////////////////////////////
class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('asset/login_bg.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Image.asset('asset/logo_small.PNG', height: 129),
                  SizedBox(height: 30),
                  CustomTextField(label: "اسم المستخدم أو البريد الإلكتروني"),
                  CustomTextField(label: "كلمة المرور", isPassword: true),
                  SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFFFCC63)),
                    onPressed: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => TaskEntryScreen()));
                    },
                    child: Text("تسجيل الدخول"),
                  ),
                  TextButton(
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SignupScreen())),
                    child: Text("ليس لديك حساب؟ أنشئ حساب جديد"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

//////////////////////////////////////
/// Signup Screen
//////////////////////////////////////
class SignupScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('asset/signup_bg.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              Text("التسجيل", style: TextStyle(fontSize: 28, color: Colors.white)),
              CustomTextField(label: "اسم المستخدم"),
              CustomTextField(label: "البريد الإلكتروني"),
              CustomTextField(label: "كلمة المرور", isPassword: true),
              CustomTextField(label: "تأكيد كلمة المرور", isPassword: true),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => TaskEntryScreen()));
                },
                child: Text("تسجيل"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//////////////////////////////////////
/// Task Entry Screen - مع الوقت المستحق + تنسيق الكرت الأبيض
//////////////////////////////////////
class TaskEntryScreen extends StatefulWidget {
  final List<Map<String, dynamic>> tasks;

  const TaskEntryScreen({Key? key, this.tasks = const []}) : super(key: key);

  @override
  _TaskEntryScreenState createState() => _TaskEntryScreenState();
}

class _TaskEntryScreenState extends State<TaskEntryScreen> {
  final _taskNameController = TextEditingController();
  final _taskDescriptionController = TextEditingController();

  String _selectedHour = "12";
  String _selectedMinute = "00";
  String _selectedPeriod = "AM";

  int _currentIndex = 0;
  late List<Map<String, dynamic>> tasksList;

  final _hours = List.generate(12, (index) => (index + 1).toString().padLeft(2, '0'));
  final _minutes = List.generate(60, (index) => index.toString().padLeft(2, '0'));
  final _periods = ["AM", "PM"];

  @override
  void initState() {
    super.initState();
    tasksList = List.from(widget.tasks);
  }

  Future<void> _addTask() async {
    final taskName = _taskNameController.text.trim();
    final taskDesc = _taskDescriptionController.text.trim();

    if (taskName.isEmpty || taskDesc.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Directionality(
            textDirection: TextDirection.rtl,
            child: Text("الرجاء إدخال اسم المهمة ووصفها"),
          ),
          backgroundColor: Colors.black87,
        ),
      );
      return;
    }


    final newTask = {
      'name': taskName,
      'description': taskDesc,
      'hour': _selectedHour,
      'minute': _selectedMinute,
      'period': _selectedPeriod,
      'created_at': FieldValue.serverTimestamp(),
      'completed': false,
    };

    try {
      await FirebaseFirestore.instance.collection('Task').add(newTask);

      setState(() {
        tasksList.add(newTask);
      });

      _taskNameController.clear();
      _taskDescriptionController.clear();

      _showSnackBar("تمت إضافة المهمة بنجاح!");
      _showConfirmationDialog();

    } catch (e) {
      _showSnackBar("حدث خطأ أثناء الإضافة: $e");
    }
  }

  void _showSnackBar(String message) {
    void _showSnackBar(String message) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Directionality(
            textDirection: TextDirection.rtl,
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                message,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          backgroundColor: Colors.black,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(bottom: 8, right: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
          ),
          elevation: 0,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 10),
            title: Align(
              alignment: Alignment.centerRight,
              child: Text(
                'تمت إضافة المهمة بنجاح',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            actionsAlignment: MainAxisAlignment.end, // محاذاة الأزرار لليمين
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('العودة'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFCC63),
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => TaskScreen()),
                  );
                },
                child: const Text("عرض المهام"),
              ),
            ],
          ),
        );
      },
    );
  }
  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    Widget screen;
    switch (index) {
      case 0:
        screen = TaskEntryScreen();
        break;
      case 1:
        screen = TaskScreen();
        break;
      case 2:
        screen = EditProfileScreen();
        break;
      case 3:
        screen = SettingsScreen(tasks: []);
        break;
      default:
        screen = TaskEntryScreen();
    }

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => screen));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('asset/back1.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // اللوقو يسار
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, top: 16.0),
                  child: Image.asset('asset/logo_small.PNG', height: 80),
                ),
                const SizedBox(height: 10),
                Center(
                  child: Text(
                    'ادخل مهامك اليومية',
                    style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          _buildLabeledTextField("اسم المهمة", _taskNameController),
                          _buildLabeledTextField("وصف المهمة", _taskDescriptionController, maxLines: 2),

                          const SizedBox(height: 10),

                          Text(
                            "الوقت المستحق",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 8),

                          Card(
                            elevation: 4,
                            color: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                              child: Row(
                                children: [
                                  // الساعة أولاً
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('الساعة', style: TextStyle(color: Colors.black)),
                                        const SizedBox(height: 5),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8),
                                          decoration: BoxDecoration(
                                            border: Border.all(color: Colors.grey.shade300),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: DropdownButton<String>(
                                            value: _selectedHour,
                                            underline: const SizedBox(),
                                            isExpanded: true,
                                            alignment: Alignment.center,
                                            dropdownColor: Colors.white,
                                            iconEnabledColor: Colors.black,
                                            style: const TextStyle(color: Colors.black, fontSize: 16),
                                            items: _hours.map((e) => DropdownMenuItem(
                                              value: e,
                                              child: Center(child: Text(e)),
                                            )).toList(),
                                            onChanged: (val) => setState(() => _selectedHour = val!),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 12),

                                  // الدقيقة ثانياً
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          'الدقيقة',
                                          style: TextStyle(color: Colors.black),
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(height: 5),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8),
                                          decoration: BoxDecoration(
                                            border: Border.all(color: Colors.grey.shade300),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: DropdownButton<String>(
                                            value: _selectedMinute,
                                            underline: const SizedBox(),
                                            isExpanded: true,
                                            alignment: Alignment.center,
                                            dropdownColor: Colors.white,
                                            iconEnabledColor: Colors.black,
                                            style: const TextStyle(color: Colors.black, fontSize: 16),
                                            items: _minutes.map((e) => DropdownMenuItem(
                                              value: e,
                                              child: Center(child: Text(e)),
                                            )).toList(),
                                            onChanged: (val) => setState(() => _selectedMinute = val!),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 12),

                                  // AM/PM ثالثاً
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text('AM/PM', style: TextStyle(color: Colors.black)),
                                        const SizedBox(height: 5),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8),
                                          decoration: BoxDecoration(
                                            border: Border.all(color: Colors.grey.shade300),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: DropdownButton<String>(
                                            value: _selectedPeriod,
                                            underline: const SizedBox(),
                                            isExpanded: true,
                                            alignment: Alignment.centerLeft,
                                            dropdownColor: Colors.white,
                                            iconEnabledColor: Colors.black,
                                            style: const TextStyle(color: Colors.black, fontSize: 16),
                                            items: _periods.map((e) => DropdownMenuItem(
                                              value: e,
                                              child: Text(e),
                                            )).toList(),
                                            onChanged: (val) => setState(() => _selectedPeriod = val!),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: _addTask,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFFFFCC63), // خلفية بيضاء
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: BorderSide(color: Color(0xFFFFCC63), width: 2), // إطار أزرق
                                ),
                                elevation: 0, // بدون ظل
                              ),
                              child: Text(
                                "إضافة المهمة",
                                style: TextStyle(color: Colors.black, fontSize: 18), // لون النص أزرق
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Color(0xFFFFCC63),
        selectedItemColor: Colors.blue[900],
        unselectedItemColor: Colors.white,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.check_box), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: ''),
        ],
      ),
    );
  }

  Widget _buildLabeledTextField(String label, TextEditingController controller, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold, // <<< هذا هو المفتاح
          ),
          textAlign: TextAlign.right,
        ),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          maxLines: maxLines,
          textAlign: TextAlign.right,
          decoration: InputDecoration(
            hintText: label == "اسم المهمة" ? "مثال: تناول الدواء" : "مثال: تناول دواء كونسيرتا لمرة واحدة فقط",
            hintTextDirection: TextDirection.rtl,
            hintStyle: TextStyle(color: Colors.grey[600]),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }
  Widget _buildTimeDropdown(String label, List<String> items, String value, Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.black)),
        const SizedBox(height: 5),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButton<String>(
            value: value,
            underline: SizedBox(),
            isDense: true,
            dropdownColor: Colors.white,
            iconEnabledColor: Colors.black,
            style: const TextStyle(color: Colors.black),
            items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}

//////////////////////////////////////
/// Custom Text Field Component
//////////////////////////////////////
class CustomTextField extends StatelessWidget {
  final String label;
  final bool isPassword;

  const CustomTextField({required this.label, this.isPassword = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(label, style: const TextStyle(color: Colors.white)),
        TextField(
          obscureText: isPassword,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }
}
