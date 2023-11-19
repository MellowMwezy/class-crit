import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class registered extends StatefulWidget {
  @override
  _registeredState createState() => _registeredState();
}

class _registeredState extends State<registered> {
  String _selectedYear = 'First Year';
  String _selectedSemester = 'First Semester';

  final List<String> _years = [
    'First Year',
    'Second Year',
    'Third Year',
    'Fourth Year'
  ];
  final List<String> _semesters = ['First Semester', 'Second Semester'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 100),
              Text(
                'Welcome to ClassCritique, where your voice matters!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
              SizedBox(height: 20),
              Text(
                'What year are you in?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
              SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFFBDBDBD),
                  borderRadius: BorderRadius.circular(13),
                ),
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedYear,
                    icon: Icon(Icons.keyboard_arrow_down),
                    iconSize: 24,
                    elevation: 16,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Poppins',
                    ),
                    onChanged: (String? newValue) {
                      if (newValue != null && newValue.isNotEmpty) {
                        _selectedYear = newValue;
                        setState(() {});
                      }
                    },
                    items: _years.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Which semester are you in?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
              SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFFBDBDBD),
                  borderRadius: BorderRadius.circular(13),
                ),
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedSemester,
                    icon: Icon(Icons.keyboard_arrow_down),
                    iconSize: 24,
                    elevation: 16,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Poppins',
                    ),
                    onChanged: (String? newValue) {
                      if (newValue != null && newValue.isNotEmpty) {
                        _selectedSemester = newValue;
                        setState(() {});
                      }
                    },
                    items: _semesters
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                width: double.infinity,
                margin: EdgeInsets.all(20),
                child: ElevatedButton(
                  onPressed: () async {
                    final user = FirebaseAuth.instance.currentUser;

                    if (user == null) {
                      return;
                    }

                    try {
                      // Query the 'levels' collection to find matching semester and year
                      final yearAsInteger = _years.indexOf(_selectedYear) + 1;
                      final semesterAsInteger =
                          _semesters.indexOf(_selectedSemester) + 1;

                      QuerySnapshot querySnapshot = await FirebaseFirestore
                          .instance
                          .collection('levels')
                          .where('semester', isEqualTo: '$semesterAsInteger')
                          .where('year', isEqualTo: '$yearAsInteger')
                          .limit(1)
                          .get();

                      // print(querySnapshot.docs.first);
                      // Check if any documents were found
                      if (querySnapshot.docs.isNotEmpty) {
                        // Get the ID of the first matching document
                        String levelsID = querySnapshot.docs.first.id;

                        // Update user data in Firestore with the found levels ID
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(user.uid)
                            .update({'levels_id': levelsID});

                        // Navigate to the LoggedIn page
                        Get.to(() => LoggedIn());
                      } else {
                        print('No matching documents found');
                        // Handle error or show a message
                      }
                    } catch (e) {
                      print('Error updating user data: $e');
                      // Handle error, show a message, etc.
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(16),
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    'Continue',
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LoggedIn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Logged In'),
      ),
      body: Center(
        child: Text('You are now logged in!'),
      ),
    );
  }
}
