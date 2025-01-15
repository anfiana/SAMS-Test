import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fyp2/navigation_service.dart';
import 'package:fyp2/provider/getit.dart'; // Ensure this contains `setupLocator`
import 'package:fyp2/routes/routes.dart';
import 'package:fyp2/screens/splash_screen/splash_screen.dart';
import 'package:fyp2/screens/pest_screen/pest_detec.dart'; // Import PestDetectionPage correctly

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  print("Firebase initialized successfully");
  setupLocator(); // Initialize the NavigationService
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  final ThemeMode themeMode = ThemeMode.system;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SAMS',
      navigatorKey: getIt<NavigationService>().navigatorKey,
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      theme: ThemeData(
        fontFamily: 'Nato Sans',
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Colors.grey,
          selectionColor: Colors.blueGrey,
        ),
        colorScheme: const ColorScheme.light(
          primary: Color(0xFFF2F2F2),
          surface: Color(0xFF1A5319),
          error: Color(0xFFB00020),
          onPrimary: Color(0xFFF5EFE7),
          onSecondary: Colors.white,
          onSurface: Colors.black,
          onError: Colors.white,
          brightness: Brightness.light,
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.bold,
            fontSize: 32,
            color: Color.fromARGB(255, 0, 0, 0),
          ),
          displayMedium: TextStyle(
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: Color(0xFF464646),
          ),
          displaySmall: TextStyle(
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.w400,
            fontSize: 18,
            color: Color(0xFF464646),
          ),
          headlineMedium: TextStyle(
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.w400,
            fontSize: 18,
            color: Color.fromARGB(255, 0, 0, 0),
          ),
          headlineSmall: TextStyle(
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.w400,
            fontSize: 12,
            color: Color(0xFFBDBDBD),
          ),
          titleLarge: TextStyle(
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: Color(0xFF464646),
          ),
        ),
      ),
      routes: {
        ...routes,
        '/pestDetection': (context) => const PestDetectionPage(),
      },
      home: const SplashScreen(),
    );
  }
}
