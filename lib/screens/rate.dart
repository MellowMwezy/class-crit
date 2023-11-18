import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class RatingsPage extends StatefulWidget {
  @override
  _RatingsPageState createState() => _RatingsPageState();
}

class _RatingsPageState extends State<RatingsPage> {
  double _rating = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Class Ratings'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RatingBar.builder(
              initialRating: _rating,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: false,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                setState(() {
                  _rating = rating;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Save the rating to Firebase
                _saveRatingToFirebase(_rating);
              },
              child: Text('Submit Rating'),
            ),
          ],
        ),
      ),
    );
  }

  void _saveRatingToFirebase(double rating) {
    // Add your Firebase logic here to save the rating to the database
    // Example using Cloud Firestore:
    FirebaseFirestore.instance.collection('class_ratings').add({
      'rating': rating,
      'timestamp': FieldValue.serverTimestamp(),
    });

    // You might want to show a success message or navigate to another page
    // after the rating is submitted.
  }
}
