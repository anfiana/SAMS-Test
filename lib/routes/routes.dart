// Import necessary files
import 'package:fyp2/screens/edit_profile/edit_profile.dart';
import 'package:fyp2/screens/login_screen/login_screen.dart';
//import 'package:fyp2/screens/settings_screen/settings_screen.dart';
import 'package:fyp2/screens/splash_screen/splash_screen.dart';
import 'package:fyp2/screens/home_screen/components/report_center.dart';
import 'package:flutter/cupertino.dart';
import 'package:fyp2/screens/home_screen/home_screen.dart';
//import 'package:fyp2/screens/home_screen/components/notification_page.dart';
import 'package:fyp2/screens/logout/logout.dart';

// Sample notification list for testing
final List<Map<String, String>> notifications = [
  {
    'title': 'Moisture Alert',
    'message': 'Moisture level exceeded 50%!',
  },
  {
    'title': 'Temperature Update',
    'message': 'Temperature is now at 25°C.',
  },
];

// Routes arranged in ascending order
final Map<String, WidgetBuilder> routes = {
  EditProfile.routeName: (context) => const EditProfile(),
  HomeScreen.routeName: (context) => const HomeScreen(),
  LoginScreen.routeName: (context) => const LoginScreen(),
  LogoutPage.routeName: (context) => const LogoutPage(),
  ReportCenter.routeName: (context) => const ReportCenter(),
  //SettingScreen.routeName: (context) => const SettingScreen(),
  SplashScreen.routeName: (context) => const SplashScreen(),
};
