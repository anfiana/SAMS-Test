/*
import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  static String routeName = '/notification';
  final List<Map<String, String>> notifications;

  const NotificationPage({Key? key, required this.notifications}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
        backgroundColor: const Color(0xFF1A5319),
      ),
      body: notifications.isEmpty
          ? Center(
              child: Text(
                "No notifications available.",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            )
          : ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return ListTile(
                  title: Text(notification['title'] ?? "No Title"),
                  subtitle: Text(notification['body'] ?? "No Body"),
                  trailing: Text(notification['time'] ?? ""),
                );
              },
            ),
    );
  }
}
*/
