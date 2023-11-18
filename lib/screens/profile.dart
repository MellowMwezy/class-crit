import 'package:classcritique/models/course.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ProfilePage(),
    );
  }
}

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Reference to the Firestore collection
  final CollectionReference levelsCollection =
      FirebaseFirestore.instance.collection('levels');

  // Variable to store data from the courses
  List<Course> _listOfCourses = [];
  final levelID = 'TfaOKa8j4vTBszZQgTGf';

  @override
  void initState() {
    super.initState();
    // Call the method to fetch data when the widget is initialized
    fetchData();
  }

  //Login auth
  // query users for logged in user to get level_id
  // query levels where id =  level twzwyuoMTKLa0YvPkHkm

  // Method to fetch data from Firebase
  void fetchData() async {
    try {
      final querySnapshot = await levelsCollection.doc(levelID).get();
      // Query the "levels" collection to get any document
      // QuerySnapshot querySnapshot = await levelsCollection.limit(6).get();

      // Check if any documents were found

      // Retrieve all data from the document
      setState(() {
        final documentData = querySnapshot.data() as Map<String, dynamic>;
        print(documentData);
        for (final course in (documentData['courses'] as List<dynamic>)) {
          _listOfCourses.add(Course.fromJSON(course as Map<String, dynamic>));
        }

        print(_listOfCourses);
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          child: ListView.builder(
            itemBuilder: (ctx, idx) {
              final course = _listOfCourses[idx];
              return ListTile(
                title: Text(course.name),
                subtitle: Text(course.code),
              );
            },
            itemCount: _listOfCourses.length,
          ),
        ),
      ),
    );
  }
}
