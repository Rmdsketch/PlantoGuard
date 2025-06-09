import 'package:flutter/material.dart';
import 'package:plantoguard/pages/login_page.dart';
import 'package:plantoguard/pages/profile_page.dart';
import 'package:plantoguard/pages/register_page.dart';
import 'package:plantoguard/pages/onboarding_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PlantoGuard',
      home: const OnboardingScreen(),
      debugShowCheckedModeBanner: false,
      routes: {
        '/login': (context) => LoginPage(),
        '/profile': (context) => const ProfilePage(),
        '/register': (context) => RegisterPage(),
      },
    );
  }
}
