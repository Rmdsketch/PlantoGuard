import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:plantoguard/constants.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:plantoguard/pages/login_page.dart';
import 'package:page_transition/page_transition.dart';

class ForgotPassword extends StatelessWidget {
  ForgotPassword({Key? key}) : super(key: key);

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  Future<void> _resetPassword(BuildContext context) async {
    final email = _emailController.text.trim();
    final newPassword = _newPasswordController.text.trim();

    if (email.isEmpty || newPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: "Error",
            message: "Please fill in both fields.",
            contentType: ContentType.failure,
          ),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:5000/auth/reset-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'new_password': newPassword,
        }),
      );

      final jsonBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            elevation: 0,
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            content: AwesomeSnackbarContent(
              title: "Success",
              message: "Password reset successfully",
              contentType: ContentType.success,
            ),
            duration: Duration(milliseconds: 600),
          ),
        );

        await Future.delayed(const Duration(seconds: 2));
        Navigator.pushReplacement(
          context,
          PageTransition(
              child: LoginPage(), type: PageTransitionType.bottomToTop),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            elevation: 0,
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            content: AwesomeSnackbarContent(
              title: "Failed",
              message: jsonBody['message'] ?? 'Reset failed',
              contentType: ContentType.failure,
            ),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: "Error",
            message: "Don't connet to server!.",
            contentType: ContentType.failure,
          ),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/images/reset-password.png'),
              const SizedBox(height: 10),
              const Text(
                'Forgot Password',
                style: TextStyle(
                  fontSize: 35.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 30),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: 'Enter Email',
                  prefixIcon: Icon(Icons.alternate_email),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _newPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: 'Enter New Password',
                  prefixIcon: Icon(Icons.lock_reset),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () => _resetPassword(context),
                child: Container(
                  width: size.width,
                  decoration: BoxDecoration(
                    color: Constants.primaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  child: const Center(
                    child: Text(
                      'Reset Password',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    PageTransition(
                      child: LoginPage(),
                      type: PageTransitionType.bottomToTop,
                    ),
                  );
                },
                child: Center(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Have an Account? ',
                          style: TextStyle(color: Constants.blackColor),
                        ),
                        TextSpan(
                          text: 'Login',
                          style: TextStyle(color: Constants.primaryColor),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
