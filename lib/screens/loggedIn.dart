import 'package:classcritique/models/course.dart';
import 'package:classcritique/screens/profile.dart';
import 'package:classcritique/screens/rate.dart';
import 'package:classcritique/screens/rate.dart'; // Import the RatingsPage class
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class LoggedIn extends StatefulWidget {
  final User user;

  LoggedIn({required this.user});

  @override
  _LoggedInState createState() => _LoggedInState();
}

class _LoggedInState extends State<LoggedIn> {
  int _selectedIndex = 0;
  List<Course> _listOfCourses = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  _loadUserCourses() async {
    final user = FirebaseAuth.instance.currentUser;
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .get();

    final userLevelId = userDoc.data()?['levels_id'];

    final levelDoc = await FirebaseFirestore.instance
        .collection('levels')
        .doc(userLevelId)
        .get();

    // final levelId = levelDoc.id;
    // final data = levelDoc.data();
    // final course = data?['courses'] ?? [];
    final documentData = levelDoc.data() as Map<String, dynamic>;
    print(documentData);
    for (final course in (documentData['courses'] as List<dynamic>)) {
      _listOfCourses.add(Course.fromJSON(course as Map<String, dynamic>));
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10.0),
                ),
                padding: EdgeInsets.all(32.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProfilePage(),
                              ),
                            );
                          },
                          child: CircleAvatar(
                            backgroundColor: Colors.blue,
                            child: Icon(Icons.person, color: Colors.white),
                          ),
                        ),
                        SizedBox(width: 20),
                        StreamBuilder<User?>(
                          stream: FirebaseAuth.instance.authStateChanges(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Text(
                                'Loading...',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.normal,
                                ),
                              );
                            }

                            if (!snapshot.hasData || snapshot.data == null) {
                              return Text(
                                'Loading...',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.normal,
                                ),
                              );
                            }

                            var userEmail =
                                snapshot.data!.email ?? 'Unknown Email';

                            var userDisplayName = userEmail.split('@')[0];

                            return Text(
                              'Hello, $userDisplayName',
                              style: TextStyle(
                                fontSize: 24,
                                fontFamily: 'Poppins',
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: ' courses',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: ' for this semester',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                        fontFamily: 'Poppins',
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                shrinkWrap: true,
                children: [
                  _buildClickableGridBox("Course 1"),
                  _buildClickableGridBox("Course 2"),
                  _buildClickableGridBox("Course 3"),
                  _buildClickableGridBox("Course 4"),
                ],
              ),
              RichText(
                text: TextSpan(
                  text: 'schedule ',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                    color: Colors.black,
                  ),
                ),
              ),
              RichText(
                text: TextSpan(
                  text: 'upcoming classes ',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'Poppins',
                    color: Colors.black,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(16.0),
                margin: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.deepPurpleAccent,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.access_time, size: 16),
                            Text(
                              ' _time',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Poppins',
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(Icons.accessibility_new, size: 16),
                            Text(
                              ' _lecturer',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Poppins',
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(Icons.room, size: 16),
                            Text(
                              ' _room',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Poppins',
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'are you attending?',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            fontFamily: 'Poppins',
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            _buildClickableBox(
                              Icons.check,
                              Colors.green,
                              "Enjoy your class",
                            ),
                            SizedBox(width: 10),
                            _buildClickableBox(
                              Icons.close,
                              Colors.red,
                              "Please attend next time",
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.white,
        color: Colors.deepPurpleAccent,
        index: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          Icon(Icons.home, size: 30),
          Icon(Icons.calendar_today, size: 30),
          Icon(Icons.history, size: 30),
          Icon(Icons.star, size: 30), // New button with a home icon
        ],
      ),
    );
  }

  void _onItemTapped(int index) {
    if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => RatingsPage()),
      );
      print('Navigate to home page'); // Replace with your navigation logic
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  Widget _buildGridBox(String courseName) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(10.0),
      ),
      padding: EdgeInsets.all(16.0),
      child: Center(
        child: Text(
          courseName,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontFamily: 'Poppins',
          ),
        ),
      ),
    );
  }

  Widget _buildClickableBox(IconData icon, Color color, String snackBarText) {
    return GestureDetector(
      onTap: () {
        _showSnackBar(snackBarText, color);
      },
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10.0),
        ),
        padding: EdgeInsets.all(10.0),
        child: Icon(
          icon,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildClickableGridBox(String courseName) {
    return GestureDetector(
      onTap: () {
        // Handle course box click here
        // You can add your logic or navigation
      },
      child: _buildGridBox(courseName),
    );
  }

  void _showSnackBar(String text, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }
}
