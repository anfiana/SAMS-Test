import 'package:flutter/material.dart';
import 'package:fyp2/screens/login_screen/login_screen.dart';
import 'package:fyp2/service/signUp/authentication.dart';
import 'package:fyp2/config/size_config.dart'; // Import the backend AuthMethod class
// Import Realtime Database

class RegisterScreen extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  RegisterScreen({super.key});

  /// A simple regex-based function to validate email format.
  bool _isValidEmail(String email) {
    return RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email);
  }

  /// Helper method to show a SnackBar with a given message.
  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  /// Display a dialog after successful registration.
  void _showVerificationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text(
            "Registration Complete",
            style: TextStyle(color: Colors.black),
          ),
          content: const Text(
            "Your registration is successful.\nPlease log in to your account.",
            style: TextStyle(color: Colors.black),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacementNamed('/login-screen');
              },
              child: const Text(
                "OK",
                style: TextStyle(color: Colors.green),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A5319),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A5319),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          const Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: 100),
              child: Text(
                'SignUp',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.all(40.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: usernameController,
                    decoration: const InputDecoration(
                      labelText: 'Username',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: confirmPasswordController,
                    decoration: const InputDecoration(
                      labelText: 'Confirm Password',
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                  ),
                SizedBox(height: getProportionateScreenHeight(10)),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Have an account already?',
                          style: TextStyle(
                            color: Color(0xFF1A5319),
                            fontSize: 16,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            'Login',
                            style: TextStyle(
                              color:Color(0xFF1A5319),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () async {
                      final username = usernameController.text.trim();
                      final email = emailController.text.trim();
                      final password = passwordController.text;
                      final confirmPassword = confirmPasswordController.text;
                      print("TEST123");
                      Map<String, dynamic>? latestData = await AuthMethod().getLatestSensorData();
                      
                      print("GOTIT\n\n\n\n\n\n");

                      

                      if (username.length < 4 || username.length > 10) {
                        _showError(context,
                            "Username must be between 4 and 10 characters.");
                        return;
                      }
                      if (!_isValidEmail(email)) {
                        _showError(context, "Please enter a valid email.");
                        return;
                      }
                      if (password.length <= 6) {
                        _showError(context,
                            "Password must be more than 6 characters.");
                        return;
                      }
                      if (password != confirmPassword) {
                        _showError(context,
                            "Confirm password does not match password.");
                        return;
                      }

                      // Call Firebase back-end
                      String res = await AuthMethod().signupUser(
                        email: email,
                        password: password,
                        name: username,
                      );

                      if (res == "success") {
                        _showVerificationDialog(context);
                      } else {
                        _showError(context, res);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1A5319),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(70.0),
                      ),
                      padding: const EdgeInsets.all(16.0),
                    ),
                    child: const Text(
                      'Register',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
