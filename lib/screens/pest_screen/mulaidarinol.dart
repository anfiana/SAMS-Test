import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fyp2/service/signUp/authentication.dart';
import 'dart:async'; // For Timer

class PestDetectionPage extends StatefulWidget {
  const PestDetectionPage({super.key});

  @override
  _PestDetectionPageState createState() => _PestDetectionPageState();
}

class _PestDetectionPageState extends State<PestDetectionPage> {
  final FirebaseDatabase database = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL: "https://fyp2-test1-default-rtdb.asia-southeast1.firebasedatabase.com",
  );

  late final DatabaseReference _databaseReference;

  String _detectionClass = "";
  double _detectionProbability = 0.0;
  List<Map<String, dynamic>> pestRecords = [];
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _databaseReference = database.ref("sensor_data");

    // Initial one-time read for all data.
    _databaseReference.once(DatabaseEventType.value).then((DatabaseEvent event) {
      final value = event.snapshot.value;
      print("One-time read: $value");
      if (value == null) {
        print("No data found at sensor_data (one-time read)!");
      }
    }).catchError((error) {
      print("One-time read ERROR: $error");
    });

    // Real-time listener for sensor_data updates.
    _databaseReference.onValue.listen((event) {
      final data = event.snapshot.value;

      if (data == null) {
        print("No data found at sensor_data (real-time)!");
        return;
      }

      final parsedData = Map<String, dynamic>.from(data as Map);

      // Parsing detection data (if exists).
      String detectionClass = parsedData['Detection_1_class'] ?? "";
      double detectionProbability =
          (parsedData['Detection_1_probability'] ?? 0.0).toDouble();

      print("Detection Class: $detectionClass");
      print("Detection Probability: $detectionProbability");

      setState(() {
        _detectionClass = detectionClass;
        _detectionProbability = detectionProbability;
        
        // Add the new record to the list (Simulating IoT record update).
        final DateTime now = DateTime.now();
        pestRecords.add({
          'time': now,
          'title': 'Pest Detected: $detectionClass',
          'description': 'Detection Probability: ${detectionProbability.toStringAsFixed(2)}',
        });

        // Automatically remove records older than 24 hours.
        pestRecords.removeWhere((record) {
          final DateTime recordTime = record['time'];
          return now.difference(recordTime) > const Duration(hours: 24);
        });
      });
    }, onError: (Object error) {
      print("Real-time listener error: $error");
    });

    _startUpdatingSensorData();
  }

  void _startUpdatingSensorData() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) async {
      // This will automatically fetch and update the sensor data.
      await fetchAndUpdateSensorData();
    });
  }

  Future<void> fetchAndUpdateSensorData() async {
    // This function can be used to simulate fetching new data if needed.
    Map<String, dynamic>? latestData = await AuthMethod().getLatestSensorData();

    if (latestData != null) {
      setState(() {
        _detectionClass = latestData['Detection_1_class'] ?? "";
        _detectionProbability =
            (latestData['Detection_1_probability'] as num?)?.toDouble() ?? 0.0;
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
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
                fontWeight: FontWeight.bold,
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
