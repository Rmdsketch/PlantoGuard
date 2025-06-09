import 'package:flutter/material.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:page_transition/page_transition.dart';
import 'package:plantoguard/pages/forgot_password.dart';
import 'package:plantoguard/pages/register_page.dart';
import 'package:plantoguard/pages/root_page.dart';
import 'package:plantoguard/services/api_service.dart';
import 'package:plantoguard/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    final response = await ApiService.loginUser(
      email: _emailController.text,
      password: _passwordController.text,
    );

    final prefs = await SharedPreferences.getInstance();
    if (response != null && response['token'] != null) {
      await prefs.setString('token', response['token']);
    }

    Navigator.of(context).pop();
    if (response != null && response['message'] == 'Login successful') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          margin: EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
          ),
          content: AwesomeSnackbarContent(
            title: "Login Successful",
            message: "Welcome back!",
            contentType: ContentType.success,
          ),
          duration: Duration(milliseconds: 600),
        ),
      );
      await Future.delayed(const Duration(milliseconds: 600));

      Navigator.pushAndRemoveUntil(
        context,
        PageTransition(
          child: const RootPage(),
          type: PageTransitionType.bottomToTop,
        ),
        (route) => false,
      );
      
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: "Login Failed",
            message: "Please check your credentials.",
            contentType: ContentType.failure,
          ),
          duration: Duration(milliseconds: 600),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              children: [
                Flexible(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Center(
                      child: Image.asset(
                        'assets/images/PlantoGuard.png',
                        width: size.width * 1.8,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'PlantoGuard',
                          style: TextStyle(
                            color: Constants.primaryColor,
                            fontSize: 35.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            hintText: 'Enter Email',
                            prefixIcon: Icon(Icons.alternate_email),
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            hintText: 'Enter Password',
                            prefixIcon: Icon(Icons.lock),
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => _login(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Constants.primaryColor,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              'Login',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                PageTransition(
                                  child: ForgotPassword(),
                                  type: PageTransitionType.bottomToTop,
                                ),
                              );
                            },
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  const TextSpan(
                                    text: 'Forgot your password? ',
                                    style: TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'Reset here',
                                    style: TextStyle(
                                      color: Constants.primaryColor,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 25),
                        const Row(
                          children: [
                            Expanded(child: Divider()),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Text('OR'),
                            ),
                            Expanded(child: Divider()),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 14),
                          decoration: BoxDecoration(
                            border: Border.all(color: Constants.primaryColor),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset('assets/images/google.png',
                                  height: 24),
                              const SizedBox(width: 10),
                              Text(
                                'Sign In with Google',
                                style: TextStyle(
                                  color: Constants.blackColor,
                                  fontSize: 16.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                PageTransition(
                                  child: RegisterPage(),
                                  type: PageTransitionType.bottomToTop,
                                ),
                              );
                            },
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'New to Planty? ',
                                    style:
                                        TextStyle(color: Constants.blackColor),
                                  ),
                                  TextSpan(
                                    text: 'Register',
                                    style: TextStyle(
                                        color: Constants.primaryColor),
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
              ],
            );
          },
        ),
      ),
    );
  }
}
