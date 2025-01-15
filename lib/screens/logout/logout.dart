import 'package:flutter/material.dart';
import 'package:fyp2/screens/login_screen/login_screen.dart'; // Import your LoginScreen

class LogoutPage extends StatelessWidget {
  const LogoutPage({super.key});

  static const String routeName = '/logout-page';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Logout'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            _showLogoutDialog(context);
          },
          child: const Text('Logout'),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('No'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, LoginScreen.routeName);
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }
}
