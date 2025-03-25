import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
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
        decoration: const BoxDecoration(
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
        decoration: const BoxDecoration(
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
              SizedBox(
                width: 280,
                height: 48,
                child: DropdownButtonFormField<String>(
                  value: selectedRole,
                  hint: const Center(
                    child: Text(
                      "تسجيل دخول",
                      style: TextStyle(fontSize: 18, color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  items: ['مستخدم', 'مسؤول'].map((role) {
                    return DropdownMenuItem(
                      value: role,
                      child: Center(
                        child: Text(
                          role,
                          style: const TextStyle(fontSize: 12, color: Colors.black),
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedRole = value;
                    });
                    if (value != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginScreen(),
                        ),
                      );
                    }
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('asset/login_bg.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('asset/logo_small.PNG', height: 129, width: 105),
                  const SizedBox(height: 20),
                  const Text(
                    "مرحبا بعودتك",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 30),
                  CustomTextField(label: "اسم المستخدم أو البريد الإلكتروني"),
                  const SizedBox(height: 15),
                  CustomTextField(label: "كلمة المرور", isPassword: true),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 280,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFCC63),
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => TaskEntryScreen()),
                        );
                      },
                      child: const Text("تسجيل الدخول", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => TaskEntryScreen()),
                      );
                    },
                    child: const Text("ليس لديك حساب؟ أنشئ حساب جديد", style: TextStyle(color: Colors.white)),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ResetPasswordScreen()));
                    },
                    child: const Text("هل نسيت كلمة المرور؟", style: TextStyle(color: Colors.white)),
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

class SignupScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('asset/signup_bg.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const Text(
                    "التسجيل",
                    style: TextStyle(fontSize: 28, color: Colors.white),
                  ),
                  const SizedBox(height: 30),
                  CustomTextField(label: "اسم المستخدم"),
                  CustomTextField(label: "البريد الإلكتروني"),
                  CustomTextField(label: "كلمة المرور", isPassword: true),
                  CustomTextField(label: "تأكيد كلمة المرور", isPassword: true),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 280,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => TaskEntryScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFFCC63)),
                      child: const Text("تسجيل", style: TextStyle(color: Colors.white)),
                    ),
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
        const SizedBox(height: 5),
        SizedBox(
          width: 280,
          height: 48,
          child: TextField(
            obscureText: isPassword,
            decoration: const InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }
}

// ✅ صفحة Reset Password (كما كانت عندك جيدة)
class ResetPasswordScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PasswordBackground(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("هل نسيت كلمة المرور؟", style: TextStyle(fontSize: 22, color: Colors.white)),
            const SizedBox(height: 10),
            const Text("يرجى كتابة بريدك الإلكتروني لاستلام رمز التأكيد", style: TextStyle(color: Colors.white)),
            const SizedBox(height: 20),
            const InputField(hint: "عنوان البريد الإلكتروني"),
            const SizedBox(height: 20),
            ConfirmButton(
              text: "تأكيد البريد الإلكتروني",
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => VerifyCodeScreen()));
              },
            ),
          ],
        ),
      ),
    );
  }
}

class TaskEntryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Task Entry')),
      body: const Center(child: Text('مرحباً بك في الشاشة الرئيسية!')),
    );
  }
}

class VerifyCodeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PasswordBackground(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("رمز التحقق", style: TextStyle(color: Colors.white)),
            const SizedBox(height: 20),
            ConfirmButton(
              text: "تأكيد",
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => NewPasswordScreen()));
              },
            ),
          ],
        ),
      ),
    );
  }
}

class NewPasswordScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PasswordBackground(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const InputField(hint: "كلمة المرور الجديدة", obscureText: true),
            const InputField(hint: "تأكيد كلمة المرور", obscureText: true),
            ConfirmButton(
              text: "تأكيد",
              onPressed: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
              },
            ),
          ],
        ),
      ),
    );
  }
}

class PasswordBackground extends StatelessWidget {
  final Widget child;

  const PasswordBackground({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("asset/reset_password_screens.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: child,
      ),
    );
  }
}

class InputField extends StatelessWidget {
  final String hint;
  final bool obscureText;

  const InputField({required this.hint, this.obscureText = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      child: TextField(
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}

class ConfirmButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const ConfirmButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      height: 48,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
        onPressed: onPressed,
        child: Text(text, style: const TextStyle(color: Colors.white)),
      ),
    );
  }
}
