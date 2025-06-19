import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fyp2/config/size_config.dart';
import 'package:fyp2/screens/home_screen/home_screen.dart'; // Import HomeScreen to access routeName

class ReportCenter extends StatefulWidget {
  static String routeName = '/report_center';
  const ReportCenter({super.key});

  @override
  State<ReportCenter> createState() => _ReportCenterState();
}

class _ReportCenterState extends State<ReportCenter> {
  final TextEditingController _complaintController = TextEditingController();
  bool _isSubmitting = false; 

  @override
  void initState() {
    super.initState();
  }

  void _submitComplaint() async {
    String complaint = _complaintController.text.trim();

    if (complaint.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Please fill out the complaint box.",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      // Get the current user
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception("User not logged in");
      }

      // Reference to the user's complaints subcollection
      final complaintsRef = FirebaseFirestore.instance
          .collection('userReport') // Main collection
          .doc(user.email) // Document for the logged-in user
          .collection('complaints'); // Subcollection for complaints

      // Get the current count of complaints
      final snapshot = await complaintsRef.get();
      final nextComplaintId = "complaint${snapshot.size + 1}"; // Generate next ID

      // Add the complaint with a custom ID
      await complaintsRef.doc(nextComplaintId).set({
        'comment': complaint, // Store the user's complaint
        'timestamp': FieldValue.serverTimestamp(), // Add a timestamp
      });

      // Show success dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: const Text(
              "Report Successfully Sent",
              style: TextStyle(color: Colors.black),
            ),
            content: const Text(
              "Thank you for submitting your report.",
              style: TextStyle(color: Colors.black),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    HomeScreen.routeName,
                    (Route<dynamic> route) => false,
                  );
                },
                child: const Text(
                  "OK",
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          );
        },
      );

      // Clear the complaint input
      _complaintController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to send report: $e")),
      );
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Report Center",
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF1A5319),
        elevation: 0, // Remove AppBar shadow
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: const Color(0xFF1A5319),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(getProportionateScreenWidth(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            Text(
              "Describe your problem:",
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                  ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                controller: _complaintController,
                maxLines: 6,
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(12),
                  hintText: "Write your complaint here...",
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: getProportionateScreenHeight(50),
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submitComplaint,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFEF9E1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _isSubmitting
                    ? const CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.black),
                      )
                    : const Text(
                        "Submit",
                        style: TextStyle(fontSize: 16, color: Color(0xFF000000)),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
