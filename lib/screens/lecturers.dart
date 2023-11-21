import 'package:classcritique/screens/loggedIn.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LecturerPage(),
    );
  }
}

class LecturerPage extends StatefulWidget {
  @override
  _LecturerPageState createState() => _LecturerPageState();
}

class _LecturerPageState extends State<LecturerPage> {
  final _userStream =
      FirebaseFirestore.instance.collection('courses').snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: _userStream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text("connect error");
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text("loading...");
            }
            var docs = snapshot.data!.docs;
            //return Text('${docs.length}');
            return ListView.builder(
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const Icon(Icons.person_2_sharp),
                    title: Text(docs[index]['name']),
                    subtitle: Text('${docs[index]['lecturer']}'),
                  );
                });
          }),
      floatingActionButton: SizedBox(),
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
        height: 50.0,
      ),
    );
  }

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                LoggedIn(user: FirebaseAuth.instance.currentUser!)),
      );
      print('Navigate to home page'); // Replace with your navigation logic
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }
}
