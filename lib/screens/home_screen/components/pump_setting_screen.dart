/*import 'package:flutter/material.dart';
import 'package:fyp2/service/signUp/authentication.dart';

class UpdatePumpSettingsScreen extends StatefulWidget {
  final String userId; // Pass the logged-in user's UID
  const UpdatePumpSettingsScreen({required this.userId, super.key});

  @override
  _UpdatePumpSettingsScreenState createState() =>
      _UpdatePumpSettingsScreenState();
}

class _UpdatePumpSettingsScreenState extends State<UpdatePumpSettingsScreen> {
  final TextEditingController _pumpController = TextEditingController();
  final TextEditingController _moistureController = TextEditingController();
  bool _isLoading = false;

  Future<void> _updateSettings() async {
    setState(() {
      _isLoading = true;
    });

    String pump = _pumpController.text.trim();
    int? moisture = int.tryParse(_moistureController.text.trim());

    if (pump.isEmpty || moisture == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill in all fields correctly."),
          backgroundColor: Colors.red,
        ),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }


    String res = await AuthMethod().updatePumpSettings(
      userId: widget.userId,
      pump: pump,
      moisture: moisture,
    );

    setState(() {
      _isLoading = false;
    });

    if (res == "success") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Pump settings updated successfully!"),
          backgroundColor: Colors.green,
        ),
      );
      _pumpController.clear();
      _moistureController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(res),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Update Pump Settings"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Pump Name",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _pumpController,
              decoration: const InputDecoration(
                hintText: "Enter pump name (e.g., Water Pump 1)",
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Moisture Threshold",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _moistureController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: "Enter moisture threshold (e.g., 30)",
              ),
            ),
            const SizedBox(height: 30),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: _updateSettings,
                    child: const Text("Update Settings"),
                  ),
          ],
        ),
      ),
    );
  }
}

*/