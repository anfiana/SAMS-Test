import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:fyp2/config/size_config.dart';
import 'package:fyp2/view/home_screen_view_model.dart';
import 'package:fyp2/screens/plants_manager/plants_manager.dart';
import 'package:fyp2/service/signUp/authentication.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'dart:async'; // For Timer
import 'dark_container.dart';

class Body extends StatefulWidget {
  final HomeScreenViewModel model;
  const Body({super.key, required this.model});

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final FirebaseDatabase database = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL: "https://fyp2-test1-default-rtdb.asia-southeast1.firebasedatabase.com",
  );

  late final DatabaseReference _databaseReference;

  double _temperature = 0.0;
  double _humidity = 0.0;
  double _moisture1 = 0.0;
  double _moisture2 = 0.0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _databaseReference = database.ref("sensor_data");

    _databaseReference.once(DatabaseEventType.value).then((DatabaseEvent event) {
      final value = event.snapshot.value;
      print("One-time read: $value");
      if (value == null) {
        print("No data found at sensor_data (one-time read)!");
      }
    }).catchError((error) {
      print("One-time read ERROR: $error");
    });

    _databaseReference.onValue.listen((event) {
      final data = event.snapshot.value;

      if (data == null) {
        print("No data found at sensor_data (real-time)!");
        return;
      }

      final parsedData = Map<String, dynamic>.from(data as Map);

      final double humidity = (parsedData['humidity'] ?? 0.0).toDouble();
      final double temperature = (parsedData['temperature'] ?? 0.0).toDouble();
      final double moisture1 = (parsedData['moisture_sensor_1'] ?? 0.0).toDouble();
      final double moisture2 = (parsedData['moisture_sensor_2'] ?? 0.0).toDouble();

      print("Humidity: $humidity");
      print("Temperature: $temperature");
      print("Moisture #1: $moisture1");
      print("Moisture #2: $moisture2");

      setState(() {
        _temperature = temperature;
        _humidity = humidity;
        _moisture1 = moisture1;
        _moisture2 = moisture2;
      });
    }, onError: (Object error) {
      print("Real-time listener error: $error");
    });

    _startUpdatingSensorData();
  }

  Future<void> fetchAndUpdateSensorData() async {
    Map<String, dynamic>? latestData = await AuthMethod().getLatestSensorData();

    if (latestData != null) {
      setState(() {
        _temperature = (latestData['temperature'] as num?)?.toDouble() ?? 0.0;
        _humidity = (latestData['humidity'] as num?)?.toDouble() ?? 0.0;
        _moisture1 = (latestData['moisture_sensor_1'] as num?)?.toDouble() ?? 0.0;
        _moisture2 = (latestData['moisture_sensor_2'] as num?)?.toDouble() ?? 0.0;
      });
    }
  }

  void _startUpdatingSensorData() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) async {
      await fetchAndUpdateSensorData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: getProportionateScreenWidth(7),
          vertical: getProportionateScreenHeight(7),
        ),
        decoration: const BoxDecoration(
          color: Color(0xFFFFFFFF),
        ),
        child: Column(
          children: [
            SizedBox(height: getProportionateScreenHeight(5)),
            _buildTemperatureAndHumidityRow(context),
            _buildMoistureRow(context),
            _buildButton(
              context,
              label: 'Pest Detection',
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const PestDetectionPage()),
              ),
            ),
            _buildButton(
              context,
              label: 'Plant Manager',
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const PlantsPage()),
              ),
            ),
            //_buildDarkContainerRow(),
            SizedBox(height: getProportionateScreenHeight(10)),
          ],
        ),
      ),
    );
  }

  Widget _buildTemperatureAndHumidityRow(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildSleekCircularSlider(
            context,
            label: 'Temperature',
            initialValue: _temperature,
          ),
        ),
        Expanded(
          child: _buildSleekCircularSlider(
            context,
            label: 'Humidity',
            initialValue: _humidity,
          ),
        ),
      ],
    );
  }

  Widget _buildMoistureRow(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: getProportionateScreenHeight(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Moisture Sensor 1',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          LinearPercentIndicator(
            lineHeight: 20.0,
            percent: _moisture1 / 100, // Assuming moisture is a percentage (0-100)
            backgroundColor: const Color(0xFFBDBDBD),
            progressColor: const Color(0xFF1A5319),
            animation: true,
            animationDuration: 500,
            barRadius: const Radius.circular(10),
            center: Text(
              '${_moisture1.toInt()}%',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.white, // Ensures the text is visible on the progress bar
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          SizedBox(height: getProportionateScreenHeight(10)),
          Text(
            'Moisture Sensor 2',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          LinearPercentIndicator(
            lineHeight: 20.0,
            percent: _moisture2 / 100, // Assuming moisture is a percentage (0-100)
            backgroundColor: const Color(0xFFBDBDBD),
            progressColor: const Color(0xFF1A5319),
            animation: true,
            animationDuration: 500,
            barRadius: const Radius.circular(10),
            center: Text(
              '${_moisture2.toInt()}%',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.white, // Ensures the text is visible on the progress bar
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSleekCircularSlider(
    BuildContext context, {
    required String label,
    required double initialValue,
  }) {
    return GestureDetector(
      onTap: () {},
      child: Padding(
        padding: EdgeInsets.all(getProportionateScreenHeight(5)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SleekCircularSlider(
              min: 0,
              max: 100,
              initialValue: initialValue,
              appearance: CircularSliderAppearance(
                size: 150,
                startAngle: 250,
                angleRange: 360,
                customColors: CustomSliderColors(
                  trackColor: const Color(0xFFBDBDBD),
                  progressBarColor: const Color(0xFF1A5319),
                  shadowColor: const Color(0xFFBDBDBD).withOpacity(0.1),
                  shadowMaxOpacity: 1,
                  shadowStep: 25,
                ),
                customWidths: CustomSliderWidths(
                  progressBarWidth: 22,
                  handlerSize: 25,
                  trackWidth: 22,
                  shadowWidth: 50,
                ),
              ),
              innerWidget: (double value) => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${value.toInt()}°',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text('Celsius',
                      style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
            SizedBox(height: getProportionateScreenHeight(10)),
            Text(
              label,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context,
      {required String label, required VoidCallback onPressed}) {
    return Padding(
      padding: EdgeInsets.all(getProportionateScreenHeight(5)),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(
                vertical: getProportionateScreenHeight(15)),
            backgroundColor: const Color(0xFF1A5319),
          ),
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }
}



class PestDetectionPage extends StatefulWidget {
  const PestDetectionPage({super.key});

  @override
  PestDetectionPageState createState() => PestDetectionPageState();
}

class PestDetectionPageState extends State<PestDetectionPage> {
  // Make sure Firebase is already initialized in main() before creating this widget
  final FirebaseDatabase database = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL: "https://fyp2-test1-default-rtdb.asia-southeast1.firebasedatabase.app/",
  );

  DatabaseReference? _databaseReference;

  List<Map<String, dynamic>> pestRecords = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    // Reference to your "predictions" node
    _databaseReference = database.ref().child('predictions');
    print("TEST...");

    // Now that it's set, you can call your fetch methods
    _fetchDataManually();
    // If you want real-time updates, use: _fetchDataFromFirebase();
  }

  // Function to manually fetch data for debugging & display
  Future<void> _fetchDataManually() async {
    try {
      print("Fetching data manually...");
      if (_databaseReference == null) {
        print("Error: _databaseReference is null!");
        return;
      }

      final snapshot = await _databaseReference!.get();
      if (!snapshot.exists) {
        print("No data available in the database.");
        setState(() {
          pestRecords = [];
          isLoading = false;
        });
        return;
      }

      // We have snapshot data—let's parse it
      final snapshotValue = snapshot.value;
      print("Manual fetch result: $snapshotValue");

      if (snapshotValue is Map) {
        // Convert dynamic Map to a Map<String, dynamic>
        final data = Map<String, dynamic>.from(snapshotValue);
        List<Map<String, dynamic>> records = [];

        data.forEach((key, value) {
          print("Processing key: $key");
          if (value is Map) {
            // For each child, get 'detections'
            final detections = List<dynamic>.from(value['detections'] ?? []);
            print("Detections for key $key: $detections");

            // Each detection is also a map
            for (var detection in detections) {
              if (detection is Map) {
                records.add({
                  'class': detection['class'] ?? 'Unknown',
                  'probability': detection['probability'] ?? 0.0,
                  'timestamp': value['timestamp'] ?? 'Unknown',
                });
              }
            }
          } else {
            print("Value for key $key is not a valid Map");
          }
        });



         // Sort records by timestamp DESC (newest first)
        records.sort((a, b) {
          final dateA = DateTime.tryParse(a['timestamp'] ?? '') ??
              DateTime.fromMillisecondsSinceEpoch(0);
          final dateB = DateTime.tryParse(b['timestamp'] ?? '') ??
              DateTime.fromMillisecondsSinceEpoch(0);
          return dateB.compareTo(dateA); // descending
        });


/*
        // Group records by date (e.g., "2025-01-22")
      Map<String, List<Map<String, dynamic>>> groupedRecords = {};
      for (var record in records) {
        final timestamp = DateTime.tryParse(record['timestamp'] ?? '');
        if (timestamp != null) {
          final dateKey = '${timestamp.year}-${timestamp.month.toString().padLeft(2, '0')}-${timestamp.day.toString().padLeft(2, '0')}';
          if (!groupedRecords.containsKey(dateKey)) {
            groupedRecords[dateKey] = [];
        
          }
          
          groupedRecords[dateKey]!.add(record);
        }
      }



      // Sort by most recent date
      List<String> sortedDates = groupedRecords.keys.toList();
      sortedDates.sort((a, b) {
        final dateA = DateTime.parse(a);
        final dateB = DateTime.parse(b);
        return dateB.compareTo(dateA); // descending
      });
*/




      // 1) Choose your target date — for example, today's date
      DateTime today = DateTime.now();
      // Convert 'today' to a date string like '2025-01-22' or a DateTime “truncated” to day
      final String todayKey = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

      // 2) Filter out records that don't match that date
      records = records.where((record) {
        final timestamp = DateTime.tryParse(record['timestamp'] ?? '');
        if (timestamp == null) return false;

        final recordKey = '${timestamp.year}-${timestamp.month.toString().padLeft(2, '0')}-${timestamp.day.toString().padLeft(2, '0')}';
        return recordKey == todayKey;
      }).toList();


      /*
        // Limit to latest 10 records
        if (records.length > 10) {
          records = records.sublist(0, 10);
        }
      */
        

        


        setState(() {
          pestRecords = records;
          isLoading = false;
        });
        print("Final processed pest records: $pestRecords");
      } else {
        print("Snapshot value is not a valid Map");
        setState(() {
          pestRecords = [];
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error during manual fetch: $e");
      setState(() {
        pestRecords = [];
        isLoading = false;
      });
    }
  }

  // Example of real-time fetching (if you prefer using it):
  void _fetchDataFromFirebase() {
    if (_databaseReference == null) {
      print("Error: _databaseReference is null!");
      return;
    }

    print("Listening for real-time updates...");
    _databaseReference!.onValue.listen((event) {
      print("Firebase onValue triggered");
      final snapshotValue = event.snapshot.value;

      if (snapshotValue == null) {
        print("No data found in Firebase. Snapshot is null.");
        setState(() {
          isLoading = false;
          pestRecords = [];
        });
        return;
      }

      try {
        print("Raw snapshot value: $snapshotValue");
        final data = Map<String, dynamic>.from(
          snapshotValue as Map<dynamic, dynamic>,
        );
        print("Parsed data from Firebase: $data");

        List<Map<String, dynamic>> records = [];

        data.forEach((key, value) {
          print("Processing key: $key");
          if (value is Map<dynamic, dynamic>) {
            final detections = List<dynamic>.from(value['detections'] ?? []);
            print("Detections for key $key: $detections");

            for (var detection in detections) {
              if (detection is Map<dynamic, dynamic>) {
                records.add({
                  'class': detection['class'] ?? 'Unknown',
                  'probability': detection['probability'] ?? 0.0,
                  'timestamp': value['timestamp'] ?? 'Unknown',
                });
              }
            }
          } else {
            print("Value for key $key is not a valid Map");
          }
        });

        setState(() {
          pestRecords = records;
          isLoading = false;
        });
        print("Final processed pest records: $pestRecords");
      } catch (e) {
        print("Error parsing data from Firebase: $e");
        setState(() {
          isLoading = false;
        });
      }
    }, onError: (error) {
      print("Error fetching data: $error");
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
                      color: Colors.white,
                      margin: const EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 16.0,
                      ),
                      child: ListTile(
                        title: Text('Pest: ${record['class']}'),
                        subtitle: Text(
                          'Probability: '
                          '${(record['probability'] * 100).toStringAsFixed(2)}%\n'
                          'Timestamp: ${record['timestamp']}',
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}