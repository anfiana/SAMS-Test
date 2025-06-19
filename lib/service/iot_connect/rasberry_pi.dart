import 'package:http/http.dart' as http;

Future<void> sendDataToRaspberryPi(int moisture) async {
  try {
    final url = Uri.parse('http://http://172.16.137.227:5000/update_moisture');

    final response = await http.post(
      url,
      body: {'moisture': moisture.toString()},
    );

    if (response.statusCode == 200) {
      print("Successfully sent moisture data to Raspberry Pi");
    } else {
      print("Failed to send data. Status code: ${response.statusCode}");
    }
  } catch (e) {
    print("Error sending data to Raspberry Pi: $e");
  }
}
