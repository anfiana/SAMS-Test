import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fyp2/config/size_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: Text("Edit Profile")),
        body: const Body(),
      ),
    );
  }
}

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  // Text Controllers for form fields
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: getProportionateScreenWidth(20),
        right: getProportionateScreenWidth(20),
        bottom: getProportionateScreenHeight(15),
      ),
      child: ListView(
        children: [
          SizedBox(height: getProportionateScreenHeight(40)),
          Padding(
            padding: const EdgeInsets.only(left: 7, right: 7),
            child: Row(
              children: [
                const Text(
                  'Edit Profile',
                  style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: const Icon(
                    Icons.close,
                    size: 35,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: getProportionateScreenHeight(25)),
          Form(
            key: _formKey,
            child: Column(
              children: [
                // Username Field
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: usernameController,
                  autofocus: false,
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value!.isEmpty || value.trim().isEmpty) {
                      return 'Username is required';
                    }
                    return null;
                  },
                  cursorColor: Colors.black12,
                  decoration: InputDecoration(
                    hintText: 'Username',
                    hintStyle: const TextStyle(color: Colors.grey),
                    icon: Container(
                      height: 50,
                      width: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A5319),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Icon(
                        Icons.person,
                        color: Colors.white,
                      ),
                    ),
                    border: const UnderlineInputBorder(),
                  ),
                ),
                SizedBox(height: getProportionateScreenHeight(20)),

                // Password Field
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: passwordController,
                  autofocus: false,
                  obscureText: true,
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value!.isEmpty || value.trim().isEmpty) {
                      return 'Password is required';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                  cursorColor: Colors.black12,
                  decoration: InputDecoration(
                    hintText: 'New Password',
                    hintStyle: const TextStyle(color: Colors.grey),
                    icon: Container(
                      height: 50,
                      width: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A5319),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Icon(
                        Icons.lock,
                        color: Colors.white,
                      ),
                    ),
                    border: const UnderlineInputBorder(),
                  ),
                ),
                SizedBox(height: getProportionateScreenHeight(20)),

                // Confirm Password Field
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: confirmPasswordController,
                  autofocus: false,
                  obscureText: true,
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value!.isEmpty || value.trim().isEmpty) {
                      return 'Confirm Password is required';
                    }
                    if (value != passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                  cursorColor: Colors.black12,
                  decoration: InputDecoration(
                    hintText: 'Confirm Password',
                    hintStyle: const TextStyle(color: Colors.grey),
                    icon: Container(
                      height: 50,
                      width: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A5319),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Icon(
                        Icons.lock,
                        color: Colors.white,
                      ),
                    ),
                    border: const UnderlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: getProportionateScreenHeight(20)),

          // Save Changes Button
          GestureDetector(
            onTap: () async {
              if (_formKey.currentState!.validate()) {
                await saveChangesToFirestore();
              }
            },
            child: Container(
              height: getProportionateScreenHeight(40),
              decoration: BoxDecoration(
                color: const Color(0xFF1A5319),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Center(
                child: Text(
                  'Save Changes',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.white70,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Function to update Firestore and Firebase Authentication
  Future<void> saveChangesToFirestore() async {
    try {
      // Fetch the current user's UID
      String userID = FirebaseAuth.instance.currentUser!.uid;

      // Update the user's password in Firebase Authentication
      String newPassword = passwordController.text.trim();
      if (newPassword.isNotEmpty) {
        await FirebaseAuth.instance.currentUser!.updatePassword(newPassword);
      }

      // Create a map of updated user data for Firestore
      Map<String, dynamic> userData = {
        "name": usernameController.text.trim(),
      };

      // Update the Firestore document
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userID)
          .set(userData, SetOptions(merge: true));

      // Show success dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: const Text(
              'Success',
              style: TextStyle(color: Colors.black),
            ),
            content: const Text(
              'Username and Password Updated Successfully!',
              style: TextStyle(color: Colors.black),
            ),
            actions: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close dialog
                    Navigator.of(context)
                        .pushReplacementNamed('/home-screen'); // Navigate to Home Screen
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A5319),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'OK',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          );
        },
      );
    } catch (e) {
      // Handle errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to update profile: $e")),
      );
    }
  }
}
