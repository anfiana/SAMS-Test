import 'package:flutter/material.dart';
import 'package:fyp2/config/size_config.dart';
import 'package:fyp2/screens/home_screen/home_screen.dart';
import 'package:fyp2/screens/forget_password/forget_password.dart';
import 'package:fyp2/screens/register_screen/register_screen.dart';
import 'package:fyp2/service/signUp/authentication.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _loginUser() async {
    setState(() {
      _isLoading = true;
    });

    // Send login request to the back-end
    String res = await AuthMethod().loginUser(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    setState(() {
      _isLoading = false;
    });

    if (res == "success") {
      Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            res,
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Image.asset(
                'assets/images/login.png',
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
                        'LOGIN',
                        style:
                            Theme.of(context).textTheme.displayLarge!.copyWith(
                                  color: Colors.white,
                                  fontSize: 64,
                                ),
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
              'Sign into \nmanage your device',
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
                suffixIcon: const Icon(
                  Icons.email,
                  color: Colors.black,
                ),
                fillColor: Colors.white,
                filled: true,
              ),
            ),
          ),
          SizedBox(height: getProportionateScreenHeight(20)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(70.0),
                ),
                hintText: 'Password',
                suffixIcon: const Icon(
                  Icons.lock,
                  color: Colors.black,
                ),
                fillColor: Colors.white,
                filled: true,
              ),
              obscureText: true,
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 30.0, top: 8.0),
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ForgetPasswordPage(),
                    ),
                  );
                },
                child: const Text(
                  'Forget Password?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GestureDetector(
              onTap: _isLoading ? null : _loginUser,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: const Color(0XFFFBF6E9),
                  borderRadius: BorderRadius.circular(70.0),
                ),
                alignment: Alignment.center,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Color(0XFF493628))
                    : const Text(
                        'Login',
                        style: TextStyle(color: Color(0XFF493628)),
                      ),
              ),
            ),
          ),
          SizedBox(height: getProportionateScreenHeight(10)),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Not having an account?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RegisterScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    'SignUp',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
