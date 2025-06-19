import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class PestDetectionPage extends StatefulWidget {
  const PestDetectionPage({super.key});

  @override
  PestDetectionPageState createState() => PestDetectionPageState();
}

class PestDetectionPageState extends State<PestDetectionPage> {
  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.ref().child('predictions');

  List<Map<String, dynamic>> pestRecords = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchDataFromFirebase();
  }

  // Function to fetch and process data from Firebase in real-time
  void _fetchDataFromFirebase() {
    _databaseReference.onValue.listen((event) {
      final snapshotValue = event.snapshot.value;

      if (snapshotValue == null) {
        setState(() {
          isLoading = false;
          pestRecords = [];
        });
        return;
      }

      try {
        final data = Map<String, dynamic>.from(snapshotValue as Map<dynamic, dynamic>);
        List<Map<String, dynamic>> records = [];

        data.forEach((key, value) {
          if (value is Map<dynamic, dynamic>) {
            final record = {
              'class': value['Detection_1_class'] ?? 'Unknown',
              'probability': value['Detection_1_probability'] ?? 0.0,
              'timestamp': value['timestamp'] ?? 'Unknown',
            };
            records.add(record);
          }
        });

        setState(() {
          pestRecords = records;
          isLoading = false;
        });
      } catch (e) {
        setState(() {
          isLoading = false;
        });
      }
    }, onError: (error) {
      setState(() {
        isLoading = false;
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
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white, 
    ),
  ),
  centerTitle: true,
  backgroundColor: const Color(0xFF1A5319), // Matches the background color
  iconTheme: const IconThemeData(color: Colors.white), // Ensures back icon is white
),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : pestRecords.isEmpty
              ? const Center(child: Text("No pest data available."))
              : ListView.builder(
                  itemCount: pestRecords.length,
                  itemBuilder: (context, index) {
                    final record = pestRecords[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      child: ListTile(
                        leading: Icon(
                          Icons.bug_report,
                          color: Colors.red.shade700,
                        ),
                        title: Text(
                          'Pest: ${record['class']}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          'Probability: ${(record['probability'] * 100).toStringAsFixed(2)}%\n'
                          'Timestamp: ${record['timestamp']}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}