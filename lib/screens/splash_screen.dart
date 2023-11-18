import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
            'assets/splash.png'), // You need to replace 'splash.png' with your actual image path.
      ),
    );
  }
}
