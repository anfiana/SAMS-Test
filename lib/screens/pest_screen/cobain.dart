import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:async';

class PestDetectionPage extends StatefulWidget {
  const PestDetectionPage({super.key});

  @override
  _PestDetectionPageState createState() => _PestDetectionPageState();
}

class _PestDetectionPageState extends State<PestDetectionPage> {
  final List<Map<String, dynamic>> pestRecords = [];
  final FirebaseDatabase database = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL: "https://fyp2-test1-default-rtdb.asia-southeast1.firebasedatabase.com",
  );

  late final DatabaseReference _databaseReference;


  @override
  void simulateIoTUpdates() {
    Timer.periodic(const Duration(seconds: 10), (timer) {
      final DateTime now = DateTime.now();
      final newRecord = {
        'time': now,
        'title': 'Pest Record ${pestRecords.length + 1}',
        'description': 'Details about pest detected.',
      };

      setState(() {
        pestRecords.add(newRecord);
      });

      // Automatically remove records older than 24 hours
      pestRecords.removeWhere((record) {
        final DateTime recordTime = record['time'];
        return now.difference(recordTime) > const Duration(hours: 24);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pest Detection',
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFF1A5319),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Scanned Environment Data',
              style: TextStyle(
                fontSize: 24.0,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: pestRecords.length,
                itemBuilder: (context, index) {
                  final record = pestRecords[index];
                  return Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      leading: const Icon(
                        Icons.bug_report,
                        color: Color(0xFF1A5319), // Green icon
                      ),
                      title: Text(
                        record['title'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A5319), // Green text
                        ),
                      ),
                      subtitle: Text(
                        record['description'],
                        style: const TextStyle(
                          color: Colors.grey, // Subtitle text color
                        ),
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.grey, // Trailing icon color
                      ),
                     
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

