import 'package:flutter/material.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:page_transition/page_transition.dart';
import 'package:plantoguard/constants.dart';
import 'package:plantoguard/pages/login_page.dart';
import 'package:plantoguard/services/api_service.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({Key? key}) : super(key: key);

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _register(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    final response = await ApiService.registerUser(
      email: _emailController.text,
      fullName: _nameController.text,
      password: _passwordController.text,
    );

    Navigator.of(context).pop();

    if (response != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Registration Successful',
            message: 'You have successfully registered!',
            contentType: ContentType.success,
          ),
          duration: Duration(milliseconds: 600),
        ),
      );

      await Future.delayed(const Duration(milliseconds: 600));
      Navigator.pushReplacement(
        context,
        PageTransition(
          child: LoginPage(),
          type: PageTransitionType.bottomToTop,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Registration Failed',
            message: 'Please check your inputs and try again.',
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
                          controller: _nameController,
                          decoration: const InputDecoration(
                            hintText: 'Enter Full Name',
                            prefixIcon: Icon(Icons.person),
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
                            onPressed: () => _register(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Constants.primaryColor,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              'Register',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
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
                                'Sign Up with Google',
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
                                  child: LoginPage(),
                                  type: PageTransitionType.bottomToTop,
                                ),
                              );
                            },
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Have an Account? ',
                                    style:
                                        TextStyle(color: Constants.blackColor),
                                  ),
                                  TextSpan(
                                    text: 'Login',
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