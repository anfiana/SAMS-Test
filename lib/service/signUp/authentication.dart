import 'package:cloud_firestore/cloud_firestore.dart' hide Query;
import 'package:firebase_auth/firebase_auth.dart' ;
import 'package:firebase_database/firebase_database.dart';  // Import Realtime Database
import 'package:firebase_core/firebase_core.dart' ;
import 'package:http/http.dart' as http;


class AuthMethod {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  //final FirebaseDatabase _database = FirebaseDatabase.instance; // Initialize Realtime Database
  //final databaseURL = 'https://fyp2-test1-default-rtdb.asia-southeast1.firebasedatabase.app/';
  final FirebaseDatabase _database = FirebaseDatabase.instanceFor(app: Firebase.app(), databaseURL: 'https://fyp2-test1-default-rtdb.asia-southeast1.firebasedatabase.app/');


  // SignUp User
  Future<String> signupUser({
    required String email,
    required String password,
    required String name,
  }) async {
    String res = "Some error occurred";
    try {
      if (email.isNotEmpty || password.isNotEmpty || name.isNotEmpty) {
        // Check if email already exists
        final existingEmail = await _firestore
            .collection("users")
            .where("email", isEqualTo: email)
            .get();

        if (existingEmail.docs.isNotEmpty) {
          return "Email is already registered. Please use another email.";
        }

        // Check if username already exists
        final existingUsername = await _firestore
            .collection("users")
            .where("name", isEqualTo: name)
            .get();

        if (existingUsername.docs.isNotEmpty) {
          return "Username is already taken. Please choose another one.";
        }

        

        // Register user in Firebase Auth
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Add user to Firestore  //TANDAIN AKU UBAH NAME DISINI DALAM DOC HARUSNYA (cred.user!.uid)
        await _firestore.collection("users").doc(cred.user!.uid).set({
          'name': name,
          'uid': cred.user!.uid,
          'email': email,
        });

        res = "success";
      }
    } catch (err) {
      return err.toString();
    }
    return res;
  }

  // Login User
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error occurred";
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        // Attempt to sign in with email and password
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        res = "success"; // Login successful
      } else {
        res = "Please enter all the fields."; // One or more fields are empty
      }
    } on FirebaseAuthException catch (err) {
  print("Caught FirebaseAuthException with code: ${err.code}"); // Log the error code for all cases

  if (err.code == 'user-not-found' || err.code == 'wrong-password') {
    res = "Email or password is invalid."; // Unified message for invalid credentials
  } else if (err.code == 'invalid-email') {
    res = "The email address is not valid.";
  } else {
    res = err.message ?? "An unknown error occurred.";
  }
} catch (err) {
  // Catch any other exceptions and return a generic error message
  res = "An unexpected error occurred. Please try again later.";
}
    return res;
  }

  // Sign Out User
  Future<void> signOut() async {
    await _auth.signOut();
  }


    // New Function: Get Data from Firebase Realtime Database
  Future<DataSnapshot> getDataFromRealtimeDatabase(String path) async {
    try {
      DatabaseReference ref = _database.ref(path);
      DataSnapshot snapshot = await ref.get();
      return snapshot;
    } catch (error) {
      print("Error retrieving data: $error");
      rethrow; // or handle the error accordingly
    }
  }

  Future<void> listLatestChildPath(String parentPath) async {
  // Get a reference to the parent node
  DatabaseReference ref = _database.ref(parentPath);

  // Query to get the latest child node by key
  Query latestQuery = ref.orderByKey().limitToLast(1);

  try {
    DataSnapshot snapshot = await latestQuery.get();

    if (snapshot.exists) {
      var data = snapshot.value;
      if (data is Map) {
        print('Latest child path under $parentPath:');
        data.forEach((key, value) {
          print('$parentPath/$key');
        });
      } else {
        print('Data at $parentPath is not a Map. It may not have child nodes.');
      }
    } else {
      print('No data found at $parentPath');
    }
  } catch (e) {
    print('Error fetching data: $e');
  }
}


/*Future<String> updatePumpSettings({
    required String userId,
    required String pump,
    required int moisture,
  }) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('plants')
          .doc(pump)
          .update({
        'moisture': moisture,
      });

      return "success";
    } catch (e) {
      return e.toString();
    }
  }

*/


//TRY CONNECTIG TO RASBERY PY
/*Future<int> getMoistureSetting({
    required String userId,
    required String pump,
  }) async {
    try {
      // Get the document for the specific pump
      var docSnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('plants')
          .doc(pump)
          .get();

      if (docSnapshot.exists) {
        // Extract moisture value from the document
        int moisture = docSnapshot.data()?['moisture'] ?? 0;  // Default to 0 if not found
        return moisture;
      } else {
        throw Exception("Document does not exist");
      }
    } catch (e) {
      print("Error getting moisture value: $e");
      rethrow; // Or handle the error in some way
    }
  }
  */

  Future<int> getMoistureSetting({
    required String userId,
    required String pump,
  }) async {
    try {
      // Get the document for the specific pump
      var docSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('plants')
          .doc(pump)
          .get();

      if (docSnapshot.exists) {
        // Extract moisture value from the document
        int moisture = docSnapshot.data()?['moisture'] ?? 0;  // Default to 0 if not found
        return moisture;
      } else {
        throw Exception("Document does not exist");
      }
    } catch (e) {
      print("Error getting moisture value: $e");
      rethrow;
    }
  }

Future<void> sendMoistureToRaspberryPi(int moisture, String pump) async {
  try {
    // Define the URL of the Raspberry Pi endpoint
    final url = Uri.parse('http://172.16.137.227:5000/update_moisture');

    // Send an HTTP POST request with the moisture and pump data
    final response = await http.post(
      url,
      body: {
        'moisture': moisture.toString(),
        'pump': pump,
      },
    );

    if (response.statusCode == 200) {
      print("Successfully sent moisture and pump data to Raspberry Pi");
    } else {
      print("Failed to send data. Status code: \${response.statusCode}");
    }
  } catch (e) {
    print("Error sending data to Raspberry Pi: \$e");
  }
}





Future<Map<String, dynamic>?> getLatestSensorData() async {
  // Define the constant parent path
  const String parentPath = "/sensor_data";

  // Get a reference to the parent node
  DatabaseReference ref = _database.ref(parentPath);

  // Query to get the latest child node by key
  Query latestQuery = ref.orderByKey().limitToLast(1);

  try {
    DataSnapshot snapshot = await latestQuery.get();

    if (snapshot.exists) {
      var data = snapshot.value;
      if (data is Map) {
        // Extract the first (and only) key-value pair from the Map
        String latestChildKey = data.keys.first;
        var latestChildData = data[latestChildKey];

        if (latestChildData is Map) {
          // Cast the child data as Map<String, dynamic>
          return Map<String, dynamic>.from(latestChildData);
        } else {
          print('The latest child data is not a Map.');
        }
      } else {
        print('Data at $parentPath is not a Map.');
      }
    } else {
      print('No data found at $parentPath');
    }
  } catch (e) {
    print('Error fetching data: $e');
  }

  return null; // Return null if no data is found or there's an error
}
}

