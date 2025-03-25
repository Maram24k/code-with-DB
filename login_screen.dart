import 'package:flutter/material.dart';
import 'main.dart';
import 'signup_screen.dart' as signup;
import 'main.dart' as main;
import 'reset_password_screen.dart';
import 'task_entry_screen.dart';  // تأكد من المسار
import 'package:gp/widgets/custom_text_field.dart' as widgets;



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
                  const widgets.CustomTextField(label: "اسم المستخدم أو البريد الإلكتروني"),
                  const SizedBox(height: 15),
                  const widgets.CustomTextField(label: "كلمة المرور", isPassword: true),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 280,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFFCC63)),
                      onPressed: () {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => TaskEntryScreen()));
                      },
                      child: const Text("تسجيل الدخول", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SignupScreen()));
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
