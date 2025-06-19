import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp2/config/size_config.dart';  // Ensure you have this if you're using it.
import 'package:fyp2/view/snackbar.dart';  // Add your Snackbar widget or function

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({super.key});

  @override
  _ForgetPasswordPageState createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  String? _emailError;

  // Firebase Auth instance for sending password reset email
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool isValidEmail(String email) {
    // Regular expression for validating email addresses
    final RegExp emailRegex =
        RegExp(r'^[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  void _validateEmail() {
    setState(() {
      if (_emailController.text.isEmpty) {
        _emailError = 'Email cannot be empty';
      } else if (!isValidEmail(_emailController.text)) {
        _emailError = 'Please enter a valid email address';
      } else {
        _emailError = null; // Clear the error
      }
    });
  }

  void _resetPassword() async {
    if (_emailError == null && _emailController.text.isNotEmpty) {
      try {
        // Send password reset email
        await _auth.sendPasswordResetEmail(email: _emailController.text);
        // Show success message
        showSnackBar(context,
            "A password reset link has been sent to your email address.");

        // Show confirmation dialog
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: Colors.white,
              title: const Text("Password Reset"),
              content: const Text(
                  "A password reset link has been sent to your email address."),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                    Navigator.of(context).pop(); // Navigate back to login
                  },
                  child: const Text(
                    "OK",
                    style: TextStyle(color: Color(0xFF1A5319)),
                  ),
                ),
              ],
            );
          },
        );
      } catch (e) {
        // Handle any errors
        showSnackBar(context, e.toString());
      }
    } else {
      _validateEmail();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
            'Forget Password',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        centerTitle: true,
        backgroundColor: const Color(0xFF1A5319),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Image.asset(
                'assets/images/farm.png', // Your image path
                height: getProportionateScreenHeight(300),
                width: double.infinity,
                fit: BoxFit.fill,
              ),
              Positioned(
                bottom: getProportionateScreenHeight(20),
                left: getProportionateScreenWidth(20),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'FORGET PASSWORD',
                        style: Theme.of(context)
                            .textTheme
                            .displayLarge!
                            .copyWith(
                                color: const Color.fromARGB(255, 255, 255, 255),
                                fontSize: 36),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              'Enter your email to reset your password',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: TextField(
              controller: _emailController,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(70.0),
                ),
                hintText: 'Email',
                errorText: _emailError,
                suffixIcon: const Icon(
                  Icons.email,
                  color: Colors.black,
                ),
                fillColor: Colors.white, // Set the background color to white
                filled: true, // Enable the fill color
              ),
              onChanged: (value) {
                _validateEmail();
              },
            ),
          ),
          SizedBox(height: getProportionateScreenHeight(20)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GestureDetector(
              onTap: _resetPassword,  // Call reset password when tapped
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF8E8), // Green background
                  borderRadius: BorderRadius.circular(70.0),
                ),
                alignment: Alignment.center,
                child: const Text(
                  'Reset Password',
                  style: TextStyle(
                    color: Color(0xFF493628),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
