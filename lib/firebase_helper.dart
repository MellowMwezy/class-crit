import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseHelper {
  // Collection reference for users
  final CollectionReference users =
      FirebaseFirestore.instance.collection("users");

  // Function to add a new user to Firestore
  Future<void> addUser(String studentId, String password) async {
    await users.add({
      'student_id': studentId,
      'password': password,
    }).then((value) {
      print("User added successfully!");
    }).catchError((error) {
      print("Failed to add user: $error");
    });
  }
}
