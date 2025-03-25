import 'package:flutter/material.dart';

class PasswordBackground extends StatelessWidget {
  final Widget child;

  const PasswordBackground({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("asset/reset_password_screens.jpg"),
            fit: BoxFit.contain, // بدل cover مؤقتًا للتجربة
            alignment: Alignment.center,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: child,
          ),
        ),
      ),
    );
  }
}
