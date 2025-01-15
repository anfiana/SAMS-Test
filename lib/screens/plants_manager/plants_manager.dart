import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PlantsPage extends StatefulWidget {
  const PlantsPage({super.key});

  @override
  _PlantsPageState createState() => _PlantsPageState();
}

class _PlantsPageState extends State<PlantsPage> {
  Stream<QuerySnapshot<Map<String, dynamic>>>? _plantsStream;

  @override
  void initState() {
    super.initState();
    _initializePlantsStream();
  }

  // Initialize Firestore stream for plants
  void _initializePlantsStream() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _plantsStream = FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('plants')
            .snapshots();
      });
    }
  }

  // Show information dialog
  void showBookInfo() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Text(
            'Book Information',
            style: TextStyle(color: Colors.black),
          ),
          content: const Text(
            'Hello World',
            style: TextStyle(color: Colors.black),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Close',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }

  // Check if a new plant can be added
  Future<bool> _canAddPlant() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final plantsCollection = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('plants');

      final snapshot = await plantsCollection.get();
      return snapshot.docs.length < 2; // Limit to 2 plants
    }
    return false;
  }

  // Determine the next available pump
  Future<String> _getNextAvailablePump() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final plantsCollection = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('plants');

      final snapshot = await plantsCollection.get();
      final pumpsInUse = snapshot.docs
          .map((doc) => doc.data()['pump'] as String?)
          .where((pump) => pump != null)
          .toList();

      if (!pumpsInUse.contains('Water Pump 1')) {
        return 'Water Pump 1';
      } else if (!pumpsInUse.contains('Water Pump 2')) {
        return 'Water Pump 2';
      }
    }
    return 'Unknown Pump'; // Fallback, shouldn't occur
  }

  // Add a new plant
  Future<void> _addPlant() async {
    final canAdd = await _canAddPlant();

    if (!canAdd) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You can only add up to 2 plants, each assigned to a unique pump.',
          style: TextStyle(color: Colors.black),),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
        ),
  
      );
      return;
    }

    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final moistureController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Plant'),
          backgroundColor: Colors.white,
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Plant Name',
                    hintText: 'Enter plant name (e.g., Plant 1, Plant 2)',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a plant name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: moistureController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Moisture Level',
                    hintText: 'Enter moisture value (0-100)',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a moisture value';
                    }
                    final intValue = int.tryParse(value);
                    if (intValue == null || intValue < 0 || intValue > 100) {
                      return 'Moisture must be between 0 and 100';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  final pump = await _getNextAvailablePump();
                  final user = FirebaseAuth.instance.currentUser;
                  if (user != null) {
                    try {
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(user.uid)
                          .collection('plants')
                          .add({
                        'name': nameController.text.trim(),
                        'moisture': int.parse(moistureController.text.trim()),
                        'pump': pump,
                      });
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${nameController.text.trim()} assigned to $pump.'),
                        ),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error adding plant: $e')),
                      );
                    }
                  }
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  // Delete a plant
  Future<void> _deletePlant(String plantId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('plants')
            .doc(plantId)
            .delete();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Plant deleted successfully.')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting plant: $e')),
        );
      }
    }
  }

  // Edit a plant's moisture level
  Future<void> _editMoisture(String plantId, int currentMoisture) async {
    final formKey = GlobalKey<FormState>();
    final moistureController =
        TextEditingController(text: currentMoisture.toString());

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Moisture Level'),
          backgroundColor: Colors.white,
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: moistureController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Moisture Level',
                hintText: 'Enter new moisture value (0-100)',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a moisture value';
                }
                final intValue = int.tryParse(value);
                if (intValue == null || intValue < 0 || intValue > 100) {
                  return 'Moisture must be between 0 and 100';
                }
                return null;
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  final newMoisture = int.tryParse(moistureController.text.trim());
                  if (newMoisture != null) {
                    try {
                      final user = FirebaseAuth.instance.currentUser;
                      if (user != null) {
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(user.uid)
                            .collection('plants')
                            .doc(plantId)
                            .update({'moisture': newMoisture});
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Moisture updated.')),
                        );
                      }
                      Navigator.of(context).pop();
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error updating moisture: $e')),
                      );
                    }
                  }
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // If _plantsStream is null, show a message or loading indicator
    if (_plantsStream == null) {
      return Scaffold(
        backgroundColor: const Color(0xFF1A5319), // Set background to green
        appBar: AppBar(
          title: const Text(
            'Plant Moisture',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          backgroundColor: const Color(0xFF1A5319), // AppBar matches background
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                // Optionally, you can prompt the user to log in
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please log in to manage plants.')),
                );
              },
            ),
          ],
        ),
        body: const Center(
          child: Text(
            'User not logged in.',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: showBookInfo,
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          child: const Icon(Icons.book, color: Color.fromARGB(255, 93, 93, 93)),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF1A5319), // Set background to green
      appBar: AppBar(
        title: const Text(
          'Plant Moisture',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF1A5319), // AppBar matches background
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addPlant,
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>( 
        stream: _plantsStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong.'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final plants = snapshot.data?.docs ?? [];

          if (plants.isEmpty) {
            return const Center(child: Text('No plants available.'));
          }

          return ListView.builder(
            itemCount: plants.length,
            itemBuilder: (context, index) {
              final plant = plants[index].data();
              final plantId = plants[index].id;
              final plantName = plant['name'] ?? 'Unknown Plant';
              final moisture = plant['moisture'] ?? 0;
              final pump = plant['pump'] ?? 'Unknown Pump';

              return Card(
                color: Colors.white, // Card background is white
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: const BorderSide(color: Colors.black),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Plant Information
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            plantName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Pump: $pump',
                            style: const TextStyle(color: Colors.black),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              ElevatedButton(
                                onPressed: () => _editMoisture(plantId, moisture),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: const Color(0xFF1A5319),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                ),
                                child: const Text('EDIT'),
                              ),
                              const SizedBox(width: 8), // Spacer between buttons
                              ElevatedButton(
                                onPressed: () => _deletePlant(plantId),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red, // Red button
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                ),
                                child: const Text('DELETE'),
                              ),
                            ],
                          ),
                        ],
                      ),
                      // Moisture Indicator
                      SizedBox(
                        width: 80,
                        height: 120, // Increase height to accommodate the new text
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                CircularProgressIndicator(
                                  value: moisture / 100,
                                  backgroundColor: Colors.grey[400],
                                  color: Colors.green[700],
                                  strokeWidth: 8,
                                ),
                                Text(
                                  '$moisture%',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8), // Space between the circle and text
                            Text(
                              'Moisture Value',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                              ),
                              textAlign: TextAlign.center, // Center-align the text
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showBookInfo,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        child: const Icon(Icons.book, color: Color.fromARGB(255, 93, 93, 93)),
      ),
    );
  }
}
