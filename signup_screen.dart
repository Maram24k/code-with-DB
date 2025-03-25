import 'package:flutter/material.dart';
import 'main.dart';
import 'role_selection_screen.dart';  // إذا تحتاجها
import 'login_screen.dart';  // إذا تحتاجها



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
                  const CustomTextField(label: "اسم المستخدم"),
                  const CustomTextField(label: "البريد الإلكتروني"),
                  const CustomTextField(label: "كلمة المرور", isPassword: true),
                  const CustomTextField(label: "تأكيد كلمة المرور", isPassword: true),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 280,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => TaskEntryScreen()));
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
