import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class PestDetectionPage extends StatefulWidget {
  const PestDetectionPage({super.key});

  @override
  State<PestDetectionPage> createState() => _PestDetectionPageState();
}

class _PestDetectionPageState extends State<PestDetectionPage> {
  // Reference to the 'predictions' node in the database
  Query dbRef = FirebaseDatabase.instance.ref().child('predictions');
  DatabaseReference reference = FirebaseDatabase.instance.ref().child('predictions');

  Widget listItem({required Map<String, dynamic> pestData}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Class: ${pestData['Detection_1_class']}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(
              "Probability: ${(pestData['Detection_1_probability'] * 100).toStringAsFixed(2)}%",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 5),
            Text(
              "Timestamp: ${pestData['timestamp']}",
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pest Detection"),
        backgroundColor: const Color(0xFF1A5319), // Optional: adjust the theme color
      ),
      body: FirebaseAnimatedList(
        query: dbRef,
        itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index) {
          if (snapshot.value == null) {
            return const Center(child: Text("No pest data found."));
          }

          // Parse the snapshot into a Map
          Map<String, dynamic> pestData = Map<String, dynamic>.from(snapshot.value as Map);
          pestData['key'] = snapshot.key;

          return listItem(pestData: pestData);
        },
      ),
    );
  }
}
