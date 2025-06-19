import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';

class AuthMethod {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL:
          'https://fyp2-test1-default-rtdb.asia-southeast1.firebasedatabase.app/');

  // Sign-Up User
  Future<String> signupUser({
    required String email,
    required String password,
    required String name,
  }) async {
    String res = "Some error occurred";
    try {
      if (email.isNotEmpty && password.isNotEmpty && name.isNotEmpty) {
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

        // Add user to Firestore
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
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        res = "success"; // Login successful
      } else {
        res = "Please enter all the fields.";
      }
    } on FirebaseAuthException catch (err) {
      if (err.code == 'user-not-found' || err.code == 'wrong-password') {
        res = "Email or password is invalid.";
      } else if (err.code == 'invalid-email') {
        res = "The email address is not valid.";
      } else {
        res = err.message ?? "An unknown error occurred.";
      }
    } catch (err) {
      res = "An unexpected error occurred. Please try again later.";
    }
    return res;
  }

  // Sign Out User
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Update Pump Settings
  Future<String> updatePumpSettings({
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
}
