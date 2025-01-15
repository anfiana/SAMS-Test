import 'package:fyp2/config/size_config.dart';
import 'package:fyp2/screens/login_screen/login_screen.dart';
import 'package:fyp2/screens/register_screen/register_screen.dart';
import 'package:flutter/material.dart';

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 14,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFF1A5319),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            height: getProportionateScreenHeight(20),
          ),
          Material(
            color: Colors.transparent,
            child: Image.asset('assets/images/splash_img.png'),
          ),

          // Buttons section
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context)
                        .pushReplacementNamed(LoginScreen.routeName);
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      borderRadius: BorderRadius.circular(70.0),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      'Login',
                      style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                    ),
                  ),
                ),
              ),
              SizedBox(height: getProportionateScreenHeight(10)),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegisterScreen()),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      borderRadius: BorderRadius.circular(70.0),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      'Register',
                      style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
