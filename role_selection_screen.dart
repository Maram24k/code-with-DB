import 'package:flutter/material.dart';

import 'other_classes.dart';
import 'task_entry_screen.dart';



class ResetPasswordScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PasswordBackground(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "هل نسيت كلمة المرور؟",
              style: TextStyle(fontSize: 22, color: Colors.white),
            ),
            const SizedBox(height: 10),
            const Text(
              "يرجى كتابة بريدك الإلكتروني لاستلام رمز التأكيد",
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            const InputField(hint: "عنوان البريد الإلكتروني"),
            const SizedBox(height: 20),
            ConfirmButton(
              text: "تأكيد البريد الإلكتروني",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => VerifyCodeScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
