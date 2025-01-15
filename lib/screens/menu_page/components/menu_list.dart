import 'package:fyp2/screens/menu_page/components/list_tile.dart';
import 'package:fyp2/screens/edit_profile/edit_profile.dart';
import 'package:fyp2/screens/home_screen/components/report_center.dart';
//import 'package:fyp2/screens/home_screen/components/notification_page.dart';
import 'package:flutter/material.dart';
import 'package:fyp2/config/size_config.dart';

class MenuList extends StatelessWidget {
  const MenuList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          //height: getProportionateScreenHeight(10),
        ),
        MenuListItems(
          iconPath: 'assets/icons/menu_icons/devices.svg',
          itemName: 'Edit Profile',
          function: () => Navigator.of(context).pushNamed(
            EditProfile.routeName,
          ),
        ),
        SizedBox(
          height: getProportionateScreenHeight(10),
        ),
        MenuListItems(
          iconPath: 'assets/icons/menu_icons/settings.svg',
          itemName: 'Report Center',
          function: () => Navigator.of(context).pushNamed(
            ReportCenter.routeName,
          ),
        ),
        SizedBox(
          height: getProportionateScreenHeight(10),
        ),
        /*MenuListItems(
          iconPath: 'assets/icons/menu_icons/notifications.svg',
          itemName: 'Notification',
          function: () => Navigator.of(context).pushNamed(
            NotificationPage.routeName,
          ),
        ),*/
        SizedBox(
          height: getProportionateScreenHeight(10),
        ),
        MenuListItems(
          iconPath: 'assets/icons/menu_icons/logout.svg',
          itemName: 'Logout',
          function: () {
            _showLogoutDialog(context); // Show the logout confirmation dialog
          },
        ),
      ],
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), // Rounded corners
          ),
          backgroundColor: Colors.white, // White background for the dialog
          title: const Text(
            'Confirm Logout',
            style: TextStyle(color: Colors.black), // Black text color
          ),
          content: const Text(
            'Are you sure you want to logout?',
            style: TextStyle(color: Colors.black), // Black text color
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text(
                'No',
                style: TextStyle(color: Colors.black), // Black text color
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black, // Black button background
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Rounded corners
                ),
              ),
              onPressed: () {
                Navigator.pushReplacementNamed(
                    context, '/splash-screen'); // Navigate to the login screen
              },
              child: const Text(
                'Yes',
                style: TextStyle(color: Colors.white), // White text color
              ),
            ),
          ],
        );
      },
    );
  }
}
